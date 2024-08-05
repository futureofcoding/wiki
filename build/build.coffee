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
rm = (path)-> try fs.rmSync path, recursive: true

# Give us the names of all the files in a given folder, ignoring dotfiles
readDir = (path)-> fs.readdirSync(path).filter (file)-> !file.startsWith "."

# Return the text contents of the file at the given path
readFile = (path)-> fs.readFileSync(path).toString()

# Make a file at the given path, containing the given text
writeFile = (path, text)-> fs.writeFileSync ensureDir(path), text

# Copy the file from the given path to the given destination path
copyFile = (path, dest)-> fs.copyFileSync path, dest

# MARKDOWN

markdownRules = readFile "build/markdown-rules.txt"
  .split "\n"
  .filter (l)-> l.indexOf("→") > -1
  .map (l)->
    [mdPattern, htmlPattern] = l.split("→")
    mdPattern = mdPattern.trim()
    htmlPattern = htmlPattern.trim()
    mdRegex = new RegExp mdPattern, "g"
    [mdRegex, htmlPattern]


# BEGIN

# First, clear the `public` folder by deleting and remaking it
rm "public"
mkdir "public"

# Copy all static assets to the `public` folder
for file in readDir "assets"
  copyFile "assets/#{file}", "public/#{file}"

# Load the page layout HTML template
layout = readFile "build/layout.html"

# Loop through page files
for pageFilename in readDir "pages"

  # Load this page file's content
  pageContent = readFile "pages/" + pageFilename

  # Process the frontmatter
  [_, frontmatter, body] = pageContent.split "---"

  # Extract key-value pairs from the frontmatter
  data = {}
  for line in frontmatter.split "\n"
    [k, v] = line.split /\s*:\s*/
    data[k] = v

  # Apply our internal link macro
  body = body.replaceAll /\[\[([^|\]]+)|([^\]]+)\]\]/g, '<a href="$2">$1</a>'

  # If this page is markdown, run it through our list of replacement rules
  if pageFilename.endsWith ".md"
    for [mdRegex, htmlPattern] in markdownRules
      body = body.replaceAll mdRegex, htmlPattern

  # For the sake of nice looking output, trim excess whitespace around the body
  body = body.trim()

  # Inject the page title as a visible title element
  body = "<title>#{data.title}</title>\n\n" + body

  # For the sake of nice looking output, indent every line of the body
  body = body.split("\n").map((l)-> "    " + l).join("\n")

  # Insert the page body into the layout
  pageHtml = layout.replace /\s*{{page}}/, body

  # Replace the string {{path}} with the path to this page file — used for Edit on GitHub link
  pageHtml = pageHtml.replaceAll "{{path}}", "pages/#{pageFilename}"

  # We're done generating the page's html. Now figure out where to save the file, and save it.

  # Separate the name of the page file from the extension
  [pageName, _] = pageFilename.split "."

  # This is the full destination path where we'll save our page.
  # To make the URLs pretty, each page becomes an "index.html" file in its own folder.
  destPath = "public/" + pageName + "/index.html"

  # One exception to the above — the main index of the site does not go in its own folder.
  destPath = destPath.replace "/index/index.html", "/index.html"

  # Finally, write the page content to the destination path.
  writeFile destPath, pageHtml

# We're done!
