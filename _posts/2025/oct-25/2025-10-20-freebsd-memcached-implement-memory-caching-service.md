---
title: Playing around with FreeBSD Memcached How to implement an in-memory data caching service
date: "2025-10-20 07:09:10 +0100"
updated: "2025-10-20 07:09:10 +0100"
id: freebsd-memcached-implement-memory-caching-service
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/oct-25/oct-25-118.jpg
toc: true
comments: true
published: true
excerpt: This Memcached tutorial explains how to install and use Memcached on a FreeBSD server. This tutorial is great for those new to FreeBSD and looking to improve website performance.
keywords: freebsd, kernel memory, memcached, memcache, caching, service, implement, nextcloud, wordpress, drupal
---


In 2003, while working at LiveJournal, Brad Fitzpatrick successfully created Memcached. The initial idea for Memcached came from Fitzpatrick's struggles with slow database queries. Fitzpatrick needed a way to improve the performance of the websites he was working on.

He successfully developed Memcached as a caching layer placed between the database and the web application, allowing frequently accessed data to be stored in memory and retrieved quickly.

Memcached was originally written in Perl and later rewritten in C. Memcached has a backend whose sole task is to store key values ​​in memory. The application is very simple, and large companies like Netflix, Wikipedia, and Facebook have used Memcached to improve the performance of their websites.

Memcached is a free, open-source, high-performance distributed memory object caching system. In dynamic web applications, using Memcached can reduce database load and improve site performance.

Memcached's design allows it to cache data in server memory, thereby speeding up website access times. This makes it an ideal choice for applications that need to store and retrieve large amounts of data quickly.

Therefore, it's no surprise that many large companies use Memcached as a fast and efficient caching solution that can reduce the time it takes for a website or application to retrieve data from the database.

Memcached can take memory from parts of the system with large amounts of memory and access areas with less memory than necessary. Memcached can also make better use of memory capacity. See the diagram below, which implements two Memcached scenarios.

1. Each node is completely independent (top).
2. Each node can use the memory of other nodes (bottom).

<br/>

![FreeBSD Memcached](/img/oct-25/oct-25-118.jpg)

<br/>


This Memcached tutorial explains how to install and use Memcached on a FreeBSD server. This tutorial is great for those new to FreeBSD and looking to improve website performance.

## 1. How to Install Memcached

Memcached is an in-memory key-value data store that runs on macOS, BSD, and Linux. In this section, you'll install Memcached on FreeBSD via the PKG package manager or the Ports system.

To install Memcached on FreeBSD, first run the command below to update the FreeBSD PKG package index and then install the Memcached dependencies.


```
proot@ns3:~ # pkg update -f
proot@ns3:~ # pkg upgrade -f
```

<br/>

```
root@ns3:~ # root@ns3:~ # pkg install cyrus-sasl libevent rfc libxml2 libmemcached php82-pecl-memcached msgpack-c php82-pecl-msgpack
```

Run the port command below and install the memcached package on FreeBSD with `make install clean`.


```sh
root@ns3:~ # cd /usr/ports/databases/memcached
root@ns3:/usr/ports/databases/memcached # make install clean
```

After the installation process is complete, you run the command below to activate the Memcached service, so that it can run automatically, namely by adding several Memcached scripts.


```
root@ns3:/usr/ports/databases/memcached # ee /etc/rc.conf
memcached_enable="YES"
memcached_user="nobody"
memcached_group="nobody"
memcached_flags="-l 192.168.5.2 -d -U 0 -m 512 -c 2048"
```

Memcached flag options used:

- **-l** = 192.168.5.80: Run the memcached service on IP address 192.168.5.2
- **-U 0** = Disable memcached on UDP ports.
- **-d** = Run memcached in the background.
- **-c** = 2048: Set the maximum connections to 2048.
- **-m** = Set maximum memory to 512 MB.

You can check the Memcached service you have created above.

```
root@ns3:/usr/ports/databases/memcached # sysrc -a | grep memcached
memcached_enable: YES
memcached_flags: -l 192.168.5.2 -d -U 0 -m 512 -c 2048
memcached_group: nobody
memcached_user: nobody
```

Once you have configured memcached, start Memcached with the service command.


```sh
root@ns3:~ # service memcached restart
root@ns3:~ # service memcached status
```

On FreeBSD by default Memcached runs on port 1121, run the sockstat command to verify memcached port 1121.


```
root@ns3:~ # sockstat -4 | grep 11211
nobody   memcached  42237 16 tcp4   192.168.5.2:11211     *:*
```

## 2. Testing Memcached Connection

Now that Memcached is installed on your FreeBSD server and running normally, verify Memcached using the Memcached tool and the Netcat utility. The Memcached tool is a Perl-based application for checking statistics and managing Memcached, included in the Memcached package.

You don't need to install the tool; it's installed automatically when you install Memcached. Use the following commands to test and verify Memcached using the Memcached tool.


```sh
root@ns3:~ # memcached-tool 192.168.5.2 settings
```

You can also check memcached statistics, such as current read and write statistics, connection statistics, and also authentication statistics.

```sh
root@ns3:~ # memcached-tool 192.168.5.2 stats
```

Besides using the above commands, you can also verify memcached statistics via the netcat or nc commands as in the following example.

```
root@ns3:~ # echo stats | nc 192.168.5.2 11211
```

## 3. Testing With PHP pecl-memcache

After verifying that the Memcached connection is working properly on FeeeBSD, you can also perform a Memcached test using PHP. This test ensures that applications running PHP, such as WordPress, Joomla, Drupal, and other websites, can connect to Memcached.

In PHP, there are two independent PECL PHP extensions for working with Memcached servers:

- **Memcache,** a very lightweight extension with minimal features, is known for its speed and productivity.
- **Memcached,** a fully featured extension, providing full capabilities for working with Memcached servers. This extension has slightly different syntax for some parameters.

In this article, we'll be using the PECL-Memcached extension syntax. Before starting the test, first install pecl-memcache by following the command below.

```
root@ns3:~ # cd /usr/ports/databases/pecl-memcache
root@ns3:/usr/ports/databases/pecl-memcache # make install clean
```

With the command in the console you can check whether the PECL-Memcached extension is installed in PHP.

```php
root@ns3:~ # php -i | grep memcached
/usr/local/etc/php/ext-30-memcached.ini,
memcached
memcached support => enabled
libmemcached-awesome version => 1.1.4
memcached.compression_factor => 1.3 => 1.3
memcached.compression_threshold => 2000 => 2000
memcached.compression_type => fastlz => fastlz
memcached.default_binary_protocol => Off => Off
memcached.default_connect_timeout => 0 => 0
memcached.default_consistent_hash => Off => Off
memcached.serializer => php => php
memcached.sess_binary_protocol => On => On
memcached.sess_connect_timeout => 0 => 0
memcached.sess_consistent_hash => On => On
memcached.sess_consistent_hash_type => ketama => ketama
memcached.sess_lock_expire => 0 => 0
memcached.sess_lock_max_wait => not set => not set
memcached.sess_lock_retries => 5 => 5
memcached.sess_lock_wait => not set => not set
memcached.sess_lock_wait_max => 150 => 150
memcached.sess_lock_wait_min => 150 => 150
memcached.sess_locking => On => On
memcached.sess_number_of_replicas => 0 => 0
memcached.sess_persistent => Off => Off
memcached.sess_prefix => memc.sess.key. => memc.sess.key.
memcached.sess_randomize_replica_read => Off => Off
memcached.sess_remove_failed_servers => Off => Off
memcached.sess_sasl_password => no value => no value
memcached.sess_sasl_username => no value => no value
memcached.sess_server_failure_limit => 0 => 0
memcached.store_retry_count => 0 => 0
Registered save handlers => files user memcache memcached
```

Now we will check the Memcached server operation with PHP scripts. Create a PHP file and write the script, then run it.

```
root@ns3:~ # cd /usr/local/www/apache24/data
root@ns3:/usr/local/www/apache24/data # ee test.php
<?php
$memcache = new Memcache;
$memcache->connect('192.168.5.2', 11211) or die ("Could not connect");

$version = $memcache->getVersion();
echo "Server's version: ".$version."
\n";

$tmp_object = new stdClass;
$tmp_object->str_attr = 'test';
$tmp_object->int_attr = 123;

$memcache->set('key', $tmp_object, false, 10) or die ("Failed to save data at the server");
echo "Store data in the cache (data will expire in 10 seconds)
\n";

$get_result = $memcache->get('key');
echo "Data from the cache:
\n";

var_dump($get_result);
?>
```

<br/>

```
root@ns3:/usr/local/www/apache24/data # php test.php
```

Another example, write the following script.

```
root@ns3:/usr/local/www/apache24/data # ee test2.php
<?php
	
	$memcache = new Memcache;
	$memcache->connect('192.168.5.2', 11211) or die ("Can't connect");
	
	$time_start = microtime(true);
	
	for($i=0;$i<1000000;$i++) {
		$memcache->set('key' . $i, 'MyTestString', false, 3600) or die ("Storing error");
	}
	
	echo "Wrire: " . ( microtime(true) - $time_start ) . " seconds\n";
	
	$time_start = microtime(true);
	
	for($i=0;$i<1000000;$i++) {
		$get_result = $memcache->get('key' . $i);
	}
	
	echo "Read: " . ( microtime(true) - $time_start ) . " seconds\n";
	
?>
```

Memcached commands are simple yet powerful. Their simple design means they run quickly, simplify development, and solve many of the problems facing large data caches. Memcached APIs are also available for most popular languages, including Go and Python.