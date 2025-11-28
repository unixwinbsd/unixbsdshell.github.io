---
title: Update Drupal With Drush CLI and Composer PHP On FreeBSD
date: "2025-10-04 07:37:39 +0100"
updated: "2025-10-04 07:37:39 +0100"
id: drupal-with-drush-cli-composer-php-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-59.png
toc: true
comments: true
published: true
excerpt: In this article we try to explain the Drupal update process using the Drush CLI and Composer. Usually we carry out this update process after installing Drupal.
keywords: installation, drush, drupal, cli, http, api, commannd, freebsd, php, composer, laravel
---



One of the reasons why Drupal is the favorite CMS in the world is the community's quick response to the shortcomings and weaknesses of a version so that they can be repaired more quickly by the Drupal community or developers. Between one version and another, there are usually unique additional features that attract users or developers to explore further.

The update or upgrade process requires careful consideration, but the important thing is that the goal of both (update/upgrade) must be achieved with good and maximum results. It is also necessary to ask what the purpose of the process is. Whether to increase Drupal performance, improve security or just switch versions. If the reason is for security reasons then it is very mandatory for a Drupal website developer to update to the recommended or safer version.

In our opinion, the Drupal update process must still be carried out, why? because, when you first install Drupal, usually many menus cannot be used, only the admin menu runs normally, while the other menus need to be updated.

In this article we try to explain the Drupal update process using the Drush CLI and Composer. Usually we carry out this update process after installing Drupal.

![oct-25-59](/img/oct-25/oct-25-59.png)



## 1. System Specifications

OS: FreeBSD 13.2
- Drupal version: Drupal 10.0.0
- Drush version: Drush 12.4.3.0
- Apache version: apache24-2.4.58_1
- PHP cersion: php82-8.2.14
- PHP-FPM
- MySQL-Server version: mysql80-server-8.0.35


## 2. Drupal Update Process

Before you update Drupal, first check the Drupal version, so that the update process can be seen whether it was successful or not. Use the "drush status" command to see which versions of Drupal and Drush are active on your FreeBSD server.

```console
root@ns3:~ # drush status
Drupal version   : 10.0.0
Site URI         : http://default
DB driver        : mysql
DB hostname      : localhost
DB port          : 3306
DB username      : userdrupal
DB name          : drupal
Database         : Connected
Drupal bootstrap : Successful
Default theme    : olivero
Admin theme      : claro
PHP binary       : /usr/local/bin/php
PHP config       : /usr/local/etc/php.ini
PHP OS           : FreeBSD
PHP version      : 8.2.14
Drush script     : /usr/local/www/drupal10/vendor/bin/drush
Drush version    : 12.4.3.0
Drush temp       : /tmp
Drush configs    : /usr/local/www/drupal10/vendor/drush/drush/drush.yml
                   /usr/local/www/drupal10/drush/drush.yml
Install profile  : standard
Drupal root      : /usr/local/www/drupal10
Site path        : sites/default
Files, Public    : sites/default/files
Files, Temp      : /tmp
```

We will update Drupal version 10.0.0 to version 10.2.2. Follow the guide below which will update Drupal to the latest version.

  <script type="text/javascript">
	atOptions = {
		'key' : '88e2ead0fd62d24dc3871c471a86374c',
		'format' : 'iframe',
		'height' : 250,
		'width' : 300,
		'params' : {}
	};
</script>
<script type="text/javascript" src="//www.highperformanceformat.com/88e2ead0fd62d24dc3871c471a86374c/invoke.js"></script>

### 2.1. Update Drupal Database

As we know, all Drupal data is stored on the MySQL database server. The first step you have to do is update the Drupal database with the command below.

```yml
root@ns3:~ # drush updatedb
root@ns3:~ # drush cache:rebuild
root@ns3:~ # drush config:export --diff
```

Apart from using the drush command above, you can also update the database with a web browser. Type the following command in Google Chrome `"http://192.168.5.2/drupal/update.php"`.


### 2.2. Backup Drupal Database

Before you update Drupal, make a habit of always doing a `"backup"` first. This backup file really helps you if an error occurs during the update process. Follow these steps to backup a Drupal database.

```yml
root@ns3:~ # drush sql:dump --debug
root@ns3:~ # drush archive-dump --exclude-code-paths=sites/default/settings.php --debug
```

After that, you have to activate maintenance mode, the goal is that all your Drupal website data cannot be opened temporarily.

```yml
root@ns3:~ # drush state:set system.maintenance_mode 1
```

The final step is to do the `"rebuild cache"` command.

```yml
root@ns3:~ # drush cache:rebuild
```

### 2.3. Update With Composer PHP

After the Drupal database has been updated and backed up, you can continue with the update process. Use composer to carry out the Drupal update process.

```yml
root@ns3:~ # cd /usr/local/www/drupal10
root@ns3:/usr/local/www/drupal10 # composer update "drupal/core-*" --with-all-dependencies
```

Next, you update the Drupal database again then clear the cache.

```yml
root@ns3:/usr/local/www/drupal10 # drush updatedb
root@ns3:/usr/local/www/drupal10 # drush cache:rebuild
```

If you use configuration management to deploy Drupal configurations, be sure to export the configuration. Run the following command to export the configuration.

```yml
root@ns3:/usr/local/www/drupal10 # drush config:export --diff
```

After you have carried out all the processes above, normalize your Drupal website again with the following command.

```yml
root@ns3:/usr/local/www/drupal10 # drush state:set system.maintenance_mode 0
root@ns3:/usr/local/www/drupal10 # drush cache:rebuild
```

Before you see the results, run the following command.

```yml
root@ns3:/usr/local/www/drupal10 # composer install --no-dev
```

Nach, now let's see the results of all the commands you have done above. Run the command `"drush staus"`, have you succeeded in changing the Drupal version?.

```yml
root@ns3:/usr/local/www/drupal10 # drush status
```


Drupal is a CMS that can be customized for various needs and used to create all types of websites. Drupal supports various modules and themes to simplify the web development process and increase its functionality. By updating Drupal to a higher version, you will experience all the benefits of Drupal features.
