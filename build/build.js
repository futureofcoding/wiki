###
Future of Coding Wiki
CoffeeScript Build Script

This is the reference implementation for a build script.
It is run automatically on every commit to the repo.

If you'd like to run it locally:
1. Install coffeescript via npm: `npm i -g coffeescript`
2. From the root of the repo, run `coffee scripts/build.coffee`

You are heartily encouraged to port this script to your language of choice, and add it to the `scripts` folder.
Bonus points for using a language you made yourself :)

Requirements:
* Your script must be a single file, or placed in its own subfolder. Keep the main `scripts` folder tidy.
* You must include instructions for how to run your script.
* Please use as few dependencies as possible.

Also:
* I only tested this script on Mac. If you can make some small changes to get it to run on Windows, please do!
* I also wrote a JavaScript version of the script, so feel free to consult that one as well.
###

# DEPENDENCIES

# This script uses the `fs` module from NodeJS to read and write files
fs = require "fs"

# HELPER FUNCTIONS

# If any folders in the given path don't exist, create them
mkdir = (path)-> fs.mkdirSync path, recursive: true

# Given a file path, make sure all parent directories exist, then return the path
ensureDir = (path)-> mkdir(path.split("/")[0...-1].join("/")); path

# Delete the file or folder at the given path (`force` just silences an error if the file/folder doesn't exist)
rm = (path)-> fs.rmSync path, recursive: true, force: true

# Read the contents of a given file
readFile = (path)-> fs.readFileSync(path).toString()

# Gives us the names of all the files in a given folder, ignoring dotfiles
readDir = (path)-> fs.readdirSync(path).filter (file)-> !file.startsWith "."

# Make a file at the given path, containing the given text
writeFile = (path, text)-> fs.writeFileSync ensureDir(path), text

# MARKDOWN SYNTAX

# This is how we convert markdown to HTML.
# It's is a dictionary. Each key (on the left) is the HTML pattern to generate,
# and the value (on the right) is the regex that'll match our markdown syntax.

markdown =
  # header
  '<h1>$1</h1>': /#{1}\s*([^\n]+)/g
  '<h2>$1</h2>': /#{2}\s*([^\n]+)/g
  '<h3>$1</h3>': /#{3}\s*([^\n]+)/g
  '<h4>$1</h4>': /#{4}\s*([^\n]+)/g
  # paragraph
  '<p>$1</p>': /([^\n]+\n?)/g
  # ul
  '<ul><li>$3</li></ul>': /([^\n]+)(\*)([^\n]+)/g
  '<ul><li>$3</li></ul>': /([^\n]+)(\+)([^\n]+)/g
  # emphasis
  '<em>$1</em>': /\*\s?([^\n]+)\*/g
  '<em>$1</em>': /_([^_`]+)_/g
  # strong
  '<strong>$1</strong>': /\*\*\s?([^\n]+)\*\*/g
  '<strong>$1</strong>': /__([^_]+)__/g
  # code
  '<code>$2</code>': /(`)(\s?[^\n,]+\s?)(`)/g
  # TODO: code block as <pre><code>The code</code></pre>
  # link
  '<a href="$2">$1</a>': /\[([^\]]+)\]\(([^)]+)\)/g
  # image
  '<img src="$2" alt="$1">': /!\[([^\]]+)\]\(([^)]+)\)/g

# Begin

# First, clear the `public` folder by deleting and remaking it
rm "public"
mkdir "public"

# Load the header and footer HTML fragments
header = readFile "assets/header.html"
footer = readFile "assets/footer.html"

# Get all the pages
pageFilenames = readDir "pages"

# Loop through pages
for pageFilename in pageFilenames

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
  # body = body.replace /\[\[([^|\]]+)|([^\]]+)\]\]/

  # If this page is markdown, run it through our list of regexes
  if pageFilename.endsWith ".md"
    for htmlPattern, mdPattern in markdown
      body = body.replace mdPattern, htmlPattern

  # Surround the body with the header and footer HTML fragments
  pageHtml = header + body + footer

  # Separate the name of the page file from the extension
  [pageName, ext] = pageFilename.split "."

  # This is the full destination path where we'll save our page.
  # To make the URLs pretty, each page becomes an "index.html" file in its own folder.
  destPath = "public/" + pageName + "/index.html"

  # One exception to the above — the main index of the site does not go in its own folder.
  destPath = destPath.replace "/index/index.html", "/index.html"

  # Finally, write the page content to the destination path.
  writeFile destPath, pageHtml

# We're done!
