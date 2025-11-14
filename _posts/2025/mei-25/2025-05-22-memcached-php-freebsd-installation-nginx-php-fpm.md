---
title: FreeBSD Memcached - Installing and Configuring Memcached With PHP
date: "2025-05-22 08:15:35 +0100"
updated: "2025-05-22 08:15:35 +0100"
id: memcached-php-freebsd-installation-nginx-php-fpm
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/memcached_infrastructure.jpg
toc: true
comments: true
published: true
excerpt: To overcome this, an in-memory database was developed that makes cached items available to website users in a very short time.
keywords: freebsd, php, php-fpm, nginx, website, database, mariadb, sql, mysql, installation
---

Memcached is often used in cases where you want to improve the performance of dynamic applications connected to a database. This in-memory database ensures, among other things, that data is retrieved from RAM without having to access the hard drive. Memcached is useful for lightening the load on the backend system and can also significantly reduce latency.

If you need to create large data samples such as the Comments/Best Articles column for daily or weekly, Directory Navigation menus, user profile data, etc.) or calculate in PHP some data that is not needed in real time, then the data needs to be cached. Memcached allows you to cache database queries from MySQL, MariaDB or other servers via PHP to reduce the load on the database.

Popular websites like YouTube, Facebook, Twitter, and Wikipedia have long used Memcached to reduce latency and database load. But how exactly does Memcached work and what are the first steps to implementing it?

The diagram below illustrates what your memcached infrastructure will look like when you implement memcached in your environment. You’ll notice that the memcached servers don’t communicate directly with your database servers. Instead, they live in their own pool and your application does all the work.

![memcached infrastructure](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/memcached_infrastructure.jpg)

In this article we will learn the installation procedure, configuration and how to use memcached on a FreeBSD 14.3 server.

## 1. System Specifications
- FreeBSD System: FreeBSD 14.3-PRERELEASE
- IP Address: 192.168.5.71
- Hostname: ns4
- PHP Version: PHP83
- Memcached Version: memcached 1.6.26
- NGINX Version: nginx/1.24.0
- Dependencies: php83-ctype, php83-mbstring, php83-extensions dan php83-mysqli, php-fpm, pecl-memcached

## 2. Why Memcached is Important
What is Memcached? The simplest answer to that question is that it is a high-performance caching system developed almost twenty years ago by Danga Interactive for the LiveJournal Internet portal. This cache server was created to prevent the slowdown caused by database access when using sophisticated web applications.

To overcome this, an in-memory database was developed that makes cached items available to website users in a very short time. Since Memcached is able to store data in RAM, all the information the user needs can be accessed much faster. Memcached software is very easy to use, install, and configure. Furthermore, since it runs under the BSD license, it can also be freely used, modified, and copied.

The main purpose of Memcached is to optimize application performance by reducing the load on the database server. Especially in applications that require a lot of reading, caching this data provides a significant advantage over accessing the same data repeatedly. In this way, the database server operates with less load and can concentrate on other important operations.

Some of the advantages and benefits of Memcached can be seen in the following table.

| Method       | Explanation          | Benefit        | 
| ----------- | -----------   | ----------- |
| Caching          | Temporary storage for frequently accessed data  | Reduce the load on the database and speed up response times   |
| Database Optimization          | Query and schema optimization.      | Faster query execution, lower resource consumption          |
| Load balancer          | Distribution of traffic between multiple servers.     | Maintains performance even in heavy traffic situations          |
| Data partitioning          | Splitting a large database into smaller parts  | Faster query processing, better scalability          |

In addition to having many advantages, Memcached also has many disadvantages. The following table explains some of the advantages and disadvantages of using Memcached.


| Advantages       | Disadvantages          | 
| ----------- | -----------   | 
| Multiprocess architecture enables vertical scalability of computing power.          | Data is not visible, making it difficult to debug.          | 
| Very short response time thanks to storing values ​​in memory          | It only stores data temporarily and loses data if the Memcached instance fails.      | 
| Supports open data formats and most common clients and programming languages.          | Non-redundant, meaning it does not duplicate or back up data to protect against failure.     | 
| Offers ease of use and flexibility for application development          | Lack of security mechanisms requires the use of additional firewalls  | 
| A mature open source solution with open data storage          | The value key length is limited to 250 characters (1 MB)  | 

## 3. Installation Process
In this process there are many dependencies that you have to install, because Memcached is used with PHP with NGINX, PHP or others. So there will be many PHP dependencies that you have to install.
### 3.1. Install PHP and PHP-FPM
In the section we will not discuss, to do this process you can read the previous article that explains the installation process. We assume you have activated PHP and PHP-FPM.
### 3.2. Install Memcached
In this process we will use the ports system to install Memcached. On FreeBSD Memcached ports are located in the /usr/ports/databases/memcached directory. Run the command below to start the Memcached installation process.

```
root@ns4:~ # cd /usr/ports/databases/memcached
root@ns4:/usr/ports/databases/memcached # make install clean
```


### 3.3. Enable Memcached to start automatically at boot.
To enable memcached to start automatically at boot, you must type the script in the /etc/rc.conf file. In addition to typing it directly, there is another alternative by running the sysrc command. This command is a command line utility that manages system services on a FreeBSD server. With the sysrc command you can directly enable memcached.

```
root@ns4:~ # sysrc memcached_enable="YES"
memcached_enable:  -> YES

root@ns4:~ # sysrc memcached_flags="-l 192.168.5.71 -p 11211 -m 128 -c 1024"
memcached_flags:  -> -l 192.168.5.71 -p 11211 -m 128 -c 1024
```

The above command is used to enable the memcached Server to Operation over TCP/IP Mode. If you want to enable memcached to # Memcached Server. UNIX socket mode, use the below command.

```
root@ns4:~ # sysrc memcached_enable="YES"
memcached_enable:  -> YES

root@ns4:~ # sysrc memcached_flags="-s /var/run/memcached/memcached.sock -a 700"
memcached_flags:  -> -s /var/run/memcached/memcached.sock -a 700
```

You can choose from the two methods above. In this article, we will activate memcached to TCP/IP mode, with IP 192.168.5.71 as the IP address of the FreeBSD server being used.

Below is a table of basic memcached startup parameters that you can use as a reference to activate memcached.

| Description       | Parameters and default values          | 
| ----------- | -----------   | 
| -s          | Path to socket. Runs in socket mode (TCP/IP doesn't work)          | 
| -a          | Socket access rights. The default value is 700.      | 
| -l          | The IP addresses that Memcached listens on. By default, all addresses     | 
| -p          | The port that Memcached listens on. The default is 11211 TCP.  | 
| -m          | Maximum object size, in megabytes. The default size is 64Mb.          | 
| -d          | Run as daemon          | 
| -c          | Maximum simultaneous connections, default is 1024.          | 

Once you have set everything according to the instructions above, run memcached with the service command.

```
root@ns4:~ # service memcached restart
```

If you have run memcached, check whether the memcached port 11212, which you have specified in the /etc/rc.conf file above, is open or not? Use the sockstat command to check the memcached port.

```
root@ns4:~ # sockstat -l | grep 11211
nobody   memcached  35145 16  tcp4   192.168.5.71:11211    *:*

root@ns4:~ # sockstat -4 | grep 11211
you have mail
nobody   memcached  80732 16  tcp4   192.168.5.71:11211    *:*
```

## 4. Connect Memcached to PHP
To connect memcached to PHP, an extension is needed as a connecting medium. By default memcached has provided the extension, you can install it directly.

There are two independent PHP PECL extensions to work with the Memcached server:
- Memcache, a lightweight extension with a minimal set of features for working with the server. Considered faster and more productive in operation.
- Memcached, an extension with a full set of features for use. Provides full capabilities for working with the Memcached server.

Below is an example of installing both memcached extensions.

```
### Method 1 ##

root@ns4:~ # cd /usr/ports/databases/pecl-memcache
root@ns4:/usr/ports/databases/pecl-memcache # make install clean
```

```
### Method 2 ##

root@ns4:~ # cd /usr/ports/databases/pecl-memcached
root@ns4:/usr/ports/databases/pecl-memcached # make install clean
```

Although these two extensions have slightly different syntax in some parameters, the way they are used is the same. In this article, we will use method 2, using PECL-Memcached.

Before we continue with the next configuration, let's take a moment to see the memcached and PHP versions used.

```
root@ns4:~ # memcached --version
memcached 1.6.26

root@ns4:~ # php -v
PHP 8.3.6 (cli) (built: May 15 2025 11:24:52) (ZTS)
```

## 5. Checking Memcached with PHP and NGINX
You can test the memcached installation above with various testing methods. memcached can be tested with basic FreeBSD shell commands or with PHP scripts.

### 5.1. Test memcached With Command Line
There are many command lines that you can use, in this article we will use command lines such as nc and telnet. First we test the memcached connection with the nc command.

```
root@ns4:~ # echo "stats settings" | nc 192.168.5.71 11211
```

If you want to use Telnet, run the following command.

```
root@ns4:~ # telnet 192.168.5.71 11211
Trying 192.168.5.71...
Connected to ns4.
Escape character is '^]'.
stats

quit
```

**Note:** If you are using Memcached with UDP support, the memcstat command will not be able to connect to the UDP port. You can use the following netcat command to verify connectivity.

```
root@ns4:~ # nc -u 192.168.5.71 11211 -vz
Connection to 192.168.5.71 11211 port [udp/*] succeeded!
```

### 5.2. Test memcached With PHP and NGINX
Memcached is generally used together with NGINX or Apache. Thanks to PHP support, memcached is able to serve many user requests at the same time. To test whether memcached has connected to the NGINX server, you create a PHP script.

Below are some examples of PHP scripts that you can use to test memcached. We will create PHP files named test1.php, test2.php and test3.php. We will save all these files in the /usr/local/www/nginx directory. Pay attention to the writing of the PHP script below.


```
### Contoh 1 (/usr/local/www/nginx/test1.php) ###

<?php
// Kelas Memcached
$cache = new Memcached();
// Menambahkan server Memcached dengan soket UNIX.
//$cache->addServer('/var/run/memcached/memcached.sock',0); //Port ditentukan sebagai 0
// Menambahkan Server Memcached dengan TCP/IP.
$cache->addServer('192.168.5.71',11211);

// Data uji untuk caching.
$data = 'Server Memcached sedang berjalan';

// Penyimpanan data dalam cache.
$cache->set('data_cache', $data, 15);
//data_cache - kunci, $data - data yang di-cache, 15 - data waktu disimpan dalam cache.

// Keluarkan data cache dari server Memcached dengan kunci 'data_cache' ke layar.
echo $cache->get('data_cache');
?>
```

```
### Contoh 2 (/usr/local/www/nginx/test2.php) ###

<?php
$cache = new Memcached();
//$cache->addServer('/var/run/memcached/memcached.sock',0);
$cache->addServer('192.168.5.71',11211);

$u_active = $cache->get('active_users');

// Jika tidak ada data di cache, gunakan kondisi berikut.
if (empty($u_active)){
$u_active = 'Selama menit terakhir, 1500 pengguna telah aktif.';
$cache->set('active_users', $u_active, 60);
echo 'Data di-cache.'."\n";
}
echo $u_active;
?>
```

```
### Contoh 3 (/usr/local/www/nginx/test3.php) ###

<?php
$memcache = new Memcached();
$memcache->addServer('192.168.5.71', 11211);
$memcache->setOption(Memcached::OPT_COMPRESSION, false);

// set and get a Key
$memcache->set('key01', 'value01');
print 'key01.value : ' . $memcache->get('key01') . "\n";

// append and get a Key
$memcache->append('key01', ',value02');
print 'key01.value : ' . $memcache->get('key01') . "\n";

$memcache->set('key02', 1);
print 'key02.value : ' . $memcache->get('key02') . "\n";

// increment
$memcache->increment('key02', 100);
print 'key02.value : ' . $memcache->get('key02') . "\n";

// decrement
$memcache->decrement('key02', 51);
print 'key02.value : ' . $memcache->get('key02') . "\n";

?>
```

You can run all three files with the command line or a web browser like Google Chrome. If you want to run the PHP file, use the php command, as in the following example.

```
root@ns4:~ # php /usr/local/www/nginx/test1.php
Server Memcached sedang berjalan
```

```
root@ns4:~ # php /usr/local/www/nginx/test2.php
Data di-cache.
Selama menit terakhir, 1500 pengguna telah aktif.
```

```
root@ns4:~ # php /usr/local/www/nginx/test3.php
key01.value : value01
key01.value : value01,value02
key02.value : 1
key02.value : 101
key02.value : 50
```

If you want to use Google Chrome on the "address bar" menu, type **"https://192.168.5.71/test1.php"**, **"https://192.168.5.71/test2.php"**, **"https://192.168.5.71/test3.php**. The results will be visible as shown in the following image.

![Test Memcached](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/FreeBSD_Memcached_-_Menginstal_dan_Mengkonfigurasi_Memcached_Dengan_PHP.jpg)

In this tutorial, we covered PHP Memcached usage, installation, and configuration in detail. Memcached is a powerful caching system that can help you improve the performance of your PHP and NGINX applications. Now, you can start using the PHP Memcached library in your projects to cache data and optimize your web applications.
