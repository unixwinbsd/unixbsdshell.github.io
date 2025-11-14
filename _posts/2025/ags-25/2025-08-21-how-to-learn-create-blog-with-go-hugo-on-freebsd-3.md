---
title: How to Learn to Create a BLOG With Go Hugo Part 3
date: "2025-08-21 09:10:33 +0100"
updated: "2025-08-21 09:10:33 +0100"
id: how-to-learn-create-blog-with-go-hugo-on-freebsd-3
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/img/oct-25-90.jpg
toc: true
comments: true
published: true
excerpt: In part 3, we will create a project on the site that will display all the article content on our blog. The discussion in this article focuses more on setting a special layout for a blog project, so that it is visually different from other parts.
keywords: static, site, blog, go, hugo, go hugo, freebsd, learn, create, github, page, gitea, gitlab
---

Hugo is designed to help bloggers display the article content that we have created to people quickly via the internet. Hugo has several rules and conventions about how to handle collections of content, if we understand them it will make it easier to add and manage entire sections of content to a blog site quickly.

In part 3, we will create a "project" on the site that will display all the article content on our blog. The discussion in this article focuses more on setting a special layout for a blog project, so that it is visually different from other parts. We'll use GoHugo's Archetype feature to create content templates, so we can create new project pages more quickly.


## 1. Creating an Archetype Project

To start this work, as a first step we will create a file called `"projects.md"`. In the file `"/var/blog/blogspot/archetypes/projects.md"` type the script below

{% raw %}
```
root@ns1:~ # cd /var/blog/blogspot/archetypes
root@ns1:/var/blog/blogspot/archetypes # ee projects.md

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

Whenever a new project is created, the GoHugo server will always use this file as the base, and we can use placeholder text here to quickly populate the new project. After that, we create a new project page which we will place in the /var/blog/blogspot/content/projects folder, here's an example.


```
root@ns1:/var/blog/blogspot # hugo new projects/mountsemeru.md
Content "/var/blog/blogspot/content/projects/gunungsemeru.md" created
```

Open and then edit the file `/var/blog/blogspot/content/projects/gunungsemeru.md`, so that the script will look like the one below.

{% raw %}
```
---
title: "Exploring the Operating Sistem of Linux"
draft: false
---

![Gitea](/img/Gitlab.png)

Exploring the Operating Sistem of Linux Think Globally For Linux because Linux is for human life. Datainchi Born to explore Linux

### Tech used
* DNS Server
* Web Server
* Web Blog
```
{% endraw %}

To see the results run the GoHugo server by typing.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

The script above will run the GoHugo server, now you open the Google Chrome web browser and type `"http://192.168.5.2:8999/projects/mountsemeru/"`. See the results.

<br/>

![oct-25-94](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-94.jpg)

<br/>

We turn off the GoHugo server and create a new project again with the name `"mountrinjani.md"`, type the script below to create the new project.


```
root@ns1:/var/blog/blogspot # hugo new projects/mountrinjani.md
Content "/var/blog/blogspot/content/projects/gunungrinjani.md" created
```

Then you edit the script in the file `/var/blog/blogspot/content/projects/mountsemeru.md`, so the script will look like the script below.

{% raw %}
```
---
title: "Exploring the Operating Sistem of Linux"
draft: false
---

![Gitea](/img/Gitlab.png)

Exploring the Operating Sistem of Linux Think Globally For Linux because Linux is for human life. Datainchi Born to explore Linux

### Tech used
* DNS Server
* Web Server
* Web Blog
```
{% endraw %}

Run the GoHugo server again and type `"http://192.168.5.2:8999/projects/mountrinjani/"` in the Chrome, Yandex or Firefox web browser. Note the difference.

<br/>

![oct-25-95](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-95.jpg)

<br/>


## 2. Create List Layouts


Creating a list layout is useful for creating tags and categories. To begin with, we determine a default list template that will function for all list pages on the blog site.

Open the file `/var/blog/blogspot/themes/basic/layouts/_default/list.html` then add the following script code to the file, which displays the content page title and creates a list of links to each content page.

{% raw %}
```
root@ns1:/var/blog/blogspot # touch /var/blog/blogspot/themes/basic/layouts/_default/list.html
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/themes/basic/layouts/_default/list.html

{{ define "main" }}
<h2>{{ .Title }}</h2>
<ul>
{{ range .Pages }}
<li><a href="{{ .RelPermalink }}">{{ .Title }}</a></li>
{{ end }}
</ul>
{{ end }}
```
{% endraw %}

Since v0.18, everything in Hugo is Pages. This means listing pages and home pages can have associated content files (i.e. _index.md) that contain page and content metadata. This new model means we can inject list-specific front matter via `".Params"` and also means that list templates (for example, layouts/_default/list.html) have access to all page variables.

Now let's try running the Gohugo server and see the results in the Google Chrome web browser.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

After successfully creating the List layout, we continue by creating a navbar or navigation menu. To create a navbar menu we rely on creating the file `/var/blog/blogspot/themes/basic/layouts/partials/header.html`. Based on this file, we create a new file `/var/blog/blogspot/themes/basic/layouts/partials/nav.html` and enter the script below in that file.

```
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/themes/basic/layouts/_partials/nav.html

<nav>
<a href="/">Home</a>
<a href="/about">About Us</a>
<a href="/projects">Projects</a>
<a href="/resume">Privacy Policy</a>
<a href="/contact">Disclaimer</a>
</nav>
```

In practice, we may want some pages or sections of our blog site to have a slightly different theme or layout. Now we create a custom layout for the project pages that displays a list of projects in the sidebar of each project page so that visitors can navigate the projects more easily. We'll use a similar approach to the one we just used to list the projects.

In the `/var/blog/blogspot/themes/basic/layouts` folder, create a new folder called `"projects"`, type the following command to create the `"projects"` folder.

```sh
root@ns1:/var/blog/blogspot # mkdir -p /var/blog/blogspot/themes/basic/layouts/projects
```

Then we will create a new file called `"single.html"` in the directory or folder `"/var/blog/blogspot/themes/basic/layouts/projects"`. The example below is how to create a file and include the script in the file `"/var/blog/blogspot/themes/basic/layouts/projects/single.html"`.

{% raw %}
```
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/themes/basic/layouts/projects/single.html

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
</section>
</div>
{{ end }}
```
{% endraw %}

After that, edit the file `/var/blog/blogspot/themes/basic/static/css/style.css` and enter the script as in the example below.

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
```
{% endraw %}

After that, we run or activate the GoHugo server and see the results in the Google Chrome web browser by typing `"http://192.168.5.2:8999/projects/"`.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

<br/>

![oct-25-96.jpg](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-96.jpg)

<br/>


Click one of the project options displayed in the project menu.

<br/>

![oct-25-97](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-97.jpg)

<br/>



### 3. Adding Content to List Pages

When you open `"http://192.168.5.2:8999/projects/"`, we will see a list of projects and nothing else. Now we will add some content to a page. To add content to a page, we need to add the _index.md file to the folder associated with the content. This is similar to the way we add content to the home page of the blog site that we created above. Type the following command to add content to the List pages.

```
root@ns1:/var/blog/blogspot # hugo new projects/_index.md
Content "/var/blog/blogspot/content/projects/_index.md" created
```

Open and replace the script in the `/var/blog/blogspot/content/projects/_index.md` file with the script below.

{% raw %}
```
---
---
title: "Internet Router Gateway With FreeBSD PF Firewall"
draft: false
---
![alt](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiLcKS_qrGc46Wu0zEAvHufvdbfjf6FtBi032U0jdPfQP2QqnHw_J9CIbivK90nbS8ZJFWt6ZkyFJO_rnlublq85cNA6E4Gqz43e1LmmzdbggwuxFJI8JdbZj5mvWLF8cdMauHVPUZhWd8EwQz1fd0owfhFbw0qY6-na-ksiR_8lVblQg/s1600/what-is-a-firewall.jpg)

Helping You To Do Learn Opensource UNIX BSD And Web Site With Blogger

### Tech used
* DNS Server
* Web Server
* Web Blog
```
{% endraw %}

After that, we open and replace the script in the `/var/blog/blogspot/themes/basic/layouts/_default/list.html` file with the script below.

{% raw %}
```
{{ define "main" }}
<h2>{{ .Title }}</h2>
{{ .Content }}
<ul>
{{ range .Pages }}
<li><a href="{{ .RelPermalink }}">{{ .Title }}</a></li>
{{ end }}
</ul>
{{ end }}
```
{% endraw %}

Run or activate the GoHugo server again and open it in Google Chrome by typing `"http://192.168.5.2:8999/projects/"` and look at the appearance of our blog site, it will definitely change.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

<br/>

![oct-25-98](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-98.jpg)

<br/>

Sometimes content can come from other sources, or we want other sites to be able to link to our content. GoHugo has several features that allow us to do both, and we'll explore them in the next article.