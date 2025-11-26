---
title: Apache mod_rewrite - How to Redirect Users to a Mobile Website
date: "2025-11-26 09:19:47 +0000"
updated: "2025-11-26 09:19:47 +0000"
id: apache-mod-rewrite-redirect-user-to-mobile-website
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: WebServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-033.jpg
toc: true
comments: true
published: true
excerpt: This step-by-step guide will help you configure Apache to run the mobile version of your website if visitors are accessing it on a mobile device, and the standard version for visitors using a personal computer. The entire process can be done using the Apache rewrite module.
keywords: apache, mod, mod_rewrite, redirect, user, mobile, website, web server, phone, windiws, freebsd
---

In recent years, people have begun using smartphones and tablets such as iPhones, iPads, Android phones, and Blackberries to connect to the internet. Although desktop users are declining, desktop versions have many advantages over mobile versions. Since the rise of smartphones, many websites have begun creating mobile versions.

You may also have considered creating a mobile version of your website. With this significant increase in mobile users, some people have begun creating mobile versions of their websites. This step-by-step guide will help you configure an Apache web server to run a mobile version of your website.

If a visitor accesses the website using a mobile device, they will be served the mobile version of Apache, and if the visitor is using a desktop, they will be served the standard version of Apache. The entire process can be accomplished using the Apache rewrite module.

This tutorial explains how to configure Apache to serve a mobile version of your website if the visitor is using a mobile device, and a standard version if the visitor is using a regular desktop PC. This can be accomplished using the Apache rewrite module. One of the advantages of the Apache web server is that it can redirect users to the mobile or standard website based on the device using `mod_rewrite`.

This step-by-step guide will help you configure Apache to run the mobile version of your website if visitors are accessing it on a mobile device, and the standard version for visitors using a personal computer. The entire process can be done using the Apache rewrite module.

In this tutorial, we'll split two URLs (website addresses): one for the standard version and one for the mobile version. For the standard/desktop version, the URL we'll use is http://www.example.com, and for the mobile version, http://m.example.com.

<img alt="Apache mod_rewrite - How to Redirect Users to a Mobile Website" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-033.jpg' | absolute_url }}">

## 1. Enable the Apache mod_rewrite module

As mentioned above, Apache uses mod_rewrite to create mobile and web versions of websites. Therefore, before we move on to further discussion, you must first enable mod_rewrite. For this article, we're using an Ubuntu system. Below is the script for enabling mod_rewrite on Apache24.

```yml
[root@ns1 ~]# a2enmod rewrite
```

After that you restart Apache.

<div style="text-align: justify;"><br /></div>
<div style="text-align: justify;"><div class="cmd-head" style="background: rgb(231, 239, 3); border: 0px; font-family: Verdana, Geneva, sans-serif; font-size: 17px; margin: 0px; padding: 0px 10px; text-align: left;">Restart Apache</div><pre class="pre-cmd" style="background: rgb(238, 238, 238); border: 1px solid rgb(212, 212, 212); line-height: 12.24px; margin-bottom: 1.5em; margin-top: 0px; max-width: 100%; overflow: auto; padding: 10px; text-align: left;"><span style="color: #3a3a3a; font-family: Times New Roman;"><span style="font-size: 14.4px;">[root@ns1 ~]# /etc/init.d/apache2 restart</span></span></pre></div>

## 2. Create a script for the .htaccess file

Mod_rewrite rules can be configured either in the Apache configuration file `(default /etc/apache2/apache.conf)` or in the .htaccess file in the web directory. Both methods are generally similar, with a few notable exceptions:

- The .htaccess file evaluates rules based on the directory in which they reside (unless RewriteBase is configured).
- .htaccess rules apply to subdirectories, unless another .htaccess file overrides them.
- .htaccess rules can be modified on the fly. Apache configuration rules require Apache2 to be restarted before they take effect.
- RewriteMap rules must be configured in the .htaccess file.

  <script type="text/javascript">
	atOptions = {
		'key' : '88e2ead0fd62d24dc3871c471a86374c',
		'format' : 'iframe',
		'height' : 250,
		'width' : 300,
		'params' : {}
	};
</script>
<script type="text/javascript" src="//www.highperformanceformat.com/88e2ead0fd62d24dc3871c471a86374c/invoke.js"></script>


Now let's create a rewrite rule for the regular website `"www.example.com"` and we'll also create a rule that will redirect all mobile users to the mobile version of `m.example.com`. We'll focus on the relevant devices/user agents here: Android, Blackberry, Googlebot-mobile (Google's mobile search bot), IE Mobile, iPad, iPhone, iPod, Opera Mobile, PalmOS, and WebOS.

Starting with a regular/desktop site, open the .htaccess file and type the script as shown below.

```console
[root@ns1 ~]# sudo nano /var/www/www.example.com/web/.htaccess

RewriteEngine On
RewriteCond %{HTTP_USER_AGENT} "android|blackberry|googlebot-mobile|iemobile|ipad|iphone|ipod|opera mobile|palmos|webos" [NC]
RewriteRule ^$ http://m.example.com/ [L,R=302]
```

While the `.htaccess` file script for the mobile version of the Apache website, as in the example below.

```console
[root@ns1 ~]# sudo nano /var/www/www.example.com/mobile/.htaccess

RewriteEngine On
RewriteCond %{HTTP_USER_AGENT} "!(android|blackberry|googlebot-mobile|iemobile|ipad|iphone|ipod|opera mobile|palmos|webos)" [NC]
RewriteRule ^$ http://www.example.com/ [L,R=302]
```

After you have written the Apache script for both versions of the site, restart Apache24.

```yml
[root@ns1 ~]# /etc/init.d/apache2 restart
```

After that, you can open a web browser like Google Chrome and type in the URL we created above. Check to see if the desktop and mobile sites have been successfully redirected. If not, double-check the script above to make sure you haven't missed anything or made a typo.

Apache's mod_rewrite offers powerful functionality that we can leverage to strengthen our phishing campaigns. mod_rewrite processes requests and serves resources based on a set of rules configured either in the server configuration file or in the .htaccess file located in the desired web directory. To capitalize on mobile users clicking on phishing links, we can redirect them to a mobile-friendly malicious website, such as a credential harvester.
