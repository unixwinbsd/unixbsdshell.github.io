---
title: FREEBSD SYSADMIN Installing and Configuring Cyrus Sasl2
date: "2025-10-10 08:56:35 +0100"
updated: "2025-10-10 08:56:35 +0100"
id: freebsd-sysadmin-installing-cyrus-sasl2
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/oct-25/oct-25-61.jpg
toc: true
comments: true
published: true
excerpt: The discussion in this article is specifically relevant to configuring Cyrus SASL with the Postfix MTA, and assumes that you intend to use SASL with SMTP in combination with SSL/TLS encryption to secure PLAIN and/or LOGIN authentication methods.
keywords: freebsd, tutorials, installing, sysadmin, cyrus, sasl2
---

SASL (Simple Authentication and Security Layer) is a system for adding support for connection-based authentication to protocols. In this article, we will use the Simple Mail Transfer Protocol (SMTP) mechanism, namely the Postfix MTA, which uses SMTP to transfer Internet email. Adding authentication support to Postfix is ​​important for users who want to forward email through their servers from unsecured public networks. Secure email redirection can be achieved by combining SASL with `SSL/TLS-based` encryption.

By default, the Postfix MTA is not an open email forwarder. While this prevents unauthorized users from using the server to send spam, it also prevents legitimate users from sending email from locations other than the local private network. Cyrus SASL allows SMTP servers to verify the identity of remote users. Once authenticated, users are granted remote redirection privileges.

John Myers, a former systems architect at Carnegie Mellon University, published the SASL specification in October 1997. Cyrus SASL is maintained under the Cyrus Project at Carnegie Mellon.

The discussion in this article is specifically relevant to configuring Cyrus SASL with the Postfix MTA, and assumes that you intend to use SASL with SMTP in combination with `SSL/TLS` encryption to secure PLAIN and/or LOGIN authentication methods.

The operating system used in this article is FreeBSD 13. You can begin installing the Cyrus SASL authentication server, which includes Cyrus SASL. To start the Cyrus SASL authentication server installation, type the following command:

```
root@router2:~ # cd /usr/ports/security/cyrus-sasl2-saslauthd
root@router2:~ # make config && make install clean
root@router2:~ # rehash
```

A menu will appear showing the option to start the Cyrus SASL installation process, just leave these settings at default, then press the `"enter"` key.

![Freebsd cyrus sals2_install and configuration](/img/oct-25/oct-25-61.jpg)


Once you have finished installing `/security/cyrus-sasl2`, edit the `/usr/local/lib/sasl2/Sendmail.conf` file, or create one if it doesn't already exist, and add the following lines:

```
pwcheck_method: saslauthd
mech_list: plain login
```

As the script above explains, the first line directs Cyrus SASL to use the SASL authentication server you installed. The second line tells Cyrus SASL to only advertise the PLAIN and LOGIN methods when the client initially connects to the SMTP server.

The next step is to enable the SASL authentication server to start automatically when the computer starts. To configure the SASL authentication server to start automatically at startup, add the following script to the `/etc/rc.conf` file.

```
saslauthd_enable="YES"
saslauthd_flags="-a pam"
```

Run the saslauthd daemon with the following command.


```
root@router2:~ # service saslauthd restart
```
This daemon acts as a sendmail broker for authenticating against the passwd database on FreeBSD. This saves you the hassle of creating a new set of usernames and passwords for each user who needs to use SMTP authentication, and keeps the login password and email address the same.

Once the saslauthd daemon is running, type the following script into the `/etc/make.conf` file.

```
root@router2:~ # ee /etc/make.conf
SENDMAIL_CFLAGS=-I/usr/local/include/sasl -DSASL
SENDMAIL_LDFLAGS=-L/usr/local/lib
SENDMAIL_LDADD=-lsasl2
```
The above script provides Sendmail with the correct configuration options to link to `cyrus-sasl2` at compile time. Ensure cyrus-sasl2 is installed before recompiling Sendmail. Now let's recompile Sendmail by running the following command:

```
root@router2:~ # cd /usr/src/lib/libsmutil
root@router2:~ # make cleandir && make obj && make
root@router2:~ # cd /usr/src/lib/libsm
root@router2:~ # make cleandir && make obj && make
root@router2:~ # cd /usr/src/usr.sbin/sendmail
root@router2:~ # make cleandir && make obj && make && make install
```
After Sendmail is compiled and reinstalled, edit the `/etc/mail/freebsd.mc` file or a local .mc file. Many administrators prefer to use the output hostname as the .mc file name for uniqueness. Add this line to the `/etc/mail/freebsd.mc` file and place it at the end of the file.


```
root@router2:~ # ee /etc/mail/freebsd.mc
dnl set SASL options
TRUST_AUTH_MECH(`GSSAPI DIGEST-MD5 CRAM-MD5 LOGIN')dnl
define(`confAUTH_MECHANISMS', `GSSAPI DIGEST-MD5 CRAM-MD5 LOGIN')dnl
```

The final step is to run the make command while in `/etc/mail`. The script below will run the new .mc extension file and create a .cf extension file called freebsd.cf. Type the script below to copy the file to `sendmail.cf`.


```
root@router2:~ # cd /etc/mail
root@router2:/etc/mail # make install restart
```

Recompiling Sendmail should not be a problem if  `/usr/src` has not changed much and the necessary dependencies are available.