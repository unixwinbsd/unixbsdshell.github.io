---
title: FreeBSD Twitter - How to Send Tweets Using the Twitter API
date: "2025-09-29 11:57:39 +0100"
updated: "2025-10-29 11:57:39 +0100"
id: install-twitter-send-tweet-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/oct-25/oct-25-34.jpg
toc: true
comments: true
published: true
excerpt: Twitter is a well-known and much sought after online news and social networking site. With Twitter you can communicate via short messages called tweets. We can use Go, Python or other applications to post tweets without even opening the Twitter website.
keywords: installation, tweet, twitter, api, http, send, freebsd, x, using
---


If you are a business person, blogger or YouTuber, you definitely want your work to grow rapidly. Therefore, growing a business requires a lot of effort, including working on social media to attract attention and promote your work to end users around the world.

Therefore, to maximize the results of your work, it is necessary to automate as much as possible so that you don't have to spend all your time preparing posts and replying to comments manually. If you've been using Twitter for a while, you've probably noticed the number of bots floating around.

Twitter is a well-known and much sought after online news and social networking site. With Twitter you can communicate via short messages called tweets. We can use Go, Python or other applications to post tweets without even opening the Twitter website.

This post discusses the process of how to send messages on Twitter with FreeBSD. In this article we use the GO Lang programming language, to create API scripts and others.


## 1. Get Access To Twitter APIs

An API is a set of definitions and protocols for building and integrating application software. API is an abbreviation for application programming interface (Application Programming Interface). APIs allow your product or service to communicate with other products and services without having to know how they are implemented.

This method can simplify application development, saving time and money. When you design new tools and products or manage existing ones, APIs give you the flexibility to simplify design, administration, usage, and provide opportunities for innovation. APIs are also sometimes considered contracts, with documentation representing an agreement between the parties.

Follow the steps below to get a Twitter API Token:

1. Log in to the "Twitter developer portal" with your Twitter account.
2. Then click on the "Add App".

![oct-25-33](/img/oct-25-33.jpg)



3. Click the "Add an existing App" button


![oct-25-34](/img/oct-25-34.jpg)


4. Click the "Next" button on the "Add your App" menu


![oct-25-35](/img/oct-25-35.jpg)



5. Click App setting

![oct-25-36](/img/oct-25-36.jpg)


6. Click the "Edit" button on the "App details" menu


![oct-25-37](/img/oct-25-37.jpg)




You will enter the `"User authentication settings"` menu. Type the data in the menu according to the image below.

![oct-25-38](/img/oct-25-38.jpg)

<br/>

![oct-25-39](/img/oct-25-39.jpg)




7. In the "App details" menu, click the "Keys and tokens" button


![oct-25-40](/img/oct-25-40.jpg)




## 2. Creating The Twitter Go Project

Before we start, we need to create a new project directory that we will use to place all the Go Lang files. We will place this working directory in the `"/var"` folder.

```
root@ns3:~ # cd /var
root@ns3:/var # mkdir -p twitter
root@ns3:/var # cd twitter
root@ns3:/var/twitter #
```

After that, you create the `"main.go"` file, and type the script below in the `"/var/twitter/main.go"` file.


```
package main

import (
	"context"
	"fmt"
	"os"

	"github.com/michimani/gotwi"
	"github.com/michimani/gotwi/tweet/managetweet"
	"github.com/michimani/gotwi/tweet/managetweet/types"
)

func main() {

	// Check expected secrets are set in the environment variables
	accessToken := os.Getenv("TW_ACCESS_TOKEN")
	accessSecret := os.Getenv("TW_ACCESS_SECRET")

	if accessToken == "" || accessSecret == "" {
		fmt.Fprintln(os.Stderr, "Please set the TW_ACCESS_TOKEN and TW_ACCESS_SECRET environment variables.")
		os.Exit(1)
	}

	// Check the comment to tweet has been supplied
	if len(os.Args) != 2 {
		fmt.Fprintln(os.Stderr, "Please pass the comment to tweet as the only argument.")
		os.Exit(1)
	}

	client, err := newOAuth1Client(accessToken, accessSecret)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	tweetId, err := tweet(client, os.Args[1])
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(2)
	}

	fmt.Println("tweet id", tweetId)
}

func newOAuth1Client(accessToken, accessSecret string) (*gotwi.Client, error) {
	in := &gotwi.NewClientInput{
		AuthenticationMethod: gotwi.AuthenMethodOAuth1UserContext,
		OAuthToken:           accessToken,
		OAuthTokenSecret:     accessSecret,
	}

	return gotwi.NewClient(in)
}

func tweet(c *gotwi.Client, text string) (string, error) {
	p := &types.CreateInput{
		Text: gotwi.String(text),
	}

	res, err := managetweet.Create(context.Background(), c, p)
	if err != nil {
		return "", err
	}

	return gotwi.StringValue(res.Data.ID), nil
}
```

Then create another file called `".env"`, and type the following script in the `"/var/twitter/.env"` file.

```
#!/bin/bash
# usage: source .env
export GOTWI_API_KEY=consumer_key:___API-Key
export GOTWI_API_KEY_SECRET=consumer_key:___API-Key-secret

# OAuth 1.0a User token
export TW_ACCESS_TOKEN=Authentication_Tokens:___Access-Token
export TW_ACCESS_SECRET=Authentication_Tokens:___Access-Token-Secret
```

Run the `"chmod"` command to grant file ownership permissions.

```
root@ns3:/var/twitter # chmod +x main.go
root@ns3:/var/twitter # chmod +x .env
```

Since the `".env"` script uses the `export` command, don't forget to install Bash, to run the command.

```
root@ns3:/var/twitter # pkg install bash
```

Create Go modules.

```
root@ns3:/var/twitter # go mod init freeBSDtwitter
root@ns3:/var/twitter # go mod tidy
```

The above command will generate `"go.mod"` and `"go.sum"` files, which contains all Go modules. To make it easier for you to execute the tweet command, we will create a binary file from the Go module.

```
root@ns3:/var/twitter # go build
```

The `"go build"` command will produce a file named `"freeBSDtwitter"`. This file is what we will use to send tweets via the Go module. Let's check it with the `"ls"` command.

```
root@ns3:/var/twitter # ls
.env            freeBSDtwitter  go.mod          go.sum          main.go
```


## 3. How to Send Tweets


If you have carried out all the steps above, now we will try sending a `"tweet"` via the `"freeBSDtwitter"` command. But first, we remind you this project runs with `"bash"`.

```
root@ns3:/var/twitter # bash
[root@ns3 /var/twitter]# source .env
```

We will try sending a tweet with the text `"Test: Hello world from golang"`.


```
[root@ns3 /var/twitter]# ./freeBSDtwitter "Test: Hello world from golang"
tweet id 1754169995377132013
```


We will try to send a YouTube link to Twitter, run the following command.

```
[root@ns3 /var/twitter]# ./freeBSDtwitter "FreeBSD SSO:  Drupal and GitHub integration With Drupal OAuth Client:  https://youtu.be/YPsulDziw2U"
tweet id 1754184903749673005
```
<br/>

![oct-25-41](/img/oct-25-41.jpg)

<br/>

![oct-25-42](/img/oct-25-41.jpg)


Congratulations on creating your first Twitter Bot, which posts a tweet for you. I recommend you to read the official Twitter API documentation and play around with the Twitter API to see what else can be automated to benefit your business. Most other social networks have their own APIs and enable similar things.