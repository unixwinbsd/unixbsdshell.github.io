---
title: Setup Go Lang Reverse Proxy With FreeBSD
date: "2024-12-26 07:51:25 +0100"
updated: "2025-09-30 11:21:25 +0100"
id: go-lang-reverse-proxy-with-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/diagram_reverse_proxy_go_lang.jpg
toc: true
comments: true
published: true
excerpt: In large or small scale computer networks, a reverse proxy is an application that is in front of a back-end application and forwards client requests, for example the Google Chrome browser, to that application. Having a reverse proxy can help improve network scalability, performance, resilience and security. The resources returned to the client appear as if they came from the web server itself.
keywords: go, lang, golang, go lang, languange, proxy, reverse, forward, freebsd, redirect
---

A reverse proxy is a type of proxy server that receives requests from clients, and redirects them to one or more servers, after which it forwards the response back. When a client sends a request to a proxy server, the reverse proxy receives it and then redirects it to the server that matches the client's request. This allows the proxy to process requests from multiple clients at once and distribute them to different servers in the network for more efficient processing.

Reverse proxies can also perform other functions, such as restricting access based on IP address or URL, converting protocols, caching data, compressing data, and so on. This makes it a versatile tool for processing large amounts of data and ensuring network reliability and security.

The characteristic of a reverse proxy is that the proxy is used as an input point to connect users to servers connected to the proxy itself through business logic. The proxy will determine which server the client request will be sent to. The logic of building a network behind a proxy remains hidden from the user.

In large or small scale computer networks, a reverse proxy is an application that is in front of a back-end application and forwards client requests, for example the Google Chrome browser, to that application.

Having a reverse proxy can help improve network scalability, performance, resilience and security. The resources returned to the client appear as if they came from the web server itself.

In this article we will explain how to build a reverse proxy with a FreeBSD server. Even though the contents of this article run on FreeBSD, you can apply it to Linux, Windows or MacOS.

<br/>
![diagram reverse proxy go lang](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/diagram_reverse_proxy_go_lang.jpg)
<br/>


## 1. Setup Reverse Proxy

As a first step in running a reverse proxy, make sure the GO application is installed on your FreeBSD server. If GO is not installed, don't expect to be able to run a reverse proxy.

Read our previous article on how to install GO on a FreeBSD server.

[How to Install GOLANG GO Language on FreeBSD](https://unixwinbsd.site/freebsd/go-lang-freebsd14-golang-install/)

The main features of the reverse proxy that we will create:
- Reverse Proxying
    - Load Balancing
    - Active Healthchecks
- File Server
    - Browsing Directories
    - Serving Static Sites
- HTTP Response Header Modification.
- Authentication
    - Basic HTTP Auth
    - Key Auth
- Optional TLS Support.
- URL Rewrites.

The scheme of this reverse proxy is, the backend we use the Node.js Web App with IP `127.0.0.1 Port 3000` and the reverse proxy we use the Go Lang server with IP `192.168.5.2 Port 8585`.

After we create the reverse proxy schema, create a working directory to store all your reverse proxy data.

```yml
root@ns7:~ # cd /usr/local/etc
root@ns7:/usr/local/etc # mkdir -p Go-ReverseProxy-FreeBSD
root@ns7:/usr/local/etc # cd Go-ReverseProxy-FreeBSD
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD #
```

After that, create the file `gargoyle.go`, as the config file for the reverse proxy.

```yml
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # touch gargoyle.go
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # chmod +x gargoyle.go
```

In the `/usr/local/etc/gargoyle.go` file, enter the following script.

```console
package main

import (
	"os"

	"github.com/unixwinbsd/Go-ReversePRoxy-FreeBSD/internal/server"
)

func main() {
	var configFile string
	if len(os.Args) > 1 {
		configFile = os.Args[1]
	}
	if configFile == "" {
		configFile = "./config.json"
	}
	server.Start(configFile)
}
```

We continue by creating an internal directory, which contains the config, loadbalancer, reverseproxy and server directories.

```yml
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # mkdir -p internal/config
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # mkdir -p internal/loadbalancer               
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # mkdir -p internal/reverseproxy
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # mkdir -p internal/server
```

We create another bin directory, to store the json configuration files. In the bin directory, create a file called `config.json`.

```yml
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # mkdir -p bin
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # cd bin
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD/bin # touch config.json
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD/bin # chmod +x config.json
```

The contents of the `/usr/local/etc/go-reverse-proxy/bin/config.json` file should look like this.

```console
[
	{

		"source": "192.168.5.2:8585",
		"reverse_proxy": {

			"targets": ["http://127.0.0.1:3000"]
		}
	}
]



[
	{
		"source": "192.168.5.2:8585",
		"reverse_proxy": {
			"targets": [
				"http://127.0.0.1:3000"

			],

			"lb_algorithm": "round-robin",
			"health_check": {
				"enabled": true,
				// relative path for healthcheck requests, default: ""
				"path": "/health",
				// time after which each healthcheck starts, required, unit: seconds
				"interval": 10,
				// HTTP request timeout for requests to target servers, default: 5, unit: seconds
				"timeout": 15
			}
		}
	}
]

[
	{
		"source": "192.168.5.2:8585",
		"fs": {

			"path": "/root/.cache/pypoetry/index/reverseproxy/gargoyle/bin"
		}
	}
]

[
	{

		"header": {
			// map of HTTP headers to add
			"add": {
				"Access-Control-Max-Age": "86400"
			},
			// list of HTTP headers to remove
			"remove": ["Served-By"]
		}
	}
]

Supported Methods: `basic_auth`, `key_auth`


	[
		{

			"auth": {
				// map of username, hashes
				"basic_auth": {
					"tinfoil": "JDJhJDEwJHB3YWI3YTJPVmxPTG1pTjlaSG5VaU9NM2tUZWZWaTFrSGR4bFg3VXVXTGVpcWkydVA2L2VX",
					"knight": "JDJhJDEwJFB1ZVRaL2dFL1RDS1RxbFc5dTdBYWVEc245OTVuS3FPdGJjeGpXQ3Q5T0RJSjRnT2dEU3lp"
				}
			}
		}
	]


	[
		{

			"auth": {
				"key_auth": {
					// HTTP header to get the key from, default: X-Api-Key
					"header": "X-Auth-Key",
					"key": "some-secret-key"
				}
			}
		}
	]

```

Try to pay attention to the blue writing in the script above, the IP and port explain the backend and reverse proxy server, as we have explained in the image above.

Then in the internal folder we create files in each folder. You can see the contents of the script code from this file in our Github repository.

[go reverse proxy freebsd](https://github.com/unixwinbsd/Go-ReverseProxy-FreeBSD.git)

The next file we create is the `Makefile`, this file is used to build your reverse proxy project.

```yml
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD/bin # cd ..
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # touch Makefile
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # chmod +x Makefile
```

The contents of the `/usr/local/etc/go-reverse-proxy/Makefile` file should look like this.

```console
GOROOT = $(shell go env GOROOT)

build:
	@echo "> Building binary"
	go build -o bin/unixwinbsd .

build-docker:
	@echo "> Building Docker image"
	docker build -t unixwinbsd .

gencert:
	@echo "> Generating TLS cert"
	mkdir -p .unixwinbsd
	cd .unixwinbsd; go run "$(GOROOT)/src/crypto/tls/generate_cert.go" --rsa-bits=2048 --host=localhost

run:
	@echo "> Starting unixwinbsd"
	go run unixwinbsd.go

test:
	@echo "> Running tests"
	go test -v -race ./...

format:
	@echo "> Formatting the source"
	gofmt -d -e

clean:
	@echo "> Cleaning up"
	go clean -testcache
	rm -rf tmp bin

.PHONY: build run format
```



## 2. Make Build Reverse Proxy

Before we run the GO reverse proxy, do the `make build` command first.

```yml
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # go mod init github.com/unixwinbsd/Go-ReversePRoxy-FreeBSD
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # go mod tidy
```

Continue with the following command.

```yml
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # go get golang.org/x/crypto/bcrypt
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # go get github.com/unixwinbsd/Go-ReversePRoxy-FreeBSD/internal/reverseproxy
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # go get github.com/unixwinbsd/Go-ReversePRoxy-FreeBSD
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # go get github.com/unixwinbsd/Go-ReversePRoxy-FreeBSD/internal/server
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # go get github.com/unixwinbsd/Go-ReversePRoxy-FreeBSD/internal/config
```

The final step is to run the `make build` command, to create a reverse proxy bin file.

```yml
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # make build
```

The above command will create an executable file named **unixwinbsd**, which is located in the directory `/usr/local/etc/Go-ReverseProxy-FreeBSD/bin`.

Now we run the reverse proxy.

```yml
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD # cd bin
root@ns7:/usr/local/etc/Go-ReverseProxy-FreeBSD/bin # ./unixwinbsd
2024/01/07 19:10:12 INFO: Starting reverse proxy on 192.168.5.2:8585
```

Before running the `"/"` command, make sure you have the Node.js Web App server running. To see the results, open Google Chrome and type the command 192.168.5.2:8585. See the results.

<br/>
![web app go lang reverse proxy](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/web_app_go_lang_reverse_proxy.jpg)
<br/>

You can read about how to create a `Node.js` Web App in our previous article.

[Install NPM Node JS on OpenBSD](https://unixwinbsd.site/openbsd/install-npm-node-js-openbsd/)

These are just a few examples of using reverse proxies with Go lang. Its ability to proxy is very reliable and stable, so there's nothing wrong with running it on your FreeBSD server.