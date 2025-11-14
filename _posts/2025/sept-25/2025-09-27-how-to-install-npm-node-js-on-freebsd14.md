---
title: How to Install NPM NodeJS on FreeBSD 14
date: "2025-09-27 09:27:39 +0100"
updated: "2025-09-27 09:27:39 +0100"
id: how-to-install-npm-node-js-on-freebsd14
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Before we begin installing NPM, we must first install its dependencies. To install NPM dependencies, simply use the pkg package. Besides being convenient, the installation process is also fast
keywords: npm, nodeJS, node, js, javascript, install, freebsd, linux, openbsd
---

Automation is the transfer of routine development tasks that can be performed manually to a computer. Automation translates files written and understood by developers into compressed code that can be understood by browsers, resulting in the final application package.

What does automation provide? Automation saves developers time and helps find and fix errors. It creates code that saves browser time and speeds up site loading. What tasks can be automated? For example, file minification (html, css, js), image compression, fetching specific image formats (webp), assembling sprite.svg files, assembling application packages.

What tools are used for automation? The programming community has created entire libraries of automation programs. There are also systems to facilitate access to these libraries and their use in the development of new programs and applications. One such system is Node.js.

To complete your knowledge about Linux applications that can run on FreeBSD systems, we recommend that you also read the article ["How to Configure Linux Binary Compatibility on FreeBSD"](https://unixwinbsd.site/freebsd/linux-binary-compatibility-ubuntu-freebsd).


## A. System specifications

- OS: FreeBSD 13.2
- Host/domain: ns1@unixexplore.com
- IP Addrees: 192.168.5.2
- Node JS version: Node.js v18.16.0
- NPM version: NPM 9.7.2


## B. Understanding NPM package.json

Node.js is a JavaScript interpreter often used to automate project assembly. In addition to Node.js, we need the npm package manager and the Gulp task manager. The npm package manager (node ​​package manager) is automatically installed when Node.js is installed on a server computer. Npm runs in the console and executes commands we enter according to the syntax offered by Node.js.

So, in general, npm is a free utility for JavaScript developers to install and share their packages with other developers around the world. Its name stands for Node Package Manager because it was originally created as the default package manager for Node.js. This tool is successfully used to manage both open source and private development.

The npm utility is a package manager included with Node.js. A package is one or more JS files representing some type of library or tool. The package manager is designed to download packages from cloud servers or upload (publish) packages to private servers.

Using npm, we can download new packages, update and delete them, share our packages with other users (after registering on the official site), and many more uses for npm.


## C. How to Install NPM package.json

Before we begin installing NPM, we must first install its dependencies. To install NPM dependencies, simply use the pkg package. Besides being convenient, the installation process is also fast.


```
root@ns1:~ # pkg install brotli && pkg install icu && pkg install libuv
```

Once all the above dependencies are installed, proceed with installing the node.js package, type the command below to install nde.js.

```
root@ns1:~ # cd /usr/ports/www/node
root@ns1:/usr/ports/www/node # make install clean
```

Then install the NPM package by typing the following command.

```
root@ns1:/usr/ports/www/node # cd /usr/ports/www/npm
root@ns1:/usr/ports/www/npm # make install clean
```

The last package to install is npm-node. In this article, we'll install npm-node18. Type the command below to install it.

```
root@ns1:/usr/ports/www/npm # cd /usr/ports/www/npm-node18
root@ns1:/usr/ports/www/npm-node18 # make install clean
```

Now that all the node.js NPM packages are properly installed on your FreeBSD system, you can use them for web development or other purposes. First, however, let's check the versions of the packages installed above. Use the command below to see the versions you're using.


```
root@ns1:~ # node --version
v18.16.0
root@ns1:~ # npm --version
9.7.2
```

## D. How to Use NPM

Using NPM on FreeBSD, Linux, and other operating systems is nearly identical, perhaps only slightly different in the installation process, but the installation process is still relatively easy. This is because NPM was created to make things easier for its users.

We can't use NPM packages without understanding the commands within NPM. Below is a list of commands you can use when working with NPM packages.


```
npm install              install all the dependencies in your project
npm install <foo>        add the <foo> dependency to your project
npm test                 run this project's tests
npm run <foo>            run the script named <foo>
npm <command> -h         quick help on <command>
npm -l                   display usage info for all commands
npm help <term>          search for help on <term>
npm help npm             more involved overview

All commands:

    access, adduser, audit, bugs, cache, ci, completion,
    config, dedupe, deprecate, diff, dist-tag, docs, doctor,
    edit, exec, explain, explore, find-dupes, fund, get, help,
    help-search, hook, init, install, install-ci-test,
    install-test, link, ll, login, logout, ls, org, outdated,
    owner, pack, ping, pkg, prefix, profile, prune, publish,
    query, rebuild, repo, restart, root, run-script, search,
    set, shrinkwrap, star, stars, start, stop, team, test,
    token, uninstall, unpublish, unstar, update, version, view,
    whoami.
```

Okay, now we'll practice using the NPM command. For example, if you want to download a package manually, you don't need to use package.json. You can run the npm command directly with the desired package name as the command argument, and the package will be automatically downloaded to the current directory. For example, as shown below.


```
root@ns1:~ # npm install grunt-cli
added 59 packages in 15s
4 packages are looking for funding
run `npm fund` for details
```

Okay, let's give another example. In this tutorial, we'll install Grunt using npm. Grunt is a task runner that allows you to automate many everyday tasks, such as image compression and CSS file minification. Type the command below to install the Grunt application.


```
root@ns1:~ # npm install -g grunt-cli
added 59 packages in 2s
4 packages are looking for funding
run `npm fund` for details
```

With NPM, we can also install external packages, such as links or URLs on GitHub. Here's an example of installing an NPM package as a URL link.


```
root@ns1:~ # npm install https://github.com/lodash/lodash
root@ns1:~ # npm install "https://gitpkg.now.sh/emmercm/metalsmith-plugins/packages/metalsmith-mermaid?8e21383"
```

If we want to remove a package in NPM, use the `"uninstall"` command, as in the example below.

```
root@ns1:~ # npm uninstall -g grunt-cli
removed 59 packages in 7s
```

NodeJS is an exciting technology that's gaining popularity in large web projects. Therefore, it's a good idea to install it on your FreeBSD system. In this article, we've explained how to install and use npm for those new to Node.js. With this article, you should be able to use various Node.js applications on your FreeBSD system.