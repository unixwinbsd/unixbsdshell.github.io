---
title: How to Learn to Create a BLOG With Go Hugo Part 1
date: "2025-08-20 09:46:29 +0100"
updated: "2025-08-20 09:46:29 +0100"
id: how-to-learn-create-blog-with-go-hugo-on-freebsd-1
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-88.jpg
toc: true
comments: true
published: true
excerpt: In this post, we will show you how you can create your own blog for free using the three technologies above. In this article we use the FreeBSD 13.2 engine to build a blog that we can publish online via the internet.
keywords: static, site, blog, go, hugo, go hugo, freebsd, learn, create, github, page, gitea, gitlab
---

Writing technical content is a skill. Like any skill, the only way to improve is by practice. An easy way to write and share technical content is to create a blog and share your technology experiences with others on the Internet.

Many people assume that creating your own website or blog requires technical expertise (such as knowledge of database servers, web servers, content management systems such as WordPress or Joomla) and a financial investment to buy a domain or pay for VPS Hosting.

**Ideally, we should have three goals when creating and maintaining our own blog:**

- No/Low-Cost : Free or low cost
- Productive : Easy to write, edit and maintain
- Cloud Native : Leverages public cloud services for hosting, enabling unlimited scaling.

**To realize the three things above, we can use the following technology to achieve this goal:**

- **Markdown** - A markup language that is natively readable, easy to write, and can be easily converted to HTML.
- **Hugo** - A static site generator written in Go that allows content written in Markdown to be rendered to HTML web pages.
- **GitHub Pages** - A GitHub service that hosts web content (such as HTML web pages) stored in a GitHub repository.

In this post, we'll show you how you can create your own blog for free using the three technologies above. In this article we use the FreeBSD 13.2 engine to build a blog that we can publish online via the internet. You can also practice the discussion or content of this article directly on a Linux machine such as Ubuntu, CentOS or Debian and can also use Windows OS and MacOS.

## 1. System Specifications

- OS: FreeBSD 13.2
- Hostname: ns6
- Domain: datainchi.com
- IP Address: 192.168.5.2
- Golang version: go 1.20,2
- GoHugo version: hugo v0.111.3+extended freebsd/amd64
- Port Gohugo: 8999

## 2. Create a New Project

As the first step in creating a blog with Hugo, we have to prepare a new project name. We will use this project as a folder to store all our blog data. Follow the steps below to create a Blog project with GoHugo.

```console
root@ns1:~ # cd /var
root@ns1:/var # mkdir -p blog
root@ns1:/var # cd blog
root@ns1:/var/blog # hugo new site blogspot
Congratulations! Your new Hugo site is created in /var/blog/blogspot.

Just a few more steps and you're ready to go:

1. Download a theme into the same-named folder.
   Choose a theme from https://themes.gohugo.io/ or
   create your own with the "hugo new theme <THEMENAME>" command.
2. Perhaps you want to add some content. You can add single files
   with "hugo new <SECTIONNAME>/<FILENAME>.<FORMAT>".
3. Start the built-in live server via "hugo server".

Visit https://gohugo.io/ for quickstart guide and full documentation.
root@ns1:/var/blog #
```

In the script above we create a project with the name `"blogspot"` which is placed in the `/var/blog` folder, while the `"hugo new site blogspot"` script creates a blog with Gohugo and the folder for storing data for all our blogs is named "blogspot". With the script above, we already have our own blog with the name "blogspot" and the blog is ready to be edited or manipulated, such as writing data structures, writing articles and so on.

Now let's look at the contents of the `/var/blog/blogspot` folder.

```
root@ns1:/var/blog # cd blogspot
root@ns1:/var/blog/blogspot # ls
archetypes	assets		config.toml	content		data		layouts		public		static		themes
```

If we describe it, it will look as follows:

{% raw %}
```
blogspot/
+-- archetypes
 |     ¦
 |     +-- default.md
+-- config.toml
+-- content
+-- data
+-- layouts
+-- static
+-- themes
```
{% endraw %}

The next step, delete the contents of the `"/var/blog/blogspot/hugo.toml"` file and replace it with the script below.

{% raw %}
```
baseURL = 'https://datainchi.com/'
languageCode = 'en-us'
tittle = "Exploring the Operating Sistem of Linux"
```
{% endraw %}

You can adjust the contents of the **"/var/blog/blogspot/ hugo.toml"** file to the specifications of the server machine you are currently using.

Because in this article we use the domain **"datainchi.com"** in the baseURL section written with the domain name that we use.


## 3. Create a Home Page

In this sub-chapter, we will discuss how to create a layout for the home page and other layouts for our blog pages. We will place this home page in the `/var/blog/blogspot/layouts/index.html` folder. Below is the script that you must type in the file `"/var/blog/blogspot/layouts/index.html"`.

{% raw %}
```
root@ns6:/var/blog/blogspot # touch /var/blog/blogspot/layouts/index.html
root@ns6:/var/blog/blogspot # ee /var/blog/blogspot/layouts/index.html
<!DOCTYPE html>
<html lang="en-US">
<head>
<meta charset="utf-8">
<title>{{ .Site.Title }}</title>
</head>
<body>
<h1>{{ .Site.Title}}</h1>
{{ .Content }}
</body>
</html>
```
{% endraw %}

The {% raw %}{{ .content }}{% endraw %} line displays the content of the home page, which will come from the blog we created and taken from the `/var/blog/blogspot/content` folder we created above.

For a site's home page, Hugo will look for content in a file called `_index.md` in the content directory. This special file name is how Hugo finds content for all index pages, such as the home page and content lists such as tags, categories, or other collections that we will create.

The next step is to create the file `"/var/blog/blogspot/content/_index.md"`. We can place any valid Markdown content into this file. Type the following script in the file.

{% raw %}
```
root@ns6:/var/blog/blogspot # touch /var/blog/blogspot/content/_index.md
root@ns6:/var/blog/blogspot # ee /var/blog/blogspot/content/_index.md

Exploring the Operating Sistem of Linux
Think Globally For Linux because Linux is for human life. Datainchi Born to explore Linux

* About Us
* Sitemap
* FeedRSS
```
{% endraw %}

After we have created the Content file in the `/var/blog/blogspot/content/_index.md` file, the next step is to run GoHugo. Type the following command to run the GoHugo server.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

The script above is used to run the Gohugo server. In the script above, we run Gohugo on IP **192.168.5.2 with port 8999** according to the system specifications that we have determined in the discussion in sub-chapter 1 above.

The next step is to test whether Gohugo can be opened with a web browser. We open the Yandex or Google Chrome web browser and in the address bar menu type `"http://192.168.5.2:8999/"` and the results will appear as follows:

<br/>

![oct-25-88](https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-88.jpg)

<br/>


## 4. Creating Content With Archetypes

When you create content with `/var/blog/blogspot/content/_index.md` file, it means we created Content file manually. We can ask Hugo to create a content page that contains a Content placeholder. This way, we don't have to start with a blank slate when creating content. Hugo uses Archetypes to define this default content. Type the command below to start creating Content with archetypes.


```
root@ns1:/var/blog/blogspot # hugo new about.md
Content "/var/blog/blogspot/content/about.md" created
```

The script above will produce the Content file **"about.md"** which is located at `"/var/blog/blogspot/content/about.md"`. After that, open the file and delete all the contents of the script and replace it with the script below.

{% raw %}
```
date = '2025-05-30T09:34:02+07:00'
draft = true
title = 'About'

Think Globally For Linux because Linux is for human life. Datainchi Born to explore Linux
```
{% endraw %}

After that we continue by creating a new folder called `_default`. Type the following script to create the folder.

```sh
root@ns1:/var/blog/blogspot # mkdir -p /var/blog/blogspot/layouts/_default
```

We continue by copying the file `index.html`, below is the script that we type to copy the file.


```sh
root@ns1:/var/blog/blogspot # cp layouts/index.html layouts/_default/single.html
```

Then delete all the scripts in the `"/var/blog/blogspot/layouts/_default/single.html"` file and replace them with the script below.

{% raw %}
```
<!DOCTYPE html>
<html lang="en-US">
<head>
<meta charset="utf-8">
<title>{{ .Site.Title }}</title>
</head>
<body>
<h1>{{ .Site.Title}}</h1>
<h2>{{ .Title }}</h2>
{{ .Content }}
</body>
</html>
```
{% endraw %}

Run the GoHugo server.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

We can see the results by opening the Google Chrome web browser by typing `"http://192.168.5.2:8999/about/"`.

<br/>

![oct-25-89](https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-89.jpg)

<br/>


It seems that this is enough discussion in part 1 here, we will continue to part 2 with a more difficult discussion of course from part 1. Hopefully this article in part 1 will be a reference material for all of us to stay enthusiastic and continue learning GoHugo as a Static Blog creation application.
