---
title: Install and Configure pgAdmin for PostgreSQL on FreeBSD
date: "2025-06-02 18:42:11 +0100"
updated: "2025-06-02 18:42:11 +0100"
id: install-pgadmin-postgresql-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: pgAdmin is one of the leaders in open source PostgreSQL-based management, often referred to as the world's most advanced database platform. pgAdmin 4 is designed to meet the needs of both novice and experienced Postgres users, providing a powerful graphical interface that simplifies the creation, maintenance, and use of database object
keywords: pgadmin, phpmyadmin, php, postgresql, database, freebsd, install, configuration
---

pgAdmin is a management tool for PostgreSQL and derived relational databases such as EDB (Advanced Server EnterpriseDB). This program can be run as a web application or desktop. pgAdmin is a free and very popular open source platform. pgAdmin was created to make it easier for PostgreSQL database users, because this program has a graphical user interface for managing relational databases. Some of its features include query tools for SQL statements and import/export of csv files.

Graphical user interface (GUI) tools have become a standard part of today's technology workflow. For PostgreSQL management, pgAdmin is considered the right solution for users who need a graphical or GUI display, such as using Windows. As stated by its developers, pgAdmin 4 is the latest version, and its development involved a complete rewrite of the original pgAdmin tool.

pgAdmin is one of the leaders in open source PostgreSQL-based management, often referred to as the world's most advanced database platform. pgAdmin 4 is designed to meet the needs of both novice and experienced Postgres users, providing a powerful graphical interface that simplifies the creation, maintenance, and use of database objects.

pgAdmin is a free software project released under the PostgreSQL/Artistic license. pgAdmin 4 is software built using Python and JavaScript/jQuery. The desktop runtime written in C++ with Qt allows it to run standalone for individual users, or the web application code can be deployed directly on a web server for use by one or more users through their web browsers.

Another interesting feature of pgAdmin is its ability to handle SQL queries, maintenance, and other necessary processes without using the command prompt. In addition, pgAdmin also provides monitoring tools that allow users to see the status of operations at a glance, and help automate routine and periodic work.

Overall, it can be said that pgAdmin is a valuable addition to the workflow of most PostgreSQL users. With so much documentation, it is not difficult to get started, even if you have never installed a GUI tool on top of a database before. The next step is to make sure pgAdmin is compatible with the PostgreSQL installation that has been installed on your server.

In this article, we will learn about PGAdmin, a PostgreSQL management tool. As you know, SQL Server Management Studio (SSMS) and MySQL Workbench are GUI management tools for SQL Server and MySQL. Similarly, to manage Postgres database and its services, PGAadmin is used.

PGAdmin is a web-based GUI tool used to interact with Postgres database sessions, either locally or on a remote server. You can use PGAdmin to perform any type of database administration required for Postgres databases.

This article is written based on the practice done on FreeBSD 13.2 server. The following are the system specifications used to write this article.

## A. System Specifications:
- OS: FreeBSD 13.2
- IP Address: 192.168.5.2
- Domain: unixexplore.com
- PostgreSQL version: postgresql15
- Python version: python39
- Pgadmin version: pgadmin3
- Pip version: pip23.1

## B. How to Install pgadmin
In this article we will not discuss how to install PostgreSQL, we will assume that PostgreSQL has been installed on the FreeBSD server. So we continue with the installation of pgadmin. On the FreeBSD system, it is best to use the ports system to install pgadmin. Here's how to install pgadmin with the FreeBSD ports system.

```console
root@ns1:~ # cd /usr/ports/databases/py-sqlite3
root@ns1:/usr/ports/databases/py-sqlite3 # make install clean
root@ns1:/usr/ports/databases/py-sqlite3 # cd /usr/ports/lang/python39
root@ns1:/usr/ports/lang/python38 # make install clean
root@ns1:/usr/ports/lang/python38 # cd /usr/ports/devel/py-pip
root@ns1:/usr/ports/devel/py-pip # make install clean
root@ns1:/usr/ports/devel/py-pip # cd /usr/ports/devel/py-virtualenv
root@ns1:/usr/ports/devel/py-virtualenv # make install clean
```

The above command is a script to install the dependencies needed by the `pgadmin` program. The above command is very useful for running `pgadmin` on a FreeBSD system. After all the pgadmin dependencies are installed, here is how to install `pgadmin`.

```console
root@ns1:~ # cd /usr/ports/databases/pgadmin3
root@ns1:/usr/ports/databases/pgadmin3 # make install clean
```


## C. Create Python Symlink
Because pgadmin runs with python application and many python versions are automatically installed in FreeBSD, creating python symlink is very important. This symlink can be used to confirm the python version used, because in this article using python38 symlink must be python38.

Here are the steps to create python38 symlin in FreeBSD. The first step is to delete the existing symlink file.

```console
root@ns1:~ # rm -R -f /usr/local/bin/python
root@ns1:~ # ln -s /usr/local/bin/python3.9 /usr/local/bin/python
```

The first script above explains the removal of the python binary file and the second script creates a `python38` symbolic link. Both of the above script commands can also be used to resolve errors in Python such as `env python: No such file or directory`. Once the symbolic link file is created, restart your computer for the symbolic link to take effect.

```console
root@ns1:~ # reboot
```



## D. Run pgadmin
To run pgadmin, we must first create a working folder. We will create a working project named `projectPgadmin` and will place it in the `/tmp` folder.

```console
root@ns1:~ # mkdir -p /tmp/projectPgadmin
root@ns1:~ # cd /tmp/projectPgadmin
```

After that, continue by creating a working project in the Python virtual environment with the name `pgadmin`.

```console
root@ns1:/tmp/projectPgadmin # python -m venv pgadmin
root@ns1:/tmp/projectPgadmin # cd pgadmin
```

The above script is used to create a python working project named `pgadmin` and the working project is in the python virtual environment.

The working project is not yet active, now we will activate the working project, type the script below to activate the working project `pgadmin`.

```console
root@ns1:/tmp/projectPgadmin/pgadmin # source bin/activate.csh
(pgadmin) root@ns1:/tmp/projectPgadmin/pgadmin #
```


For more details about working in a `virtual python` environment, you can read the article above.

Then continue with the script below to update the `pip` application.

```console
(pgadmin) root@ns1:/tmp/projectPgadmin/pgadmin # pip install --upgrade pip
```

Once `pip` is successfully updated, type the following command to install the `pgadmin` repository.

```console
(pgadmin) root@ns1:/tmp/projectPgadmin/pgadmin # python3 -m pip install cryptography==3.3 pyopenssl ndg-httpsclient pyasn1 simple-websocket
(pgadmin) root@ns1:/tmp/projectPgadmin/pgadmin # python3 -m pip install https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v6.21/pip/pgadmin4-6.21-py3-none-any.whl
```

The next step is to type the following command to copy the `config.py` file to the `config_local.py` file.

```console
(pgadmin) root@ns1:/tmp/projectPgadmin/pgadmin # cd ..
(pgadmin) root@ns1:/tmp/projectPgadmin # cp ./pgadmin/lib/python3.9/site-packages/pgadmin4/config.py ./pgadmin/lib/python3.9/site-packages/pgadmin4/config_local.py
```

After the file copying process is complete, edit the `config_local.py` file and change the Server IP to the Private IP of our FreeBSD server computer. If you edit the config_local.py file using the `ee` or `vim` editor, you must exit the `Python virtual environment` first, use the `deactivate` command to exit the `Python virtual environment`.

```console
(pgadmin) root@ns1:/tmp/projectPgadmin # deactivate
root@ns1:/tmp/projectPgadmin # ee ./pgadmin/lib/python3.9/site-packages/pgadmin4/config_local.py
DEFAULT_SERVER = '192.168.5.2'
DEFAULT_SERVER_PORT = 5050
```


## E. Test pgadmin
After all applications are configured, now we will test whether the pgadmin application can run on the FreeBSD server. To do this test, we must be active in the Python virtual environment.

The following is a script used to activate pgadmin, starting from the `/root` folder.

```console
root@ns1:~ # cd /tmp/projectPgadmin/pgadmin
root@ns1:/tmp/projectPgadmin/pgadmin # source bin/activate.csh
(pgadmin) root@ns1:/tmp/projectPgadmin/pgadmin # cd ..
(pgadmin) root@ns1:/tmp/projectPgadmin # python ./pgadmin/lib/python3.9/site-packages/pgadmin4/pgAdmin4.py

NOTE: Configuring authentication for SERVER mode.

Enter the email address and password to use for the initial pgAdmin user account:

Email address: datainchi@gmail.com
Password: gunungrinjani
Retype password: gunungrinjani
pgAdmin 4 - Application Initialisation
======================================

Starting pgAdmin 4. Please navigate to http://192.168.5.2:5050 in your browser.
 * Serving Flask app 'pgadmin' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
```

The green script above is to activate the pgadmin application. Fill in the email according to the existing email and the password as desired.

In this article, `password` will be written as `gunungrinjani`.

After making sure the pgadmin application is active, open the Google Chrome, Yandex or Firefox web browser, in the address bar type `http://192.168.5.2:5050`.

With pgadmin, you can easily use the PostgreSQL database, because the display is in graphical or GUI form, making it easy for users to manage, modify, and run PostgreSQL.