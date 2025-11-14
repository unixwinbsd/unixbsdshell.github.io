---
title: How to Install FreeBSD VENV Virtual Environment and Python Packages
date: "2025-05-30 17:12:31 +0100"
updated: "2025-05-30 17:12:31 +0100"
id: install-python-venv-virtual-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/NugetArticle/FreeBSD%20Python%20VENV%20Virtual%20Environments%20and%20Packages.jpg&commit=481fe074f0bd681f3dc9468bc280d4d4f47aa206
toc: true
comments: true
published: true
excerpt: pip is a package manager for Python that allows you to install additional libraries and packages that are not part of the standard Python library as found in the Python Package Index. This is an easy installation replacement
keywords: python, pip, package manager, install, freebsd, symlink, virtual, env
---

When developing software with Python, the basic approach is to install Python on the server computer machine, install all the necessary libraries via the terminal, write all the script code in a single file with the extension `*.py`, or a notebook, and run the Python program on the terminal shell.

A python virtual environment is a tool that helps separate the dependencies required by different projects by creating an isolated python virtual environment for the project. This is one of the most important tools that most Python developers use.

Python virtual environment consists of two important components:
- A Python interpreter that resides in the virtual environment where python is run.
- A folder containing third-party libraries installed in a virtual environment.

Of all the reasons why Python is popular among developers, one of the biggest is its wide and growing choice of third-party packages. Practical toolkits for everything from ingesting and formatting data to high-speed math and machine learning are just a matter of importing or installing pip.

But what happens if the packages don't match each other? What do you do when different Python projects require competing or incompatible versions of the same add-on? This is where the Python virtual environment comes into play.

This virtual environment is isolated from other virtual environments, meaning any changes to dependencies installed in the virtual environment do not affect other virtual environment dependencies or system-wide libraries. Thus, we can create multiple virtual environments with different versions of Python, plus different libraries or the same library in different versions.


<br/>
<img alt="FreeBSD Python VENV Virtual Environments and Packages" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/NugetArticle/FreeBSD%20Python%20VENV%20Virtual%20Environments%20and%20Packages.jpg&commit=481fe074f0bd681f3dc9468bc280d4d4f47aa206' | relative_url }}">
<br/>

The importance of a Python virtual environment can be felt when we have multiple Python projects on the same machine that depend on different versions of the same package. For example, imagine working on two different data visualization projects that use the matplotlib package, one using version 2.2 and the other using version 3.5.

This will cause compatibility issues because Python cannot use multiple versions of the same package simultaneously. Another use case that magnifies the importance of using a Python virtual environment is when you are working on a managed server or production environment where you cannot change system-wide packages due to certain requirements.

To demonstrate the benefits of the python virtual environment, we tried installing and running it on a FreeBSD 13.2 machine. The final results of this configuration have been summarized in an article which you can now read and practice on the FreeBSD server.

[How to Install Python Package Manager PIP on FreeBSD 14](https://unixwinbsd.site/freebsd/install-python-pip-env-freebsd/)



## 1. Python Virtualenv Installation

To start a Python virtual environment, we have to install several Python library applications that are used to run the virtual environment. The most important library is Python Virtualenv, here is how to install it on a FreeBSD system.

```console
root@ns1:~ # cd /usr/ports/lang/python311
root@ns1:/usr/ports/lang/python311 # make install clean
root@ns1:~ # cd /usr/ports/devel/py-virtualenv
root@ns1:/usr/ports/devel/py-virtualenv # make install clean
```

To complete the Python virtual environment, we will also install the pip application, or you can read the complete article about pip installation in the link above.

```console
root@ns1:~ # cd /usr/ports/devel/py-pip
root@ns1:/usr/ports/devel/py-pip # make install clean
root@ns1:/usr/ports/devel/py-pip # cd /usr/ports/shells/bash
root@ns1:/usr/ports/shells/bash # make install clean
```

Or if you want to use the PKG package, follow these steps:

```console
root@ns1:~ # pkg install python311
root@ns1:~ # pkg install py311-virtualenv
root@ns1:~ # pkg install py311-pip
root@ns1:~ # pkg install bash
```


## 2. Creating a Python Virtual Environment

After the application installation process above is complete, we continue by creating virtual python. Before we apply the virtual environment and to make the work process easier we have to create a work folder. The following are the work steps that must be implemented to create a python virtual environment.

### a. Create a work folder

```console
root@ns1:~ # mkdir -p /tmp/praktekvirtual
root@ns1:~ # cd /tmp/praktekvirtual
```

### b. Create a work project

```python
root@ns1:/tmp/praktekvirtual # python -m venv tutorial-virtual
```

The script above is to create a virtual python working project with the name `tutorial-virtual`.


### c. Activate the virtual environment

After completing creating the virtual environment, the next step is to activate the virtual environment, in this case the virtual environment of our project is "tutorial-virtual".

```console
root@ns1:/tmp/praktekvirtual # cd tutorial-virtual
root@ns1:/tmp/praktekvirtual/tutorial-virtual # source bin/activate.csh
(tutorial-virtual) root@ns1:/tmp/praktekvirtual/tutorial-virtual #
```

Take a look at the blue script above, if it appears like the blue script, it means you have activated the Python virtual environment with the work project name `tutorial-virtual`.


### d. Managing Packages with pip

After successfully creating and activating the Python virtual environment, now we try to install Python libraries such as pip. What you need to pay attention to when installing the Python library is that you must be active in the Python virtual environment, as in point **"c"** above.

```console
(tutorial-virtual) root@ns1:/tmp/praktekvirtual/tutorial-virtual # pip install --upgrade pip
(tutorial-virtual) root@ns1:/tmp/praktekvirtual/tutorial-virtual # python3 -m pip install requests
```

The command in the first script is used to update the pip application, while the command in the second script is used to install the requests library which is one of the libraries in the Python Package Index (PyPI).

With pip we can determine which version of a package to install using the version of that package. For example, to install a specific version.

```console
(tutorial-virtual) root@ns1:/tmp/praktekvirtual/tutorial-virtual # python3 -m pip install 'requests==2.18.4'
(tutorial-virtual) root@ns1:/tmp/praktekvirtual/tutorial-virtual # python3 -m pip install 'requests>=2.0.0,<3.0.0'
```

The command from the first script above will install the requests package version 2.18.4 and the second script command will install the requests package version 2.0.0 or lower than version 3.

Another example is installing the application package in the Python virtual environment as in the example below.

```console
(tutorial-virtual) root@ns1:/tmp/praktekvirtual/tutorial-virtual # python -m pip install novas
Collecting novas
  Downloading novas-3.1.1.5.tar.gz (135 kB)
     ???????????????????????????????????????? 135.3/135.3 kB 1.7 MB/s eta 0:00:00
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
  Preparing metadata (pyproject.toml) ... done
Building wheels for collected packages: novas
  Building wheel for novas (pyproject.toml) ... done
  Created wheel for novas: filename=novas-3.1.1.5-cp39-cp39-freebsd_13_2_release_amd64.whl size=111806 sha256=953706837f405838280709c5e4bd98c433206e153b90ef79e2b97df4bd57672e
  Stored in directory: /root/.cache/pip/wheels/03/55/e2/0d996cda98ec16abd858b291254af4dda190368a3dbe8dbc1e
Successfully built novas
Installing collected packages: novas
Successfully installed novas-3.1.1.5
```

<br/>

```console
(tutorial-virtual) root@ns1:/tmp/praktekvirtual/tutorial-virtual # python3 -m pip install google-auth==1.1.1
Collecting google-auth==1.1.1
  Downloading google_auth-1.1.1-py2.py3-none-any.whl (60 kB)
     ???????????????????????????????????????? 60.6/60.6 kB 909.3 kB/s eta 0:00:00
Collecting cachetools>=2.0.0 (from google-auth==1.1.1)
  Obtaining dependency information for cachetools>=2.0.0 from https://files.pythonhosted.org/packages/a9/c9/c8a7710f2cedcb1db9224fdd4d8307c9e48cbddc46c18b515fefc0f1abbe/cachetools-5.3.1-py3-none-any.whl.metadata
  Downloading cachetools-5.3.1-py3-none-any.whl.metadata (5.2 kB)
Collecting pyasn1>=0.1.7 (from google-auth==1.1.1)
  Using cached pyasn1-0.5.0-py2.py3-none-any.whl (83 kB)
Collecting pyasn1-modules>=0.0.5 (from google-auth==1.1.1)
  Downloading pyasn1_modules-0.3.0-py2.py3-none-any.whl (181 kB)
     ???????????????????????????????????????? 181.3/181.3 kB 3.8 MB/s eta 0:00:00
Collecting rsa>=3.1.4 (from google-auth==1.1.1)
  Downloading rsa-4.9-py3-none-any.whl (34 kB)
Collecting six>=1.9.0 (from google-auth==1.1.1)
  Using cached six-1.16.0-py2.py3-none-any.whl (11 kB)
Downloading cachetools-5.3.1-py3-none-any.whl (9.3 kB)
Installing collected packages: six, pyasn1, cachetools, rsa, pyasn1-modules, google-auth
Successfully installed cachetools-5.3.1 google-auth-1.1.1 pyasn1-0.5.0 pyasn1-modules-0.3.0 rsa-4.9 six-1.16.0
```

To exit the python virtual environment, type the following script.

```python
(tutorial-virtual) root@ns1:/tmp/praktekvirtual/tutorial-virtual # deactivate
```

pip has more options. We can use pip to install packages in the python library with the help of pip and the python virtual environment.
