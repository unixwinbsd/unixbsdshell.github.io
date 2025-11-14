---
title: Setting ENV Paths in Freebsd for Java and Go Composer
date: "2025-05-25 08:25:35 +0100"
updated: "2025-05-25 08:25:35 +0100"
id: setting-env-path-java-composer-go-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: In the Environment, shell command variables are used as the main channel for interacting with environment variables in the operating system. The shell will act as a command line interpreter, executing instructions entered by the user.
keywords: env, path, environment, variables, composer, java, go, golang, freebsd, github, root, user, shell, command
---
In FreeBSD environment variables, known as ENV, are dynamic values â€‹â€‹that have a significant impact on the behavior of running programs and system processes. Environment variables serve as a means of sending important information to software and shaping how programs interact with the system environment. Each process in FreeBSD is always associated with a set of environment variables, which guide its behavior and interaction with other processes.

In the Environment, shell command variables are used as the main channel for interacting with environment variables in the operating system. The shell will act as a command line interpreter, executing instructions entered by the user.

The implementation of environment variables in the FreeBSD operating system is very important. With the existence of environment variables, it can be determined where variables can be accessed or placed, so that it can be clearly distinguished between global and local scopes.

<br/>


<div align="center">
    <b> <h3>
        The FreeBSD operating system uses environment variables to store information such as strings and numbers. Variables can be reused throughout the code and you can assign values â€‹â€‹to them, as well as edit, overwrite, and delete them.
    </h3></b>
    
</div>

<br/>

In this article we will learn about environment variables on a FreeBSD server. For example, we will use Composer, Go, and Java applications.

You can view environment variables in the FreeBSD operating system by using the env command. This command will display the current values â€‹â€‹for all environment pairs, name/value, and more.

```console
root@ns3:~ # env
USER=root
LOGNAME=root
HOME=/root
MAIL=/var/mail/root
PATH=/usr/local/.composer/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/root/bin
TERM=xterm
BLOCKSIZE=K
MM_CHARSET=UTF-8
LANG=C.UTF-8
SHELL=/bin/csh
SSH_CLIENT=192.168.5.54 58432 22
SSH_CONNECTION=192.168.5.54 58432 192.168.5.2 22
SSH_TTY=/dev/pts/0
HOSTTYPE=FreeBSD
VENDOR=amd
OSTYPE=FreeBSD
MACHTYPE=x86_64
SHLVL=1
PWD=/root
GROUP=wheel
HOST=ns3
REMOTEHOST=192.168.5.54
JAVA_VERSION=17.0+
ES_JAVA_HOME=/usr/local/openjdk17
GO_VERSION=1.20+
GOROOT=/usr/local/go120
GOPATH=/usr/local/go120/pkg
COMPOSER_VERSION=2.7+
COMPOSER_HOME=/usr/local/.composer/cache
COMPOSER_MIRROR_PATH_REPOS=/usr/local/.composer
COMPOSER_BINARY=/usr/local/.composer
EDITOR=vi
PAGER=less
```

## 1. Setting the Java Path Environment Variable
On FreeBSD, the JAVA_HOME and PATH environment variables need to be set to use tools such as javac, java, Tomcat, Solr, and others. If you are using Java17 or other versions, by default, FreeBSD stores the installation process files in `/usr/local/openjdk17`. The JAVA_HOME environment variable points to the JDK installation directory. To use Java Paths correctly, open the `/etc/csh.cshrc` file, and type the following path script.

```console
root@ns3:~ # ee /etc/csh.cshrc
setenv JAVA_VERSION "17.0+"
setenv ES_JAVA_HOME /usr/local/openjdk17
```
The above command only creates a temporary Java Path, now we will make the Java Path changes permanent by editing the `~/.cshrc` file.

```console
root@ns3:~ # ee .cshrc
set path = ($ES_JAVA_HOME/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
```
## 2. Setting GO PAth Path (Go Path Environment Variable)

In this section, we assume that your FreeBSD has go120 installed. By default, FreeBSD stores all Go installation files in the `/usr/local/go120` directory. We will use this directory as the path to store all Go library files from the installation process and build applications that run with Go.

The steps are almost the same as creating a Java Path. Open the `/etc/csh.cshrc` file, only the script content is different.

```console
root@ns3:~ # ee /etc/csh.cshrc
setenv GO_VERSION "1.20+"
setenv GOROOT /usr/local/go120
setenv GOPATH /usr/local/go120/pkg
```
Make `GOROOT` and `GOPATH` permanent FreeBSD environment variables. Type the following script in the `~/.cshrc` file.

```console
root@ns3:~ # ee .cshrc
set path = ($GOROOT/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
set path = ($GOPATH/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
```
Let's give an example, changing the Go Path. Open the `/usr/local/go120/pkg` directory, view its contents with the `ls -l` command.

```console
root@ns3:~ # cd /usr/local/go120/pkg
root@ns3:/usr/local/go120/pkg # ls -l
total 1
drwxr-xr-x  2 root  wheel  6 Mar 21 00:13 include
drwxr-xr-x  3 root  wheel  3 Mar 21 00:13 tool
```

In the `/usr/local/go120/pkg` directory there are two folders, namely include and tools. For more details, how to implement PATH GO, we will install the `"Google Indexing API"` application, we will clone it from the Github server.

```console
root@ns3:~ # cd /var
root@ns3:/var # git clone https://github.com/unixwinbsd/FreeBSD_Google_Indexing_API.git
```
Once you are done cloning, proceed to install the application.

```console
root@ns3:/var # cd FreeBSD_Google_Indexing_API
root@ns3:/var/FreeBSD_Google_Indexing_API # go build -v ./...
```
Now you see the `/usr/local/go120/pkg` directory again, run the `ls -l` command.

```console
root@ns3:/var/FreeBSD_Google_Indexing_API # cd /usr/local/go120/pkg
root@ns3:/usr/local/go120/pkg # ls -l
total 2
drwxr-xr-x  2 root  wheel  6 Mar 21 00:13 include
drwxr-xr-x  3 root  wheel  3 Mar 21 00:33 pkg
drwxr-xr-x  3 root  wheel  3 Mar 21 00:13 tool
```
From the above script, we can see that there is a new folder called `"pkg"`. Let's see the contents of the pkg folder.

```console
root@ns3:/usr/local/go120/pkg # cd pkg
root@ns3:/usr/local/go120/pkg/pkg # ls
mod
root@ns3:/usr/local/go120/pkg/pkg # cd mod
root@ns3:/usr/local/go120/pkg/pkg/mod # ls
cache                           go.opencensus.io@v0.24.0        google.golang.org
cloud.google.com                go.opentelemetry.io
github.com                      golang.org
```
With the above example, it is quite clear that all the installation files will be stored in the `/usr/local/go120/pkg` directory. At this point, you have begun to understand the usefulness of the Path environment variable.

## 3. Setting the Composer Path Environment Variable
For any operating system that uses multiple users, running applications at the root level is not recommended. In addition to security factors, it will also make it difficult to work with multiple users. The placement of files or libraries from the application installation should not be done in the root. For example, in the composer application, if you do not specify a path, all files will be placed in `/root/.composer/cache`.

In this section, we will move the default composer path to the `/usr/local` directory, as we did in Java and Go. To set the Composer Path, the method is almost the same as Java and Go. The first step you have to do is create the` /usr/local/.composer/cache` directory.

```console
root@ns3:~ # mkdir -p /usr/local/.composer/cache
root@ns3:~ # cd /usr/local/.composer/cache
root@ns3:/usr/local/.composer/cache #
```
After that, you open the `/etc/csh.cshrc` file, then type the script below.

```console
root@ns3:~ # ee /etc/csh.cshrc
setenv COMPOSER_VERSION "2.7+"
setenv COMPOSER_HOME /usr/local/.composer/cache
setenv COMPOSER_MIRROR_PATH_REPOS /usr/local/.composer
setenv COMPOSER_BINARY /usr/local/.composer
```
In this article we use Composer version 2.7.0. After you determine the location of the Composer Path. Make this path permanent, so that all files generated from the PHP Composer installation are placed on the path you specified above. Open the `~/.cshrc` file, type the script below in the `~/.cshrc` file.

```console
root@ns3:~ # ee .cshrc
set path = ($COMPOSER_HOME/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
set path = ($COMPOSER_MIRROR_PATH_REPOS/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
set path = ($COMPOSER_BINARY/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
```

In order for all the above Path changes to take effect immediately, reboot your computer.

```console
root@ns3:~ # reboot
```
After you read this article and apply it to your FreeBSD server, your knowledge of how to set or export environment variables in the csh/tcsh Shell Prompt from the command line on a FreeBSD system will be very helpful in finding the location of each application installation file. Everything looks neat, because you have arranged the files and directories in their respective places.