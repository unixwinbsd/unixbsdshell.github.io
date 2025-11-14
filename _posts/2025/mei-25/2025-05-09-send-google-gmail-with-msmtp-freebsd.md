---
title: Send Google Gmail Email with msmtp and FreeBSD
date: "2025-05-09 11:01:00 +0100"
updated: "2025-05-09 11:01:00 +0100"
id: send-google-gmail-with-msmtp-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: /img/oct-25/oct-25-0001.jpg
toc: true
comments: true
published: true
excerpt: Sending emails with a private server is indeed very fun, you will face challenges that you find difficult. For most people, sending emails is usually done using a web browser like Google Chrome with an attractive image display. Now we will try to send emails via the command line with a private server that we have configured.
keywords: email, google, gmail, msmtp, freebsd, command, server
---

There are many reasons why sending emails from a server or via the command line is very useful. Because you are too lazy to log in to a Gmail account connected to 2FA or for security reasons. Whatever your reasons, sending emails using the command line is worth a try, either as a lesson or as a routine job for a system administrator.

Sending emails with a private server is indeed very fun, you will face challenges that you find difficult. For most people, sending emails is usually done using a web browser like Google Chrome with an attractive image display. Now we will try to send emails via the command line with a private server that we have configured.

However, to configure an email server with exim, sendmail or postfix, exim requires many steps and you will also be faced with difficult and confusing configurations. However, you can simply use an existing email account, and send via MSMTP email like a traditional email client.

In this tutorial, we will guide and explain how to send emails to a Google account with the help of MSMTP. This article will help you with the process of installing and configuring MSMTP on a FreeBSD server.

<br/>
{% lazyload data-src="/img/oct-25/oct-25-0001.jpg" src="/img/oct-25/oct-25-0001.jpg" alt="Send Google Gmail Email with msmtp and FreeBSD" %}
<br/>

## 1. How to Install MSMTP
Before you install MSMTP, update the FreeBSD pkg package or system ports. This process ensures that your system has the latest repository updates. Run the command below to update the PKG package or ports.

```console
root@ns3:~ # pkg update -f
root@ns3:~ # pkg upgrade -f
root@ns3:~ # portmaster -a
root@ns3:~ # portupgrde -a
```
Proceed by installing msmtp dependencies.

```console
root@ns3:~ # pkg install ca_root_nss bash indexinfo gnutls gettext-runtime
```
Once the above steps are complete, you can proceed with installing msmtp. We will use the port system to install msmtp on FreeBSD.

```console
root@ns3:~ # cd /usr/ports/mail/msmtp
root@ns3:/usr/ports/mail/msmtp # make install clean
```
Type the script below in `/etc/mail/mailer.conf` file.

```console
root@ns3:~ # ee /etc/mail/mailer.conf
sendmail        /usr/local/bin/msmtp
send-mail       /usr/local/bin/msmtp
mailq           /usr/local/bin/msmtp
newaliases      /usr/local/bin/msmtp
hoststat        /usr/bin/true
purgestat       /usr/bin/true
```

## 2. Create Gmail app password
To send email with msmtp command, you have to do a little configuration on your Gmail account. In msmtp, your Gmail password does not work, msmtp only requires `"Gmail app password"`. Follow the steps below to create `"Gmail app password"`.

##### a. Open your Gmail account.
##### b. Click the Security menu on the left.
##### c. Click "2-Step Verification"

<br/>
{% lazyload data-src="/img/oct-25/oct-25-0002.jpg" src="/img/oct-25/oct-25-0002.jpg" alt="Create app password Gmail" %}
<br/>


##### d. Click "App passwords" at the very bottom.

<br/>
{% lazyload data-src="/img/oct-25/oct-25-0003.jpg" src="/img/oct-25/oct-25-0003.jpg" alt="Klick app password Gmail" %}
<br/>


##### e. Click "Your app passwords", type the name of the application you want to create, for example "Test_FreeBSD_MSMTP"

<br/>
{% lazyload data-src="/img/oct-25/oct-25-0004.jpg" src="/img/oct-25/oct-25-0004.jpg" alt="Test FreeBSD MSMTP email" %}
<br/>


##### f. After that, "password app" will appear. Later you will use this password to configure MSMTP.

<br/>
{% lazyload data-src="/img/oct-25/oct-25-0005.jpg" src="/img/oct-25/oct-25-0005.jpg" alt="password to configure MSMTP" %}
<br/>


## 3. MSMTP Configuration
In this section we will configure MSMTP to connect to Gmail servers. In `/root` you create a `.msmtprc` file.

```
root@ns3:~ # touch .msmtprc
```
Once you have finished creating the `/root/.msmtprc` file, type the following script in the file.

```console
root@ns3:~ # ee /root/.msmtprc
defaults
auth           on
tls            on
tls_trust_file /usr/local/share/certs/ca-root-nss.crt
logfile /root/.msmtp.log

# Gmail
account         gmail
host            smtp.gmail.com
port            587
from datainchi@gmail.com
user datainchi
password thll cbrj ahvd pkrw

# Set a default account
account default : gmail
```
The next step is to create a symbolic link file `.msmtprc`.

```
root@ns3:~ # ln -s /root/.msmtprc /usr/local/etc/msmtprc
```

Create a log file to store all activities performed by MSMTP.

```console
root@ns3:~ # touch /root/.msmtp.log
```

Note the `.msmtprc` script, the file says **"tls_trust_file"**. We use the FreeBSD default TLS script that comes from the `ca_root_nss` application. The file is located in the `/usr/local/share/certs` directory. And we take the password from the Gmail account we created earlier, namely **"thll cbrj ahvd pkrw"**.

The next step is to Change permissions.

```console
root@ns3:~ # chmod 0777 /root/.msmtp.log
root@ns3:~ # chmod 0644 /root/.msmtprc
```

## 4. Test By Sending Email To Gmail
Now we will run the MSMTP server, by sending Email through the command line. Run the following command to send an email to your Gmail account, friends or family.

```
root@ns3:~ # echo "Good Morning FreeBSD. I use the FreeBSD MSMTP server to send email to a Gmail account" | mail -s "Test Email" inchimediatama@gmail.com
```

The above command is used to send email, from MSMTP server.

From: **datainchi@gmail.com**

To: **inchimediatama@gmail.com**

The `-s` option in the above script is the subject of the email you are going to send.

You can see the results in the `“sent”` menu of your email account, in this example `"datainchi@gmail.com"`.

<br/>
{% lazyload data-src="/img/oct-25/oct-25-0006.jpg" src="/img/oct-25/oct-25-0006.jpg" alt="Sent menu email msmtp" %}
<br/>

By following all the guides in this article, you have successfully sent email via command line. It is very easy and simple to use. If you are interested in this guide, you can develop it with PHP commands or others.