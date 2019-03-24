---
layout: default
---

# Contributing

This wiki is built with each entry stored as a Markdown file in the [\_pages](https://github.com/futureofcoding/wiki/tree/master/_pages) directory. [Jekyll](https://jekyllrb.com/) provides auto-generated lists, references to other entries, and other programmatic page generation.

Example page:

``` yaml
---
title: My Name - Post title
category: post
link: https://example.com/post
by: My Name
date: 2019-03-22
tags: [foo, bar]
---

# first paragraph becomes the excerpt seen in some lists
Why foo is better than bar

## Markdown goes here
```

## Categories

<ul class="categories">
  <li>[<span>list</span>] - Lists of other pages.</li>
  <li>[<span>tag</span>] - Generic category for any topic. Any page can be tagged with any tag.</li>
  <li>[<span>person</span>] - Any person relevant to the future of coding community. (The <code>date</code> and <code>end_date</code> associated with a person are roughly when they have been active in work related to the future of coding.)</li>
  <li>[<span>post</span>] - Category for any blog post, academic paper, essay, or other material with a publishing date.</li>
  <li>[<span>project</span>] - Any relevant project or initiative.</li>
  <li>[<span>team</span>] - Any group or organization within the community or developing projects that belong in this wiki.</li>
</ul>

## Developing

``` bash
$ bundle install  # may need to gem install bundler first
$ bundle exec jekyll serve
```

<p><a href="{{ site.github.repository_url }}/edit/master/{{ page.path }}">Edit on GitHub</a></p>
