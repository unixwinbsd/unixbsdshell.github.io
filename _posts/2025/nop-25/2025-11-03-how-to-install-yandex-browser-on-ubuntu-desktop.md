---
title: How to Install Yandex Browser on Ubuntu Desktop
date: "2025-11-03 07:41:29 +0100"
updated: "2025-11-03 07:41:29 +0100"
id: how-to-install-yandex-browser-on-ubuntu-desktop
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-006.jpg
toc: true
comments: true
published: true
excerpt: Yandex Browser is a fast, secure, and versatile web browser developed by Yandex, a Russian multinational corporation specializing in internet-related products and services. This guide will walk you through the steps to add the Yandex repository and install the browser.
keywords: yandex, browser, freebsd, mysql, nextcloud, ubuntu, linux, openssl, google, unix, apache, apache24, bsd, debian
---

Yandex Browser is a fast, secure, and versatile web browser developed by Yandex, a Russian multinational corporation specializing in internet-related products and services.

The browser features a sleek interface, built-in security tools, and a variety of customization options. Key features include Turbo mode for faster browsing on slow connections, an integrated translation tool, and advanced privacy features to protect user data.

To install Yandex Browser on `Ubuntu 24.04, 22.04, or 20.04`, you can use Yandex's official APT repository, which provides access to the latest stable or beta versions.

During the installation process, Yandex Browser can import data from other browsers installed on your system. Like Google Chrome, importing data from Firefox requires closing the active Mozilla browser session:

This guide will walk you through the steps to add the Yandex repository and install the browser.

<br/>
<img alt="Yandex Browser" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-006.jpg' | relative_url }}">
<br/>

## A. Update Your Ubuntu System Before Installing Yandex

We will be using Ubuntu's APT package manager to install Yandex browser. If an update is available, we recommend running the system update command for installation.

Before installing any new software, it's a good idea to ensure your system is up-to-date. This ensures the latest features and security updates and reduces the potential for package conflicts during the installation process.

To update your Ubuntu system, you can run the following command in the terminal:

```yml
ns4@iwans:/$ sudo apt update && sudo apt upgrade
```
<br/>
## B. Install Yandex Browser dependencies

Once your system is updated, the next step is to install a series of dependencies essential for successfully installing Yandex Browser. While most of these packages are likely already present on your system, running the following command will verify their presence.

```yml
ns4@iwans:/$ sudo apt install curl apt-transport-https -y
```

The above command will install curl, a tool for transferring data via URL, and `apt-transport-https`, a package that allows package maintainers to transfer files and data over https. If you encounter problems later in the installation process, you may want to revisit this step to ensure these packages are installed correctly.

## C. Integrating Public Keys

The system requires a key to verify packages we receive using Yandex's additional repositories. This ensures that the system packages are in the same state as when the developers released them and have not been modified by anyone.

```yml
ns4@iwans:/$ cd /tmp
ns4@iwans:/tmp$ curl -fsSL https://repo.yandex.ru/yandex-browser/YANDEX-BROWSER-KEY.GPG | gpg --dearmor | sudo tee /usr/share/keyrings/yandex.gpg > /dev/null
```

Once the GPG key is imported, you can import the Yandex Browser Stable and Beta repositories. Please note that they share separate installations, and you can choose to import one or both, depending on your preference.

To import the Yandex Browser Stable repository, use the following command.

```yml
ns4@iwans:/tmp$ echo deb [arch=amd64 signed-by=/usr/share/keyrings/yandex.gpg] http://repo.yandex.ru/yandex-browser/deb stable main | sudo tee /etc/apt/sources.list.d/yandex-stable.list
```

With the Yandex Browser repository imported, it's time to update your package lists to reflect the newly imported repository. This can be done by running APT update with the following command.

```yml
ns4@iwans:/tmp$ sudo apt update
```
<br/>
## D. Install Yandex Browser on Ubuntu Desktop

At this point, your system is ready to install Yandex Browser. Depending on the repository you imported, you can install the stable version or the beta/development version.

To install the stable version of Yandex Browser, run the following command:

```yml
ns4@iwans:/tmp$ sudo apt install yandex-browser-stable
```
<br/>
## E. Remove Yandex Repositories

When installing Yandex Browser, whether the stable or beta version, additional source.list files may be automatically created. Due to their incorrect format, these files can trigger a series of error messages when running the apt update command.

Fortunately, there's a simple solution to this problem. You can quickly remove these unnecessary source.list files with the following command.

```yml
ns4@iwans:/tmp$ sudo rm /etc/apt/sources.list.d/yandex-browser*.list
```

The above command effectively removes all source.list files associated with Yandex Browser, regardless of whether you have installed the stable or beta version. This command retains only the source.list files you previously imported, namely, yandex-beta.list and yandex-stable.list.

Then, run the command to verify the deletion of the automatically generated source.list files.

After deleting the unnecessary source.list files, it's a good idea to verify that the operation was successful and that no related errors will occur in the future. This can be easily done by running apt update.

```yml
ns4@iwans:/tmp$ sudo apt update
```

If the removal is successful, this command will run smoothly without any Yandex Browser-related error messages. This step effectively confirms that your system is now free of automatically generated _sources.list_ files.

## F. Opening Yandex Browser with CLI or GUI

After successfully installing Yandex Browser on your Ubuntu Desktop, we can run the Yandex application.

Running Yandex Browser with the GUI is very easy, similar to opening Google Chrome on Windows. So, in this article, we will only discuss how to run Yandex Browser with the Command Line Interface, or CLI as the Westerners call it.

Open the Ubuntu CLI shell menu, then type the following command.

```yml
ns4@iwans:/$ yandex-browser-stable
```
<br/>
## G. Uninstalling Yandex Browser

If you need to uninstall Yandex Browser, use the appropriate terminal command for the installed version.

If you have the stable version installed, use the following command.

```yml
ns4@iwans:/$ sudo apt remove yandex-browser-stable
```

After uninstalling Yandex Browser, it's a good idea to remove the repositories associated with Yandex Browser from your system.

The command to remove the stable repository is:

```yml
ns4@iwans:/$ sudo rm /etc/apt/sources.list.d/yandex-stable.list
```

With Yandex Browser successfully installed on your Ubuntu system, you can enjoy its powerful features and a better browsing experience. Regularly updating the browser through Yandex's official APT repository ensures you have access to the latest features and security enhancements.

Explore the customizable settings and tools Yandex Browser offers for a more personalized and secure browsing experience.