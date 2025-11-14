---
title: Configuring PHP FPM and Apache24 on FreeBSD 14
date: "2025-10-12 19:12:02 +0100"
updated: "2025-10-12 19:12:02 +0100"
id: install-setup-pm2-server-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-65.jpg
toc: true
comments: true
published: true
excerpt: Before you can run the PM2 application, make sure Node is installed on your FreeBSD server.js. The process manager pm2is available in the npm repository and must be installed globally on the system. Before you install PM2, make sure the library packages for node and npm are installed. The following are the library files that you must install.
keywords: configuration, apache, apache24, php, fpm, freebsd, freebsd14, pm2, npm, node js, node, java
---


Deployment is one of the most important and crucial stages in software development. A proper implementation strategy is essential to ensure the best user experience while using the service effectively. However, this process also brings a number of problems.

Node.js, which runs on the open source JavaScript runtime environment, is a popular choice for building your application's backend infrastructure. Node.js allows you to run JavaScript outside of a web browser. But what if your Node application fails, will js fail too?.

PM2, or Process Manager 2, is an open source application. PM2 is a production process manager for Node.js applications that allows you to quickly start, manage, and scale node processes, and keep your applications online. It is a built-in load balancer that implements automatic restarts in the event of a crash and machine restart. PM2 (currently version 4.5.6) is installed by default in Node.js containers.

To ensure the continuous health of the Node.the js server must either keep the console open at all times, or use the pm2 process manager. It has a built-in load balancer, allows you to monitor the resources consumed by running processes, automatically restart processes after a system failure, and so on.


## A. System specifications

- OS: FreeBSD 13.2
- IP Address: 192.168.5.2
- Domain: unixexplore.com
- Hostname: ns
- NPM version: 10.2.4
- Node version: v18.18.2
- PM2 version: 5.3.0



## B. Installing PM2

Before you can run the PM2 application, make sure Node is installed on your FreeBSD server.js. The process manager pm2is available in the npm repository and must be installed globally on the system. Before you install PM2, make sure the library packages for node and npm are installed. The following are the library files that you must install.

```
root@ns:~ # pkg install git scons-py39 python gcc gmake npm bash wget
```

Now, install pm2.

```
root@ns:~ # npm install -g npm-upgrade
root@ns:~ # npm install uuid@latest --force
root@ns:~ # npm audit fix --force
root@ns:~ # npm install -g pm2
```

Enable PM2 on the FreeBSD system.

```
root@ns:~ # pm2 startup freebsd
```
<br/>

```
root@ns:~ # service pm2_root restart
[PM2] Applying action deleteProcessId on app [all](ids: [ 0 ])
[PM2] [all](0) ✓
[PM2] [v] All Applications Stopped
[PM2] [v] PM2 Daemon Stopped
[PM2] Spawning PM2 daemon with pm2_home=/root/.pm2
[PM2] PM2 Successfully daemonized
[PM2] Resurrecting
[PM2] Restoring processes located in /root/.pm2/dump.pm2
[PM2] Process /tmp/googleapi/google-indexing-api-bulk/index.js restored
┌────┬──────────┬─────────────┬─────────┬─────────┬──────────┬────────┬──────┬───────────┬──────────┬──────────┬──────────┬──────────┐
│ id │ name     │ namespace   │ version │ mode    │ pid      │ uptime │ ↺    │ status    │ cpu      │ mem      │ user     │ watching │
├────┼──────────┼─────────────┼─────────┼─────────┼──────────┼────────┼──────┼───────────┼──────────┼──────────┼──────────┼──────────┤
│ 0  │ index    │ default     │ N/A     │ fork    │ N/A      │ 0s     │ 0    │ online    │ 0%       │ 0b       │ root     │ disabled │
└────┴──────────┴─────────────┴─────────┴─────────┴──────────┴────────┴──────┴───────────┴──────────┴──────────┴──────────┴──────────┘
root@ns:~ #
```


## C. Deploying a NODE JS Application Using PM2

So that our understanding of the use of PM2 is deeper. We'll try to learn the most commonly used PM2 features, and how to use them to deploy, manage, and scale your Node.js applications in production. In this article, we will explore the various functions of PM2 using a Node.js example application.

As a first step, you must be active as a root user and be in the `/root` folder. Let's start by cloning the app repository from Github.


```
root@ns:~ # git clone https://github.com/Tjatse/pm2-gui.git
root@ns:~ # cd pm2-gui
root@ns:~/pm2-gui # npm install exports express path axios morgan pug
root@ns:~/pm2-gui # npm install pm2-gui --production
root@ns:~/pm2-gui # npm install --production
```

Edit the `"/root/pm2-gui/pm2-gui.ini"` and change script `;  origins = 'example.com:* http://example.com:* http://www.example.com:8088'` with script 
`origins = '192.168.5.2:* http://192.168.5.2:* http://192.168.5.2:8088'`. Sign **";"** we remove or delete.

IP address `192.168.5.2` is the local IP of the FreeBSD server.


```
; origins = 'example.com:* http://example.com:* http://www.example.com:8088

Change

 origins = '192.168.5.2:* http://192.168.5.2:* http://192.168.5.2:8088
```

After that we run the application.


```
root@ns:~ # cd /root/pm2-gui
root@ns:~/pm2-gui # pm2 start pm2-gui.js
```

Open the Google Chrome web browser. In the address bar menu, type `"http://192.168.5.2:8088/"`. 


## D. Managing Applications

To list all running applications.


```
root@ns:~/pm2-gui # pm2 list
┌────┬────────────────────┬──────────┬──────┬───────────┬──────────┬──────────┐
│ id │ name               │ mode     │ ↺    │ status    │ cpu      │ memory   │
├────┼────────────────────┼──────────┼──────┼───────────┼──────────┼──────────┤
│ 0  │ index              │ fork     │ 1    │ online    │ 0%       │ 0b       │
│ 1  │ index              │ fork     │ 1    │ online    │ 0%       │ 0b       │
│ 2  │ pm2-gui            │ fork     │ 16   │ online    │ 0%       │ 0b       │
│ 3  │ pm2-gui            │ fork     │ 2    │ online    │ 0%       │ 0b       │
└────┴────────────────────┴──────────┴──────┴───────────┴──────────┴──────────┘
root@ns:~/pm2-gui #
```

Managing apps is straightforward.


```
root@ns:~/pm2-gui # pm2 start pm2-gui.js
root@ns:~/pm2-gui # pm2 stop pm2-gui.js
root@ns:~/pm2-gui # pm2 restart pm2-gui.js
```

To monitor logs, custom metrics, application information.


```
root@ns:~/pm2-gui # pm2 monit
```

Results from the `"pm2 monit"` script.


![pm2 monit](/img/oct-25/oct-25-65.jpg)


PM2 allows to monitor your host/server vitals with a monitoring speedbar. To enable host monitoring:


```
root@ns:~/pm2-gui # pm2 set pm2:sysmonit true
[PM2] Setting changed
Module: pm2
$ pm2 set pm2:sysmonit true
root@ns:~/pm2-gui # pm2 update
Be sure to have the latest version by doing `npm install pm2@latest -g` before doing this procedure.
[PM2] Applying action deleteProcessId on app [all](ids: [ 0, 1, 2, 3 ])
[PM2] [all](0) ✓
[PM2] [all](2) ✓
[PM2] [index](1) ✓
[PM2] [pm2-gui](3) ✓
[PM2] [v] All Applications Stopped
[PM2] [v] PM2 Daemon Stopped
[PM2] Spawning PM2 daemon with pm2_home=/root/.pm2
[PM2] Restoring processes located in /root/.pm2/dump.pm2
[PM2] Process /tmp/googleapi/google-indexing-api-bulk/index.js restored
[PM2] Process /tmp/ubuntuindex/IndexNode/Index2_OK_NODE/index.js restored
[PM2] Process /tmp/pm2-gui/pm2-gui.js restored
[PM2] Process /root/pm2-gui/pm2-gui.js restored
>>>>>>>>>> PM2 updated
[PM2][WARN] Applications pm2-sysmonit not running, starting...
[PM2] App [pm2-sysmonit] launched (1 instances)
┌────┬─────────────────┬─────────────┬─────────┬─────────┬──────────┬────────┬──────┬───────────┬──────────┬──────────┬──────────┬──────────┐
│ id │ name            │ namespace   │ version │ mode    │ pid      │ uptime │ ↺    │ status    │ cpu      │ mem      │ user     │ watching │
├────┼─────────────────┼─────────────┼─────────┼─────────┼──────────┼────────┼──────┼───────────┼──────────┼──────────┼──────────┼──────────┤
│ 0  │ index           │ default     │ N/A     │ fork    │ N/A      │ 0s     │ 0    │ online    │ 0%       │ 0b       │ root     │ disabled │
│ 1  │ index           │ default     │ 1.0.0   │ fork    │ 2332     │ 0s     │ 0    │ online    │ 0%       │ 0b       │ root     │ disabled │
│ 2  │ pm2-gui         │ default     │ N/A     │ fork    │ N/A      │ 0s     │ 0    │ online    │ 0%       │ 0b       │ root     │ disabled │
│ 3  │ pm2-gui         │ default     │ 0.1.4   │ fork    │ 2334     │ 0s     │ 0    │ online    │ 0%       │ 0b       │ root     │ disabled │
└────┴─────────────────┴─────────────┴─────────┴─────────┴──────────┴────────┴──────┴───────────┴──────────┴──────────┴──────────┴──────────┘
root@ns:~/pm2-gui #
```

In this article, we successfully completed Node deployment.js for hosting with FreeBSD. Projects run smoothly and are updated automatically whenever changes are made. However, this is a very simple Node.js use case. Very suitable for school and training project applications.

When deploying, you may also need additional configuration, such as installing an OpenSSL certificate or changing the Apache configuration. The final list of actions that need to be performed to deploy an application in production depends on the stack used, what dependencies and connections it has  database, web server and automation utilities.