---
title: FreeBSD Elasticsearch and Logstash Tutorial - Installation and Configuration
date: "2025-06-30 08:37:15 +0100"
updated: "2025-06-30 08:37:15 +0100"
id: elastic-search-freebsd-tutorials-installation
lang: en
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/1_FreeBSD_Elstic_search_apache.jpg
toc: true
comments: true
published: true
excerpt: Elasticsearch is an open-source application built on Apache Lucene. Written in Java, it is used as a distributed RESTful search and analytics engine capable of handling a wide range of use cases.
keywords: elatic serach, nextcloud, framework, php, apache, nginx, proxy, freebsd, openbsd
---

In today's era, the ability of a website to search for files, analyze, and visualize data in small or large amounts is very important. This will certainly be very useful for the development of organizations and businesses that require speed in searching for data or files on a website. There are many search engines used by web developers. Elasticsearch is one of the many fast, sophisticated, and popular search and data analysis engines. Elasticsearch has gained tremendous popularity over the years.

Since its inception until now, Elasticsearch has grown into something much bigger than when it was first introduced. Elasticsearch is not just an ordinary search engine, but more than that, it has become a complete ecosystem known as the "Elastic Stack." This thing has become a superstar, capable of handling everything from basic website searches and log data analysis to complex data processing.

<br/>
<img alt="Elatic Search FreeBSD apache" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/1_FreeBSD_Elstic_search_apache.jpg' | relative_url }}">
<br/>

Elasticsearch is an open-source application built on Apache Lucene. Written in Java, it is used as a distributed RESTful search and analytics engine capable of handling a wide range of use cases. Elasticsearch was first introduced by Elasticsearch N.V. in 2010, and is now part of the Elastic Stack.

**

> Elasticsearch was built with extremely high scalability in mind, so it
> is able to handle the challenges of scaling indexes horizontally and
> can handle large amounts of data like a pro.

**

Elasticsearch offers many excellent features, one of which is its very fast search and analysis capabilities. Elasticsearch is capable of performing real-time searches, namely within one second. Therefore, it is only natural that many people use it to handle large amounts of data easily, efficiently, and simply.

## 1. System requirements
- OS: FreeBSD 13.2
- Hostname: ns3
- IP address: 192.168.5.2
- Logstash version: logstash8-8.11.3
- Elasticsearch version: elasticsearch8-8.11.3
- Web server: Apache24
- Dependencies: jna bash wazuh-server
- Java version:

a. openjdk version "17.0.9" 2023-10-17

b. OpenJDK Runtime Environment (build 17.0.9+9-1)

c. OpenJDK 64-Bit Server VM (build 17.0.9+9-1, mixed mode, sharing)

<br/>


## 2. Installing Elasticsearch with the Ports system
Before starting the elasticsearch installation, make sure the Java and Apache applications are running on FreeBSD. You can use the Java and Apache versions by following the instructions above. Okay, let's start installing elasticsearch dependencies.

```console
root@ns3:~ # pkg install jna bash wazuh-server
```
The next process after dependencies is to install elasticsearch. Use the FreeBSD port system, so that all libraries can be installed.

```console
root@ns3:~ # cd /usr/ports/textproc/elasticsearch8
root@ns3:/usr/ports/textproc/elasticsearch8 # make install clean
```
Then, you create a starter script, so that elasticsearch can run automatically on FreeBSD. Open the `rc.conf` file and type the script below.

```console
root@ns3:~ # ee /etc/rc.conf
elasticsearch_enable="YES"
elasticsearch_user="elasticsearch"
elasticsearch_group="elasticsearch"
elasticsearch_config="/usr/local/etc/elasticsearch"
elasticsearch_login_class="root"
elasticsearch_java_home="/usr/local/openjdk17"
```

<br/>

## 3. How to Configure Elasticsearch
Once you have completed the installation, proceed to setting up elasticsearch. The main file you need to configure is elasticsearch.yml. Open the elasticsearch.yml file and change only a few scripts, as in the example below.

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
While Elasticsearch has built-in features, you can extend its functionality by adding plugins to provide advanced analytics and process different types of data. You can install each plugin on a compatible Elasticsearch cluster, just like any other Elasticsearch plugin.

In this article, we will try installing Elasticsearch plugins and interacting with them using the Elasticsearch API. Run the commands below to install commonly used plugins.

```console
root@ns3:~ # /usr/local/lib/elasticsearch/bin/elasticsearch-plugin install ingest-attachment
```

The above command, installs the Elasticsearch plugin to index and search base64 encoded documents in formats like RTF, PDF, and PPT. You can also install the `"analysis-phonetic"` plugin to identify the search results performed by elasticsearch.

```console
root@ns3:~ # /usr/local/lib/elasticsearch/bin/elasticsearch-plugin install analysis-phonetic

```
Another plugin you can install is `“ingest-user-agent”`. This plugin is used to parse the User Agent header from HTTP requests to provide identifying information about the client sending each request.


```console
root@ns3:~ # /usr/local/lib/elasticsearch/bin/elasticsearch-plugin install ingest-user-agent
```

Run ownership commands on db and log files.

```console
root@ns3:~ # chown -R elasticsearch:elasticsearch /var/db/elasticsearch
root@ns3:~ # chown -R elasticsearch:elasticsearch /var/run/elasticsearch
```
The next step is to run elasticsearch.

```console
root@ns3:~ # service elasticsearch restart
```
After that, you test whether Elasticsearch responds to queries.

```html
root@ns3:~ # curl -X GET "192.168.5.2:9200"
{
  "name" : "node-1",
  "cluster_name" : "nextcloud2",
  "cluster_uuid" : "6oYpEqMpTPanRtTSe61E_w",
  "version" : {
    "number" : "8.11.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "64cf052f3b56b1fd4449f5454cb88aca7e739d9a",
    "build_date" : "2023-12-08T11:33:53.634979452Z",
    "build_snapshot" : false,
    "lucene_version" : "9.8.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

<br/>

## 4. How to Install Logstash8
Logstash is a real-time event processing engine for managing events and logs. You can use it to collect logs, parse them, and store them for later use. Logstash is usually paired with elasticsearch. In this section we will explain how to install Logstash on FreeBSD. After installing and configuring Logstash, we will connect it to elasticsearch, so that they can be used together.

To install Logstash, you can use the PKG package, as in the example below.

```console
root@ns3:~ # pkg install logstash8
```
Add the script below to the `rc.conf` file.

```console
root@ns3:~ # ee /etc/rc.conf
logstash_enable="YES"
logstash_user="logstash"
logstash_group="logstash"
logstash_home="/usr/local/logstash"
logstash_config="/usr/local/etc/logstash"
logstash_log="YES"
logstash_java_home="/usr/local/openjdk17"
logstash_java_opts=""
logstash_opts=""
```
Edit the `logstash.conf` file, so that it can connect to elasticsearch.

```console
root@ns3:~ # ee /usr/local/etc/logstash/logstash.conf
input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["http://192.168.5.2:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
    #user => "elastic"
    #password => "changeme"
  }
}
```

Run Logstash with the service command.

```console
root@ns3:~ # service logstash restart
Stopping logstash.
Waiting for PIDS: 906, 906.
Starting logstash.
```
Once everything is configured, you can see the result by checking elasticsearch, whether it is running normally or there is a script error. Open the Google Chrome web browser, type -`"http://192.168.5.2:9200/"`.

The result will look like the image below.

<br/>
<img alt="Result Elastic Search" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/2Result_FreeBSD_Elstic_search_apache.jpg' | relative_url }}">
<br/>

Overall, Elasticsearch is a powerful, real-time, fast, and high-performance data search and analysis engine. Its ability to handle complex queries and deliver fast search results makes it a valuable asset for organizations and enterprises dealing with large amounts of data.
