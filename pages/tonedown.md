---
title: Tonedown
contributors: Ivan Reese
---

Tonedown is a plain text markup language inspired by Gemtext and Markdown. It was first designed for the Future of Coding Wiki, but will hopefully be used in future projects as well.

It has a few leading principles, and reflects the technical aesthetics of its creator.
* The implementation is the spec.
* The implementation is easy to explain, even to non-programmers.
* It's balanced toward writing long paragraphs of prose, with occasional code snippets, inline images, or other stylistic flourishes.
* You can always just write HTML.

If something doesn't work the way you expect, tell me and I'll listen.

# How it works

Write paragraphs as single long lines.
Each new line is a new paragraph.
Blank lines are ignored.

Headings, like "How it works" above, are added like so:

 # Major heading
 ## Sub-heading
 ### Secret third heading

That is, you begin a line with a `#`, then a space, then the text.

Any line beginning with a `-` or a `*`, then a space, will make a list.
 - First list item
 - Second list item
will make bullets, like
- Secret third thing
- Wait, these are unordered lists, why am I counting?

Open and close code blocks with three backticks.

```
Some code
goes
in here
# line shit
* should be
> ignored
<even this>
also *inline* **shit** no go!

Empty line? Even this ``` should be fine!
 ```whoa
```

> A quote

An _italic_ and *italic*!
A **bold** and __bold__!

An _ita lic_ and *ita lic*!
A **bo ld** and __bo ld__!

Some *italic **both* bold** none.

__Bold__
**Bold**

_Italic_
*Italic*

***Bold italic***
___Bold italic___

_**Bold italic**_
**_Bold italic**_
_**Bold italic_**
**_Bold italic_**

__*Bold Italic*__
*__Bold Italic*__
__*Bold Italic__*
*__Bold Italic__*

*_*Just italic?*_*
_*_Just italic?_*_


