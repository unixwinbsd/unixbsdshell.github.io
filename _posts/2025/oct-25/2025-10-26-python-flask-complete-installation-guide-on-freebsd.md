---
title: FreeBSD Python Flask - Complete Installation, Configuration, and Usage Guide
date: "2025-10-26 09:22:33 +0100"
updated: "2025-10-30 13:41:21 +0100"
id: python-flask-complete-installation-guide-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/oct-25/oct-25-137.jpg
toc: true
comments: true
published: true
excerpt: Using Python Flask, you can create faster and more efficient web applications. This framework can be used for small, medium, and more complex web applications. This article will cover the installation process, configuration, and how to use Python Flask on FreeBSD.
keywords: freebsd, python, flask, ubuntu, notebook venv, virtual, complete, installation, guide, web server, openbsd
---

Entering the world of web development, there are countless languages, frameworks, and technologies to master. But what if there was a tool that could simplify your journey and help you build advanced web applications? That tool is Python Flask, a lightweight and intuitive web framework.

Through its minimalist yet feature-rich design, Flask allows you to build simple static websites to complex web applications with high speed and efficiency. What exactly is Python Flask? Why do so many developers, both beginners and experts, use it as their tool of choice? How can you use it to build your own applications?.

Python Flask is a lightweight and simple web framework written in the Python programming language. Flask is considered lightweight because it doesn't require a lot of system requirements or dependencies compared to other Python frameworks. In other words, Flask gives users more flexibility and control to build web applications according to their individual needs and desires.

Using Python Flask, you can create faster and more efficient web applications. This framework can be used for small, medium, and more complex web applications.

This article will cover the installation process, configuration, and how to use Python Flask on FreeBSD.

<br/>


{% lazyload data-src="/img/oct-25/oct-25-137.jpg" src="/img/oct-25/oct-25-137.jpg" alt="my lazyloaded image" %}

<br/>


## 1. Python Flask Installation Process

Python-supported applications on FreeBSD are very comprehensive. This is evident in the repository support provided by FreeBSD. Flask applications written in Python are also available as built-in packages on FreeBSD.

On FreeBSD, you can easily install Flask. There are two ways to install Flask: using the PKG package or system port, and through a Python virtual environment (venv). Of the two, we prefer the former. Besides being easy, almost all dependencies are available and can be easily installed.

If you're using Python venv, many versions are often out of sync with the FreeBSD version. Furthermore, Python venv often experiences kernel issues, resulting in many Python applications not running in venv. This is in stark contrast to Linux, where installing Python packages with venv is very easy.

For example, in this post, we'll install Flask using the FreeBSD PKG package. The guide below will make it easy to install Flask on FreeBSD.

```sh
root@ns3:~ # pkg install py39-flit-core py39-build py39-installer py39-pytest py39-werkzeug py39-Jinja2 py39-itsdangerous bash
```

<br/>

```sh
root@ns3:~ # pkg install py39-flask
```

## 2. How to Run Python Flask

On FreeBSD, there are many ways to run Flask. In this article, we'll show you the most common methods used by FreeBSD users: using Bash and downloading the Python application package from the GitHub repository.

### a. Running Flask with Bash

In this section, we'll show you how to run Flash with Bash. To make it easier to use Flask, create a working directory to store your Flask files.

```sh
root@ns3:~ # mkdir -p /usr/local/etc/flask
root@ns3:~ # cd /usr/local/etc/flask
root@ns3:/usr/local/etc/flask #
```

After that, in the flask directory, you create a python file `"flaskApp.py"`, and type the script below in the file.

```sh
root@ns3:/usr/local/etc/flask # touch flaskApp.py
root@ns3:/usr/local/etc/flask # ee flaskApp.py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return '"FreeBSD The Power To Server"'

if __name__ == '__main__':
    app.run()
```

Then you can run Flask with Bash, here's an example.

```sh
root@ns3:/usr/local/etc/flask # bash
[root@ns3 /usr/local/etc/flask]# export FLASK_APP=flaskApp.py
[root@ns3 /usr/local/etc/flask]# flask run --host=192.168.5.2 --debug
 * Serving Flask app 'flaskApp.py'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://192.168.5.2:5000
Press CTRL+C to quit
```
You can see the results by opening Google Chrome and typing `"http://192.168.5.2:5000/"`. If you successfully run Flask, Google Chrome will display the words `"FreeBSD The Power To Server"`. 192.168.5.2 is our FreeBSD server's private IP, you can adjust it to your FreeBSD private IP.

### b. Running Flask without Bash
If you don't have a bash application, you can run Flask without it. Below, we provide an example of how to run Flask without bash. Run the command below to run Flask without bash.

```sh
root@ns3:~ # cd /usr/local/etc/flask
root@ns3:/usr/local/etc/flask # flask --app flaskApp.py run --host=192.168.5.2 --debug
 * Serving Flask app 'flaskApp.py'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://192.168.5.2:5000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 996-541-309
```
With or without bash, the results displayed in Google Chrome will be the same. You simply choose whether to run Flask with or without bash.

### c. Run Flask from the Github repository

For web application developers, GitHub is a familiar language. Many Python packages you can use on FreeBSD are sourced from GitHub. In this section, we'll show you how to run Flask with a Python package application sourced from a GitHub repository. The first step is to clone the Python package you'll be using. Below, we've selected one Python package that we'll deploy on our FreeBSD server.

```sh
root@ns3:~ # cd /usr/local/etc/flask
root@ns3:/usr/local/etc/flask # git clone https://github.com/pallets/flask
root@ns3:/usr/local/etc/flask # cd FlaskApp
root@ns3:/usr/local/etc/flask/FlaskApp #
```

Once the cloning process is complete, run the Initialize database command.

```sh
root@ns3:/usr/local/etc/flask/FlaskApp # cd examples/tutorial
root@ns3:/usr/local/etc/flask/FlaskApp/examples/tutorial # flask --app flaskr init-db
Initialized the database.
```

After that, you run Flask (without bash).

```sh
root@ns3:/usr/local/etc/flask/FlaskApp/examples/tutorial # flask --app flaskr run --host=192.168.5.2 --debug
 * Serving Flask app 'flaskr'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://192.168.5.2:5000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 996-541-309
```

You can see the results of the above command by opening Google Chrome. Type `"http://192.168.5.2:5000/"` in the address bar.

By reading this entire article, you've successfully created a web server with Python and Flask. Now you can explore Flask's capabilities and develop web applications in Python. This material only covers a small portion of how to use Flask; we recommend studying additional materials and practicing to improve your skills.