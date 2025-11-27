---
title: FreeBSD Practical Instructions For Configuring OpenLDAP Server and Client
date: "2025-11-27 08:39:47 +0000"
updated: "2025-11-27 08:39:47 +0000"
id: practical-instruction-configuring-openldap-server-client
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: WebServer
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-034.jpg
toc: true
comments: true
published: true
excerpt: Once the OpenLDAP installation is complete, it's time to configure OpenLDAP for use on your FreeBSD system. Set up the OpenLDAP root password. OpenLDAP stores the LDAP administrator password in the slapd.conf file.
keywords: freebsd, openldap, practical, instruction, configuring, server, client, bsd, unix, openbsd
---

LDAP (Lightweight Directory Access Protocol) is a TCP-based protocol used to access directory services. Directory services provide users with information about other users and resources on a network (usually in the form of address book entries). Entries are stored in a central database and accessed from an LDAP server (OpenLDAP, Windows Server Active Directory, etc.) through an LDAP-enabled client (Microsoft Outlook, Mozilla Thunderbird, etc.).

OpenLDAP adheres to the X.500 series of directory service standards developed by the ITU-T (the standards division of the International Telecommunications Union). This program provides LDAP interoperability between X.500-based applications. According to the X.500 standard, LDAP entries are stored in a hierarchical format consisting of a set of attributes within the entry directory:

```console
-DOMAIN COMPONENT (.com)
     -DOMAIN COMPONENT (example)
         -ORGANIZATIONAL UNIT (People)
             -USER ID (jdoe)
                 -TELEPHONENUMBER (phone number)
                 -GIVENNAME (doe)
```

LDAP was created by Tim Howes, `Steve Kille, and Wengyik Yeong` in 1992. Initially, LDAP was a project to provide a directory service alongside the University of Michigan's email system. A company called Net Boolean Inc. was formed to provide email services to businesses in early 1998. Commercially available LDAP implementations were too expensive for the fledgling company.

Net Boolean created Boolean LDAP from open-source LDAP software provided by the University of Michigan. Kurt Zeilenga of Net Boolean then founded the OpenLDAP Foundation and project in August 1998. OpenLDAP development currently consists of a core team that includes founders Kurt Zeilenga, Howard Chu, and Pierangelo Masarati.

<img alt="FreeBSD Practical Instructions For Configuring OpenLDAP Server and Client" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-034.jpg' | absolute_url }}">

This time, we will try installing OpenLDAP on a FreeBSD 13.2 system. To begin installing OpenLDAP on FreeBSD, you must be logged in as the superuser or root user. To install all OpenLDAP dependencies, you must use the FreeBSD ports system to install OpenLDAP.

```yml
root@router2:~ # cd /usr/ports/net/openldap26-server
root@router2:~ # make config && make install clean
root@router2:~ # rehash
```

After that continue by installing `openldap26-client`.

```yml
root@router2:~ # cd /usr/ports/net/openldap26-client
root@router2:~ # make config && make install clean
root@router2:~ # rehash
```

Once the OpenLDAP installation is complete, it's time to configure OpenLDAP for use on your FreeBSD system. Set up the OpenLDAP root password. OpenLDAP stores the LDAP administrator password in the `/usr/local/etc/slapd.conf` file. OpenLDAP can read this password as plain text or as a hash. The hash obfuscates the password with its unique algorithm, making it invisible.

The next step is to edit the `/usr/local/etc/slapd.conf` file. If your FreeBSD server's domain name is unixexplore.com, enter `"dc=unixexplore,dc=com"`. Continue to the next line, rootdn, and enter the same information, omitting the "cn=Manager" segment. For clarity, follow the script below:

```console
root@router2:~ #  ee /usr/local/etc/openldap/slapd.conf
suffix		"dc=unixexplore,dc=com"
rootdn		"cn=Manager,dc=unixexplore,dc=com"
```

In the slapd.conf file located in the `/usr/local/etc/openldap` folder, under the include script `/usr/local/etc/openldap/schema/core.schema`, add the following script:

```console
include /usr/local/etc/openldap/schema/cosine.schema
include /usr/local/etc/openldap/schema/inetorgperson.schema
```

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

Now we continue by copying the `cosine.schema.sample` file to `cosine.schema`.

```yml
root@router2:~ # cp /usr/local/etc/openldap/schema/cosine.schema.sample cosine.schema
```

Then in the openldap client we edit the `/usr/local/etc/openldap/ldap.conf` file and add the script below to the `ldap.conf` file.

```console
root@ns1:~ # ee /usr/local/etc/openldap/ldap.conf
URI     ldap://192.168.5.2
BASE dc=unixexplore,dc=com
BINDDN cn=Manager,dc=unixexplore,dc=com

SIZELIMIT       12
TIMELIMIT       15
DEREF           never
```

We continue by creating the Start Up rc.d file, add the following script to the `/etc/rc.conf` file.

```yml
root@router2:~ # ee /etc/rc.conf
slapd_enable="YES"
slapd_flags='-h "ldapi://%2fvar%2frun%2fopenldap%2fldapi/ ldap://0.0.0.0/"'
slapd_sockets="/var/run/openldap/ldapi"
```

After that, you create a user account and group which we will name `"ldap"`.

```yml
root@router2:~ # chown -R ldap:ldap /usr/local/etc/openldap/
root@router2:~ # chown -R ldap:ldap /var/run/openldap/
```

Now let's run a test to see if there's anything wrong with the OpenLDAP configuration. Type the following command line.

```yml
root@router2:~ # service slapd restart
Stopping slapd.
Waiting for PIDS: 47346.
Performing sanity check on slap configuration: OK
Starting slapd.
root@router2:~ #
```

The meaning of the example script above is:

*Waiting for PIDS: 47346.*

*Performing sanity check on slap configuration: OK*

*Starting slapd*
<br/>

This means your OpenLDAP server is running or has been RUNNING on your FreeBSD system.

Let's check again with the ldapsearch -x script. If the following appears, then OpenLDAP is running normally.

```console
root@ns1:~ # ldapsearch -x
# extended LDIF
#
# LDAPv3
# base <dc=unixexplore,dc=com> (default) with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# search result
search: 2
result: 32 No such object

# numResponses: 1
```

Because ldapadd is sensitive to syntax errors, manually adding entries to an LDAP database (as we did in the testing section above) can be cumbersome.

There are several utilities that allow you to manage your LDAP database more efficiently and easily. phpLDAPadmin is a web-based LDAP browser designed to manage LDAP databases more intuitively.
