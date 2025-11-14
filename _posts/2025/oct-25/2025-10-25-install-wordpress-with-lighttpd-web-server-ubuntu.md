---
title: Install WordPress with Lighttpd Web Server on Ubuntu
date: "2025-10-25 19:52:26 +0100"
updated: "2025-10-25 19:52:26 +0100"
id: install-wordpress-with-lighttpd-web-server-ubuntu
lang: en
author: Iwan Setiawan
categories: linux
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-136.jpg
toc: true
comments: true
published: true
excerpt: Because Lighttpd will be used as a WordPress frontend server, it requires a number of dependencies. In addition to database server dependencies, PHP dependencies are also essential. In this article, we'll be using the MariaDB database.
keywords: database, mariadb, wordpress, server, mysql, lighttpd, query, linux, ubuntu, unix, http, https
---

For those of you or software developers looking for a lightweight and efficient web server, Lighttpd is an excellent choice. Lighttpd is a popular web server known for its high speed and lightweight design. Like Apache2, Lighttpd is easy to install and operate with PHP to run various web applications and content management systems like WordPress.

Lighttpd, or Lighty, is a high-performance web server created as a proof-of-concept for the c10k problem: "how to handle 10,000 parallel connections on a single server." Lighttpd is designed for speed, security, light weight, and flexibility. It uses minimal CPU and memory and offers advanced features like FastCGI, CGI, Auth, Compression, URL Rewriting, and more.

Wordpd, meanwhile, is a free and open-source content management system that allows you to create blogs and websites from a web-based interface. Installing WordPress with Lighttpd will improve your website's speed and performance.

In this post, we'll show you how to install WordPress with the Lighttpd web server on an Ubuntu server.

<br/>
<img alt="Install WordPress with Lighttpd web server" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-136.jpg' | relative_url }}">
<br/>


## A. Install Lighttpd

Before we start installing the Lighttpd web server, first run the update and upgrade commands, so that all Ubuntu repositories are at the latest version.

```yml
$ sudo apt update
$ sudo apt upgrade
```

After that, you can immediately continue by installing Lighttpd, with the following command.

```yml
$ sudo apt install lighttpd
```

### a. Enable and check the status of Lighttpd

To ensure that the web server automatically starts with system boot every time, we need to enable it. So, run the command below.

```yml
$ sudo systemctl enable lighttpd
```

### b. Check Lighttpd status

```yml
$ sudo systemctl status lighttpd
```
Now, please open the Google Chrome web browser, in the address bar menu, type the Lighttpd IP address, for example `"http://192.168.5.3"`.


## B. Install Lighttpd Dependencies

Because Lighttpd will be used as a WordPress frontend server, it requires a number of dependencies. In addition to database server dependencies, PHP dependencies are also essential. In this article, we'll be using the MariaDB database.

Before installing dependencies, ensure Apache has been removed from your Ubuntu server. You can use the following command to remove Apache.

```yml
$ apt-get remove apache2 -y
$ systemctl stop apache2
```

Below are the commands to install Lighttpd dependencies, such as MariaDB and PHP.

```yml
$ apt-get install mysql-server php php-fpm php-mysql php-cli php-curl php-xml php-json php-zip php-mbstring php-gd php-intl php-cgi -y
```

## C. PHP-FPM Configuration

Next, you need to configure `PHP-FPM` to work with Lighttpd. To do this, edit the www.conf file with the `nano command`.

```yml
$ nano /etc/php/7.4/fpm/pool.d/www.conf
```

Find the script below,

```yml
listen = /run/php/php7.4-fpm.sock
```

Then, you are against the following script.

```yml
listen = 127.0.0.1:9000
```

Save and close the file, then edit the `15-fastcgi-php.conf` file.

```yml
$ nano /etc/lighttpd/conf-available/15-fastcgi-php.conf
```

Find the script below

```yml
"bin-path" => "/usr/bin/php-cgi",
"socket" => "/var/run/lighttpd/php.socket",
```
and you replace it with the following script,

```yml
"host" => "127.0.0.1",
"port" => "9000",
```

Save and close the file, then enable the required modules with the following command.

```yml
$ lighty-enable-mod fastcgi
$ lighty-enable-mod fastcgi-php
```

The next step, you restart Lighttpd and PHP-FPM.

```yml
$ systemctl restart lighttpd
$ systemctl restart php7.4-fpm
```


## D. Create a MariaDB database for wordpress

In this article we do not cover the MariaDB installation process, so we will go straight to creating the database needed to run WordPress.

```yml
$ sudo mysql
CREATE DATABASE wpdb;
GRANT ALL PRIVILEGES on wpdb.* TO 'wpuser'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT;
```

## E. Install WordPress

In this section, we'll install WordPress, which we'll use to set up a CMS for the Lighttpd web server. Okay, let's get straight to installing WordPress.

```yml
$ cd /var/www/html
$ wget https://wordpress.org/latest.tar.gz
```

Since the WordPress file is in tar format, you must extract it first before using it.

```yml
$ tar -xvzf latest.tar.gz
```

Next, change the directory to WordPress and rename the configuration file as in the following example.

```yml
$ cd wordpress
$ mv wp-config-sample.php wp-config.php
```

Next, edit the main WordPress configuration file and specify the MariaDB database settings we created above.

```yml
$ nano wp-config.php
```

Find several scripts and change them like the following example.

```yml
/** The name of the database for WordPress */
define( 'DB_NAME', 'wpdb' );

/** MySQL database username */
define( 'DB_USER', 'wpuser' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );
```

Save and close the file, then set the proper permissions and ownership with the following commands.

```yml
$ chown -R www-data:www-data /var/www/html/wordpress
$ chmod -R 755 /var/www/html/wordpress
```

## F. Lighttpd Configuration For WordPress

The first step you have to do is create a directory to store the virtual host configuration files.

```yml
$ mkdir -p /etc/lighttpd/vhosts.d/
```

Next, edit the Lighttpd configuration file.

```yml
$ nano /etc/lighttpd/lighttpd.conf
```

Then, you add `mod_rewrite` in the file.

```yml
server.modules = (
        "mod_access",
        "mod_alias",
        "mod_compress",
        "mod_redirect",
        "mod_rewrite",
)
```

And don't forget to add the script below, to determine the path of your virtual host configuration directory.

```yml
include_shell "cat /etc/lighttpd/vhosts.d/*.conf"
```

Save and close the file. Then, create a new virtual host configuration file for WordPress.

```yml
$ nano /etc/lighttpd/vhosts.d/wordpress.conf
```

In the `wordpress.conf` file, you add the following script.

```yml
$HTTP["host"] =~ "(^|.)wordpress.example.com$" {
server.document-root = "/var/www/html/wordpress"
server.errorlog = "/var/log/lighttpd/wordpress-error.log"

}
```

After that, restart Lighttpd

```yml
$ systemctl restart lighttpd
```

## G. Open the Wordpress Dashboard

Once all the above configurations have been successfully executed and nothing has been missed, the next step is to open WordPress. To open WordPress with Lighttpd, open the Google Chrome web browser and type `"http://192.168.5.3/wp-admin/setup-config.php"`. If the configuration is correct, your screen will appear as shown below.

<br/>
<img alt="Open the WordPress Dashboard" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ '/img/oct-25/oct-25-135.jpg' | relative_url }}">
<br/>

If the image above appears, it means your WordPress is running properly and has connected to the Lighttpd web server. Next, simply follow the instructions displayed in each image in the Google Chrome browser.

Congratulations! You have successfully installed WordPress with Lighttpd on Ubuntu. You can now create high-performance websites or blogs from the WordPress dashboard on your dedicated server.