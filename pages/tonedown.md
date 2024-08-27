---
title: Tonedown
contributors: Ivan Reese
---

Tonedown is a plain text markup language designed by Ivan Reese specifically for this Wiki. It aspires to be quite similar to [Markdown](https://daringfireball.net/projects/markdown/), with the pragmatism of [Gemtext](https://gemini.flounder.online/docs/cheatsheet.gmi). It has a few leading principles, and reflects the technical aesthetics of its designer.

Like Markdown and Gemtext, and unlike HTML, you'll find it pleasant to read and write Tonedown in a plain text editor, especially long-form prose like a wiki entry. The syntax should get out of your way and let you focus on the content of your writing.

Like Markdown, you can just write HTML pretty much anywhere and it'll pass straight through.

Unique to Tonedown is a focus on the clarity of the implementation. It's coded in a slightly unusual style, with the eventual goal of making it quite straightforward to port to other languages. To wit, the implementation is exhaustively commented; the code should make sense to someone who is just beginning to learn how to code and is unfamiliar with the programming language used. (Note that this is a work in progress — at the time of writing, the implementation does not uniformly meet these goals.)

If something doesn't work the way you expect, tell me and I'll listen.

# Tour

### Paragraphs
Each line of plain writing becomes its own paragraph. It's strongly recommended that you enable **Soft Wrap** in your editor.

```
It is late. The window is open.
A machine drones in the distance.

It can't even hold a steady pitch.
```
↓
```
<p>It is late. The window is open.</p>
<p>A machine drones in the distance.</p>
<p>It can't even hold a steady pitch.</p>
```

### Headings
Tonedown supports three levels of heading, colloquially named as follows.

```
# Major heading
## Minor heading
### Diminished heading
```
↓
```
<h1>Major heading</h1>
<h2>Minor heading</h2>
<h3>Diminished heading</h3>
```

Any line beginning with a `-` or a `*` will make a list.
 - First list item
 - Second list item
will make bullets, like
- Secret third thing
- Wait, these are unordered lists, why am I counting?

Open and close code blocks with three backticks.

```
This boxy abode
  contains your code
    natural or synthetic

# line shit
* should be
> ignored
<a>and this poor link, apathetic</a>
Any *inline* **style**? Decline. A super duper really very greatly excessively long single solid never-ceasing run-on? With aplomb!

Empty line? Even this ``` should be fine!
```

> A quote

# How it works

Each line is processed one by one.

If the line is just good ol' plain normal writing, it becomes a `<p>` element. Each new line becomes a new paragraph. Blank lines are ignored.

If the line begins like one of the following, it'll behave accordingly:

 # An `<h1>` title
 ## An `<h2>` title
 ### An `<h3>` title
 - A `<ul>` list (you can also use a `*` for lists)
 > A blockquote

You can create blocks of code with three backticks, like so:

&#96;&#96;&#96;
Some code
&#96;&#96;&#96;

You can also use <span style="color:yellow">HTML</span> anywhere, anytime.

The line above looks like so:
```
<span style="color:yellow">HTML</span>
```

# Extra testing

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


