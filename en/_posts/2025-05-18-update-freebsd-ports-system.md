---
title: How to Update the FreeBSD Ports System
date: "2025-05-18 16:15:35 +0100"
id: update-freebsd-ports-system
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "SysAdmin"
excerpt: The FreeBSD Ports Collection provides a simple and centralized way to install FreeBSD software.
keywords: freebsd, file, command, ports, port, system, update, upgrade, pkg
---

The FreeBSD Ports Collection provides a simple and centralized way to install FreeBSD software. Ports consist of categorized directories that contain makefiles that are used by the make command to compile source code into executable programs or libraries. The Ports Collection is designed for automation and is relatively easy to use. With the Ports Collection, administrators can be responsible for keeping applications/programs updated to the latest versions sourced from the official developers who created the program.

Installing software from ports is the same as building a program from source code. If the source code is not already on the system, it can be downloaded from a site specified by the makefile. The system verifies the contents of the downloaded source code, usually using an MD5 (Message-Digest algorithm 5) hash to ensure its authenticity. An MD5 hash is a 32-character alphanumeric string that is like a fingerprint for a file. An example of an MD5 hash would look like this: e6c75c12f663a484ee3157ab058cfc9e.

Once the source code has been authenticated, the make program checks the makefile to see if the port requires any other software. If so, FreeBSD also installs those dependencies. They are then applied to the source code before being compiled and installed. Once all processing is complete, the port is treated as a FreeBSD package and recorded in the installed packages database, pkgdb.db, which is stored in the /var/db/pkg directory.

## 1. Portsnap

Portsnap is a FreeBSD utility used to take and update compressed snapshots of the FreeBSD ports system, and extract and update uncompressed ports. In normal update operations, portsnap will periodically restore modified files to their unmodified state and delete unknown local files.

Before using ports, you must first obtain the Ports Collection directory in the /usr/ports folder. The portsnap command allows you to download and update the FreeBSD Ports collection over the internet. To download the Ports collection, type the following command.

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

The "portsnap fetch" command above is to download the Ports collection to be extracted to the /usr/ports folder. After the download process is complete, extract portsnap with the following command.

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



Cara Update Sistem Ports FreeBSD
