---
title: How to Learn to Create a BLOG With Go Hugo Part 6
date: "2025-08-22 19:21:14 +0100"
updated: "2025-08-22 19:21:14 +0100"
id: how-to-learn-create-blog-with-go-hugo-on-freebsd-6
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-104.jpg
toc: true
comments: true
published: true
excerpt: To simplify the process of hosting our content, we can use GoHugo to add a blog to a website so that it can be read by many people. To create a blog on GoHugo, we will create a new content type, called Post, and create a layout to support the appearance of the post so that it looks attractive and easy to read.
keywords: static, site, blog, go, hugo, go hugo, freebsd, learn, create, github, page, gitea, gitlab
---



When we want to share our thoughts with the rest of the world, using our own website is one of the best ways to do it. While there are other platforms that can be used to do this, choosing to host from your own domain offers certain advantages. We can measure the impact, control how information is presented, and more importantly, build our own brand with the content we have. Currently, to publish content elsewhere, we have to agree to their terms of service, and sometimes give up control of the content and communities we own.

To simplify the process of hosting our content, we can use GoHugo to add a blog to a website so that it can be read by many people. To create a blog on GoHugo, we will create a new content type, called `"Post"`, and create a layout to support the appearance of the post so that it looks attractive and easy to read.

There are many things we can do, in this article it is a development of what we have done in the previous article, but in this article we will apply it in a new way. Apart from creating content types and including a third party comment system and implementing an article numbering system, we can monitor the number of article posts in the future.

A blog post has a title, author's name, and several article posts. Maybe there's a summary too. With GoHugo we can also put posts into categories and tag them.

To start with the above, we can start by creating an archetype for the post. Create a file called `"posts.md"`, and enter the script as below in the file `"/var/blog/blogspot/archetypes/posts.md"`.

{% raw %}
```
root@ns1:/var/blog/blogspot # touch /var/blog/blogspot/archetypes/posts.md
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/archetypes/posts.md

---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: false
author: Iwan Setiawan
---

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua.
<!--more-->
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.
```
{% endraw %}

The file above will be used to generate the initial post on the GoHugo server, the method is to generate a file called `"post1.md"`. Type the command below to do this.

{% raw %}
```
root@ns1:/var/blog/blogspot # hugo new posts/post1.md
Content "/var/blog/blogspot/content/posts/post1.md" created
```
{% endraw %}

Then activate GoHugo by typing the following command.

{% raw %}
```console
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```
{% endraw %}

And see the results on your monitor screen, by opening the Google Chrome web browser by typing `"http://192.168.5.2:8999/posts/"`.

<br/>

![oct-25-104.jpg](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-104.jpg)

<br/>

Click post1 in the image above, and it will look like the image below.

<br/>

![oct-25-105.jpg](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-105.jpg)

<br/>



## 1. Create Post Layouts

The first step to create a post layout is to create a directory or folder where the post will be placed. The command below is used to create a post layout folder.

```sh
root@ns1:/var/blog/blogspot # mkdir /var/blog/blogspot/themes/basic/layouts/posts
```

After that we create a file called `"single.html"`, which will hold the layout for each post. Create a main content block and place the post title and content in its own element section with a class, this will help with the organization of each post. Type the script below in the file `"/var/blog/blogspot/themes/basic/layouts/posts/single.html"`.

{% raw %}
```
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/themes/basic/layouts/posts/single.html

{{ define "main" }}
<article class="post">
<header>
<h2>{{ .Title }}</h2>
<p>By {{ .Params.Author }}</p>
<p>Posted {{ .Date.Format "January 2, 2006" }}</p>
<p>Reading time: {{ math.Round (div (countwords .Content) 200.0) }} minutes.</p>
</header>
<section class="body">
{{ .content }}
</section>
</article>
{{ end }}
```
{% endraw %}

To see the results, activate GoHugo.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

Now try opening the Google Chrome or Firefox web browser by typing `"http://192.168.5.2:8999/posts/post2/"`, on the monitor screen it will look like the image below.

<br/>

![2025-10-15_08-50-33](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-106.jpg)



## 2. Organizing Content with Taxonomies

Many blogs and content systems can place posts into categories and apply tags to them. This logical grouping of content is known as a taxonomy. Hugo supports categories and tags out of the box and can generate category and tag list pages automatically.

To do this, open the file `"/var/blog/blogspot/archetypes/posts.md"` and edit the script, so the script will look like the one below.

{% raw %}
```
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: false
author: Iwan Setiawan
---

categories:
- Web Server
- Web Blog
- Shell Script

tags:
- software
- html
```
{% endraw %}

Adding the script above as default in the `"archetypes"` folder will not affect the content we created previously. So that the script changes in the file above can be applied, open and edit the file `"/var/blog/blogspot/content/posts/post1.md"`, so that the script will be like the one below.

{% raw %}
```
---
title: "Post1"
date: 2023-09-28T05:56:13+07:00
draft: false
author: Iwan Setiawan
---

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua.
<!--more-->
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.

categories:
- Personal
- Thoughts

tags:
- software
- html

```
{% endraw %}

After that, add the script below to the file `"/var/blog/blogspot/config.toml"`, place it at the very bottom of the script file.

{% raw %}
```
[taxonomies]
tag = "tags"
category = "categories"
```
{% endraw %}

To customize a page that displays a list of all tags, create a file called `"tag.terms.html"` to place the new layout. Place the file in the `/var/blog/blogspot/theme/basic/layouts/_default/` folder. To the new file add the usual layout boilerplate, including title and {% raw %}`{{ .content }}`{% endraw %}.

Type the command below to create the file `/var/blog/blogspot/themes/basic/layouts/_default/tag.terms.html` and enter the following script into the file.

{% raw %}
```
root@ns1:/var/blog/blogspot # touch /var/blog/blogspot/themes/basic/layouts/_default/tag.terms.html
root@ns1:/var/blog/blogspot # ee /var/blog/blogspot/themes/basic/layouts/_default/tag.terms.html

{{ define "main" }}
<h2>{{ .Title }}</h2>
{{ .content }}
{{ range .Data.Terms.Alphabetical }}
<p class="tag">
<a href="{{ .Page.Permalink }}">{{ .Page.Title }}</a>
<span class="count">({{ .Count }})</span>
</p>
{{ end }}
{{ end }}
```
{% endraw %}

In the example script above, {% raw %}`{{ .content }}`{% endraw %} in tag layout. When the `/tags` section is opened on a browser website, Hugo will search for the content in `content/tags/_index.md`. Create the _index.md file using the command below.

```sh
root@ns1:/var/blog/blogspot # hugo new tags/_index.md
Content "/var/blog/blogspot/content/tags/_index.md" created
```

Open the file `/var/blog/blogspot/content/tags/_index.md` then change the entire contents of the script, with the script below.

{% raw %}
```
---
title: "Tags"
date: 2025-09-28T06:10:51+07:00
draft: false
tags: ["software", "html"]
---

These are the site's tags:

```
{% endraw %}

If a tag link is clicked or opened, GoHugo will look for the layout associated with the tag. If we want to customize the tag layout, tweak the file called tag.html which is in the `/var/blog/blogspot/themes/basic/layouts/_default` folder and use the same logic that we used in the existing list layout to interesting content.

Next we will add a list of tags into a single post layout. Open the file `"/var/blog/blogspot/themes/basic/layouts/posts/single.html"` then change or replace the script with the script below.

{% raw %}
```
{{ define "main" }}
<article class="post">
<header>
<h2>{{ .Title }}</h2>
<p>By {{ .Params.Author }}</p>
<p> Posted {{ .Date.Format "January 2, 2006" }}
<span class="tags">
in {{ range .Params.tags }}
<a class="tag" href="/tags/{{ . | urlize }}">{{ . }}</a>
{{ end }}
</span>
</p>

<p>Reading time: {{ math.Round (div (countwords .Content) 200.0) }} minutes.</p>
</header>
<section class="body">
{{ .content }}
</section>
</article>
{{ end }}
```
{% endraw %}

So that the tag can be connected to the article post, we open and edit the file `"/var/blog/blogspot/content/posts/post1.md"` so that the script looks like the one below.

{% raw %}
```
---
title: "Post1"
date: 2025-09-28T05:56:13+07:00
author: Iwan Setiawan
draft: false
tags: ["software", "html"]
---

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua.
<!--more-->
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.

categories:
- Personal
- Thoughts

tags:
- software
- html
```
{% endraw %}

The next step we will beautify the appearance of the tag, add a CSS script like the example below to the file `/var/blog/blogspot/themes/basic/static/css/style.css`, then place the script at the very bottom/end of the file .

{% raw %}
```
a.tag {
background-color: #ddd;
color: #333;
display: inline-block;
padding: 0.1em;
font-size: 0.9em;
text-decoration: none;
}
```
{% endraw %}

The final step in creating Taxonomies is to test whether the tags we created above can be opened. Activate the Gohugo server with the command below.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

Open Google Chrome and type the command `"http://192.168.5.2:8999/tags/"`, then the monitor screen will look like the image below.

<br/>

![2025-10-15_08-58-27](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-107.jpg)

<br/>


## 3. Customizing URLs for Posts

By default, blog content will usually be displayed under posts/. For example, your first blog post is available at `http://192.168.5.2/posts/post1`. Usually a blog uses the year/month/title format for its blog post URL. These meaningful URLs show anyone viewing the URL how old the post is, but also indicate that the content is organized by date.

A permalink is a permanent link to a specific page, often used when sharing a page with others via social media, newsletters, or even search results. We can use front matter on posts to control post permalinks using the url field, but this is really only meant to handle situations where you're migrating content or need to make one-time adjustments. Hugo lets you specify how you want to structure the links in its configuration file.

In the `/var/blog/blogspot/config.toml` file, add the Permalinks script, as in the example below.

{% raw %}
```
[taxonomies]
year = "year"
month = "month"
tag = "tags"
category = "categories"

[permalinks]
posts = "posts/:year/:month/:slug/"
year = "/posts/:slug/"
month = "/posts/:slug/"
```
{% endraw %}

Apart from that, we also have to change or insert the script below in each posting file for new articles. Below is an example of a script contained in the file `"/var/blog/blogspot/content/posts/post1.md"`.

{% raw %}
```
---
title: "Post1"
date: 2025-09-28T05:56:13+07:00
author: Iwan Setiawan
draft: false
tags: ["software", "html"]
year: "2025"
month: "2025/09"
---

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua.
<!--more-->
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat.

categories:
- Personal
- Thoughts

tags:
- software
- html
```
{% endraw %}

The script above will not work without generating it, generate the file `/var/blog/blogspot/archetypes/posts.md` by entering the script below in that file.

{% raw %}
```
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: false
author: Iwan Setiawan
year: "{{ dateFormat "2006" .Date }}"
month: "{{ dateFormat "2006/01" .Date }}"
---

categories:
- Web Server
- Web Blog
- Shell Script

tags:
- software
- html
```
{% endraw %}

After that we create a new post, type the following script to create a new post file.

```sh
root@ns1:~ # cd /var/blog/blogspot
root@ns1:/var/blog/blogspot # hugo new posts/post2.md
Content "/var/blog/blogspot/content/posts/post2.md" created
```


## 4. Customizing Blog Pages

In this discussion we will create a post layout that shows the title, date, and summary of the content of each post. As a first step, create the file `/var/blog/blogspot/themes/basic/layouts/partials/post_summary.html`. In the file, add the following code, which displays the post title, publication date, and summary in the <article> element.

{% raw %}
```sh
root@ns1:~ # touch /var/blog/blogspot/themes/basic/layouts/_partials/post_summary.html
root@ns1:~ # ee /var/blog/blogspot/themes/basic/layouts/partials/post_summary.html

<article>
<header>
<h3>
<a href="{{ .RelPermalink }}">{{ .Title }}</a>
</h3>
<time>
{{ .Date | dateFormat "January" }}
{{ .Date | dateFormat "2" }}
</time>
</header>
{{ .Summary }}
</article>
```
{% endraw %}

After that, create another file called `"/var/blog/blogspot/themes/basic/layouts/posts/list.html"`, and enter the script below in that file.

{% raw %}
```
root@ns1:~ # touch /var/blog/blogspot/themes/basic/layouts/posts/list.html
root@ns1:~ # ee /var/blog/blogspot/themes/basic/layouts/posts/list.html

{{ define "main" }}
<h2>{{ .Title }}</h2>
{{ range .Pages }}
{{ partial "post_summary.html" . }}
{{ end }}
{{ end }}
```
{% endraw %}

Now we test the results, by activating the GoHugo server.

```sh
root@ns1:/var/blog/blogspot # hugo server --bind=192.168.5.2 --baseURL=http://192.168.5.2 --port=8999
```

Open the Google Chrome or Yandex web browser, type `"http://192.168.5.2:8999/posts/"`, then it will look like the following image.

<br/>

![2025-10-15_09-03-56](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-108.jpg)

<br/>


This layout only works for posts. This will not work for taxonomy pages such as year and month archive pages. To make it work, we need a more specific layout. Define the year and month pages as a new taxonomy, so create the files `"year.html"` and `"month.html"` in the directory `"/var/blog/blogspot/themes/basic/layouts/_default"`, with the same code as the layout in post list. To speed up the process, copy the existing list page.


```sh
root@ns1:/var/blog/blogspot # cd themes/basic/layouts
root@ns1:/var/blog/blogspot/themes/basic/layouts # cp posts/list.html _default/year.html
root@ns1:/var/blog/blogspot/themes/basic/layouts # cp posts/list.html _default/month.html
root@ns1:/var/blog/blogspot/themes/basic/layouts # cd -
root@ns1:/var/blog/blogspot # 
```

After the list page has been created, continue by creating a navigation menu or navbar. Open the file `"/var/blog/blogspot/themes/basic/layouts/partials/nav.html"`, and add a link to the post page. The. Below is an example of a script in that file.

{% raw %}
```
<nav>
<a href="/">Home</a>
<a href="/about">About Us</a>
<a href="/posts">Blog</a>
<a href="/projects">Projects</a>
<a href="/privacy">Privacy Policy</a>
<a href="/disclaimer">Disclaimer</a>
</nav>
```
{% endraw %}

We hope that at this point we will continue the discussion of the article in this chapter with the next chapter with a different topic and theme. At this point, you must be able to understand the structure of creating a blog with GoHugo, because if you don't understand it well enough, it is feared that you will have difficulty studying the next chapter.