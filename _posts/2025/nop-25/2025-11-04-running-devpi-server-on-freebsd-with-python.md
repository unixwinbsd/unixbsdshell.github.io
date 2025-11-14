---
title: Running DEVPI Server on FreeBSD with the PyPI Private Python Package
date: "2025-11-04 07:55:41 +0100"
updated: "2025-11-04 07:55:41 +0100"
id: running-devpi-server-on-freebsd-with-python
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-007.jpg
toc: true
comments: true
published: true
excerpt: In this tutorial, we'll create a mirror using PyPI, a Python platform for fetching and downloading Python packages.
keywords: devpi, server, freebsd, mysql, pypi, php, python, venv, pip, package, private, apache24, bsd, linux
---

DevPI is a server written in Python, making it highly compatible with PyPI. Because DevPI is written in Python, you can run it locally or install it on a personal server like FreeBSD. Simplicity and ease of use are among DevPI's strengths, so it's no surprise that the installation process is straightforward.

DevPi is released with three Python packages:
1. devpi-server
As a caching proxy for PyPI. The DevPI server is capable of serving a consistent caching index for pypi.python.org as well as a local, GitHub-style overlay index. Once you have a DevPI pypi package, it will never be changed and will never be modified.
2. devpi-web
One of the devpi-server plugins that provides a web interface and search. With DevPI Web, you can easily search your local package directory.
3. devpi-client
One of DevPI's command-line features, with subcommands for creating users, using indexes, uploading and installing from indexes, and a "test" command for running tox. The DevPI client is indispensable for more esoteric use cases.

<br/>
<img alt="python DevPI server on freebsd" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-007.jpg' | relative_url }}">
<br/>

In this tutorial, we'll create a mirror using PyPI, a Python platform for fetching and downloading Python packages. PyPI mirrors are especially useful if you want a copy of PyPI for personal or internal use. Website mirroring refers to the concept of replicating or copying a website or any network node for a specific purpose.

- Ensure the availability of the original site.
- Provide real-time backups of the original site.
- Reduce network traffic.
- Increase access speed.

To accomplish this, we'll use a package called DevPi. Installing and running DevPI is very easy on FreeBSD. To get started, you'll need to run a Python virtual environment.

## 👨‍💻 1. Creating a Python Venv

As we know, FreeBSD has a large number of Python packages in its repositories. To avoid version differences and other issues, FreeBSD users are required to install Python packages in a virtual environment.

This aims to isolate each installed package from being linked to other Python packages. Below, we will explain how to install a Python virtual environment (venv) on FreeBSD.

```yml
root@ns3:~ # mkdir -p /var/venv
root@ns3:~ # cd /var/venv
root@ns3:/var/venv # python -m venv devpi
```

After that, you activate the Python virtual environment.

```yml
root@ns3:/var/venv # cd devpi
root@ns3:/var/venv/devpi # source bin/activate.csh
(devpi) root@ns3:/var/venv/devpi #
```

By running the command above, you've activated the Python venv. Then, run the pip upgrade command.

```yml
(devpi) root@ns3:/var/venv/devpi # pip install --upgrade pip
```

## 👨‍💻 2. How to Install the DevPI Server

In this section, we'll install and run the DevPI server to serve an automatically and efficiently updated PyPI mirror cache on your FreeBSD server. The DevPI server uses SQLite to store its data. On FreeBSD, you don't need to install SQLite, as it's installed automatically. Okay, let's get started installing `devpi-server, devpi-client, and devpi-web`.

```yml
(devpi) root@ns3:/var/venv/devpi # pip install -q -U devpi-server devpi-web devpi-client
```

After that, check the DevPI version of the server you are using with the following command.

```yml
(devpi) root@ns3:/var/venv/devpi # devpi-server --version
6.10.0
```

The next step is to initialize the devpi server.

```yml
(devpi) root@ns3:/var/venv/devpi # devpi-init --serverdir /root/.devpi/server
```

## 👨‍💻 3. Create pip.conf

On FreeBSD, the pip configuration file for the DevPI server is located in the Python virtual environment, `/var/venv/devpi`. The location of the `pip.conf` file varies across operating systems.

The pip.conf file can be used to define configuration and environment variables for pip, such as:

- command-line options.
- environment variables.
- configuration files.

pip has three levels of configuration files:

- **global:** system-wide configuration file, shared across all users.
- **user:** per-user configuration file.
- **site:** per-environment configuration file; i.e., per-virtualenv.

Additionally, on DevPI servers, the pip.conf file can be used to avoid retyping the index URL with pip or easy-install. You can benefit from the pip.conf file when installing applications with the pip command.

Below is an example of a pip.conf file configuration script.

```console
(devpi) root@ns3:/var/venv/devpi # touch pip.conf
(devpi) root@ns3:/var/venv/devpi # ee pip.conf
[global]
index-url = http://192.168.5.2:3141/root/pypi/+simple/

[search]
index = http://192.168.5.2:3141/root/pypi/

[install]
Trusted-host = 192.168.5.2
```

After that, create a `.pydistutils.cfg` file to configure `easy_install`. Add the script below to the `.pydistutils.cfg` file.

```yml
(devpi) root@ns3:/var/venv/devpi # touch .pydistutils.cfg
(devpi) root@ns3:/var/venv/devpi # ee .pydistutils.cfg
[easy_install]
index_url = http://192.168.5.2:3141/root/pypi/+simple/
```

## 👨‍💻 4. Enable the DevPI Server with Python Supervisor

Since the DevPI server is written in Python and runs in a Python virtual environment, to enable the DevPI server daemon to run in the background on FreeBSD, we use Python Supervisor. If you are still in the Python virtual environment, exit the Python VENV and install Python Supervisor.

```yml
(devpi) root@ns3:/var/venv/devpi # deactivate
root@ns3:/var/venv/devpi # pkg install py39-supervisor
```

Next, create a `rc.d` script to run Python watchdog automatically. Add the following script to your `/etc/rc.conf` file.

```console
root@ns3:/var/venv/devpi # ee /etc/rc.conf
supervisord_enable="YES"
supervisord_config="/usr/local/etc/supervisord.conf"
supervisord_user="root"
```

Then, open the `supervisord.conf` file, delete all the scripts and replace them with the scripts below.

```console
root@ns3:/var/venv/devpi # cd /usr/local/etc
root@ns3:/usr/local/etc # ee supervisord.conf
[unix_http_server]
file=/var/run/supervisor/supervisor.sock   ; the path to the socket file
;chmod=0700                 ; socket file mode (default 0700)
;chown=nobody:nogroup       ; socket file uid:gid owner
;username=user              ; default is no username (open server)
;password=123               ; default is no password (open server)

;[inet_http_server]         ; inet (TCP) server disabled by default
;port=127.0.0.1:9001        ; ip_address:port specifier, *:port for all iface
;username=user              ; default is no username (open server)
;password=123               ; default is no password (open server)

[supervisord]
logfile=/var/log/supervisord.log ; main log file; default $CWD/supervisord.log
logfile_maxbytes=50MB        ; max main logfile bytes b4 rotation; default 50MB
logfile_backups=10           ; # of main logfile backups; 0 means none, default 10
loglevel=info                ; log level; default info; others: debug,warn,trace
pidfile=/var/run/supervisor/supervisord.pid ; supervisord pidfile; default supervisord.pid
nodaemon=false               ; start in foreground if true; default false
silent=false                 ; no logs to stdout if true; default false
minfds=1024                  ; min. avail startup file descriptors; default 1024
minprocs=200                 ; min. avail process descriptors;default 200
;umask=022                   ; process file creation umask; default 022
;user=supervisord            ; setuid to this UNIX account at startup; recommended if root
;identifier=supervisor       ; supervisord identifier, default is 'supervisor'
;directory=/tmp              ; default is not to cd during start
;nocleanup=true              ; don't clean up tempfiles at start; default false
;childlogdir=/tmp            ; 'AUTO' child log dir, default $TEMP
;environment=KEY="value"     ; key value pairs to add to environment
;strip_ansi=false            ; strip ansi escape codes in logs; def. false

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor/supervisor.sock ; use a unix:// URL  for a unix socket
;serverurl=http://127.0.0.1:9001 ; use an http:// url to specify an inet socket
;username=chris              ; should be same as in [*_http_server] if set
;password=123                ; should be same as in [*_http_server] if set
;prompt=mysupervisor         ; cmd line prompt (default "supervisor")
;history_file=~/.sc_history  ; use readline history if available

[program:devpi]
command=/usr/local/bin/devpi-server  --port 3141 --host 192.168.5.2 --serverdir /root/.devpi/server              ; the program (relative uses PATH, can take args)
;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
;numprocs=1                    ; number of processes copies to start (def 1)
directory=/root/.devpi                ; directory to cwd to before exec (def no cwd)
;umask=022                     ; umask for process (default None)
;priority=999                  ; the relative start priority (default 999)
autostart=true                ; start at supervisord start (default: true)
;startsecs=1                   ; # of secs prog must stay up to be running (def. 1)
startretries=3                ; max # of serial start failures when starting (default 3)
autorestart=unexpected        ; when to restart if exited after running (def: unexpected)
;exitcodes=0                   ; 'expected' exit codes used with autorestart (default 0)
;stopsignal=QUIT               ; signal used to kill process (default TERM)
;stopwaitsecs=10               ; max num secs to wait b4 SIGKILL (default 10)
stopasgroup=true             ; send stop signal to the UNIX process group (default false)
killasgroup=true             ; SIGKILL the UNIX process group (def false)
user=root                   ; setuid to this UNIX account to run the program
redirect_stderr=true          ; redirect proc stderr to stdout (default false)
;stdout_logfile=/var/venv/devpi/supervisord.log        ; stdout log path, NONE for none; default AUTO
;stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stdout_logfile_backups=10     ; # of stdout logfile backups (0 means none, default 10)
;stdout_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
;stdout_events_enabled=false   ; emit events on stdout writes (default false)
;stdout_syslog=false           ; send stdout to syslog with process name (default false)
;stderr_logfile=/a/path        ; stderr log path, NONE for none; default AUTO
;stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stderr_logfile_backups=10     ; # of stderr logfile backups (0 means none, default 10)
;stderr_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
;stderr_events_enabled=false   ; emit events on stderr writes (default false)
;stderr_syslog=false           ; send stderr to syslog with process name (default false)
;environment=A="1",B="2"       ; process environment additions (def no adds)
;serverurl=AUTO                ; override serverurl computation (childutils)

;[eventlistener:theeventlistenername]
;command=/bin/eventlistener    ; the program (relative uses PATH, can take args)
;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
;numprocs=1                    ; number of processes copies to start (def 1)
;events=EVENT                  ; event notif. types to subscribe to (req'd)
;buffer_size=10                ; event buffer queue size (default 10)
;directory=/tmp                ; directory to cwd to before exec (def no cwd)
;umask=022                     ; umask for process (default None)
;priority=-1                   ; the relative start priority (default -1)
;autostart=true                ; start at supervisord start (default: true)
;startsecs=1                   ; # of secs prog must stay up to be running (def. 1)
;startretries=3                ; max # of serial start failures when starting (default 3)
;autorestart=unexpected        ; autorestart if exited after running (def: unexpected)
;exitcodes=0                   ; 'expected' exit codes used with autorestart (default 0)
;stopsignal=QUIT               ; signal used to kill process (default TERM)
;stopwaitsecs=10               ; max num secs to wait b4 SIGKILL (default 10)
;stopasgroup=false             ; send stop signal to the UNIX process group (default false)
;killasgroup=false             ; SIGKILL the UNIX process group (def false)
;user=chrism                   ; setuid to this UNIX account to run the program
;redirect_stderr=false         ; redirect_stderr=true is not allowed for eventlisteners
;stdout_logfile=/a/path        ; stdout log path, NONE for none; default AUTO
;stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stdout_logfile_backups=10     ; # of stdout logfile backups (0 means none, default 10)
;stdout_events_enabled=false   ; emit events on stdout writes (default false)
;stdout_syslog=false           ; send stdout to syslog with process name (default false)
;stderr_logfile=/a/path        ; stderr log path, NONE for none; default AUTO
;stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stderr_logfile_backups=10     ; # of stderr logfile backups (0 means none, default 10)
;stderr_events_enabled=false   ; emit events on stderr writes (default false)
;stderr_syslog=false           ; send stderr to syslog with process name (default false)
;environment=A="1",B="2"       ; process environment additions
;serverurl=AUTO                ; override serverurl computation (childutils)

;[group:thegroupname]
;programs=progname1,progname2  ; each refers to 'x' in [program:x] definitions
;priority=999                  ; the relative start priority (default 999)

; The [include] section can just contain the "files" setting.  This
; setting can list multiple files (separated by whitespace or
; newlines).  It can also contain wildcards.  The filenames are
; interpreted as relative to this file.  Included files *cannot*
; include files themselves.

;[include]
;files = /var/venv/devpi/gen-config/supervisor-devpi.conf
```

Proceed by enabling Python supervisor by running the command below.

```yml
root@ns3:/usr/local/etc # service supervisord restart
Stopping supervisord.
Waiting for PIDS: 965.
Starting supervisord.
```

## 👨‍💻 5. DevPI Client User Management

After you activate the DevPI server, the next step is to create a user and password to connect to it. This step is crucial because it will protect your DevPI server network. Follow the instructions below to create a user and password for the DevPI client.

```yml
root@ns3:~ # cd /usr/local/etc
root@ns3:/usr/local/etc # cd /var/venv/devpi
root@ns3:/var/venv/devpi # source bin/activate.csh
(devpi) root@ns3:/var/venv/devpi # devpi use -l http://192.168.5.2:3141
```

The above command is used to activate Python Venv and the `devpi use -l` command to connect the client to the server. Once the client connects to the server, create a json file, see the example below.

```console
(devpi) root@ns3:/var/venv/devpi # touch /root/.devpi/client/current.json
(devpi) root@ns3:/var/venv/devpi # ee /root/.devpi/client/current.json
{
  "features": [
    "server-keyvalue-parsing"
  ],
  "login": "http://192.168.5.2:3141/+login"
}
```

### a. Change the root password

The root password is automatically generated when the DevPI server is installed. For security reasons, change the root password.

```yml
(devpi) root@ns3:/var/venv/devpi # devpi login root --password=''
(devpi) root@ns3:/var/venv/devpi # devpi user -m root password=router1234
```

The command `devpi login root --password=''` is used when first installing the DevPI server. Since the root user password is empty after the DevPI server installation is complete, the default is blank: ''

After changing the root password, you must log in as root with the password you created, which is `"router1234"`. Now run the login to root command.

```console
(devpi) root@ns3:/var/venv/devpi # devpi login root
password for user root at http://192.168.5.2:3141/: router1234
logged in 'root', credentials valid for 10.00 hours
```

### b. Create a New User

To restrict the number of DevPI server users, we will create a user that can access the DevPI server.

```yml
(devpi) root@ns3:/var/venv/devpi # devpi user -c john email=datainchi@gmail.com password=johndoe123
user created: john
```

The above command is used to create,
User: **john**
Password: **johndoe123**

Try now to log in with the user john.

```yml
(devpi) root@ns3:/var/venv/devpi # devpi login john
password for user john at http://192.168.5.2:3141/: johndoe123
logged in 'john', credentials valid for 10.00 hours
```

## 👨‍💻 6. Using pip on the DevPI Server

In this section, we'll use the pip command on the DevPI server. Both easy_install and easy_install have the -i option to specify the index server URL. We'll demonstrate using the pip command, pointing the installer to the dedicated root/pypi index, which is served by the devpi server by default.

Okay, now let's install the simplejson package as our test cache. We'll log in as the root user.

```console
(devpi) root@ns3:/var/venv/devpi # devpi login root
(devpi) root@ns3:/var/venv/devpi # pip install -i http://192.168.5.2:3141/root/pypi/+simple/ simplejson
Looking in indexes: http://192.168.5.2:3141/root/pypi/+simple/
Collecting simplejson
  Downloading http://192.168.5.2:3141/root/pypi/%2Bf/bce/df4cae0d47839/simplejson-3.19.2-py3-none-any.whl (56 kB)
     ???????????????????????????????????????? 57.0/57.0 kB 1.2 MB/s eta 0:00:00
```

We will give another example, in the example below we login with user john, and we will install panda application.

```console
(devpi) root@ns3:/var/venv/devpi # devpi login john
(devpi) root@ns3:/var/venv/devpi # pip install --trusted-host 192.168.5.2 -i http://192.168.5.2:3141/root/pypi panda
Looking in indexes: http://192.168.5.2:3141/root/pypi
Collecting panda
  Downloading http://192.168.5.2:3141/root/pypi/%2Bf/f21/3b848f09268b3/panda-0.3.1.tar.gz (5.8 kB)
```

DevPi Server is a powerful and flexible Python package management system used for installing software. With DevPi Server, you can simplify the distribution and management of Python software.

Despite its shortcomings and limitations, DevPi Server remains a reliable and efficient tool for managing, distributing, and deploying Python software packages. We hope this article has provided you with in-depth and comprehensive information on how to install DevPi Server on FreeBSD.
