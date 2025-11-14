---
title: Site Search
layout: default
excerpt: Search Article
permalink: /search/
---


<ul id="search-results"></ul>

<script>
  // Template to generate the JSON to search
  window.store = {
    {% for post in site.posts %}
      "{{ post.url | slugify }}": {
        "title": "{{ post.title | xml_escape }}",
        "author": "{{ post.author | xml_escape }}",
        "category": "{{ post.category | xml_escape }}",
        "content": {{ post.content | strip_html | strip_newlines | jsonify }},
        "url": "{{ post.url | xml_escape }}"
      }
      {% unless forloop.last %},{% endunless %}
    {% endfor %}
  };
</script>

<!-- Import lunr.js from unpkg.com -->
<script src="{{ '/assets/theme/js/lunr.js' | relative_url }}"></script>
<!-- Custom search script which we will create below -->
<script src="/assets/theme/js/search.js"></script>

<!--
<script src="{{ '/assets/theme/js/lunr.js' | relative_url }}"></script>
<link rel="preload" href="/assets/theme/js/lunr.js" as="script" />
-->
