---
title: Download Youtube Videos With Youtube dl CMD on FreeBSD
date: "2025-11-22 18:45:02 +0000"
updated: "2025-11-22 18:45:02 +0000"
id: download-youtube-video-with-youtube-dl-cmd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/salin_alamat_url_untuk_persiapan_download.jpg
toc: true
comments: true
published: true
excerpt: This article will discuss how to use youtube-dl, what capabilities this utility provides to users, and what useful features the developer has included. We'll be using the FreeBSD operating system for this article.
keywords: video, youtube, subscribe, download, youtube dl, command, cmd, freebsd, bsd, unix, shell
---

Have you ever wanted to save your favorite video or audio from the internet to your computer? But how could the website not have a download button? That's exactly what the free, cross-platform utility youtube-dl is for: it allows you to download audio and video files simply by knowing the address of the page where the file is located.

The youtube-dl application is a small command-line program for downloading videos from YouTube.com, Metacafe.com, Google Videos, Photobucket Videos, Yahoo Video, Dailymotion, and more. youtube-dl is a Python-based utility for downloading videos from various websites. It can be run on Linux, FreeBSD, or Windows operating systems.

This article will discuss how to use youtube-dl, what capabilities this utility provides to users, and what useful features the developer has included. We're using the FreeBSD operating system for this article.

## 1. Installing YouTube-dl

On the FreeBSD operating system, you can install youtube-dl in several ways. The quickest way is to use the PKG package, but PKG doesn't completely install all dependent libraries. The best way is to use the FreeBSD porting system.

As a first step, install the YouTube-dl dependencies.

```yml
root@ns6:~ # pkg install tex-xetex tex-formats texlive-base ghc hs-pandoc rtmpdump
```

Once all the above dependencies are installed, proceed with installing the Youtube dl application.

```yml
root@ns6:~ # cd /usr/ports/www/youtube_dl
root@ns6:/usr/ports/www/youtube_dl # make config
```

<img alt="Install Dependency Youtube DL" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/instal_dependensi.jpg' | absolute_url }}">

If you want to use MP3 audio conversion, make sure multimedia/ffmpeg was created with the "LAME" option enabled. Use the "make clean" command to start the installation.

```yml
root@ns6:/usr/ports/www/youtube_dl # make install clean
```

## 2. How to Download with YouTube dl

To successfully use this utility, you must correctly type the command in the terminal. The syntax is simple:

> youtube-dl [OPTIONS] URL [URL...]

Main options:

-**-h, --help:** Print this help text and exit.
-**--version:** Print the program version and exit.
-**-U, --update:** Update this program to the latest version.
-**-i, --ignore-errors:** Continue on download errors.
-**--abort-on-error:** Cancel any subsequent video downloads.
-**--dump-user-agent:** Display the current browser identifier.
-**--list-extractors:** List all supported extractors.
-**--extractor-descriptions:** Descriptions of the output from all supported extractors.
-**--force-generic-extractor:** Force extraction to use a generic extractor.
-**--default-search:** Use this prefix for unqualified URLs.
-**--ignore-config:** Do not read the configuration file.
-**--config-location:** The path to the configuration file.
-**--flat-playlist:** Do not extract videos from playlists, just list them.
-**--mark-watched:** Mark videos as watched (YouTube only).
-**--no-mark-watched:** Don't mark videos as watched (YouTube only).
-**--no-color:** Don't emit color codes in the output.

To download videos, the first step is to create a download folder `"/tmp/YTDownload"`.

```yml
root@ns6:~ # mkdir -p /tmp/YTDownload
root@ns6:~ # cd /tmp/YTDownload
```

Then open the YouTube website, and copy the URL in the address bar menu, as shown below.

<img alt="copy the url address to prepare for download" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/salin_alamat_url_untuk_persiapan_download.jpg' | absolute_url }}">

After that, run the following command in the terminal.

<img alt="run via cmd command" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/run_via_cmd_command.jpg' | absolute_url }}">

```console
root@ns6:/tmp/YTDownload # youtube-dl 'https://www.youtube.com/watch?v=dMoCmLnak4w'
[youtube] dMoCmLnak4w: Downloading webpage
[dashsegments] Total fragments: 1
[download] Destination: Satu Keluarga Diserang Pria Bersenjata Tajam Terekam CCTV - LIS 21_11-dMoCmLnak4w.f136.mp4
[download] 100% of 9.07MiB in 00:06
[dashsegments] Total fragments: 1
[download] Destination: Satu Keluarga Diserang Pria Bersenjata Tajam Terekam CCTV - LIS 21_11-dMoCmLnak4w.f140.m4a
[download] 100% of 1022.10KiB in 00:00
[ffmpeg] Merging formats into "Satu Keluarga Diserang Pria Bersenjata Tajam Terekam CCTV - LIS 21_11-dMoCmLnak4w.mp4"
Deleting original file Satu Keluarga Diserang Pria Bersenjata Tajam Terekam CCTV - LIS 21_11-dMoCmLnak4w.f136.mp4 (pass -k to keep)
Deleting original file Satu Keluarga Diserang Pria Bersenjata Tajam Terekam CCTV - LIS 21_11-dMoCmLnak4w.f140.m4a (pass -k to keep)
root@ns6:/tmp/YTDownload #
```

The youtube-dl utility will be useful for anyone who wants to download music and videos from sites that don't offer download functionality. It has many flexible settings and only one drawback: poor graphics.
