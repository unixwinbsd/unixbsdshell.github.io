---
title: FreeBSD Elasticsearch - Enabling Text Search in NextCloud
date: "2025-05-28 07:26:00 +0100"
updated: "2025-05-28 07:26:00 +0100"
id: elasticsearch-freebsd-enable-text-search-netxcloud
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/13freebsd%20nextcloud%20utilitis.jpg&commit=74ca034dc7cbe8c3e5c2fe93bccb82e137281557

toc: true
comments: true
published: true
excerpt: The Elasticsearch application is often used as a means for organizations or companies to present information quickly and efficiently. Thanks to its flexibility and versatility, Elasticsearch has become one of the most widely used and popular search engines in the world.
keywords: elasticsearch, nextcloud, freebsd, enable, text search, search, text, app, store, app store
---

One of Nextcloud's capabilities is supporting search via the web interface and on the client. In this mode, the search is based on the file names being compared and the file content is not searched. However, there are other options that can be used to set up a full-text search.

The Elasticsearch application is often used as a means for organizations or companies to present information quickly and efficiently. Thanks to its flexibility and versatility, Elasticsearch has become one of the most widely used and popular search engines in the world.

On the Nextcloud server, Elasticsearch is the backbone of full-text search. If you want to use Elasticsearch as a search engine, Nextcloud and Elasticsearch must be installed separately or independently. Elasticsearch is a Java-based search engine, so the first step is to make sure that Java is installed. You should check if Java is installed on your FreeBSD server.

<br/>
<img alt="freebsd elasticsearch utility" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/13freebsd%20nextcloud%20utilitis.jpg&commit=74ca034dc7cbe8c3e5c2fe93bccb82e137281557' | relative_url }}">
<br/>

## 1. How to Install Elasticsearch
On FreeBSD, the Elasticsearch configuration process is very simple and the installation process is not too complicated. You only need to install Elasticsearch via the pkg package by typing the command below. But before you install Elasticsearch, run the update command first to update the PKG package.

```console
root@ns3:~ # pkg update -f
root@ns3:~ # pkg upgrade -f
```

After the update process is complete, carry out the installation process.

```console
root@ns3:~ # pkg install elasticsearch8
```

After that, you enable elasticsearch7 so that it can run automatically when the computer is rebooted. In the `/etc/rc.conf` file you type the following script.

```console
root@ns3:~ # ee /etc/rc.conf
elasticsearch_enable="YES"
elasticsearch_user="elasticsearch"
elasticsearch_group="elasticsearch"
elasticsearch_config="/usr/local/etc/elasticsearch"
##elasticsearch_config="/usr/local/etc/elasticsearch/elasticsearch.yml"
elasticsearch_login_class="root"
elasticsearch_java_home="/usr/local/openjdk11"
```
We continue by installing `Java openjdk17`.

```console
root@ns3:~ # cd /usr/ports/java/openjdk17
root@ns3:~ # make install clean
```
You can read a complete guide on how to install Java OpenJDK on FreeBSD in the following article.


[Installing and Configuring Java OpenJDK 20 on FreeBSD 14](https://unixwinbsd.site/freebsd/installation-java-development-kit-on-freebsd/)

Since we will be using `Elasticsearch` with Nextcloud's `Full Text Search`, the PHP readline library is required to connect Elasticsearch and Full Text Search. Run the following command to install PHP readline.

```console
root@ns3:~ # pkg install php82-readline
```

The next step is to configure the file `/usr/local/etc/elasticsearch/elasticsearch.yml`. In this file you activate several scripts as in the example below.

```console
root@ns3:~ # ee /usr/local/etc/elasticsearch/elasticsearch.yml
cluster.name: nextcloud2
node.name: node-1
path.data: /var/db/elasticsearch
path.logs: /var/run/elasticsearch
bootstrap.memory_lock: true
network.host: 192.168.5.2
http.port: 9200
discovery.seed_hosts: ["127.0.0.1", "[::1]"]
discovery.type: single-node
xpack.ml.enabled: false
xpack.security.enabled: false
xpack.security.enrollment.enabled: false
```

Add the Elasticsearch ingestion plugin.

```console
root@ns3:~ # /usr/local/lib/elasticsearch/bin/elasticsearch-plugin install ingest-attachment
```
Restart Elasticsearch.

```console
root@ns3:~ # service elasticsearch restart
```
Check whether elasticsearch is running or not.

```console
root@ns3:~ # curl -XGET '192.168.5.2:9200/?pretty'
```

<br/>
## 2. How to Install Full Text Search Nextcloud
Once you have finished installing Elasticsearch, proceed to install Nextcloud Full Text Search. Follow the commands below to install and enable Full Text Search.

```console
root@ns3:~ # occ app:install files_fulltextsearch
root@ns3:~ # occ app:install fulltextsearch
root@ns3:~ # occ app:install fulltextsearch_elasticsearch
```

After that you activate Full Text Search.

```console
root@ns3:~ # occ app:enable files_fulltextsearch
root@ns3:~ # occ app:enable fulltextsearch
root@ns3:~ # occ app:enable fulltextsearch_elasticsearch
```
Now you can directly connect Nextcloud with elastic search. Please login to your Nextcloud account, then click on the Administration settings menu and the full-text search menu. Follow the image guide below.

<br/>
<img alt="full text speech nextcloud" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/14full%20text%20speech%20nextcloud.jpg&commit=a97590e409bf9edbcd2eaf861bd779fe6dcf2030' | relative_url }}">
<br/>

In the `Address of the Servlet` menu, type the elasticsearch IP address, which is `http://192.168.5.2:9200/`. In the index menu, also type "nextcloud2", adjust it to the `cluster.name:nextcloud2` script in the `elasticsearch.yml` file.

After that you run Generate search index, the search index structure is done in the console with the command line, here is an example of the command you must run.

```console
root@ns3:~ # cd /usr/local/www/nextcloud
root@ns3:/usr/local/www/nextcloud # occ fulltextsearch:index
```

To ensure full-text search has been indexed into the Nextcloud `App Store`, run the two command lines below.

```console
root@ns3:/usr/local/www/nextcloud # occ fulltextsearch:check
root@ns3:/usr/local/www/nextcloud # occ fulltextsearch:test
```

The final step is to run the Apache web server.

```console
root@ns3:~ # service apache24 restart
```

By setting this section on the Nextcloud website, your Nextcloud server is now connected to elasticsearch. You can perform searches efficiently, safely, and with high performance. Not only that, elasticsearch is also able to analyze data quickly and in large quantities.