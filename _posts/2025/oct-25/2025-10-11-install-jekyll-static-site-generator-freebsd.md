---
title: How to Install Jekyll Static Website Generator with FreeBSD
date: "2025-10-11 15:03:21 +0100"
updated: "2025-10-11 15:03:21 +0100"
id: install-jekyll-static-site-generator-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-63.jpg
toc: true
comments: true
published: true
excerpt: In this article we assume that all the applications above have been installed properly and are running smoothly on the FreeBSD server. So, we will not discuss the application installation process above. We will focus on the core discussion of Jekyll.
keywords: jekyll, ruby, static, site, generator, freebsd
---


We know that there are two types of websites, namely dynamic and static. On dynamic websites, for example those created using CMS such as WordPress, Joomla, Drupal and Blogger or Blogspot. All information or content on a dynamic website to fill a web page is stored in a database which will then be retrieved when there is an order or query.

Meanwhile, static websites do not use a database. All the information that will be displayed on a web page is already in the HTML file. No more query processing. These HTML files can be written one by one using a text editor such as Notepad or Sublime Text, or can also be generated automatically using a `"static site generator"` such as Jekyll, Hugo or others.

Jekyll, according to its tagline `"a simple, blog-aware, static site generator"` is software for creating static blogs. To produce a blog, Jekyll only needs a template, article files written in Markdown format and a configuration file. Then we upload the results to the server. That's our blog. As simple as that?. Jekyll and other static blogs have many advantages over WordPress, Joomla, Drupal and others, among the advantages of Jekyll are:

- As I said, WordPress is overkill. Too much, at least for my needs in creating a blog. Meanwhile, Jekyll is specifically intended as a blogging platform. Even though it is much simpler, Jekyll is still rich in the features needed to create a blog.
- Jekyll is much faster, because all the pages displayed are actually finished. No more queries to the database. In addition, loading static files on website pages requires much smaller resources on the server side.
- Because the server only contains static files, Jekyll is safer from irresponsible hacker attacks. There is nothing that hackers can target, unless they have the username and password.
- Jekyll is one of the engines behind Github. Therefore, we can easily publish blogs on Github for free. With Github, every change to our blog will be recorded, even if it only changes one letter. Yes, Github is one of the most popular versioning control services. Apart from that, Github makes it easier for us to collaborate.
- Jekyll uses Markdown. This means you can create articles containing R scripts with R Markdown.
<br/>

![jekyll static site generator](/img/oct-25/oct-25-63.jpg)


Jekyll is a static site creation utility, or SSG. With Jekyll the process of building a fast, safe and scalable website becomes easier. In short, SSG is the process of generating a website consisting of pre-built static HTML pages. Jekyll can eliminate the need for server-side processing, so creating static sites can result in faster load times and high scalability.


## 1. System Requirements

- Operating System: FreeBSD 13.3
- Hostname: ns3
- IP Address: 192.168.5.2
- Ruby version: ruby 3.1.4p223 (2023-03-30 revision 957bb7cb81) [amd64-freebsd13]
- Gem version: gems 3.5.7
- Bundler version: Bundler 2.3.6
- Web Server: Apache24
- Database: Postgresql15-server

In this article we assume that all the applications above have been installed properly and are running smoothly on the FreeBSD server. So, we will not discuss the application installation process above. We will focus on the core discussion of Jekyll.


## 2. Install Jekyll

To simplify the process of creating a Jekyll project, we will create a working directory for Jekyll. This directory will store all Jekyll files and information. Run the mkdir command to create a new directory.

```
root@ns3:~ # mkdir -p /var/jekyll-static
root@ns3:~ # cd /var/jekyll-static
root@ns3:/var/jekyll-static #
```
Now we will install Jekyll in the directory you created above.

```
root@ns3:/var/jekyll-static # pkg install rubygem-jekyll rubygem-jekyll-sitemap rubygem-bundler
```
After that, you download Jekyll from the Github repository.

```
root@ns3:/var/jekyll-static # git clone https://github.com/jekyll/jekyll.git
```


## 3. Setup Jekyll

Bundler is one of Jekyll's indispensable utilities, as it tracks dependencies per project, very useful if you need to run different versions of Jekyll in different projects.

After you have finished downloading Jekyll from Github, you can continue with this bundle command. This command will generate a new Bundler project (by creating an empty Gemfile).

```
root@ns3:/var/jekyll-static # cd jekyll
root@ns3:/var/jekyll-static/jekyll # rm Gemfile
root@ns3:/var/jekyll-static/jekyll # bundle init
Writing new Gemfile to /var/jekyll-static/jekyll/Gemfile
```
In the `Gemfile file`, type the script below.

```
root@ns3:/var/jekyll-static/jekyll # ee Gemfile
source "https://rubygems.org"

gem 'jekyll', '~> 4.3.2'
gem 'bundler', '~> 2.3.7'
gem 'faraday-retry'
gem 'backports', '~> 3.23'
gem 'kramdown'
gem 'puma'


# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

# Plugins
group :jekyll_plugins do
    # gem 'devlopr', '~> 0.4.5'
    gem 'jgd', '~> 1.12'
    gem 'jekyll-feed', '~> 0.17.0'
    gem 'jekyll-paginate', '~> 1.1.0'
    gem 'jekyll-gist', '~> 1.5.0'
    gem 'jekyll-seo-tag', '~> 2.8.0'
    gem 'jekyll-sitemap', '~> 1.4.0'
    gem 'jekyll-admin', '~> 0.11.1'
end


# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 2.0"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?
gem "webrick", "~> 1.7"
```

In the `Gemfile.lock` file, type the script below.

```
root@ns3:/var/jekyll-static/jekyll # ee Gemfile.lock
GEM
  remote: https://rubygems.org/
  specs:
    addressable (2.8.1)
      public_suffix (>= 2.0.2, < 6.0)
    backports (3.23.0)
    colorator (1.1.0)
    concurrent-ruby (1.2.0)
    em-websocket (0.5.3)
      eventmachine (>= 0.12.9)
      http_parser.rb (~> 0)
    eventmachine (1.2.7)
    faraday (2.7.4)
      faraday-net_http (>= 2.0, < 3.1)
      ruby2_keywords (>= 0.0.4)
    faraday-net_http (3.0.2)
    faraday-retry (2.0.0)
      faraday (~> 2.0)
    ffi (1.15.5)
    forwardable-extended (2.6.0)
    google-protobuf (3.21.12-x86_64-darwin)
    google-protobuf (3.21.12-x86_64-linux)
    http_parser.rb (0.8.0)
    i18n (1.12.0)
      concurrent-ruby (~> 1.0)
    jekyll (4.3.2)
      addressable (~> 2.4)
      colorator (~> 1.0)
      em-websocket (~> 0.5)
      i18n (~> 1.0)
      jekyll-sass-converter (>= 2.0, < 4.0)
      jekyll-watch (~> 2.0)
      kramdown (~> 2.3, >= 2.3.1)
      kramdown-parser-gfm (~> 1.0)
      liquid (~> 4.0)
      mercenary (>= 0.3.6, < 0.5)
      pathutil (~> 0.9)
      rouge (>= 3.0, < 5.0)
      safe_yaml (~> 1.0)
      terminal-table (>= 1.8, < 4.0)
      webrick (~> 1.7)
    jekyll-admin (0.11.1)
      jekyll (>= 3.7, < 5.0)
      sinatra (>= 1.4)
      sinatra-contrib (>= 1.4)
    jekyll-feed (0.17.0)
      jekyll (>= 3.7, < 5.0)
    jekyll-gist (1.5.0)
      octokit (~> 4.2)
    jekyll-paginate (1.1.0)
    jekyll-sass-converter (3.0.0)
      sass-embedded (~> 1.54)
    jekyll-seo-tag (2.8.0)
      jekyll (>= 3.8, < 5.0)
    jekyll-sitemap (1.4.0)
      jekyll (>= 3.7, < 5.0)
    jekyll-watch (2.2.1)
      listen (~> 3.0)
    jgd (1.12)
      jekyll (>= 1.5.1)
      trollop (= 2.9.9)
    kramdown (2.4.0)
      rexml
    kramdown-parser-gfm (1.1.0)
      kramdown (~> 2.0)
    liquid (4.0.4)
    listen (3.8.0)
      rb-fsevent (~> 0.10, >= 0.10.3)
      rb-inotify (~> 0.9, >= 0.9.10)
    mercenary (0.4.0)
    multi_json (1.15.0)
    mustermann (3.0.0)
      ruby2_keywords (~> 0.0.1)
    nio4r (2.5.8)
    octokit (4.25.1)
      faraday (>= 1, < 3)
      sawyer (~> 0.9)
    pathutil (0.16.2)
      forwardable-extended (~> 2.6)
    public_suffix (5.0.1)
    puma (6.0.2)
      nio4r (~> 2.0)
    rack (2.2.6.2)
    rack-protection (3.0.5)
      rack
    rake (13.0.6)
    rb-fsevent (0.11.2)
    rb-inotify (0.10.1)
      ffi (~> 1.0)
    rexml (3.2.5)
    rouge (4.0.1)
    ruby2_keywords (0.0.5)
    safe_yaml (1.0.5)
    sass-embedded (1.58.0)
      google-protobuf (~> 3.21)
      rake (>= 10.0.0)
    sawyer (0.9.2)
      addressable (>= 2.3.5)
      faraday (>= 0.17.3, < 3)
    sinatra (3.0.5)
      mustermann (~> 3.0)
      rack (~> 2.2, >= 2.2.4)
      rack-protection (= 3.0.5)
      tilt (~> 2.0)
    sinatra-contrib (3.0.5)
      multi_json
      mustermann (~> 3.0)
      rack-protection (= 3.0.5)
      sinatra (= 3.0.5)
      tilt (~> 2.0)
    terminal-table (3.0.2)
      unicode-display_width (>= 1.1.1, < 3)
    tilt (2.0.11)
    trollop (2.9.9)
    tzinfo (2.0.6)
      concurrent-ruby (~> 1.0)
    tzinfo-data (1.2022.7)
      tzinfo (>= 1.0.0)
    unicode-display_width (2.4.2)
    wdm (0.1.1)
    webrick (1.8.1)

PLATFORMS
  universal-darwin-21
  x86_64-linux

DEPENDENCIES
  backports (~> 3.23)
  bundler (~> 2.3.7)
  faraday-retry
  jekyll (~> 4.3.2)
  jekyll-admin (~> 0.11.1)
  jekyll-feed (~> 0.17.0)
  jekyll-gist (~> 1.5.0)
  jekyll-paginate (~> 1.1.0)
  jekyll-seo-tag (~> 2.8.0)
  jekyll-sitemap (~> 1.4.0)
  jgd (~> 1.12)
  kramdown
  puma
  tzinfo (~> 2.0)
  tzinfo-data
  wdm (~> 0.1.1)
  webrick (~> 1.7)

BUNDLED WITH
   2.3.7
```
Now you install Jekyll with the bundler.

```
root@ns3:/var/jekyll-static/jekyll # bundle install
root@ns3:/var/jekyll-static/jekyll # bundle update
```
The final step is to run Jekyll.

```
root@ns3:/var/jekyll-static/jekyll # rails s -b 192.168.5.2
```
Installing and configuring static sites with Jekyll on FreeBSD 13.3 Stable is easy and improves your ability to maintain fast, secure, and easily scalable websites. Jekyll.