---
title: Setup OpenSMTPD SMTP Mail Relay to Google's gmail With FreeBSD
date: "2025-06-04 15:50:05 +0100"
updated: "2025-06-04 15:50:05 +0100"
id: opensmtpd-smtp-mail-relay-google-gmail-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://avatars.dzeninfra.ru/get-zen_doc/271828/pub_684053c0c8677d586f684376_684056e9443a9c0119ea6f8c/scale_1200
toc: true
comments: true
published: true
excerpt: OpenSMTPD is part of the OpenBSD project developed by Gilles Chehade, Pierre-Yves Ritschard, Jacek Masiulaniec and many others who are members of the OpenBSD project. Its primary goal is to be a secure mailing daemon without the licensing restrictions of Postfix and without the added complexity of sendmail
keywords: opensmtpd, smtp, mail, relay, google, gmail, freebsd, msmtp
---

There are many reasons people have for running a dedicated email server, such as privacy concerns or simply wanting to do it for fun and to learn about building a private server. Whatever the reason, building a private server is satisfying or perhaps beneficial for everyone.

OpenSMTPD is part of the OpenBSD project developed by Gilles Chehade, Pierre-Yves Ritschard, Jacek Masiulaniec and many others who are members of the OpenBSD project. Its primary goal is to be a secure mailing daemon without the licensing restrictions of Postfix and without the added complexity of sendmail. OpenSMTP is very stable, fast, secure and easy to configure, use and is under the ISC license.

OpenSMTPD is a free, easy-to-use and simple implementation of the Simple Mail Transfer Protocol. OpenSMTPD was created to make it easy to send and receive email, as well as acting as a relay host. It aims to be reliable and respect RFCs and standard behavior if it does not reduce overall system security.

<br>
![freebsd Relay Email SMTP OpenSMTPD](https://avatars.dzeninfra.ru/get-zen_doc/271828/pub_684053c0c8677d586f684376_684056e9443a9c0119ea6f8c/scale_1200)
<br>


In this article, we will explain the process of installing, configuring and using OpenSMTP on FreeBSD. This guide is intended for people familiar with the Linux and BSD command lines.


## 1. Initial Setup OpenSMTP

On FreeBSD servers OpenSMTPD is included in the PKG package or port. In this discussion we will explain several examples running on the FreeBSD server. You can also use every configuration in this article on OpenBSD. The only difference is the file path.

First, we need to install the dependencies that OpenSMTPD requires, namely build and library dependencies.

```console
root@ns3:~ # pkg install groff libevent opensmtpd-extras
```
Now you can install OpenSMTPd, the `PORTS` system is highly recommended, although the installation process takes a long time, all libraries can be installed perfectly.

```console
root@ns3:~ # cd /usr/ports/mail/opensmtpd
root@ns3:/usr/ports/mail/opensmtpd # make install clean
```
Create an OpenSMTPd script to run automatically on FreeBSD. Type the script below in the `/etc/rc.conf` file.

```console
root@ns3:~ # ee /etc/rc.conf
smtpd_enable="YES"
smtpd_config="/usr/local/etc/mail/smtpd.conf"
smtpd_procname="/usr/local/sbin/smtpd"
smtpd_flags=""
```
You must also disable sendmail in the `/etc/rc.conf` file.

```console
root@ns3:~ # ee /etc/rc.conf
sendmail_enable="NONE"
```


## 2. OpenSMTPD Configuration

The OpenSMTP configuration file is `smtpd.conf`. You can change the script file according to your FreeBSD server needs and specifications.

Below is an example of the `/usr/local/etc/mail/smtpd.conf` script.

```console
root@ns3:~ # ee /usr/local/etc/mail/smtpd.conf
table aliases file:/etc/mail/aliases
table secrets file:/etc/mail/secrets
table domains file:/etc/mail/domains

listen on 127.0.0.1 port 25 hostname datainchi.com

action "local" maildir alias <aliases>
action "relay" relay

match for local action "local"
match from local for any action "relay"
```
Create secret and domain folders, then change permissions and ownership.

```console
root@ns3:~ # touch /etc/mail/secrets
root@ns3:~ # touch /etc/mail/domains
root@ns3:~ # chmod 640 /etc/mail/secrets
root@ns3:~ # chown root:_smtpd /etc/mail/secrets
root@ns3:~ # chmod 640 /etc/mail/domains
root@ns3:~ # chown root:_smtpd /etc/mail/domains
```
Update permissions and ownership.

```console
root@ns3:~ # mkdir -p /var/spool/smtpd/corrupt
root@ns3:~ # chown -R _smtpq:wheel /var/spool/smtpd/corrupt
root@ns3:~ # chown -R root:_smtpq /var/spool/smtpd/offline
root@ns3:~ # chown -R _smtpq:wheel /var/spool/smtpd/purge
root@ns3:~ # chown -R _smtpq:wheel /var/spool/smtpd/queue
root@ns3:~ # chown -R _smtpq:wheel /var/spool/smtpd/temporary
root@ns3:~ # chmod -R 770 /var/spool/smtpd/offline
root@ns3:~ # chmod -R 700 /var/spool/smtpd/purge
```
In the `/etc/mail/mailer.conf` file, type the script below.

```console
root@ns3:~ # ee /etc/mail/mailer.conf
sendmail        /usr/local/sbin/smtpctl
send-mail       /usr/local/sbin/smtpctl
mailq           /usr/local/sbin/smtpctl
makemap         /usr/local/libexec/opensmtpd/makemap
newaliases      /usr/local/libexec/opensmtpd/makemap
```
Check the validity errors of your configuration file, `/usr/local/etc/mail/smtpd.conf`.

```console
root@ns3:~ # smtpd -n
configuration OK
```


## 3. Mail Delivery and Eelay to Google's GMAIL

After you have successfully installed and configured OpenSMTPD, the next step we will use OpenSMTPD to send email to a Gmail account. In this example we will send a Gmail email from datainchi@gmail.com to inchimediatama@gmail.com.

In OpenSMTPD, the process of sending an email to a Gmail account requires your email account password. For my use case, I use a GMail account that requires two-factor authentication. Therefore, I have to use App Password instead of regular password. For GMail users who experience a similar situation, you can read instructions on how to create an Application Password in our previous article.

<div align="center">

[Freebsd Send Emails Gmail with msmtp Command](https://unixwinbsd.site/en/freebsd/2025/05/09/send-google-gmail-with-msmtp-freebsd/)

</div>

After that, open the `/usr/local/etc/mail/smtpd.conf` file, look for the relay action script "relay" and replace it with the script below.

```console
root@ns3:~ # ee /usr/local/etc/mail/smtpd.conf
table aliases file:/etc/mail/aliases
table secrets file:/etc/mail/secrets
table domains file:/etc/mail/domains

listen on 127.0.0.1 port 25 hostname datainchi.com

action "local" maildir alias <aliases>
####action "relay" relay
action "relay" relay host smtp+tls://label@smtp.gmail.com:587 auth <secrets>

match for local action "local"
match from local for any action "relay"
```
Open the `/etc/mail/secrets` file and type in the password that comes from your Gmail account's `"App Password"`. In this example the password: App Password is **"thll cbrj ahvd pkrw"**.

```console
root@ns3:~ # ee /etc/mail/secrets
label datainchi@gmail.com:thll cbrj ahvd pkrw
```
Run the command below to send an email to a Gmail account.

```console
root@ns3:~ # echo "FreeBSD OpenSMTPD" | mail -s "Setup OpenSMTPD SMTP Mail Server With FreeBSD" inchimediatama@gmail.com
```

If everything works and there is nothing wrong with the above configuration, you will receive an email at the specified address.