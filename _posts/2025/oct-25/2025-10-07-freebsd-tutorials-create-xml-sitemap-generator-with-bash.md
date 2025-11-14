---
title: FreeBSD Tutorials Create XML Sitemap Generator With Bash
date: "2025-10-07 09:03:21 +0100"
updated: "2025-10-07 09:03:21 +0100"
id: freebsd-tutorials-create-xml-sitemap-generator-with-bash
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/oct-25/oct-25-56.jpg
toc: true
comments: true
published: true
excerpt: We will try to create or develop a simple shell script that can crawl a website and generate a simple, workable XML sitemap. That will make it much easier to create sitemaps on a regular basis. We will use the Bash utility in FreeBSD to crawl the website.
keywords: freebsd, tutorials, create, xml, sitemap, generator, bash
---


A site map or site map is a file that contains a collection of URLs of web pages that can be accessed by users and search engines. The format can be anything as long as you can read it and understand the format. Generally, there are two types of formats commonly used when creating sitemaps, namely XML and HTML.

All websites, whether they are blogspot or wordpress, should ideally have at least one form of sitemap, especially for search engine optimization (SEO). XML sitemaps are usually preferred for SEO because they contain a lot of relevant metadata information throughout the website page urls. Nearly all search engines have the ability to read properly formatted sitemaps, which are then used to index pages on the website.

If you are creating a website using any website building framework such as Blogspot, WordPress, Joomla or Drupal, then there are already plugins that can help generate relevant sitemaps automatically. However, if you are developing a website using other web technologies such as Javascript, PHP, HTML and CSS without the help of website building software or platforms, then you need to create a sitemap manually.

For a small number of website pages, creating a sitemap manually is still possible, but if you have more than 100 website pages, the job will be very troublesome. Because you will definitely have ongoing maintenance if the website has continuous updates where new pages are added periodically along with pages being removed.

We will try to create or develop a simple shell script that can crawl a website and generate a simple, workable XML sitemap. That will make it much easier to create sitemaps on a regular basis. We will use the Bash utility in FreeBSD to crawl the website.

![oct-25-56](/img/oct-25/oct-25-56.jpg)



## 1. Create Bash scripts

FreeBSD and BASH are very useful utilities, with these two utilities, we can do various things, one of which is parsing and crawling the Sitemap.

To make it easier for you to write and learn the Sitmap generator, in this article we have provided the complete script in our Github repository. You can directly clone the script from Github.

But there's nothing wrong if we write the BASH script in this article. Your first step is to create a directory to store the BASH script.

```
root@ns7:~ # mkdir -p /var/FreeBSD_Sitemap_Generator
root@ns7:~ # cd /var/FreeBSD_Sitemap_Generator
root@ns7:/var/FreeBSD_Sitemap_Generator # touch sitemap.sh
root@ns7:/var/FreeBSD_Sitemap_Generator # chmod +x sitemap.sh
```

The first script above will create a new folder called "FreeBSD_Sitemap_Generator", the second script creates a "sitemap.sh" file and the third script gives file access rights to the user.

Below are the script contents of the  `"/var/FreeBSD_Sitemap_Generator/sitemap.sh"` file.

````
#!/bin/bash

#======================================================
# Simple site crawler to create a search engine XML Sitemap.
# Version: 1.0
# License: GPL v2
# Free to use, without any warranty.
# Written by JhonDoe
#======================================================
#
# sitemap.sh <URL> [sitemap file]
#
# Example: sh sitemap.sh https://www.example.com /var/www/mysite/sitemap.xml
#
#======================================================

# Init script.
OIFS="$IFS"
IFS=$'\n'

URL="$1"
SITEMAP="$2"

HEADER="FreeBSD XML Sitemap Generator - BASH Script 1.0 2020/01/16 https://www.unixwinbsd.site"
AGENT="Mozilla/5.0 (compatible; FreeBSD BASH XML Sitemap Generator/1.0)"

echo $HEADER
echo

# Check URL parameter.
if [ "$URL" == "www.unixwinbsd.site" ]
then

    echo "Error! No URL specified."
    echo "Example: \"sh $0 https://www.unixwinbsd.site\""
    exit 1

fi

# Check sitemap parameter. If none given, use "sitemap.xml".
if [ "$SITEMAP" == "" ]
then

    SITEMAP=sitemap.xml

fi


# Get the scheme, site and domain name.
tmp_http=$(echo $URL | cut -b1-7)
tmp_https=$(echo $URL | cut -b1-8)

if [ "$tmp_http" == "http://" ]
then

    SCHEME=$tmp_http
    SITE=$(echo $URL | cut -b8-)

elif [ "$tmp_https" == "https://" ]
then

    SCHEME=$tmp_https
    SITE=$(echo $URL | cut -b9-)

else

    echo "Error! No scheme. You have to use \"http://\" or \"https://\"."
    echo "  http://$URL"
    echo "or"
    echo "  https://$URL"
    exit 1

fi

DOMAIN=$(echo $SITE | cut -d/ -f1)


# Create temporary directory.
TMP=$(mktemp -d)


# Grab the website.
echo "Downloading \"$URL\" to temporary directory \"$TMP\"..."
WGET_LOG=sitemap-wget.log

wget \
     --recursive \
     --no-clobber \
     --page-requisites \
     --convert-links \
     --restrict-file-names=windows \
     --no-parent \
     --directory-prefix="$TMP" \
     --domains $DOMAIN \
     --user-agent="$AGENT" \
     $URL >& $WGET_LOG

if [ ! -d "$TMP/$SITE" ]
then
    echo
    echo "Error! See \"$WGET_LOG\"."
    echo
    echo "Removing \"$TMP\"."
    rm -rf "$TMP"
    
    exit 1
fi

# Get current directory and store it for later.
curr_dir=$(pwd)


# Go to the temporary directory.
cd "$TMP"

#==============================
# Change this for your needs.
# Example, exclude files from /print and /slide: 
#   files=$(find | grep -i html | grep -v "$SITE/print" | grep -v "$SITE/slide")

files=$(find | grep -i html)

#==============================

# Go back to the previous directory.
cd "$curr_dir"


# Generate the XML file
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!-- Created with $HEADER -->
<!-- Date: $(date +"%Y/%m/%d %H:%M:%S") -->
<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\"
        xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
        xsi:schemaLocation=\"http://www.sitemaps.org/schemas/sitemap/0.9
        http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\">" > "$SITEMAP"

echo "  <url>
    <loc>$URL</loc>
    <changefreq>weekly</changefreq>
    <priority>0.5</priority>
  </url>" >> "$SITEMAP"


for i in $files
do

echo "  <url>
    <loc>$SCHEME$(echo $i | cut -b3-)</loc>
    <changefreq>weekly</changefreq>
    <priority>0.5</priority>
  </url>" >> "$SITEMAP"

done

echo "</urlset>" >> "$SITEMAP"


# All done. Remove temporary files.
echo "$SITEMAP created."
echo "Removing \"$TMP\" and \"$WGET_LOG\"."
rm -rf "$TMP"
rm "$WGET_LOG"

echo "Done."
```


In the blue script above, you can replace it with your website URL or domain name.


## 2. Run the BASH Script


The script above runs with BASH, so make sure the BASH application is installed on the FreeBSD server. If not, follow the commands below to install BASH on FreeBSD.

```
root@ns7:/var/FreeBSD_Sitemap_Generator # pkg install bash
```

There are two ways to run the sitemap generator script above.

The first way is to type the command below.

```
root@ns7:/var/FreeBSD_Sitemap_Generator # bash sitemap.sh https://www.unixwinbsd.site
```

Second way.

```
root@ns7:/var/FreeBSD_Sitemap_Generator # bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml
```

I prefer to do it repeatedly, so that the crawling process can continue and speed up your website URL appearing on the Search Engine page. Examples like this.

```
root@ns7:/var/FreeBSD_Sitemap_Generator # bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml && bash sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml
```


## 3. Create a Crontab Script

This method is used so that the BASH script you created above can run automatically, without having to type commands manually. The Crontab process is a utility built into FreeBSD, its function is to really help users to run simple applications automatically.

Even though Crontab is almost the same as rc.d, starting up rc.d is more complete and can run scripts automatically for heavy and large applications.

Please open the Crontab file. In that file, enter the script
`"bash /usr/local/etc/FreeBSD_Sitemap_Generator/sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml"`. Notice the example below.

```
root@ns7:~ # ee /etc/crontab
0	*	*	*	*	root	bash /usr/local/etc/FreeBSD_Sitemap_Generator/sitemap.sh https://www.unixwinbsd.site /tmp/sitemap.xml
```

With the crontab script, you don't need to crawl manually. You just wait for your website URL page to appear in the Google search engine.