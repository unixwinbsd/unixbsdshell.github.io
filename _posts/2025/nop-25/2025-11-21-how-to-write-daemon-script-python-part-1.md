---
title: FreeBSD and Python - How to Write Daemon Script - Part 1
date: "2025-11-21 13:46:39 +0000"
updated: "2025-11-21 13:46:39 +0000"
id: how-to-write-daemon-script-python-part-1
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/nop-25-024.jpg
toc: true
comments: true
published: true
excerpt: Since the first Python daemon appeared, the Python library has introduced a daemon runner to handle daemons. The first step to using the Python Daemon is to install the Python Daemon application.
keywords: script, python, daemon, freebsd, unix, bsd, command, shell, write
---

A few additional notes. While the word **"daemon"** may sound sinister, it has nothing to do with Satan; it actually comes from the Greek word daimon `(δαίμων)`, which refers to the spirit that humans possess and that ultimately defines them.

A daemon is a process. It's no more or less than your browser process. The key difference is that a daemon is a process that doesn't require user input to function. Imagine, for example, a web server that doesn't wait for its own user to perform an action, but instead waits for another host on the network to make a request. These requests need to be processed without any human intervention.

The daemon utility is detached from the controlling terminal and executes the program specified by its arguments. Privileges can be granted to specific users. Output from the daemonized process can be directed to syslog and to log files. We can create a daemon process in Python by passing the "daemon" argument to the multiprocessing constructor or through the "daemon" property.

Every Python program executes within a Process, which is a new instance of the Python interpreter. This process is named MainProcess and has a single thread used to execute program instructions, called MainThread. Both processes and threads are created and managed by the underlying operating system. Sometimes we may need to create new child processes within our programs to execute code concurrently. Python provides the ability to create and manage new processes through the multiprocessing.Process class.

Daemon is pronounced **"dee-mon,"** like the alternative spelling "demon." The idea is that a background process is like a "daemon" or spirit (from ancient Greek) that performs tasks for you in the background. You can also call a daemonic process daemonic.

A process can be configured to be a daemon or not, and most processes in concurrent programming, including the primary parent process, are non-daemonic (not background) processes by default. The property of being a daemonic process may not be supported by the underlying operating system that actually creates and manages the execution of threads and processes.

<img alt="FreeBSD and Python - How to Write Daemon Script - Part 1" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/nop-25-024.jpg' | absolute_url }}">

## 1. What Is a Python Daemon?

In 2009, PEP 3143 was created, with the goal of creating a "package in the Python standard library that provides a simple interface for tasks like daemon processes." While this goal wasn't impossible, and enough people were interested in seeing the project succeed, it didn't work. The person responsible for it didn't have enough time left, and no one stepped in to save the project. A sad death for a good project.

This tragedy didn't affect the functionality of python-daemon so much (it essentially covered everything needed for a daemon), but rather its documentation. As I mentioned before, the weakest point is the documentation in the PEP and partly in the code itself.

Since the first daemons appeared in Python, the Python library introduced a daemon runner to handle daemons. However, the Daemon Runner library is now deprecated, and the DaemonContext API library used in DaemonRunner is used instead.

It's true that DaemonRunner extends the functionality of DaemonContext, but it does so in a very outdated way (e.g., it doesn't use argparse). This may be the reason why it was eventually deprecated. Without further ado, DaemonContext makes it easy to start daemon jobs with just a context manager.

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

## 2. How to Create a Python Daemon

The first step to using Python Daemon is to install the Python Daemon application. The following command is used to install the python daemon.

```yml
root@ns1:~ # pip install python-daemon
```

To create a python daemon and make it easier to learn, below we will provide an example of a daemon file. We create a file with the name `/tmp/gunungsemeru.py` and enter the following script into the file `/tmp/gunungsemeru.py`.

```console
root@ns1:/ # ee /tmp/gunungsemeru.py
#!/usr/local/bin/python

 # Imports #
import time

 # Globals #
TTL_SECONDS = 30
TTL_CHECK_INTERVAL = 5

 # Fuctions #

 # Main #
print("Started!")
for i in range(1, TTL_SECONDS + 1):
    time.sleep(1)
    if i % TTL_CHECK_INTERVAL == 0:
        print("Running for " + str(i) + " seconds...")
print("TTL reached, terminating!")
exit(0)
```

Then create file permissions on the file `/tmp/gunungsemeru.py`.

```yml
root@ns1:/tmp # chmod +x /tmp/gunungsemeru.py
```

Now we test the file `/tmp/gunungsemeru.py`, whether the Python daemon is running or not.

```console
root@ns1:~ # cd /tmp
root@ns1:/tmp # ./gunungsemeru.py restart
Started!
Running for 5 seconds...
```

The main part of the program first outputs an initial message to the terminal, then enters a for loop, which counts from 1 to 30. In Python, we can do this by passing a list of values ​​after the in keyword. Counting up to 5 can be written as i in [1, 2, 3, 4, 5].

The next thing to explore is signal handling. Since a daemon is essentially a program running in the background, we need a way to tell it to stop, for example. This is usually done using signals. We can send some signals to a normal program running in the terminal by pressing a key combination, while all of them can be sent with the kill command.

If we press CTRL+C, for example, we send SIGINT to the running application, telling it to "stop operation." Something somewhat similar is SIGTERM, which means "hey, please stop." This is a good termination signal, allowing the program to clean up and then shut down properly.

However, if we use kill-9, we'll send SIGKILL, an unskippable kill signal, which effectively means "die!" to the targeted process (if we've ever done this on a live database or other sensitive application, we know we really need to think before using it, or we might run into a lot of trouble for the next few hours).

Here's the script to send the signal to the Python daemon. First, delete the contents of the `/tmp/gunungsemeru.py` file and replace it with the script below.

```console
root@ns1:/ # ee /tmp/gunungsemeru.py
#!/usr/local/bin/python
 
 # Imports #
import signal
import time
 
 # Globals #
TTL_SECONDS = 30
TTL_CHECK_INTERVAL = 5
 
 # Fuctions #
def signal_handler(signum, frame):
    print("Received signal" + str(signum) + "!")
    if signum == 2:
        exit(0)
 
 # Main #
signal.signal(signal.SIGHUP, signal_handler)
signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGQUIT, signal_handler)
signal.signal(signal.SIGILL, signal_handler)
signal.signal(signal.SIGTRAP, signal_handler)
signal.signal(signal.SIGABRT, signal_handler)
signal.signal(signal.SIGEMT, signal_handler)
#signal.signal(signal.SIGKILL, signal_handler)
signal.signal(signal.SIGSEGV, signal_handler)
signal.signal(signal.SIGSYS, signal_handler)
signal.signal(signal.SIGPIPE, signal_handler)
signal.signal(signal.SIGALRM, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)
#signal.signal(signal.SIGSTOP, signal_handler)
signal.signal(signal.SIGTSTP, signal_handler)
signal.signal(signal.SIGCONT, signal_handler)
signal.signal(signal.SIGCHLD, signal_handler)
signal.signal(signal.SIGTTIN, signal_handler)
signal.signal(signal.SIGTTOU, signal_handler)
signal.signal(signal.SIGIO, signal_handler)
signal.signal(signal.SIGXCPU, signal_handler)
signal.signal(signal.SIGXFSZ, signal_handler)
signal.signal(signal.SIGVTALRM, signal_handler)
signal.signal(signal.SIGPROF, signal_handler)
signal.signal(signal.SIGWINCH, signal_handler)
signal.signal(signal.SIGINFO, signal_handler)
signal.signal(signal.SIGUSR1, signal_handler)
signal.signal(signal.SIGUSR2, signal_handler)
#signal.signal(signal.SIGTHR, signal_handler)
 
print("Started!")
for i in range(1, TTL_SECONDS + 1):
    time.sleep(1)
    if i % TTL_CHECK_INTERVAL == 0:
        print("Running for " + str(i) + " seconds...")
print("TTL reached, terminating!")
exit(0)
```

The example script above has added a function called `"signal_handler"` as that's its purpose. When run, it handles every signal that can be sent on a FreeBSD system (run kill -l to list all available signals on Unix-like operating systems).

The logging system must also be taken into account when handling background processes. A daemon, detached from a TTY, can no longer accept input as usual from STDIN. However, we're investigating those signals, so that's not a problem. However, this also means the daemon can't use `STDOUT or STDERR` to print anything to the terminal.

Where does data written by the daemon, such as STDOUT, go? It goes to the system log. Unless there's a specific configuration for it, you can find it in `/var/log/messages`. Since we expect quite a bit of debug output during the development phase, we don't want to clutter `/var/log/messages` with it. So, to write a well-behaved daemon, there's one more thing we need to consider: `"Logging"` The following is a logging script for the Puthon daemon.

```console
root@ns1:/ # ee /tmp/gunungsemeru.py
#!/usr/local/bin/python
 
 # Imports #
import logging
import signal
import time
 
 # Globals #
TTL_SECONDS = 30
TTL_CHECK_INTERVAL = 5
 
 # Fuctions #
def handler_sigterm(signum, frame):
    logging.debug("Exiting on SIGTERM")
    exit(0)
 
def handler_sigint(signum, frame):
    logging.debug("Not going to quit, there you have it!")
 
 # Main #
signal.signal(signal.SIGINT, handler_sigint)
signal.signal(signal.SIGTERM, handler_sigterm)
try:
    logging.basicConfig(filename='bdaemon.log', format='%(levelname)s:%(message)s', level=logging.DEBUG)
except:
    print("Error: Could not create log file! Exiting...")
    exit(1)
 
logging.info("Started!")
for i in range(1, TTL_SECONDS + 1):
    time.sleep(1)
    if i % TTL_CHECK_INTERVAL == 0:
        logging.info("Running for " + str(i) + " seconds...")
logging.info("TTL reached, terminating!")
exit(0)
```

The only thing left to do is modify the print statement so that we use logging. Depending on how critical the log entry is, we can also use different levels of importance, from least important (DEBUG) to most important (CRITICAL).

We can wait for the program to complete and then view the log, or we can open a second terminal and type -f bdaemon.log there to view the output while the program is running.

Okay! With the article in step 1, we have everything needed to daemonize a Python program.
