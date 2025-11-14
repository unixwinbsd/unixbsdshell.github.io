---
title: Using Java Jsoup Web Scraping to Extract Website Data with FreeBSD
date: "2025-08-12 07:15:23 +0100"
updated: "2025-08-12 07:15:23 +0100"
id: java-jsoup-scraping-extract-website-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/FreeBSD_JSoup_Maven_compilePackageInstall.jpg
toc: true
comments: true
published: true
excerpt: Web scraping is one of the simplest, most effective, efficient, and beneficial ways to extract data from websites. Some websites may contain vast amounts of valuable data. This is where web scraping can help read and analyze the data.
keywords: java, openjdk, jsoup, scraping, web scraping, surl, site, freebsd, crawling, indexing
---

Java is one of the most popular and widely used programming languages, with a large community. This allows for the creation of highly scalable and reliable services and multi-threaded data extraction solutions. Let's cover the key concepts of web scraping with Java and review the most popular libraries for orchestrating data extraction flows from websites with JSoup.

JSoup is a Java library designed to work with HTML and Java scripts, simplifying work with HTML and XML. This allows developers to easily read and analyze data. JSoup can parse HTML from URLs, files, or strings. It offers an easy-to-use API for URL fetching, data parsing, extraction, and manipulation using DOM APIs, CSS, and xpath selector methods.

This is an excellent library for simple web scraping due to its simplicity and ability to parse HTML scripts the same way browsers do, allowing you to use commonly used CSS selectors.

JSoup works in much the same way as modern browsers, implementing the WHATWG HTML5 specification and parsing HTML into the DOM. Furthermore, JSoup offers several advantages that traditional browsers don't.

- Sanitize user-submitted content against a safelist to prevent XSS attacks.
- Discover and extract data using DOM traversal or CSS selectors.
- Scrape and parse HTML from URLs, files, or strings.
- Produce clean HTML.
- Manipulate HTML elements, attributes, and text.

In this article, we'll learn step-by-step how to extract data from a website using Java JSoup and Maven. The web scraping tutorial uses a FreeBSD server with Java and Maven installed.

## 1. What is Web Scraping?
Web scraping is one of the simplest, most effective, efficient, and beneficial ways to extract data from websites. Some websites may contain vast amounts of valuable data. This is where web scraping can help read and analyze the data.

Web scraping refers to the extraction of data from a website. It is the process of obtaining data from a website, whether large or small. The information is then collected and exported into a more user-friendly format, whether it be a spreadsheet or an API.

Using web scraping, we can obtain specific data such as images, tables, posts, or source code from the entire website content. The obtained data can be used for various purposes, such as data collection, research, analysis, and more.

A web scraper can obtain all data from a website or blog. To obtain this data, we need to provide the URL of the website we want to scrape. It's best to specify the type of data we want to scrape to speed up and streamline the process.

For example, if we want videos or images from a website, we specify that we only need elements with the img tag to retrieve images. This will remove all img tags found on websites with the given URL. Web scrapers load all HTML code from the URL, although some advanced scrapers can even load CSS and JavaScript. The extracted data can be saved in an Excel file, a CSV file, or even a JSON file.



## 2. How to Install JSoup
To use JSoup on a FreeBSD server, ensure your server has Java and Maven installed, as this article uses Maven as the JSoup build system. Read our previous article on how to install Maven and Java on FreeBSD.

The FreeBSD repository doesn't provide JSoup; you can install JSoup from GitHub. The commands below will guide you through installing JSoup on FreeBSD. Since you already have Maven installed, we'll place the JSoup directory in the Maven directory `"/usr/local/etc/maven-wrapper/instances.d"`.

```yml
root@ns7:~ # cd /usr/local/etc/maven-wrapper/instances.d
root@ns7:/usr/local/etc/maven-wrapper/instances.d # git clone https://github.com/jhy/jsoup.git
root@ns7:/usr/local/etc/maven-wrapper/instances.d # cd jsoup
root@ns7:/usr/local/etc/maven-wrapper/instances.d/jsoup #
```

The above script is used to configure JSoup from GitHub on your local FreeBSD server. Now let's install `JSoup`.

```console
root@ns7:/usr/local/etc/maven-wrapper/instances.d/jsoup # mvn install
or
root@ns7:/usr/local/etc/maven-wrapper/instances.d/jsoup # mvn install -X
```

## 3. Using jsoup Web Scraping
Web scraping should always start with a human touch. Before you scrape a website, you need to understand the HTML data structure of the website. Understanding data structures will give you an idea of how to navigate HTML tags when you apply a scraper.

We will use Maven as a web scraping tool. To create a new Maven project, open a PuTTY terminal, if you are running it through Windows and run the following command.

**"mvn archetype:generate -DgroupId=com.example.jsoupexample -DartifactId=jsoup-example -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false"**

```console
root@ns7:/usr/local/etc/maven-wrapper/instances.d # mvn archetype:generate -DgroupId=com.example.jsoupexample -DartifactId=jsoup-example -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------< org.apache.maven:standalone-pom >-------------------
[INFO] Building Maven Stub Project (No POM) 1
[INFO] --------------------------------[ pom ]---------------------------------
[INFO]
[INFO] >>> archetype:3.2.1:generate (default-cli) > generate-sources @ standalone-pom >>>
[INFO]
[INFO] <<< archetype:3.2.1:generate (default-cli) < generate-sources @ standalone-pom <<<
[INFO]
[INFO]
[INFO] --- archetype:3.2.1:generate (default-cli) @ standalone-pom ---
[INFO] Generating project in Batch mode
[INFO] ----------------------------------------------------------------------------
[INFO] Using following parameters for creating project from Archetype: maven-archetype-quickstart:1.4
[INFO] ----------------------------------------------------------------------------
[INFO] Parameter: groupId, Value: com.example.jsoupexample
[INFO] Parameter: artifactId, Value: jsoup-example
[INFO] Parameter: version, Value: 1.0-SNAPSHOT
[INFO] Parameter: package, Value: com.example.jsoupexample
[INFO] Parameter: packageInPathFormat, Value: com/example/jsoupexample
[INFO] Parameter: package, Value: com.example.jsoupexample
[INFO] Parameter: groupId, Value: com.example.jsoupexample
[INFO] Parameter: artifactId, Value: jsoup-example
[INFO] Parameter: version, Value: 1.0-SNAPSHOT
[INFO] Project created from Archetype in dir: /usr/local/etc/maven-wrapper/instances.d/jsoup-example
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  5.997 s
[INFO] Finished at: 2023-12-30T16:42:32+07:00
[INFO] ------------------------------------------------------------------------
```
Edit the file `"/usr/local/etc/maven-wrapper/instances.d/jsoup-example/pom.xml"` and delete its entire contents. Replace it with the script below.

```console
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.example.jsoupexample</groupId>
  <artifactId>jsoup-example</artifactId>
  <version>1.0-SNAPSHOT</version>

  <name>jsoup-example</name>
  <!-- FIXME change it to the project's website -->
  <url>http://www.example.com</url>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>1.7</maven.compiler.source>
    <maven.compiler.target>1.7</maven.compiler.target>
  </properties>

  <dependencies>
 <dependency>
        <groupId>org.jsoup</groupId>
        <artifactId>jsoup</artifactId>
        <version>1.14.3</version>
    </dependency>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
        <plugins>
            <plugin>
                <artifactId>maven-assembly-plugin</artifactId>
                <configuration>
                    <archive>
                        <manifest>
                            <mainClass>com.example.jsoupexample.App</mainClass>
                        </manifest>
                    </archive>
                    <descriptorRefs>
                        <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                </configuration>
                <executions>
                    <execution>
                        <id>make-assembly</id>  
                        <phase>package</phase>  
                        <goals>
                            <goal>single</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>


</project>
```


Don't forget, delete the entire contents of the file `"/usr/local/etc/maven-wrapper/instances.d/jsoup-example/src/main/java/com/example/jsoupexample/App.java"`, and replace it with the script below.

```console
package com.example.jsoupexample;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class App {

 public static void main(String[] args) {
        for(int i = 1; i <= 4; ++i) {
            System.out.println("PAGE " + i);
            try {
                String url = (i==1) ? "https://www.scrapingbee.com/blog" : "https://www.scrapingbee.com/blog/page/" + i;

                Document document = Jsoup.connect(url)
                                        .timeout(5000)
                                        .get();

                Elements blogs = document.getElementsByClass("p-10");
                for (Element blog : blogs) {
                    String title = blog.select("h4").text();
                    System.out.println("TITLE: " + title);

                    String link = blog.select("a").attr("href");
                    System.out.println("LINK: " + link);

                    String headerImage = blog.selectFirst("img").attr("src");
                    System.out.println("HEADER IMAGE: " + headerImage);
                    String authorImage = blog.select("img[src*=authors]").attr("src");
                    System.out.println("AUTHOR IMAGE:" + authorImage);

                    System.out.println();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }
}
```

To run the web scraper, open your terminal, navigate to the `"/usr/local/etc/maven-wrapper/instances.d/jsoup-example"` directory, and run the following command.

```yml
root@ns7:/usr/local/etc/maven-wrapper/instances.d # cd jsoup-example
root@ns7:/usr/local/etc/maven-wrapper/instances.d/jsoup-example # mvn compile && mvn package && mvn install
```

<br/>
<img alt="FreeBSD JSoup Maven Compile Package Install" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/FreeBSD_JSoup_Maven_compilePackageInstall.jpg' | relative_url }}">
<br/>

Run web scraper with jar.

```yml
root@ns7:/usr/local/etc/maven-wrapper/instances.d/jsoup-example # java -jar target/jsoup-example-1.0-SNAPSHOT-jar-with-dependencies.jar
```

<br/>
<img alt="FreeBSD Run JSoup webscraper" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/FreeBSD_Run_JSoup_webscraper.jpg' | relative_url }}">
<br/>

You can see all the scripts in this article in full on [Github](https://github.com/unixwinbsd/jsoup-example/tree/main).

This example only shows a small portion of what jsoup can do. JSoup is an excellent choice for web scraping in Java. While this article introduces the library, you can learn more about it in the jsoup documentation. While jsoup is easy to use and efficient, it does have its drawbacks. For example, it can't execute JavaScript code, which means it can't be used for scraping dynamic web pages and single-page applications. In those cases, you'll need to use something like Selenium.