---
title: Update FreeBSD 14 PKG Packages With pkg Binary Package Manager
date: "2025-06-12 07:31:03 +0100"
updated: "2025-06-12 07:31:03 +0100"
id: update-upgrade-pkg-ports-package-binary-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: FreeBSD is a popular server platform and open source Unix-like operating system developed from the Berkeley Software Distribution (BSD). FreeBSD is an operating system intended to run modern servers, PCs, and embedded devices
keywords: binary, portsnap, fetch, update, upgrade, kernel, ports, system, package, pkg, openbsd, update, upgrade, cvs, mirror
---

FreeBSD is a popular server platform and open source Unix-like operating system developed from the Berkeley Software Distribution (BSD). FreeBSD is an operating system intended to run modern servers, PCs, and embedded devices. The term BSD stands for "Berkeley Software Distribution".


The term refers to a source code release from the University of California, Berkeley that was originally an add-on to the AT&T Research UNIX operating system. Several open source operating system projects are based on the 4.4BSD-Lite version of this source code. In addition, these projects include several packages from other Open Source projects, especially the GNU project.


FreeBSD has a variety of system tools as part of its base system. FreeBSD offers two free mechanisms for installing third-party programs/applications such as NGINX, apache, unbound, hitch, freeradius, mysql-server, openldap and others. To install these applications, FreeBSD offers 2 installation methods.


- **Ports:** The FreeBSD Ports collection is used to install applications from source code.
- **pkg:** The pkg package is used to install applications from the default binaries.


The discussion in this article will be limited to how to install programs/applications on a FreeBSD machine with the pkg package. For those who want to install programs/applications with the Ports system, you can read the previous article. Not only that, this article also discusses how to update and upgrade pkg packages.

<div align="center">
[`How to Update FreeBSD Ports With Portsnap and GIT`](https://unixwinbsd.site/openbsd/update-ports-system-openbsd/)
</div>

## 👨‍💻 1. pkg Binary Package Manager
pkg is a next-generation replacement for the existing FreeBSD package management utility, with several features that make working with binary packages faster and simpler. The pkg binary packages are located in the /usr/local directory. Most of the configuration files are located under /usr/local/etc. If you are coming from the Linux community, you might find this unusual. The important files and directories for the pkg package management system in FreeBSD are listed below:

- Official FreeBSD repositories location: `/etc/pkg`
- The pkg configuration file: `/usr/local/etc/pkg.conf`
- Package cache directory: `/var/cache/pkg`
- FreeBSD repository file: `/etc/pkg/FreeBSD.conf`
- Custom repositories directory: `/usr/local/etc/pkg/repos`
- SQLite database file: `/var/db/pkg/local.sqlite`


To start using the pkg package, type the following script.

```console
root@ns1:~ # pkg install autoconf automake libtool pkgconf libucl zsh git
```
To install the latest release version of a pkg package, insert the following script in the `/etc/make.conf` file.

```console
root@ns1:~ # ee /etc/make.conf
WITH_PKG=yes
```
<br/>

## 👨‍💻 2. Binary Package Configuration
If `WITH_PKG` is yes, proceed with downloading the pkg binary package.

```console
root@ns1:~ # cd /usr/local/etc
root@ns1:/usr/local/etc # git clone https://github.com/freebsd/pkg
```
Wait a few moments, if the git cloning process is complete, continue by installing the pkg package.

```console
root@ns1:~ # cd /usr/local/etc/pkg
root@ns1:/usr/local/etc/pkg # ./configure
No installed jimsh or tclsh, building local bootstrap jimsh0
Host System...x86_64-unknown-freebsd13.2
Build System...x86_64-unknown-freebsd13.2
C compiler... cc -g -O2
C++ compiler... c++ -g -O2
Build C compiler...cc
Checking for stdlib.h...ok
Checking for git...ok
Checking for archive_read_open...ok
Checking for zlibVersion...ok
Checking for BZ2_bzReadOpen...ok
Checking for lzma_version_string...ok
Checking for SHA256_Data...ok
Checking for archive_write_add_filter_zstd...ok
Checking for ZSTD_versionNumber...ok
Checking for atomic builtins... ok
Checking for /proc/self/fd support... no
Checking for memmove...ok
Checking for usleep...ok
Checking for pread...ok
Checking for pwrite...ok
Checking for SOCK_SEQPACKET...ok
Checking for struct sockaddr_in.sin_len...ok
Checking for struct stat.st_mtim...ok
Checking for struct stat.st_flags...ok
Checking for gmtime_r...ok
Checking for isnan...ok
Checking for localtime_r...ok
Checking for __res_setservers...ok
Checking for unlinkat...ok
Checking for faccessat...ok
Checking for fstatat...ok
Checking for openat...ok
Checking for readlinkat...ok
Checking for fflagstostr...ok
Checking for reallocarray...ok
Checking for strchrnul...(cached) ok
Checking for copy_file_range...ok
Checking for humanize_number...ok
Checking for fts_open...ok
Checking for humanize_number...ok
Checking for dlclose...ok
Checking for __res_query...ok
Checking for link.h...ok
Checking for machine/endian.h...ok
Checking for osreldate.h...ok
Checking for readpassphrase.h...ok
Checking for sys/procctl.h...ok
Checking for sys/statfs.h...not found
Checking for sys/statvfs.h...ok
Checking for libutil.h...(cached) ok
Checking for dirent.h...ok
Checking for sys/sockio.h...ok
Checking for endian.h...ok
Checking for sys/endian.h...ok
Checking for be16dec...ok
Checking for be16enc...ok
Checking for be32dec...ok
Checking for be32enc...ok
Checking for be64dec...ok
Checking for be64enc...ok
Checking for le16dec...ok
Checking for le16enc...ok
Checking for le32dec...ok
Checking for le32enc...ok
Checking for le64dec...ok
Checking for le64enc...ok
Checking for elf-hints.h...ok
Checking for cap_sandboxed...ok
Checking for sys/capsicum.h...ok
Checking for pkg-config...1.8.1
Created tests/Makefile from tests/Makefile.autosetup
Created docs/Makefile from docs/Makefile.autosetup
Created external/liblua/Makefile from external/liblua/Makefile.autosetup
Created external/msgpuck/Makefile from external/msgpuck/Makefile.autosetup
Created external/yxml/Makefile from external/yxml/Makefile.autosetup
Created scripts/Makefile from scripts/Makefile.autosetup
Created external/libcurl/Makefile from external/libcurl/Makefile.autosetup
```
Once the configuration process is complete, proceed with installing the pkg package.

```console
root@ns1:/usr/local/etc/pkg # make
root@ns1:/usr/local/etc/pkg # make install
```
or,

```console
root@ns1:/usr/local/etc/pkg # gmake
root@ns1:/usr/local/etc/pkg # gmake install
```
Now that your FreeBSD computer has the pkg binary package, you can use pkg to install some third-party applications/programs. To make the pkg package available to install applications/programs, create a `FreeBSD.conf` file in the `/usr/local/etc/pkg/repos` folder.


```console
root@ns1:~ # mkdir -p /usr/local/etc/pkg/repos
root@ns1:~ # touch /usr/local/etc/pkg/repos/FreeBSD.conf
root@ns1:~ # chmod +x /usr/local/etc/pkg/repos/FreeBSD.conf
root@ns1:~ # cp /etc/pkg/FreeBSD.conf /usr/local/etc/pkg/repos/FreeBSD.conf
```
After you have copied the **FreeBSD.conf** file. Move the PKG package repository from `/etc/pkg` to `/usr/local/etc/pkg`. To do this, disable the update process in the `/etc/pkg/FreeBSD.conf` file.

```console
root@ns1:~ # cd /etc/pkg
root@ns1:/usr/local/etc/pkg/repos # ee FreeBSD.conf
#
# To disable this repository, instead of modifying or removing this file,
# create a /usr/local/etc/pkg/repos/FreeBSD.conf file:
#
#   mkdir -p /usr/local/etc/pkg/repos
#   echo "FreeBSD: { enabled: no }" > /usr/local/etc/pkg/repos/FreeBSD.conf
#

FreeBSD: {
  url: "pkg+https://pkg.FreeBSD.org/${ABI}/latest",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: no
}
```
Change `"enable"` from `"yes"` to `"no"`.

After that, you Update the pkg package.

```console
root@ns1:~ # pkg update -f
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
root@ns1:~ # pkg upgrade -f
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Checking for upgrades (0 candidates): 100%
Processing candidates (0 candidates): 100%
Checking integrity... done (0 conflicting)
Your packages are up to date.
```
The `pkg` utility is not loaded by default on FreeBSD, but you can quickly install pkg by running the following command.

```console
root@ns1:~ # pkg bootstrap -f
The package management tool is not yet installed on your system.
Do you want to fetch and install it now? [y/N]: y
Bootstrapping pkg from pkg+http://pkg.FreeBSD.org/FreeBSD:13:amd64/latest, please wait...
Installing pkg-1.19.2...
package pkg is already installed, forced install
Extracting pkg-1.19.2: 100%
```
<br/>

## 👨‍💻 3. How to Use the PKG Command
One of the main features of FreeBSD is the pkg package management system, which allows users to easily install, update, and remove software packages. In this sub-article, we will discuss examples of useful PKG commands for managing packages in FreeBSD.

### a. Install Application Programs
Below we will provide several ways to install application programs that run on FreeBSD.

```console
root@ns1:~ # pkg install apache24
root@ns1:~ # pkg install nginx
root@ns1:~ # pkg install unbound
root@ns1:~ # pkg install isc-dhcp44-server
```

### b. Searching for Application Programs
Below we will provide several ways to search for application programs that you will install on FreeBSD.

```console
root@ns1:~ # pkg search python
root@ns1:~ # pkg search apache24
root@ns1:~ # pkg search nginx
root@ns1:~ # pkg search unbound
lua51-luaunbound-1.0.0_1       Lua binding to libunbound
lua52-luaunbound-1.0.0_1       Lua binding to libunbound
lua53-luaunbound-1.0.0_1       Lua binding to libunbound
lua54-luaunbound-1.0.0_1       Lua binding to libunbound
unbound-1.17.1_2               Validating, recursive, and caching DNS resolver
unbound_exporter-0.4.1_6       Prometheus metrics exporter for the Unbound DNS resolver
```
### c. View installed application programs

```console
root@ns1:~ # pkg info
```

### d. Delete installed application programs

```console
root@ns1:~ # pkg delete python
root@ns1:~ # pkg delete apache24
root@ns1:~ # pkg delete nginx
root@ns1:~ # pkg delete unbound
Checking integrity... done (0 conflicting)
Deinstallation has been requested for the following 1 packages (of 0 packages in the universe):

Installed packages to be REMOVED:
	unbound: 1.17.1_2

Number of packages to be removed: 1

The operation will free 8 MiB.

Proceed with deinstalling packages? [y/N]: y
[1/1] Deinstalling unbound-1.17.1_2...
[1/1] Deleting files for unbound-1.17.1_2: 100%
You may need to manually remove /usr/local/etc/unbound/unbound.conf if it is no longer needed.
```

### e. Displaying pkg Package Information
```console
root@ns1:~ # pkg info python
root@ns1:~ # pkg info -d python
root@ns1:~ # pkg info -d nginx
root@ns1:~ # pkg info -d unbound
```
FreeBSD implements two companion technologies for installing third-party software. The FreeBSD Ports Collection, for installing from source, and packages, for installing from pre-built binaries.

However, as FreeBSD moves the system more strongly toward universal package management, you should try to manage third-party software with pkg as much as possible. Avoid using ports unless the software you want doesn't have a packaged version or you need to adjust compile-time options.