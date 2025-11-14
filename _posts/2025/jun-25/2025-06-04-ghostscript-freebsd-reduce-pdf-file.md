---
title: Using FreeBSD and Ghostscript to Reduce PDF File Size
date: "2025-06-04 14:01:05 +0100"
updated: "2025-06-04 14:01:05 +0100"
id: ghostscript-freebsd-reduce-pdf-file
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://pbs.twimg.com/media/GslSzDdasAE26e4?format=jpg&name=medium
toc: true
comments: true
published: true
excerpt: Despite its name, Ghostscript is not a script. Ghostscript is a suite of software programs that can interpret the Postscript language created by Adobe Systems Inc. Through these programs, users can convert Postscript language files into various raster image processing (RIP) formats for printing and display, or interpret Postscript files for printers that do not have native Postscript capabilities
keywords: ghostscript, reduce, pdf, file, apache, proxy, reverse, jenkins, ci, cid, freebsd, installation, github, gitlab
---

Ghostscript is an interpreter for the PostScript® language and PDF files. Ghostscript is available under the GNU GPL Affero license or licensed for commercial use from Artifex Software, Inc. Ghostscript has been in active development for over 30 years and has been ported to several different systems over the years. Ghostscript consists of a PostScript interpreter layer and a graphics library.

Despite its name, Ghostscript is not a script. Ghostscript is a suite of software programs that can interpret the Postscript language created by Adobe Systems Inc. Through these programs, users can convert Postscript language files into various raster image processing (RIP) formats for printing and display, or interpret Postscript files for printers that do not have native Postscript capabilities. The suite of software can perform the same function for portable document format (PDF) files and has the ability to convert Postscript files to PDF, or vice versa.

In 1986, L. Peter Deutsch created the Ghostscript package for the GNU Not Unix Project (GNU) as a means for open-source UNIX systems to interpret the Postscript language. Although intended as open source software, Deutsch also planned to make a commercial version, so he retained copyright on the source code. As a result, the software ended up under the constraints of many different licenses that restricted its use in various ways.

<br/>
![freebsd and ghostscript kompress pdf file](https://pbs.twimg.com/media/GslSzDdasAE26e4?format=jpg&name=medium)
<br/>


Since most people are more familiar with the Ghostscript program as a printer program, in this article we will discuss another function of the Ghostscript program, namely using this program to reduce or compress PDF files.


## 1. How to Install Ghostscript on FreeBSD
In order for the Ghostscript application to run on the FreeBSD system, the first step to running Ghostscript is to install it. The command below is used to install Ghostscript on FreeBSD. In this article, FreeBSD version 13.2 is used.

```console
root@ns1:~ # cd /usr/ports/print/ghostscript10
root@ns1:cd /usr/ports/print/ghostscript10 # make install clean
```

The command from the script above is used to install `Ghostscript`, we can also use the pkg package to **install Ghostscript**, here is how to install Ghostscript with the `FreeBSD pkg package`.

```console
root@ns1:~ # pkg install ghostscript10
```


## 2. How to Compress PDF Files with Ghostscript

How to use the Ghostscript application is relatively easy and very simple, with just one command we can compress PDF files from large to small. To practice how to compress with Ghostscript, suppose we have a PDF file named `"unix_command_eng.pdf"` and we put the file in the `/tmp` folder. Now we see with the `"ls"` command.

```console
root@ns1:/tmp # ls -ls
217 -rw-------   1 root      wheel   278952 Aug 27 20:41 tmpug9m00lrcacert.pem
   9 -rw-------   1 root     wheel    23645 Aug 27 23:51 tmpxriuokj4.lnk
 217 -rw-------   1 root     wheel   278952 Aug 25 16:09 tmpz8v4mdybcacert.pem
   9 drwxr-xr-x   5 root     wheel        7 Aug 25 16:55 tutorial-env
4497 -rw-r--r--   1 root     wheel  4598191 Aug 29 17:14 unix_command_eng.pdf
   9 drwxr-xr-x   5 root     wheel        7 Aug 25 16:30 venv
3209 -rw-r--r--   1 jenkins  wheel  3404114 Aug 29 11:27 winstone8584808061225671634.jar
```

From the above display we can see that the file `unix_command_eng.pdf` has a file size of around 4,598,191 kb or more than 4 MB. Now we will reduce or compress the file `unix_command_eng.pdf` with Ghostscript. The following command is used to compress PDF files with Ghostscript.

```console
root@ns1:~ # cd /tmp
root@ns1:/tmp # gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="unixhasilkompresi.pdf" unix_command_eng.pdf
```

Now we see the results with the command `"ls -lh"`.

```console
root@ns1:/tmp # ls -lh
-rw-------   1 root     wheel    14K Aug 27 11:56 tmps1b3q1dq.lnk
-rw-------   1 root     wheel   272K Aug 27 20:41 tmpug9m00lrcacert.pem
-rw-------   1 root     wheel    23K Aug 27 23:51 tmpxriuokj4.lnk
-rw-------   1 root     wheel   272K Aug 25 16:09 tmpz8v4mdybcacert.pem
drwxr-xr-x   5 root     wheel     7B Aug 25 16:55 tutorial-env
-rw-r--r--   1 root     wheel   4.4M Aug 29 17:14 unix_command_eng.pdf
-rw-r--r--   1 root     wheel   898K Aug 29 17:26 unixhasilkompresi.pdf
drwxr-xr-x   5 root     wheel     7B Aug 25 16:30 venv
-rw-r--r--   1 jenkins  wheel   3.2M Aug 29 11:27 winstone8584808061225671634.jar
```

From the results above, it can be seen that the original file `unix_command_eng.pdf` with a size of `4.4 MB` has been changed to a file unixkomprasikan.pdf with a size of `898 kb`. There is a very large reduction in file size capacity.

With the Ghostscript application, it will really help us to reduce the file size. Amazingly, Ghostscript can reduce the number of files very significantly, but does not reduce the results displayed by the PDF file. The results of compressing PDF files with Ghostscript have more or less the same quality.