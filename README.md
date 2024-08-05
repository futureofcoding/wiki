# Future of Coding Wiki

Welcome to the Future of Coding Wiki!

We'll use this wiki to collect all sorts of references, projects, concepts, realizations, and other such bits of endearingly valuable knowledge that are surfaced by discussions in [our community](https://futureofcoding.org/community).

## Contributing

Everyone is welcome to contribute. Please feel free to edit _anything in the repo_ at any time in any way, and then submit a PR.

### Pages

Each page is an HTML or Markdown file stored in the [pages](https://github.com/futureofcoding/wiki/tree/master/pages) folder.

Note that we use a custom Markdown subset. See below for the supported syntax.

The file should begin with "frontmatter", which is a fancy name for metadata using the following template:

```yaml
title: Name of the Page
---
```

Yeah, that's it for now. We might add some other kinds of frontmatter soon — maybe a tagging scheme?

Use a `---` to mark the end of the frontmatter. After that, you can have normal HTML or Markdown, like so:

```yaml
title: An HTML Example
---
<p>Love to write tags. Not even joking.</p>
```

```yaml
title: A Markdown Example
---
This is a *very* simple page.
```

### Macros

While writing a page in either HTML or Markdown, you can use one of the following macros.

#### Internal Link
We use a format for links inspired by Wikipedia: `[[Page Name]]` or `[[Page Name|displayed text]]`

That's the only macro for now. We might add more soon.

### Markdown

We use a super-simple subset of Markdown syntax:

* Paragraphs: Bare text will be wrapped in `<p>` tags
* Headings: `#` for `<h1>`, `##` for `<h2>`, `###` for `<h3>`, `####` for `<h4>`
* Styling: `*` or `_` for `<em>`, `**` or `__` for `<strong>`
* Links:

### Build Scripts

This wiki uses a build script to do a few things:

1. Expand the macros.
2. Convert markdown pages to HTML.
3. Add header/footer to HTML pages.

If you edit the wiki via the Github web interface, the build script will run automatically on every commit.

If you make a local clone of the wiki repo, you'll see that there's a `scripts` folder, containing a few build scripts.
All the scripts do the same thing. Run whichever script is most convenient for you.
If none of the scripts are convenient, or if you're looking for something fun to do, please port or rewrite the build script in a language of your choice.
