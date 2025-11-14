---
title: How to Learn to Create a BLOG With Go Hugo Part 5
date: "2025-08-22 08:01:55 +0100"
updated: "2025-08-22 08:01:55 +0100"
id: how-to-learn-create-blog-with-go-hugo-on-freebsd-5
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-103.jpg
toc: true
comments: true
published: true
excerpt: In this material we will discuss creating a website or blog with GoHugo. The main discussion this time focuses more on retrieving data using remote repositories or external repositories such as Github or Bootstrap.
keywords: static, site, blog, go, hugo, go hugo, freebsd, learn, create, github, page, gitea, gitlab
---

In this material we will discuss creating a website or blog with GoHugo. The main discussion this time focuses more on retrieving data using remote repositories or external repositories such as Github or Bootstrap.

To get Github server data, we will use the GitHub API and then make a request to `https://api.github.com/nameusers/<project name>`. It returns a JSON collection from all Github repositories without requiring any authorization. So that we can use the Github repository with the GoHugo server, the main requirement and what we do is have a Github account.

If you don't have a Github account, create one first and note down/save the Github account username.

To be able to use the Github repository, open and edit the `/var/blog/blogspot/hugo.toml` file, then insert the script below into that file.

{% raw %}
```
baseURL = 'http://unixexplore.com/'
languageCode = 'en-us'
title = 'Nusantara Bercoding'
theme = "basic"

[params]
author = "Iwan Setiawan"
description = "Helping You To Do Learn Opensource UNIX BSD And Web Site With Blogger"
gh_url = "https://api.github.com/users"
gh_user = "iwanse1977"
```
{% endraw %}

Then, create a layout, namely by creating a file `"/var/blog/blogspot/themes/basic/layouts/_default/opensource.html"`. 

Use the command below to create the file and enter the script as in the following example.

{% raw %}
```
root@ns1:/var/blog/blogspot # touch /var/blog/blogspot/themes/basic/layouts/_default/opensource.html
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/themes/basic/layouts/_default/opensource.html

{{ define "main" }}
<h2>{{ .Title }}</h2>
{{ .Content }}
{{ $url := printf "%s/%s/repos" .Site.Params.gh_url .Site.Params.gh_user }}
{{ $repos := getJSON $url }}
<section class="oss">
{{ range $repos }}
<article>
<h3><a href="{{ .html_url }}">{{ .name }}</a></h3>
<p>{{ .description }}</p>
</article>
{{ end }}
</section>
{{ end }}
```
{% endraw %}

Next, create a new content page for the file named `"opensource.md"`. Use the following command to create the `"opensource.md"` content.

```
root@ns1:/var/blog/blogspot # hugo new opensource.md
Content "/var/blog/blogspot/content/opensource.md" created
```

Next, we replace the script in the file `"/var/blog/blogspot/content/opensource.md"`, with the script below.

{% raw %}
```
---
title: "Opensource"
date: 2025-09-27T14:44:36+07:00
draft: false
layout: opensource
---
My Open Source Software on GitHub:
```
{% endraw %}

If you have created a project on Github, the project will be displayed by the GoHugo server on the blog site that we are creating.

GoHugo is a static site generator that converts existing content documents into web pages. GoHugo doesn't have the built-in ability to generate content pages from data, but we can still make it work. For example, we can still write a small script that reads the data and generates a Markdown document, which is stored in the content folder, then, when we run GoHugo to build the site, the resulting pages will be included.

In this case, Hugo developers want GoHugo to stay focused on fast website creation. As a result, we will often rely on outside tools or external Hugo repositories for more complex situations.

Now we continue to beautify the appearance, we will create a "css" file. Enter the following script into the file `"/var/blog/blogspot/themes/basic/static/css/style.css"`.

{% raw %}
```
.container {
margin: 0 auto;
width: 80%;
}

nav, footer {
background-color: #333;
color: #fff;
text-align: center;
}

nav {
display: flex;
flex-direction: column;
}
nav > a {
flex: 1;
text-align: center;
text-decoration: none;
color: #fff;
}
@media only screen and (min-width: 768px) {
nav { flex-direction: row; }

.project-container { display: flex; }

.project-container .project-list { width: 20%; }

.project-container .project { flex: 1; }
}

.oss {
display: flex;
flex-wrap: wrap;
justify-content: space-between;
}
.oss article {
border: 1px solid #ddd;
box-shadow: 3px 3px 3px #ddd;
margin: 0.5%;
padding: 0.5%;
width: 30%;
}
```
{% endraw %}

After that, we open and edit the file `"/var/blog/blogspot/themes/basic/layouts/projects/list.html"`. Delete all the contents of the script and insert the new script below in the file.

{% raw %}
```
{{define "main"}}
<small>portfolio\themes\basic\layouts\projects\list.html</small>
<h2>{{.Title}}</h2>
<div>
  {{.Content}}
  {{ range first 1 (where site.RegularPages "Type" "in" "projects").ByDate.Reverse }}
  info: aktuellstes projekt in der liste ist <a href="{{.RelPermalink}}">{{.Title}}<a>
  {{end}}
</div>
<ul>
  {{range.Pages}}
  <li><a href="{{.RelPermalink}}">{{.Title}}<a>
  <br />{{.Summary}}</li>
  {{end}}
</ul>
<div>
  {{ with .Site.GetPage "/opensource.md" }}
  <h4><a href="{{ .RelPermalink }}">{{.Title}}</a>&nbsp;
  <small>({{ .Summary }})</small></h4>
  {{ end }}
</div>
{{end}}
```
{% endraw %}

The script above will take data from any page into the layout that we have created. Now let's try to activate the GoHugo server by typing the script below.

```
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

and see the results by opening the Google Chrome web browser by typing `"http://192.168.5.2:8999/opensource/"`. 




## 1. Content With RSS


GoHugo is able to create RSS feeds for websites/blogs automatically using the default RSS 2.0 template. If we type `"http://192.168.5.2:8999/index.xml"` in the Chrome web browser, we will find a built-in RSS Feed that includes all your pages and looks like the one below.

{% raw %}
```
<?xml version="1.0" encoding="utf-8" standalone="yes" ?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
<title>Brian&#39;s Portfolio</title>
<link>http://localhost:1313/</link>
<description>Recent content on Brian&#39;s Portfolio</description>
<generator>Hugo -- gohugo.io</generator>
<language>en-us</language>
<lastBuildDate>Thu, 02 Jan 2020 12:45:51 -0600</lastBuildDate>
<atom:link href="http://localhost:1313/index.xml" rel="self"
type="application/rss+xml" />
<item>
<title>Open Source Software</title>
<link>http://localhost:1313/opensource/</link>
<pubDate>Thu, 02 Jan 2020 12:42:17 -0500</pubDate>
<guid>http://localhost:1313/opensource/</guid>
<description>My Open Source Software:</description>
</item>
...
</channel>
</rss>
```
{% endraw %}

Even though GoHugo automatically creates an RSS feed, the feed is hidden and not displayed by GoHugo. So that RSS feeds from websites/blogs can be seen by others, we can add meta tags to the header to our website. The writing script is `<link rel="alternate" type="application/rss+xml" href="http://example.com/feed" >`

To be able to display RSS, you can use these tags to identify RSS feeds automatically. Open and replace the script in the file `"/var/blog/blogspot/themes/basic/layouts/partials/head.html"` with the script below.

{% raw %}
```
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>
{{- if .Page.IsHome -}}
{{ .Site.Title }}
{{- else -}}
{{ .Title }} – {{ .Site.Title }}
{{- end -}}
</title>
<meta name="author" content="{{ .Site.Params.author }}">
<meta name="description" content="
{{- with .Page.Description -}}
{{ . }}
{{- else -}}
{{ .Site.Params.description }}
{{- end -}}">
<link rel="stylesheet" href="{{ "css/style.css" | relURL }}">
{{ range .AlternativeOutputFormats -}}
{{- $link := `<link rel="%s" type="%s" href="%s" title="%s">` -}}
{{- $title := printf "%s - %s" $.Page.Title $.Site.Title -}}
{{- if $.Page.IsHome -}}
{{ $title = $.Site.Title }}
{{- end -}}
{{ printf $link .Rel .MediaType.Type .Permalink $title | safeHTML }}
{{- end }}
</head>
```
{% endraw %}


## 2. Rendering Content as JSON

GoHugo also supports JSON format files, which means you can use Hugo to create JSON APIs that can be consumed from other applications. Unlike RSS feeds, we need to create a layout for JSON file output, and we have to specify which pages on our website should use the JSON file output type.


To explore JSON files in GoHugo, we will create a JSON list of project pages containing the title and URL for each project page, which can then be used from other applications. The resulting file will look like this.

{% raw %}
```
{
"projects": [
{
"url": "http://example.org/projects/awesomeco/",
"title": "Awesomeco",
},
{
"url": "http://example.org/projects/jabberwocky/",
"title": "Jabberwocky",
}
]
}
```
{% endraw %}

As a first step in creating a file in JSON format, we create a new file called "list.json". Use the command below to create the file `"/var/blog/blogspot/themes/basic/layouts/projects/list.json"` and insert the script below into the file.

{% raw %}
```
root@ns1:/var/blog/blogspot # touch /var/blog/blogspot/themes/basic/layouts/projects/list.json
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/themes/basic/layouts/projects/list.json

{
"projects": [
{{- range $index, $page := (where .Site.RegularPages "Type" "in" "projects") }}
{{- if $index -}} , {{- end }}
{
"url": {{ .Permalink | jsonify }},
"title": {{ .Title | jsonify }}
}
{{- end }}
]
}
```
{% endraw %}

In this case, the output format needs to be specified on the project list content page. Edit the content/projects/_index.md file and add the following front line to tell GoHugo to generate a JSON file in addition to the HTML and XML files it generates by default.

Now let's try to activate the GoHugo server, by typing the following command.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

As the final step, we see the results of our work by opening the Yandexs or Chrome web browser, in the address bar menu type `"http://192.168.5.2:8999/projects/"`. The result will look like the following image.

![oct-25-103.jpg](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-103.jpg)


We've successfully integrated some JSON data into a website we're designing, loading a GitHub repository from a publicly viewable GitHub API. Additionally, we have also used data from configuration files and individual frontends throughout our website/blog. The discussion in this article ends here, so that you are not confused about learning GoHugo and also to make learning easier. We will continue the discussion in the next article.