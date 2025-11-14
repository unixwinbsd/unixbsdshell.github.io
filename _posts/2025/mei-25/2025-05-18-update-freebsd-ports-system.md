---
title: How to Update the FreeBSD Ports System
date: "2025-05-18 16:15:35 +0100"
updated: "2025-05-18 16:15:35 +0100"
id: update-freebsd-ports-system
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: The FreeBSD Ports Collection provides a simple and centralized way to install FreeBSD software.
keywords: freebsd, file, command, ports, port, system, update, upgrade, pkg
---

The FreeBSD Ports Collection provides a simple and centralized way to install FreeBSD software. Ports consist of categorized directories that contain makefiles that are used by the make command to compile source code into executable programs or libraries. The Ports Collection is designed for automation and is relatively easy to use. With the Ports Collection, administrators can be responsible for keeping applications/programs updated to the latest versions sourced from the official developers who created the program.

Installing software from ports is the same as building a program from source code. If the source code is not already on the system, it can be downloaded from a site specified by the makefile. The system verifies the contents of the downloaded source code, usually using an MD5 (Message-Digest algorithm 5) hash to ensure its authenticity. An MD5 hash is a 32-character alphanumeric string that is like a fingerprint for a file. An example of an MD5 hash would look like this: e6c75c12f663a484ee3157ab058cfc9e.

Once the source code has been authenticated, the make program checks the makefile to see if the port requires any other software. If so, FreeBSD also installs those dependencies. They are then applied to the source code before being compiled and installed. Once all processing is complete, the port is treated as a FreeBSD package and recorded in the installed packages database, pkgdb.db, which is stored in the `/var/db/pkg` directory.

## 1. Portsnap

Portsnap is a FreeBSD utility used to take and update compressed snapshots of the FreeBSD ports system, and extract and update uncompressed ports. In normal update operations, portsnap will periodically restore modified files to their unmodified state and delete unknown local files.

Before using ports, you must first obtain the Ports Collection directory in the `/usr/ports` folder. The portsnap command allows you to download and update the FreeBSD Ports collection over the internet. To download the Ports collection, type the following command.

```
root@ns2:~ # portsnap fetch
Looking up portsnap.FreeBSD.org mirrors... 5 mirrors found.
Fetching snapshot tag from dualstack.aws.portsnap.freebsd.org... done.
Fetching snapshot metadata... done.
Updating from Mon Jul  3 07:05:15 WIB 2023 to Tue Jul  4 14:40:14 WIB 2023.
Fetching 5 metadata patches... done.
Applying metadata patches... done.
Fetching 0 metadata files... done.
```

The "portsnap fetch" command above is to download the Ports collection to be extracted to the `/usr/ports` folder. After the download process is complete, extract portsnap with the following command.

```
root@ns2:~ # portsnap extract
/usr/ports/.arcconfig
/usr/ports/.gitignore
/usr/ports/.hooks/pre-commit
/usr/ports/.hooks/pre-commit.d/
/usr/ports/.hooks/prepare-commit-msg
/usr/ports/CHANGES
/usr/ports/CONTRIBUTING.md
/usr/ports/COPYRIGHT
/usr/ports/GIDs
/usr/ports/Keywords/exec.ucl
/usr/ports/Keywords/fc.ucl
```

Proceed with updating the Port collection.

```
root@ns2:~ # portsnap update
Ports tree is already up to date.
```

## 2. Update Ports with Git

In addition to portsnap, the FreeBSD Ports collection can also be updated using git.

Git is a so-called Version Control System ("VCS") that can help control a project. A project can be anything, a single shell script, a group of shell scripts, the source code for a program (or many programs) and can even update the FreeBSD kernel. To update the Ports collection with git, type the following command.

```
root@ns2:~ # pkg install git
root@ns2:~ # git clone -b release/13.2.0 --depth 1 https://git.FreeBSD.org/ports.git /usr/ports
Cloning into '/usr/ports'...
```

Once you're done cloning the Ports collection, run the git pull and git branch scripts.

```
root@ns2:~ # cd /usr/ports
root@ns2:/usr/ports # git pull && git branch --all
root@ns2:/usr/ports # git config --global --add safe.directory /usr/ports
```

## 3. Update Ports

To keep the Ports collection up to date and always display the latest version, the FreeBSD Ports collection must always be updated, this is done to ensure that applications that will be installed through the port system are the latest versions. To update the Ports collection, follow these steps.

```
root@ns2:~ # cd /usr/ports/lang/perl5.32
root@ns2:/usr/ports/lang/perl5.38 # make install clean
```

The next step is to update the FreeBSD Ports collection with portmaster. Type the following command.

```
root@ns2:~ # cd /usr/ports/ports-mgmt/portmaster
root@ns2:/usr/ports/ports-mgmt/portmaster # make install clean
```

portmaster will identify four categories of ports:
- Root Port: The root port has no dependents and has no dependencies.
- Trunk Port: The trunk port has no dependents, but depends on other ports.
- Branch port: The branch port has dependencies and depends on other ports.
- Leaf port: The leaf port has dependencies but does not depend on other ports.

Portmaster is only installed once. To update the Portmaster or renew the Portmaster, you only need to type the following command.

```
root@ns2:~ # portmaster -L
```

To update or upgrade all legacy ports, use the following script.

```
root@ns2:~ # portmaster -a
```

We can also add -f to upgrade and rebuild all ports if a problem occurs during the upgrade process.

```
root@ns2:~ # portmaster -af
```

Portmaster can also be used to install new ports, updating all dependencies before building and installing new ports. To use this feature, specify the port location in the Ports Collection. The example below is to update the dependencies of the bash program.

```
root@ns2:~ # portmaster shells/bash
```

The next step to update the Port collection is with the portupgrade command.

```
root@ns2:~ # cd /usr/ports/ports-mgmt/portupgrade
root@ns2:/usr/ports/ports-mgmt/portupgrade # make install clean
```

Use the following command to update all ports on a FreeBSD system.

```
root@ns2:~ # portupgrade -a
```

Alternatively, add -i to require confirmation for each port update.

```
root@ns2:~ # portupgrade -ai
```

To update only one application, use the following script.

```
root@ns2:~ # portupgrade -R apache24
or
root@ns2:~ # portupgrade -PP apache24
```

## 4. Cleaning Ports Trash

Using the Ports Collection will take up disk space. After an application is installed and updated, it will leave cache files in the Ports collection. Running make clean inside the ports framework will delete the temporary working directory. Unless -K is specified, Portmaster automatically destroys this directory after installing and updating an application. For example, if apache24 is installed, the following command will delete all temporary files from the local copy of the Ports Collection.

```
root@ns2:~ # cd /usr/ports/www/apache24
root@ns2:/usr/ports/www/apache24 # make install clean
root@ns2:/usr/ports/www/apache24 # portsclean -C
```

The first script in the above command opens the `/usr/ports/www/apache24` folder, the second script installs the apache24 application and the third script will remove the temporary dependency files used to install apache24. These files are usually located in the work folder. During the Apache installation process, the work folder is located in the `/usr/ports/www/apache24/work` folder.

In addition, distribution files that come from the installation source are collected in the `/usr/ports/distfiles` folder. To remove all distfiles that are no longer referenced by any port, use Portupgrade. However, it is recommended that the files in the `/usr/ports/distfiles` folder are not deleted. Run the following command to remove the files in the `/usr/ports/distfiles` folder.

```
root@ns2:~ # portsclean -D
or
root@ns2:~ # portscleaning -DD
```

In addition to installing applications using ports, FreeBSD also provides a utility for installing ports, namely pkg. With pkg, program/application installation can take place quickly. Discussion about pkg will be explained in the next article.
