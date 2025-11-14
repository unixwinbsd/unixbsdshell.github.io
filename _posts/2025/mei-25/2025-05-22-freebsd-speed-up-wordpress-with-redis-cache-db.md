---
title: FreeBSD Installation to Speed ​​Up WordPress Site with Redis Cache
date: "2025-05-22 19:11:15 +0100"
updated: "2025-10-20 08:09:10 +0100"
id: freebsd-speed-up-wordpress-with-redis-cache-db
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-117.jpg
toc: true
comments: true
published: true
excerpt: It is important to understand that object caching is different from regular HTML content caching. WP Fastest Cache, WP-Rocket, LiteSpeed ​​Cache, and other caching plugins can improve site loading speed by storing static copies of HTML pages and bypassing PHP code execution. Redis caches database content, minimizing the number of requests and bypassing the need to access the database directly.
keywords: freebsd, redis, cache, cache db, speed up, wordpress, speed, wp cli, apache, nginx
---

Redis is a data structure stored in a computer's memory. Redis stores all data in a dictionary format, where keys are associated with their values. This technology is a great solution for speeding up and optimizing WordPress-powered sites. Caching improves performance by storing data, code, and other objects in memory.

Object caching can significantly improve the performance of your WordPress site, but not all sites can be accelerated with it. In this article, we'll try to understand under what conditions Redis is applicable and useful for WordPress, and under what circumstances it shouldn't be used. We'll also understand how it works, how to install, and configure it.

For this tutorial, we'll use a FreeBSD server. It's robust and reliable for handling demanding tasks.

<br/>

![Redis Cache Db](/img/oct-25/oct-25-117.jpg)

<br/>

## A. What is Redis Object Cache?
It's important to understand that object caching is different from regular HTML content caching. WP Fastest Cache, WP-Rocket, LiteSpeed ​​Cache, and other caching plugins can improve site loading speed by storing static copies of HTML pages and bypassing PHP code execution. Redis caches database content, minimizing the number of requests and bypassing the need to access the database directly.

Memcached is also a popular caching option. However, Redis currently does everything Memcached can do, with a much larger and more advanced feature set. This Stack Overflow page provides some general information as an overview or introduction for those new to Redis.

When a WordPress page is first loaded, a database query is executed on the server. Redis remembers or caches that query. This way, when another user loads the WordPress page, the results are served from Redis and from memory without having to query the database. The Redis implementation used in this tutorial acts as a persistent object cache for WordPress (without an expiration date). The object cache works by storing the SQL queries in memory required to load the WordPress page.

When the page loads, the resulting SQL query results are served to Redis from memory, eliminating the need for the query to go to the database. The result is significantly faster page load times and less server impact on database resources. If a query is not available in Redis, the database returns the result, and Redis adds the result to its cache.

To start studying this article, we recommend that you read our previous articles:

[Configuring PHP FPM and Apache24 on FreeBSD](https://unixwinbsd.site/freebsd/setup-php-fpm-apache-freebsd/)


## B. WP-CLI
WP-CLI is a command-line interface for managing your WordPress website. This interface allows you to manage your WordPress site using commands that can be entered on the command line. This means you can manage your site without having to log in to the WordPress admin panel. WP-CLI is a useful tool for developers who want to quickly complete tasks on their websites.

WP-CLI is a command-line tool, so to use it, you need command-line access on your server. To start using WP-CLI, you need to install it on your server. You can install WP-CLI through Composer or download it from the official WP-CLI website.

Once you've installed WP-CLI, you can start using it to manage your site. This tool is incredibly convenient because:

- First, it allows you to quickly complete tasks that would take much longer in the WordPress admin area, such as updating plugins or creating random posts.
- Second, it contains commands that have no alternative in the WordPress admin panel, such as exporting the database or clearing the transit cache.

Once you have finished installing WordPress, download the wp-cli.phar file using wget or curl.

```sh
root@ns:~ # pkg install php82-phar
root@ns:~ # wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
root@ns:~ # chmod +x wp-cli.phar
root@ns:~ # cp -R wp-cli.phar /usr/local/bin/wp
```

If WP-CLI is successfully installed, the output will look like this when running `"wp --info"`.

```sh
root@ns:~ # wp --info
OS:     FreeBSD 13.2-RELEASE FreeBSD 13.2-RELEASE releng/13.2-n254617-525ecfdad597 GENERIC amd64
Shell:  /bin/csh
PHP binary:     /usr/local/bin/php
PHP version:    8.2.11
php.ini used:   /usr/local/etc/php.ini
MySQL binary:   /usr/local/bin/mysql
MySQL version:  mysql  Ver 8.0.33 for FreeBSD13.2 on amd64 (Source distribution)
SQL modes:
WP-CLI root dir:        phar://wp-cli.phar/vendor/wp-cli/wp-cli
WP-CLI vendor dir:      phar://wp-cli.phar/vendor
WP_CLI phar path:       /root
WP-CLI packages dir:
WP-CLI cache dir:       /root/.wp-cli/cache
WP-CLI global config:
WP-CLI project config:
WP-CLI version: 2.9.0
```

Proceed with updating wp-cli.

```sh
root@ns:~ # wp cli update
Success: WP-CLI is at the latest version.
```

## C. Redis Object Cache Configuration
The first step is to install the Redis library. This extension provides an API for communicating with the Redis database.

```sh
root@ns:~ # cd /usr/ports/databases/pecl-redis && make install clean
root@ns:/usr/ports/databases/pecl-redis # pkg install php82-pecl-redis
```

And now we can safely proceed to installing and configuring the Redis Cache plugin for WordPress. Let me remind you that object caching stores the results of requested database queries. Then, on subsequent calls (requests), it serves them faster than re-querying and re-creating them from the database, which naturally improves performance.

The main requirement for installing the Redis Object Cache plugin in WordPress is that our server computer must have Redis installed. Please see the previous article on [installing Redis on FreeBSD](https://unixwinbsd.site/openbsd/how-to-install-redis-cache-openbsd).

By default, the object caching plugin connects to the Redis server over TCP port 127.0.0.1:6379 and uses a database with key 0. To avoid conflicts with other sites, you need to configure the plugin by changing the constant in the file to "/usr/local/www/wordpresswp-config.php". Type the script below into the file.


```php
// adjust Redis host and port if necessary 
define( 'WP_REDIS_HOST', '127.0.0.1' );
define( 'WP_REDIS_PORT', 6379 );

// change the prefix and database for each site to avoid cache data collisions
define( 'WP_REDIS_DATABASE', 0 ); // 0-15

// reasonable connection and read+write timeouts
define( 'WP_REDIS_TIMEOUT', 1 );
define( 'WP_REDIS_READ_TIMEOUT', 1 );
define( 'WP_REDIS_PASSWORD', 'gunungrinjani' );

/* That's all, stop editing! Happy publishing. */
require_once(ABSPATH . 'wp-settings.php');
```


Use WP-CLI commands to activate the Redis Object Cache plugin.

```sh
root@ns:~ # wp --path='/usr/local/www/wordpress/' plugin install redis-cache --activate --allow-root
Warning: redis-cache: Plugin already installed.
Activating 'redis-cache'...
Plugin 'redis-cache' activated.
Success: Plugin already installed.
```
<br/>

```sh
root@ns:~ # wp --path='/usr/local/www/wordpress/' redis enable --allow-root
root@ns:~ # wp --path='/usr/local/www/wordpress/' redis update-dropin --allow-root
```

That's it. WordPress will automatically use Redis caching when it detects the `object-cache.php` file. To ensure it's working properly, run $ redis-cli monitor and refresh the page (while still logged in). 

You'll see a Redis activity log with the installed and accepted keys.

Now, every time your web server receives a database request, it will return the cached data directly from RAM to save resources. If the requested data isn't cached through Redis, the web server will fetch and process it from the database as usual. This way, Redis caching significantly reduces server load and makes your site run faster.
