---
title: How to Learn to Create a BLOG With Go Hugo Part 4
date: "2025-08-21 20:33:21 +0100"
updated: "2025-08-21 20:33:21 +0100"
id: how-to-learn-create-blog-with-go-hugo-on-freebsd-4
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-99.jpg
toc: true
comments: true
published: true
excerpt: In the discussion of this article we will learn how to use data and configure it on a blog site theme. For example, we will create an additional <meta> tag in the header of the blog that we are designing. Open the config.toml file
keywords: static, site, blog, go, hugo, go hugo, freebsd, learn, create, github, page, gitea, gitlab
---


Currently, if we look at a modern blog site, the structure prioritizes data, this data may come in the form of content stored in Markdown files, or from external APIs. GoHugo has built-in support for incorporating external data files into blog sites, and GoHugo can also retrieve data from remote sources to generate content for the layout of a blog site.

<br/>

![proyek blog go hugo](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-99.jpg)

<br/>

In the discussion of this article we will learn how to use data and configure it on a blog site theme. For example, we will create an additional <meta> tag in the header of the blog that we are designing. Open the `"config.toml"` file and add a new params section that defines the blog creator and blog description. Below is a script typed in the file `"/var/blog/blogspot/hugo.toml"`.

{% raw %}
```
baseURL = 'http://unixexplore.com/'
languageCode = 'en-us'
title = 'Nusantara Bercoding'
theme = "basic"

[params]
author = "Iwan Setiawan"
description = "Exploring the Operating Sistem of Linux Think Globally For Linux because Linux is for human life. Datainchi Born to explore Linux"
```
{% endraw %}

Then open and edit the file `/var/blog/blogspot/archetypes/projects.md`, type the script below in the file.

{% raw %}
```
---
title: "Exploring the Operating Sistem of Linux"
draft: false
---
![alt](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjgldOXevWqAGanRH9_l6exveD1FJ2exPCVwiJZXw2Uf8oodHnVE-MzQ9YTXi0L0WSnKd2tQvDrCF2_FPHXv6b9DY76s0_J3gk-1gorNja_cuEGsUg0VV4SNEjvMD2ZuLmPn4AVkO4-R44ggIW1ji5pB9kbqh46dpwJdAyjLUy4ockAaw/s1600/FreeBSD%20YAML%20File%20In%20Python.png)

Exploring the Operating Sistem of Linux Think Globally For Linux because Linux is for human life. Datainchi Born to explore Linux

### Tech used
* DNS Server
* Web Server
* Web Blog
```
{% endraw %}

After that, we create a new project with the name "mountbromo.md", type the script below to create a new project "gunungbromo.md".

```sh
root@ns1:~ # cd /var/blog/blogspot
root@ns1:/var/blog/blogspot # hugo new projects/mountbromo.md
Content "/var/blog/blogspot/content/projects/gunungbromo.md" created
```

Type the script below in the file `/var/blog/blogspot/content/projects/mountbromo.md`.

{% raw %}
```
---
title: "Implementing Apache Web Socket on FreeBSD server"
draft: false
---
![alt](https://raw.githubusercontent.com/iwanse1977/iwanse1977/main/reverse2.png)

Exploring the Operating Sistem of Linux Think Globally For Linux because Linux is for human life. Datainchi Born to explore Linux

### Tech used
* DNS Server
* Web Server
* Web Blog
```
{% endraw %}

The next step, we open the file `"/var/blog/blogspot/themes/basic/layouts/projects/single.html"` and type the script below in the file.

{% raw %}
```
{{ define "main" }}
<div class="project-container">
<section class="project-list">
<h2>Projects</h2>
<ul>
{{ range (where .Site.RegularPages "Type" "in" "projects") }}
<li><a href="{{ .RelPermalink }}">{{ .Title }}</a></li>
{{ end }}
</ul>
</section>
<section class="project">
<h2>{{ .Title }}</h2>
{{ .Content }}
<h4>We Are Focus For FreeBSD Tutorials</h4>
<ul>
{{ range .Params.tech_used }}
<li>{{ . }}</li>
{{ end }}
</ul>
</section>
</div>
{{ end }}
```
{% endraw %}

We continue by creating a new file with the name `"list.html"` and enter the script below into the `/var/blog/blogspot/themes/basic/layouts/projects/list.html` file.

{% raw %}
```
root@ns1:/var/blog/blogspot # touch /var/blog/blogspot/themes/basic/layouts/projects/list.html
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/themes/basic/layouts/projects/list.html

{{ range .Pages }}
<section class="project">
<h3><a href="{{ .RelPermalink }}">{{ .Title }}</a></h3>
<p>{{ .Summary }}</p>
</section>
{{ end }}
</section>
```
{% endraw %}

After that, open and edit the file `"/var/blog/blogspot/themes/basic/layouts/_default/list.html"`, below is the script that you have to type in the file.

{% raw %}
```
{{define "main"}}
<small>var\blog\blogspot\themes\basic\layouts\_default\list.html</small>
<h2>{{.Title}}</h2>
<ul>
  {{range.Pages}}
  <li><a href="{{.RelPermalink}}">{{.Title}}<a></li>
  {{end}}
</ul>
{{end}}
```
{% endraw %}

The final step is to run the GoHugo server, type the following script to activate the GoHugo server.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

To see the results, we open the Google Chrome, Yandex or other web browser such as Modzilla Firefox. In the address bar menu, type `"http://192.168.5.2:8999/projects/"`, the results will look like the image below.

<br/>

![Go Hugo blog content](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-100.jpg)

<br/>

Try clicking on one of these projects, for example the `"Implementing Apache Web Socket on FreeBSD server"` project and the results will be like the image below.

<br/>

![gohugo blog page list](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-101.jpg) 

<br/>

In the discussion above we learned how to add <meta> tags to page descriptions, but the best practice is to create descriptions that reflect what is actually on the page. We'll add conditional logic to the layout to control how the data is displayed. For example, we can check if there is a description field defined on the page, and if there is not, we can go back to the previous description.

To handle the case where we want to check the value in a default variable in a page description, replace the meta description in `"/var/blog/blogspot/themes/basic/layouts/partials/head.html"` with the script below.

{% raw %}
```
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{ .Site.Title }}</title>
<meta name="author" content="{{ .Site.Params.author }}">
<meta name="description" content="
{{- with .Page.Description -}}
{{ . }}
{{- else -}}
{{ .Site.Params.description }}
{{- end -}}">
<link rel="stylesheet" href="{{ "css/style.css" | relURL }}">
</head>
```
{% endraw %}

Meanwhile the `<title>` element currently uses the site title and does not accurately reflect individual page titles. This can have a bad impact on search engine rankings, but it is also bad from a usability perspective. The value of the <title> tag is what appears in the title of a browser or bookmark tab, as well as bookmarks someone creates.

Let's use the default site title on the home page, and use more specific page titles elsewhere. To do this, use the built-in if statement. The Site.IsHome variable checks whether we are on the home page or not and displays the site title or more specific page title. Open and edit the file `"/var/blog/blogspot/themes/basic/layouts/partials/head.html"` so that the script will look like the one below.

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
</head>
```
{% endraw %}


## 1. Using Local Data Files

Data directories can store structured data files in YAML, JSON, or TOML format that you can use in layouts to display content. We can write this data file or extract it from another source. Now we try adding social media profile information to the contact page of our GoHugo site.

To create social media content, we will create a file called `"socialmedia.json"`. In the file `/var/blog/blogspot/data/socialmedia.json`, enter the script below.

{% raw %}
```
root@ns1:/var/blog/blogspot # touch /var/blog/blogspot/data/socialmedia.json
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/data/socialmedia.json

{ "accounts" :
[
{
"name": "Twitter",
"url": "https://twitter.com/bphogan"
},
{
"name": "LinkedIn",
"url": "https://linkedin.com/in/bphogan"
}
]
}
```
{% endraw %}

Then in the `"/var/blog/blogspot/layouts/_default"` folder we add the "contact.html" file. Type the command below to create the file `"/var/blog/blogspot/layouts/_default/contact.html"` and add the script to it.

{% raw %}
```
root@ns1:/var/blog/blogspot # touch /var/blog/blogspot/layouts/_default/contact.html
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/layouts/_default/contact.html

{{ define "main" }}
<h2>{{ .Title }}</h2>
{{ .Content }}
<h3>Social Media</h3>
<ul>
{{ range .Site.Data.socialmedia.accounts }}
<li><a href="{{ .url }}">{{ .name }}</a></li>
{{ end }}
</ul>
{{ end }}
```
{% endraw %}

In this case, there is no such association, so we must explicitly assign the layout file to the Markdown file `"contact.md"`. Type the following command to create the file `"/var/blog/blogspot/content/contact.md"` and enter the script below into the file.

{% raw %}
```
root@ns1:/var/blog/blogspot # touch /var/blog/blogspot/content/contact.md
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/content/contact.md

---
title: "Contact"
date: 2025-01-01T12:55:44-05:00
draft: false
layout: contact
---

This is my Contact page.
```
{% endraw %}

The final step is to activate the GoHugo server, type the following command to run the GoHugo server.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

Now let's see the results, by opening the Yandex web browser or Google Chrome, and typing `"http://192.168.5.2:8999/contact/"` in the web browser's address bar menu. The result will look like the image below.

<br/>

![oct-25-102.jpg](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-102.jpg)

<br/>

We have finished the discussion in this article with the creation of social media links, we will continue with other material in the next section.