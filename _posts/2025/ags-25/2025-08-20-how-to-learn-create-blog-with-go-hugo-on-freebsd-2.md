---
title: How to Learn to Create a BLOG With Go Hugo Part 2
date: "2025-08-20 17:25:43 +0100"
updated: "2025-08-20 17:25:43 +0100"
id: how-to-learn-create-blog-with-go-hugo-on-freebsd-2
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-90.jpg
toc: true
comments: true
published: true
excerpt: In this article we will create our own theme, even though the theme we create is very simple, the most important thing is that we understand the code structure contained in the theme, only after that we compare it with themes made by other people which are widely spread on the internet.
keywords: static, site, blog, go, hugo, go hugo, freebsd, learn, create, github, page, gitea, gitlab
---

In part 1 we learned how to create a simple and simple blog, in this discussion we will learn how to create a basic theme to beautify the appearance of the blog. There are many Hugo themes that we can use and the ready-to-use themes are quite complex with many features that take time to configure properly. It's best to understand how a theme works before we dive into other people's code that exists within the theme.

In this article we will create our own theme, even though the theme we create is very simple, the most important thing is that we understand the code structure contained in the theme, only after that we compare it with themes made by other people which are widely spread on the internet.


## 1. Creating a Hugo Theme

We can create a theme by creating a new directory in your site's `"themes"` folder, but Hugo has a built-in theme generator that creates everything we need for the theme. Run this command from the root of your Hugo site to generate a new theme called `"basic"`.

```console
root@ns1:~ # cd /var/blog/blogspot
root@ns1:/var/blog/blogspot # hugo new theme basic
Creating theme at /var/blog/blogspot/themes/basic
```


After the `"basic"` theme has been successfully created, a theme structure will be formed in the `/var/blog/blogspot/themes/basic` folder. The following is the theme structure that we created with the command above.

<br/>

![oct-25-90](https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-90.jpg)

<br/>
    

The next step is to move several files in the `/var/blog/blogspot/layouts` folder to the `/var/blog/blogspot/themes` folder.


```sh
root@ns1:/var/blog/blogspot # mkdir -p /var/blog/blogspot/themes/basic/layouts/_default
root@ns1:/var/blog/blogspot # mv /var/blog/blogspot/layouts/index.html /var/blog/blogspot/themes/basic/layouts/index.html
root@ns1:/var/blog/blogspot # mv /var/blog/blogspot/layouts/_default/single.html /var/blog/blogspot/themes/basic/layouts/_default/single.html
```


After that we edit the `/var/blog/blogspot/config.toml` file, at the end of the script add the command theme = "basic" Complete example of the `/var/blog/blogspot/hugo.toml` file after we edit.

{% raw %}
```
baseURL = 'https://datainchi.com/'
languageCode = 'en-us'
title = 'Exploring the Operating Sistem of Linux'
theme = "basic"
```
{% endraw %}

Run our Gohugo server by typing the following command.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```


Open Google Chrome and type `"http://192.168.5.2:8999/"`, then the blog display from our GoHugo server will appear.

<br/>

![oct-25-91](https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-91.jpg)

<br/>


## 2. Using Content Blocks and Partials

Home page layouts and single page layouts both contain HTML script frameworks. The framework will become more complex once we add headers, footers, and navigation. Rather than duplicating that code in multiple places, Hugo provides one place for us to put your framework so that all other layouts can be built based on that code. When we create a theme, the theme is created to beautify the appearance of our blog.

Open the file `"/var/blog/blogspot/themes/basic/layouts/_default/baseof.html"`, and look at the script code in it. The file will be the "base" of every other layout we will create, as the name suggests. Below are the contents of the file `"/var/blog/blogspot/themes/basic/layouts/_default/baseof.html"`.


{% raw %}
```console
root@ns1:/var/blog/blogspot # touch /var/blog/blogspot/themes/basic/layouts/_default/baseof.html
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/themes/basic/layouts/_default/baseof.html
<!DOCTYPE html>
<html>
    {{- partial "head.html" . -}}
    <body>
        {{- partial "header.html" . -}}
        <div id="content">
        {{- block "main" . }}{{- end }}
        </div>
        {{- partial "footer.html" . -}}
    </body>
</html>
```
{% endraw %}

The first section listed in the baseof.html file is the head.html file, which is located in the `/var/blog/blogspot/themes/basic/layouts/partials` folder. This file will contain code that usually appears in the head section of a website or blog. Enter the script below in the file `/var/blog/blogspot/themes/basic/layouts/partials/head.html`.

{% raw %}
```
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{ .Site.Title }}</title>
</head>
```
{% endraw %}

The next partial reference is the header.html file, this file will store your page header. That's where you'll place your banner and navigation. Add the following code to the file `/var/blog/blogspot/themes/basic/layouts/partials/header.html`.

{% raw %}
```
<header>
<h1>{{ .Site.Title }}</h1>
</header>
<nav>
<a href="/">Home</a>
<a href="/about">About Us</a>
<a href="/resume">Privacy Policy</a>
<a href="/contact">Disclaimer</a>
</nav>
```
{% endraw %}

Finally we will create a folder for the Footer layout, type the script below in the file `"/var/blog/blogspot/themes/basic/layouts/partials/footer.html"`.

{% raw %}
```
<footer>
<small>Copyright {{now.Format "2006"}} Exploring the Operating Sistem of Linux.</small>
</footer>
```
{% endraw %}

The next step is to determine the blocks on the layout of the blog home page that we will create. Open the file `/var/blog/blogspot/themes/basic/layouts/index.html`, delete the contents of the script and replace it with the script below.

{% raw %}
```
{{ define "main" }}
{{ .Content }}
{{ end }}
```
{% endraw %}

When the GoHugo server does a BUILD on the blog that we created, the GoHugo server will create a home page by combining the content file **(/var/blog/blogspot/content/_index.md)** with the layout file, which will then use the baseof file. Some or all of the content is combined, creating one full page.

The index.html layout file only affects the home page of the blog we create, so change the script code in the `/var/blog/blogspot/themes/basic/layouts/_default/single.html` file, so that the single page layout functions the same way. Below are the contents of the script from the file `/var/blog/blogspot/themes/basic/layouts/_default/single.html`.

{% raw %}
```
{{ define "main" }}
<h2>{{ .Title }}</h2>
{{ .Content }}
{{ end }}
```
{% endraw %}

After that, run the GoHugo server by typing the script below.


```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

We can see the results by opening the Google Chrome web browser and typing `"http://192.168.5.2:8999/"`, it will appear as shown in the image below.

<br/>

![oct-25-92](https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-92.jpg)

<br/>

The display above still looks chaotic and looks untidy. We will tidy up the appearance of the image above using CSS.


## 3. Setting Themes With CSS

In addition to layout files, theme files contain images, scripts, and style sheets that control the visual aspects of a blog site, such as colors, fonts, and content placement. These assets go into the `/var/blog/blogspot/static` directory. In this folder we will find a CSS folder and a JS folder.

Before we get started with CSS, let's add more structure to the layout so we can have more control over the page width. This will be useful on larger devices. Change the baseof file to wrap everything in a div with the container class, and change the existing div tags around the main block to HTML main body tags. The main tag will make it easier for assistive technologies to identify the blog site's main content, and the container div will allow us to control how wide the site is on larger monitors when you add CSS.

Open and edit the file `/var/blog/blogspot/themes/basic/layouts/_default/baseof.html`, so the script will be like below.

{% raw %}
```
<!DOCTYPE html>
<html>
{{- partial "head.html" . -}}
<body>
<div class="container">
{{- partial "header.html" . -}}
<main>
{{- block "main" . }}{{- end }}
</main>
{{- partial "footer.html" . -}}
</div>
</body>
</html>
```
{% endraw %}

After that, we continue by creating a CSS stylesheet file. In the `/var/blog/blogspot/themes/basic/static/css` folder, we create a file called "style.css" and type the script below in the file `/var/blog/blogspot/themes/basic/static/css/style.css`.

{% raw %}
```
root@ns1:/var/blog/blogspot # mkdir -p /var/blog/blogspot/themes/basic/static/css
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/themes/basic/static/css/style.css

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
}
```
{% endraw %}

As a final step, we edit the file `/var/blog/blogspot/themes/basic/layouts/partials/head.html`, and type the following script in the file.

{% raw %}
```
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{ .Site.Title }}</title>
<link rel="stylesheet" href="{{ "css/style.css" | relURL }}">
</head>
```
{% endraw %}

Then we run the Gohugo server.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

To see the results, we open the Yandex or Google Chrome web browser and type `"http://192.168.5.2:8999/"`, then it will appear as shown in the image below.

<br/>

![oct-25-93](https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-93.jpg)

<br/>

Now the appearance of our blog is a little neater and looks cuter, pleasing to the eye and eye. We will end the discussion in part 2 here. Hopefully your knowledge will increase somewhat with the article in part 2. We will continue the discussion to part 3, with a script that is more complicated and of course more challenging.