---
title: FreeBSD Gitlab Runner - Installation and Usage Guide
date: "2025-05-24 08:55:35 +0100"
updated: "2025-05-24 08:55:35 +0100"
id: install-gitlab-runner-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: GitLab Runner is an open source project used to run your work and send the results back to GitLab.
keywords: gitlab, runner, pipeline, gitlab runner, freebsd, shell, ssh, repository
---

It seems that Gitlab has big ambitions to replace Github, because there are so many applications created to manage Gitlab repositories. With these applications, it is very easy for Gitlab users to connect and communicate with their repositories in Gitlab. As if Gitlab users are spoiled with the convenience of these applications. One of the applications that is often used by developers is `gitlab-runner`.

GitLab Runner is an open source project that is used to run your work and send the results back to GitLab. This project is used in conjunction with GitLab CI/CID, an open source continuous integration service included with GitLab that
coordinates the work. In other words, this is an important component of GitLab's continuous integration and deployment workflow.

As an application that runs on a separate machine or container, the main purpose of GitLab Runner is to run jobs from the GitLab CI/CD configuration. When we push code to the GitLab repository, the runner takes the job, runs the specified commands, and reports the results back to GitLab. So, by using GitLab Runner, we can automate the process of building, testing, and deploying, saving time and reducing the risk of manual errors.

In this tutorial we will see how to set up and configure GitLab Runner on FreeBSD, as well as its various features and capabilities.

## 1. System Specifications
- OS: FreeBSD 14. 3
- Hostname: ns4
- IP Address: 192.168.5.71
- Gilab Runner Version: 18.0.0


## 2. Runner Executors
In carrying out its tasks, GitLab Runner implements various executors that can be used to run your builds in various environments.

GitLab Runner provides the following executors:

| Executor       | Required configuration          | Where jobs are executed        | 
| ----------- | -----------   | ----------- |
| shell          |           | Local shell. Default executor.          |
| docker          | [runners.docker] and Docker Engine      | Docker container.          |
| docker-windows          | [runners.docker] and Docker Engine     | Windows Dockercontainer.          |
| docker-ssh          | [runners.docker], [runners.ssh], and Docker Engine  | Docker container, but with an SSH connection. The Docker container is executed on the local machine. This setting changes how commands are run inside the container. If you want to run docker commands on an external machine, change the parameterhostin the sectionrunners.docker.          |
| ssh          | [runners.ssh]  | SSH, remotely.          |
| parallels          | [runners.parallels] and [runners.ssh]  | Parallels VM, SSH connection.          |
| virtualbox          | [runners.virtualbox] and [runners.ssh]  | VirtualBox VM, SSH connection.          |
| docker+machine          | [runners.docker] and [runners.machine]  | Likedocker, but uses auto-scaled Docker machines.          |
| docker-ssh+machine          | [runners.docker] and [runners.machine]  | Likedocker-ssh, but uses auto-scaled Docker machines.          |
| kubernetes          | [runners.kubernetes]  | Kubernetes pods.          |



## 3. Gitlab Runner Installation
On FreeBSD Gitlab Runner is available in the PKG package and the ports system. You can install it directly with one of these packages. We recommend using the PKG package to make the installation process easier. Below are the commands you can run to install Gitlab Runner

```console
root@ns4:~ # pkg install devel/gitlab-runner
```
Please note, during the installation process, the system will create a user and group for Gitlab Runner with the name `gitlab-runner:gitlab-runner`.

### 3.1. Enabling Gitlab Runner
After the installation process is complete, you can immediately activate Gitlab Runner in the `/etc/rc.conf` file. In that file, type the script below.

```console
gitlab_runner_enable="YES"
gitlab_runner_dir="/var/tmp/gitlab_runner"
gitlab_runner_user="gitlab-runner"
gitlab_runner_group="gitlab-runner"
gitlab_runner_syslogtag="gitlab-runner"
gitlab_runner_svcj_options="net_basic"
```

### 3.2. Running Gitlab Runner
The script in the `/etc/rc.conf` file is used to enable Gitlab Runner to run automatically. You can also run Gitlab Runner by running the following command.

```console
root@ns4:~ #   service gitlab_runner restart
Stopping gitlab_runner.
Waiting for PIDS: 1156, 1156.
Starting gitlab_runner.
root@ns4:~ #
```

### 3.3. Register Gitlab Runner
The Gitlab Runner that you have activated must be registered immediately to Gitlab so that you can use its functions. Registering the runner will create a connection between the runner and GitLab, so that both can communicate and run tasks.

To create a Runner, you must register your Runner on the Gitlab site. In your working repository on Gitlab, click the `Settings >> CI/CD` menu, then click the `Runners` menu. In the `Project runners` menu, click the `create project runner` menu.

After that, the runner token code will appear, you must register this code via the FreeBSD shell menu.

Here is the command to register the Gitlab Runner.

```console
root@ns4:~ # gitlab-runner register  --url https://gitlab.com  --token glrt-pJESaf7VlJfjyaryLccHN286MQpwOjE1djNkegp0OjMKdTpncXhwcBg.01.1j1mlp8bv
Runtime platform                                    arch=amd64 os=freebsd pid=1078 revision=18.0.0 version=18.0.0
Running in system-mode.
WARNING: You need to manually start builds processing:
WARNING: $ gitlab-runner run

Enter the GitLab instance URL (for example, https://gitlab.com/):
[https://gitlab.com]:
Verifying runner... is valid                        runner=pJESaf7Vl
Enter a name for the runner. This is stored only in the local config.toml file:
[ns4]:
Enter an executor: kubernetes, shell, ssh, docker, docker-windows, docker+machine, docker-autoscaler, instance, custom, parallels, virtualbox:
shell
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!

Configuration (with the authentication token) was saved in "/usr/local/etc/gitlab-runner/config.toml"
root@ns4:~ #
```

```console
root@ns4:~ # gitlab-runner run
```
On FreeBSD systems, all the Gitlab Runner information you have created above will be stored in the `/usr/local/etc/gitlab-runner/config.toml` file.

To see the script contents of the file, run the `cat` command.

```console
root@ns4:~ # cat /usr/local/etc/gitlab-runner/config.toml
concurrent = 1
check_interval = 0
connection_max_age = "15m0s"
shutdown_timeout = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "ns4"
  url = "https://gitlab.com"
  id = 47669129
  token = "glrt-pJESaf7VlJfjyaryLccHN286MQpwOjE1djNkegp0OjMKdTpncXhwcBg.01.1j1mlp8bv"
  token_obtained_at = 2025-05-31T08:45:47Z
  token_expires_at = 0001-01-01T00:00:00Z
  executor = "shell"
  [runners.cache]
    MaxUploadedArchiveSize = 0
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
root@ns4:~ #

```

### 3.4. Displaying Gitlab Runner List
In Gitlab you can create many Runners, we recommend creating Runners as needed. To see a list of Runners that you have created, run the following command.

```console
root@ns4:~ # service gitlab_runner list
Runtime platform                                    arch=amd64 os=freebsd pid=1113 revision=18.0.0 version=18.0.0
Listing configured runners                          ConfigFile=/var/tmp/gitlab_runner/.gitlab-runner/config.toml
runner1234                                          Executor=shell Token=glrt-NgUu45FU3jLLOE6YbT6Hd286MQpwOjE1djNkegp0OjMKdTpncXhwcBg.01.1j0dbf347 URL=https://gitlab.com
```

### 3.5. Gitlab Runner flags
The `gitlab-runner` command has many options, but the options we explained above are one of the most important commands and must be run when you are going to use Gitlab Runner. The following is a list of `gitlab-runner` command options that you can try.

| Option       | Description          | 
| ----------- | -----------   | 
| list          | List all configured runners          | 
| run          | run multi runner service      | 
| register          | register a new runner     | 
| reset-token          | reset a runner's token          | 
| install          | install service          | 
| uninstall          | uninstall service          | 
| start          | start service          | 
| Stop          | stop service          | 
| restart          | restart service          | 
| status          | get status of a service          | 
| run-single          | start single runner          | 
| unregister          | unregister specific runner          | 
| verify          | verify all registered runners          | 
| wrapper          | start multi runner service wrapped with gRPC manager server          | 
| fleeting          | manage fleeting plugins          | 
| artifacts-downloader          | download and extract build artifacts (internal)          | 
| artifacts-uploader          | create and upload build artifacts (internal)          | 
| cache-archiver          | create and upload cache artifacts (internal)          | 
| cache-extractor          | download and extract cache artifacts (internal)          | 
| cache-init          | changed permissions for cache paths (internal)          | 
| health-check          | check health for a specific address          | 
| proxy-exec          | execute internal commands (internal)          | 
| read-logs          | reads job logs from a file, used by kubernetes executor (internal)          | 
| help, h          | Shows a list of commands or help for one command          | 
|                                                                               |
| --cpuprofile value          | write cpu profile to file [$CPU_PROFILE]          | 
| --debug          | debug mode [$RUNNER_DEBUG]          | 
| --log-format value          | Choose log format (options: runner, text, json) [$LOG_FORMAT]          | 
| --log-level value, -l value          | Log level (options: debug, info, warn, error, fatal, panic) [$LOG_LEVEL]          | 
| --help, -h          | show help          | 
| --version, -v          | print the version          | 


In short, gitlab-runner is an essential tool for managing CI/CD job execution in GitLab. It simplifies the registration, configuration, deployment, and management of GitLab Runners, so you can automate and organize your software development and deployment processes efficiently.

Using the examples provided, you can efficiently register, manage, and verify runners, so that the development-to-deployment process runs smoothly. Whether you are setting up a new environment, maintaining an active system, or troubleshooting connectivity issues, this tool equips you with the skills you need to adapt to the demands of your evolving projects.