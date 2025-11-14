---
title: Installing Python Package Manager PIP on OpenBSD  7.6
date: "2025-02-17 17:23:11 +0100"
updated: "2025-07-23 17:25:12 +0100"
id: install-python-pip-on-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: SysAdmin
background: https://media.licdn.com/dms/image/v2/D4D12AQGUGMQ67uCIiw/article-cover_image-shrink_720_1280/B4DZZqIIriHwAI-/0/1745537241002?e=1763596800&v=beta&t=SV3AIRKnlgTszFdAvXJlIe6GkGSRiThtD2bf08_pTNM
toc: true
comments: true
published: true
excerpt: Pip is a package management system used to install and manage software packages written in Python.
keywords: python, pip, venv, oepnbsd, unix, freebsd, poetry, Package Manager
---

Pip is a package management system used to install and manage software packages written in Python. Pip stands for Pip Installs Packages. Pip allows you to install libraries and tools from the Python Package Index (PyPI) or other repositories.

As a software developer, you can use pip to install various Python modules and packages for your own Python projects. and also as an end user, you may need pip to install some applications developed using Python and can be easily installed using pip. One example is the Stress Terminal application, which you can easily install using pip.

In this article, we will learn how to install and configuration Python and PIP on OpenBSD.

## A. System specifications:

<br/>
> OS: OpenBSD 7.6-current amd64         
> Host: Acer Aspire M1800         
> Packages: 124 (pkg_info)            
> Shell: ksh v5.2.14 99/07/13.2           
> CPU: Intel Core 2 Duo E8400 (2) @ 3.000GHz       
> Memory: 181MiB / 1775MiB        
> IP Address: 192.168.5.3       
> Hostname: ns3          
> Versi Python: python-3.11.10p0        
> Versi PIP: py-pip-20.3.4p3       

<br/>
<img alt="Python PIP OpenBSD" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://media.licdn.com/dms/image/v2/D4D12AQGUGMQ67uCIiw/article-cover_image-shrink_720_1280/B4DZZqIIriHwAI-/0/1745537241002?e=1763596800&v=beta&t=SV3AIRKnlgTszFdAvXJlIe6GkGSRiThtD2bf08_pTNM' | relative_url }}">
<br/>

## B. Install Python-3.11

Because PIP is used to make it easier to install Python packages, the main requirement for PIP to be used is that you must install Python.

```yml
ns5# pkg_add python-3.11.10p0
or
ns5# pkg_add python-3.11.10p1
ns5# pkg_add py-setuptools-44.1.1p0v0
```
<br/>
### a. Create Python-3.11 Symlink

Because there are so many python repositories in OpenBSD that will indirectly be installed when you install one of the programs. So to make sure which version of Python you are using, you have to create a symlink.

```console
ns5# ln -s /usr/local/bin/python3.11 /usr/local/bin/python
```
<br/>
### b. Checking Python Version

This part is very important, not only to check the python version, but also to make sure whether Python has been installed or not on OpenBSD.

```yml
ns5# python --version
Python 3.11.10
```

## C. Installing PIP

Pip is a special program used to install Python packages onto your system. PIP is sometimes included automatically when Python is installed on your system, and sometimes you have to install it yourself. However, on OpenBSD systems, you must install PIP manually. This guide will help you install PIP on OpenBSD.

```console
ns5# pkg_add -i py-pip
```
<br/>
### a. Create PIP Symlink

Similar to Python programs, you also need to create a symlink for PIP.

```console
ns5# ln -sf /usr/local/bin/pip2.7 /usr/local/bin/pip
```
<br/>
### b. Checking PIP Version

The next step is almost the same as the Python program, we continue by checking the PIP version.

```console
ns5# pip --version
```

## D. Installing Python Packages with PIP

Once the PIP installation is complete, pip is installed and ready to use. As a result, we can start installing packages using PIP from PyPI. Most Python packages can be installed in a single command line. For example, here's how to install Requests, which is used to make API calls from Python programs.

```console
ns5# pip install --user requests
```

In the example script above, PIP has downloaded the files needed to install Requests, and then managed the installation for us. The --user flag means that pip has made Requests available to us, but not to other users. This prevents individual Python packages from conflicting with each other on a multi-user system. It’s a good idea to use this flag unless you have a specific reason not to.

### a. Removing Python packages with pip

If you want to remove a Python installation package, you can use the request to do the removal as in the following example.

```console
ns5# pip uninstall requests
```
<br/>
### b. How to Update PIP

Once PIP is installed, it is a good idea to update it from time to time. Usually pip will prompt you with instructions on how to update it when necessary, but you can try updating it manually at any time. For example, here is an example of the output for updating an older version of pip.

```console
ns5# pip install --upgrade pip
```

Actually, if you want to use Pip to install Python-based GUI applications, you should use Pipx. Pip complies with the new Python guidelines. But this article does not discuss PIPX, you can read other articles that discuss PIPX.
