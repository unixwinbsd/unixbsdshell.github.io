---
title: How to Install Python Package Manager PIP on FreeBSD 14
date: "2025-05-30 11:12:31 +0100"
updated: "2025-05-30 11:12:31 +0100"
id: install-python-pip-env-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://ic.pics.livejournal.com/unixbsdshell/101779565/365/365_800.jpg
toc: true
comments: true
published: true
excerpt: pip is a package manager for Python that allows you to install additional libraries and packages that are not part of the standard Python library as found in the Python Package Index. This is an easy installation replacement
keywords: python, pip, package manager, install, freebsd, symlink, virtual, env
---

If you may say so, Python is the most popular programming language that is widely used by data analysts. Python is a powerful and stable free open source programming language with applications in many software domains, such as web development, game development, and, of course, data scientists.

Although Python itself is already capable of doing a lot of cool things, data professionals and more broadly software developers often use additional packages also known as libraries to make their lives easier working with python. A package is a collection of files, modules, and related dependencies that can be used repeatedly in different applications and problems.

One of Python's main strengths is its extensive and well-documented and comprehensive library catalogue. Where the library is hosted, how do you install and manage the packages you like. One of them is pip, a utility from Python that can help manage distribution packages with Python appropriately and correctly.

pip is a package manager for Python that allows you to install additional libraries and packages that are not part of the standard Python library as found in the Python Package Index. This is an easy installation replacement. If your Python version is 2.7.9 (or higher) or Python 3.4 (or higher), then pip comes pre-installed with Python, in other cases, you have to install it separately.

In this tutorial, you will be introduced to the world of packages in Python and pip, the standard package installer for Python. Pip is a powerful tool that lets you leverage and manage many of the Python packages you will encounter as a data professional and programmer.

<br/>
<img alt="python pip standard distribution" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://ic.pics.livejournal.com/unixbsdshell/101779565/365/365_800.jpg' | relative_url }}">
<br/>

## A. System Specifications:
- OS: FreeBSD 14.1-STABLE
- Hostname: ns1
- IP Address: 192.168.5.234
- Python: python: 3.11_3,2
- PIP: py311-pip


## B. Installing pip and python

There are two ways to install pip on a FreeBSD system. In this article we will install pip on a FreeBSD 14.1 server.

```console
root@ns1:~ # freebsd-version
14.1-STABLE
```

Before we start installing pip, we first determine the version of python that will be used, because writing this article uses `python3.1`.

```console
root@ns1:~ # cd /usr/ports/lang/python311
root@hostname1:/usr/ports/lang/python311 # make install clean
```

The command above is used to install Python, in this case the version installed is `Python39`. Next we install pip.

```console
root@ns1:/usr/ports/lang/python39 # cd /usr/ports/devel/py-pip
root@ns1:/usr/ports/devel/py-pip # make install clean
```

If you want to use the pkg package for pip installation, here is an example.

```console
root@ns1:~ # pkg install python311
root@ns1:~ # pkg install py311-pip
```

## C. Symlink pip and python

Because there are so many versions of python on FreeBSD systems, we have to make python39 the default used by our FreeBSD 13.2 server. Here's how to create a python39 symlink on FreeBSD and continue by rebooting/restarting the computer so that the python symlink can be used immediately.

```console
root@ns1:~ # rm -R -f /usr/local/bin/python
root@ns1:~ # ln -s /usr/local/bin/python3.11 /usr/local/bin/python
root@ns1:~ # reboot
```

After that, we continue by creating a pip symlink, the method is almost the same as above, only the script commands are different, here is how to create a pip symlink.

```console
root@ns1:~ # rm -R -f /usr/local/bin/pip
root@ns1:~ # ln -s /usr/local/bin/pip-3.11 /usr/local/bin/pip
root@ns1:~ # reboot
```

After the pip and python symlinks are installed, `upgrade pip`.

```console
root@ns1:~ # pip install --upgrade pip
```

After everything is configured, we do a test on pip, in this test we install a program and uninstall it using pip.

```console
root@ns1:~ # pip install awscli
root@ns1:~ # pip uninstall awscli
```

Installing and using pip on FreeBSD is an easy and efficient way to manage Python packages. With this program, you can install, update, and remove the packages you need for your work projects. Use the `pip install, pip install --upgrade, and pip uninstall` commands to manage packages on a FreeBSD system. Once pip is installed on the FreeBSD system, we are now ready to take full advantage of pip for Python development on FreeBSD.