---
layout: default
---

# Future of Coding Wiki

Welcome to the Future of Coding Wiki! The goal of this wiki is to collect all of the resources from [Slack](https://futureofcoding.slack.com), Twitter, academic papers, blogs and the internet, related to the broad topic of the future of coding. The hope is that a wiki format will make knowledge easier to build and retrieve, and for connections to form between the various ideas in the community.

Each entry is a Markdown file stored in the [\_pages]({{ site.github.repository_url }}/tree/master/_pages) directory. Jekyll provides auto-generated lists, references to other entries, and other programmatic page generation.

## Top-level lists

* [List of everything](./List-of-everything)
* [List of everything by date](./List-of-everything-by-date)
* [List of everything by tag](./List-of-everything-by-tag)
* [List of lists](./List-of-lists)
* [List of people](./List-of-people)
* [List of posts](./List-of-posts)
* [List of projects](./List-of-projects)
* [List of tags](./List-of-tags)
* [List of teams](./List-of-teams)

<form method="get" action="{{ site.github.repository_url }}/search">
  <p>
  <label>Search on GitHub: <input name="q" type="text"></label>
  <input type="submit" value="Search">
  </p>
</form>

## Tags

<ul class="item-list">
{% assign pages = site.pages | where_exp: "item","item.categories contains 'tag'" | sort: "title" %}
{% for page in pages %}
  <li><a href=".{{ page.url }}">{{ page.title }}</a>{{ page.excerpt }}</li>
{% endfor %}
</ul>

<p><a href="{{ site.github.repository_url }}/edit/master/{{ page.path }}">Edit on GitHub</a></p>
