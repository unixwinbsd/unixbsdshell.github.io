---
title: Google Indexing API With Go Lang For Submit URLs On FreeBSD
date: "2025-08-09 10:13:21 +0100"
updated: "2025-08-09 10:13:21 +0100"
id: google-indexing-api-with-go-lang-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/url-indexing-api.jpg
toc: true
comments: true
published: true
excerpt: Indexing API is a Google search engine tool that web site owners can use to send notifications directly to Google's search robot, about adding or removing pages from Google resources. With the Indexing API you can submit up to 200 pages per day for scanning and subsequent indexing
keywords: google, indexing, api, cloud, freebsd, go, language, golang, gsc, gcp
---

Indexing API is a Google search engine tool that web site owners can use to send notifications directly to Google's search robot, about adding or removing pages from Google resources. With the Indexing API you can submit up to 200 pages per day for scanning and subsequent indexing (up to a maximum of 100 pages per iteration). This will significantly speed up the process from page creation to getting the first results in organic search results.

Every SEO expert must have faced the problem that Google search robots find and index pages very slowly. To optimize this, it is critical that new or re-optimized pages enter the index with updated data as quickly as possible. Because the standard method via Google Search Console to speed up page indexing on Google takes a long time for your URL to be indexed. Additionally, the classic method via the Google Search Console webmaster tools, has a limit on the number of URLs submitted per day, and the process itself can take up to several weeks.

Usually websites are indexed by Google automatically. However, there is also a sitemap to help website owners announce what Google should crawl or certain pages on the website. For every website update, Google search engine crawler robots visit the website and update their index with the latest page information. However, waiting for the Google bot to scan our page automatically takes a long time. That's where the Google Indexing API comes into play.

Google indexing API, helps us index pages in Google records faster than other methods. You can clone the source code in this article on the [unixwinbsd Github repository](https://github.com/unixwinbsd/FreeBSD_Google_Indexing_API.git).

<br/>
{% lazyload data-src="/img/oct-25/url-indexing-api.jpg" src="/img/oct-25/url-indexing-api.jpg" alt="url indexing API" %}
<br/>

## 1. Crete Json Key

The main requirement for doing Google indexing API, you must have a jason key file. You can create this file on [Google Cloud Platform](https://console.cloud.google.com/projectselector2/iam-admin/serviceaccounts).

The json file is very useful, because we will use this file in the Go Lang script code. Below is an example of a json file that you have created on Google Cloud Platform.

`"blog-project-43540-d31ba843867c.json"`

We will place the json file together with the Go lang file in one folder.

In this article, we will not explain how to create a json file, you can read our previous article, about how to create a jason file in Google Cloud Platform.

## 2. Crete Script Go Lang

At this stage we will create a Go lang file script. This script will help you index your website's pages in bulk, without having to manually request each URL for submission in the Google Search Console interface.

Before we start, we will create a working directory for creating our project. We will place the working directory in `"/usr/local/etc"`. Use the following command to create the `"Google Indexing API"` working directory.

```yml
root@ns7:~ # cd /usr/local/etc
root@ns7:/usr/local/etc # mkdir -p FreeBSD_Google_Indexing_API
root@ns7:/usr/local/etc # cd FreeBSD_Google_Indexing_API
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API #
```

The above command, is used to create a working directory in `"/usr/local/etc/FreeBSD_Google_Indexing_API"`.

We continue by creating a go file, which will contain a script to index website URLs.

```yml
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # touch FreeBSD_Indexing_API.go
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # chmod +x FreeBSD_Indexing_API.go
```

The script contents of the file are as below.

```console
package main

import (
	"context"
	"flag"
	"fmt"
	"google.golang.org/api/indexing/v3"        
	"google.golang.org/api/option"
	"os"
	"strings"
)

func main() {
	var urlsPath, credentials string
	flag.StringVar(&urlsPath, "urls", "./urls", "path to file with links to pages")
	flag.StringVar(&credentials, "credentials", "./blog-project-43540-d31ba843867c.json", "path to file with credentials downloaded from https://console.developers.google.com/iam-admin/serviceaccounts")
	flag.Parse()

	ctx := context.Background()
	client, err := indexing.NewService(ctx, option.WithCredentialsFile(credentials))

	if err != nil {
		fmt.Println(err)
	}

	b, err := os.ReadFile(urlsPath)

	if err != nil {
		fmt.Println(err)
	}

	str := string(b)
	urls := strings.Split(str, "\n")

	for _, url := range urls {
		notification := indexing.UrlNotification{
			Type: "URL_UPDATED",
			Url:  url,
		}

		res, err := client.UrlNotifications.Publish(&notification).Do()

		if err != nil {
			fmt.Println(err)
		}

		fmt.Println(res)
	}
}
```

The script `"./blog-project-43540-d31ba843867c.json"` above is the JSON file you created on Google Cloud Platform. We assume you have already downloaded the JSON file from Google Cloud Platform. Place it together with the `"FreeBSD_Indexing_API.go"` file in the same folder.

After that, we create a `"urls"` file, to store all the URLs that will be indexed.

```yml
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # touch urls
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # chmod -R 777 urls
```

In the `"/usr/local/etc/FreeBSD_Google_Indexing_API/urls"` file, enter your Blogspot or WordPress URL address. Like the example below.

```yml
https://www.unixwinbsd.site/2024/01/exec-maven-plugin-running-java-programs.html
https://www.unixwinbsd.site/2024/01/grpc-installation-and-use-under-freebsd.html
https://www.unixwinbsd.site/2024/01/dynamic-dns-with-godns-alternative.html
https://www.unixwinbsd.site/2024/01/setup-freebsd-scala-java-programming.html
https://www.unixwinbsd.site/2024/01/learn-how-to-install-nginx-web-server.html
https://www.unixwinbsd.site/2024/01/build-java-app-with-maven-on-freebsd.html
```

Run the following command to download the Go lang API repository.

```yml
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # go mod init github.com/unixwinbsd/FreeBSD_Google_Indexing_API
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # go mod tidy
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # go get github.com/unixwinbsd/FreeBSD_Google_Indexing_API
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # go get google.golang.org/api/indexing/v3
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # go get google.golang.org/api/option
```

The final step, we create a binary file to execute the application.

```yml
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # go build -o index FreeBSD_Indexing_API.go
```

Before we run the application, look at the file structure.

```console
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # ls
.git                                    blog-project-43540-d31ba843867c.json    go.sum                                  urls
FreeBSD_Indexing_API.go                 go.mod                                  index
```

Run the `"Google Indexing API"` application with the `"index"` command.

```yml
root@ns7:/usr/local/etc/FreeBSD_Google_Indexing_API # ./index
```

<br/>
<img alt="api indexing results" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/oct-25-001.jpg' | relative_url }}">
<br/>

Congratulations, you have successfully created the `"Google Indexing API"` application with FreeBSD. This application can index 200 URLs every day.