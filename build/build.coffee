###
Future of Coding Wiki
CoffeeScript Build Script

This is the reference implementation for the build script.
It is run automatically on every commit to the repo.

If you'd like to run it locally:
1. Install coffeescript via npm: `npm i -g coffeescript`
2. From the root of the repo, run `coffee build/build.coffee`

If you don't use npm, or don't want to install CoffeeScript,
you should use any of the other build scripts in this folder.
They all do the same thing.

You are heartily encouraged to port this script to your language of choice,
and add it to the `build` folder. Bonus points for using a language you made yourself :)
Requirements:
* Your script must be a single file, or placed in its own subfolder. Keep the main `build` folder tidy.
* You must include instructions for how to run your script.
* Please use as few dependencies as possible.

Also:
* I only tested this script on Mac. If you can make some small changes to get it to run on Windows, please do!
* I also wrote a JavaScript version of the script, so feel free to reference that one as well.
###

# DEPENDENCIES

# This script uses the `fs` module from NodeJS to read and write files
fs = require "fs"

# HELPER FUNCTIONS

# If any folders in the given path don't exist, create them
mkdir = (path)-> fs.mkdirSync path, recursive: true

# Given a file path, make sure all parent directories exist, then return the path
ensureDir = (path)-> mkdir(path.split("/")[0...-1].join("/")); path

# Delete the file or folder at the given path, or fail silently if it doesn't exist
rm = (path)-> try fs.rmSync path, recursive: trues

# Give us the names of all the files in a given folder, ignoring dotfiles
readDir = (path)-> fs.readdirSync(path).filter (file)-> !file.startsWith "."

# Return the text contents of the file at the given path
readFile = (path)-> fs.readFileSync(path).toString()

# Make a file at the given path, containing the given text
writeFile = (path, text)-> fs.writeFileSync ensureDir(path), text

# Copy the file from the given path to the given destination path
copyFile = (path, dest)-> fs.copyFileSync path, dest

indent = "      "

# Processing lines
lineRules =
  "### ": "h3"
  "## " : "h2"
  "# "  : "h1"
  "<"   : "html"
  "> "  : "blockquote"
  "* "  : "li"
  "- "  : "li"
  "```" : "code"
  ""    : "p"

getRule = (line)->
  for mark, rule of lineRules
    if line.startsWith mark
      return [mark, rule]

processLines = (lines)->
  mode = "normal"
  beginCode = true
  processedLines = []

  for line in lines

    # Figure out what rule applies to the line
    [mark, rule] = getRule line

    # Check for code mode boundary
    # TODO: Add support for a language directive after the mark
    if rule is "code"
      mode = if mode is "code" then "normal" else "code"
      if mode is "code"
        beginCode = true
      else
        processedLines[processedLines.length-1] += "</code></pre>\n"
      continue

    # When in code mode, escape a few chars, but otherwise leave the line as-is
    if mode is "code"
      line = line
        .replaceAll "&", "&amp;"
        .replaceAll "<", "&lt;"
        .replaceAll ">", "&gt;"
      line = "\n<pre><code>" + line if beginCode
      processedLines.push line
      beginCode = false
      continue

    # Check for list mode boundary
    if rule is "li" and mode isnt "list"
      mode = "list"
      processedLines.push indent + "<ul>"
    else if mode is "list" and rule isnt "li"
      mode = "normal"
      processedLines.push indent + "</ul>"

    # Pass HTML straight through
    if rule is "html"
      processedLines.push indent + line
      continue

    # Remove the mark and outer whitespace from the line
    line = line.replace(mark, "").trim()

    # If the line is now empty, bail
    continue if line.length is 0

    # Now process all the inline rules
    line = processInline line

    # Build our tags
    open = "<" + rule + ">"
    close = "</" + rule + ">"

    # Some tags get extra indentation, for pretty html output
    open = "  " + open if mode is "list"

    # Wrap the line in the tags
    processedLines.push [indent, open, line, close].join ""

  # Put all the processed lines together into a body
  body = processedLines.join "\n"

# Processing within a line
processInline = (line)->
  # Strong
  tokens = line.split /\*{2}|_{2}/
  if tokens.length > 1
    results = for token, i in tokens
      if i % 2 is 0 then token else "<strong>#{token}</strong>"
    line = results.join ""

  # Em
  tokens = line.split /\*|_/
  if tokens.length > 1
    results = for token, i in tokens
      if i % 2 is 0 then token else "<em>#{token}</em>"
    line = results.join ""

  # Code span
  tokens = line.split "`"
  if tokens.length > 1
    results = for token, i in tokens
      if i % 2 is 0 then token else "<code>#{token}</code>"
    line = results.join ""

  # Link
  # Image
  # Code span

  line

# Begin processing all files

# First, clear the `public` folder by deleting and remaking it
rm "public"
mkdir "public"

# Copy all static assets to the `public` folder
for file in readDir "assets"
  copyFile "assets/#{file}", "public/#{file}"

# Load the page layout HTML template
layout = readFile "build/layout.html"

# We have to do two passes over all the pages
# The first pass, we put together all the internal links (so we can fill out backlinks)
# The second pass, we compile all the pages

# Build up metadata about each page
pages = {}

# Loop through page files
for pageFilename in readDir "pages"

  # Make a page to store the page metadata
  page = {
    content: "Nothing here..."
    sourcePath: "unknown-path"
    destPath: "unknown-path"
    url: "unknown-url"
    backlinks: {}
    html: "Unknown HTML"
  }

  # Source path
  page.sourcePath = "pages/" + pageFilename

  # Separate the name of the page file from the extension
  [pageName, _] = pageFilename.split "."

  # This is the full destination path where we'll save our page.
  # To make the URLs pretty, each page becomes an "index.html" file in its own folder.
  page.destPath = "public/" + pageName + "/index.html"

  # One exception to the above — the main index of the site does not go in its own folder.
  page.destPath = page.destPath.replace "/index/index.html", "/index.html"

  page.url = if pageName is "index" then "/" else "/#{pageName}"

  # Load this page file's content
  page.content = readFile page.sourcePath

  # Process the frontmatter
  [a, frontmatter, body] = page.content.split /^---/m

  # Save the body
  page.body = body

  # If we don't have frontmatter, skip the page
  if not frontmatter
    console.log "page `#{pageFilename}` is missing frontmatter"
    continue

  # Extract key-value pairs from the frontmatter
  page.data = {}
  for line in frontmatter.split "\n"
    [k, v] = line.split /\s*:\s*/
    page.data[k] = v

  # Save the page by title
  pages[page.data.title] = page


for pageName, page of pages

  # If this page is markdown, run it through our list of replacement rules
  body = processLines page.body.split "\n"

  # Inject the page title as a visible title element
  body = "\n#{indent}<title>#{page.data.title}</title>\n" + body

  # Insert the page body into the layout
  page.html = layout.replace /\s*{{page}}/, body

  # Replace the string {{path}} with the path to this page file — used for Edit on GitHub link
  page.html = page.html.replaceAll "{{path}}", page.sourcePath

  # Replace the string {{all}} with links to all pages
  page.html = page.html.replaceAll "{{all}}", Object.values(pages).map((p)-> "<li><a href=\"#{p.url}\">#{p.data.title}</a></li>").join("\n")

  page.html = page.html.replaceAll "{{contributors}}", page.data.contributors?.split(", ")?.map((c)->"<li>#{c}</li>") or "None"

  # Internal link
  page.html = page.html.replaceAll /\[\[(.+)\]\]/g, (match, captured)->
    [text, title] = captured.split "|"
    title ||= text
    if dest = pages[title]
      dest.backlinks[page.data.title] = page.url
      "<a href=\"#{dest.url}\">#{title}</a>"

  null

for pageName, page of pages
  # Populate backlinks

  backlinks = for title, url of page.backlinks
    "<li><a href=\"#{url}\">#{title}</a></li>"

  if backlinks.length is 0
    backlinks = ["None"]

  page.html = page.html.replaceAll "{{backlinks}}", backlinks.join "\n"

  # Finally, write the page content to the destination path.
  writeFile page.destPath, page.html
