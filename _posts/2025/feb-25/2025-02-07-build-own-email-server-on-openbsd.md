---
title: Build Your Own Email Server on OpenBSD
date: "2025-02-06 09:17:10 +0100"
updated: "2025-02-06 09:17:10 +0100"
id: build-own-email-server-on-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/oct-25/Create-your-own-email-server-OpenSMTPD.jpg
toc: true
comments: true
published: true
excerpt: This tutorial will walk you through the process of installing OpenSMTPD on OpenBSD. OpenSMTPD is an open-source implementation of the Simple Mail Transfer Protocol.
keywords: mail server, openbsd, freebsd, email, email server, private, public
---

If you need to create your own free email server for your company or personal use (especially for small businesses), this information provides an interesting point. As a result, email can be sent worldwide through your free email server for that domain.

Why should we create our own email server?

## 1. Benefits of a Private Email Server

### a. Our Own Email Domain

Sending company emails from your own domain is a great idea to attract business interest. For example, `sales@mycompany.com`.

### b. Unlimited Users

We can create as many users as we want at no additional cost.

### c. Unlimited Targeting

Unlimited target addresses when sending emails. With external paid services, we have to pay per user.

### d. All data is under our own control

No one will be able to see our internal business conversations.

### e. Transmission Control

Some public email servers cannot send emails to certain domains, for example, protonmail.com, due to country restrictions. By hosting your own email server, you can manage these restrictions.

## 2. Building a small, secure email server with OpenBSD and OpenSMTPD

With the proliferation of fiber optic networks, many people are now trying to run their own email servers at home. Of course, if their ISP allows it not all ISPs allow traffic to port 25 on home user connections.

Considering that many home fiber optic networks have become havens for spammers, this is understandable. However, many ISPs are willing to remove the filter on port 25 once the customer demonstrates that they are not running an open relay and generally know what they are doing.

<br/>
{% lazyload data-src="/img/oct-25/Create-your-own-email-server-OpenSMTPD.jpg" src="Create-your-own-email-server-OpenSMTPD.jpg" alt="Build Your Own Email Server on OpenBSD" %}
<br/>

So, the day came when a true geek decided he needed to run his own email server from home. Since I've built several of them now, I thought it would be helpful for some people to provide a blueprint for setting one up for home use.

## 3. OpenSMTPD Installation Guide for OpenBSD

This tutorial will walk you through the process of installing OpenSMTPD on OpenBSD. OpenSMTPD is an open-source implementation of the Simple Mail Transfer Protocol. OpenSMTPD is designed with security in mind and is easy to configure.

Note: This tutorial assumes you are running OpenBSD.

To install OpenSMTPD on OpenBSD, follow these steps:

The first step is to update the OpenBSD package database.

```yml
hostname1# pkg_add -u
```

Once the update process is complete, you proceed with installing OpenSMTPD.

```yml
hostname1# pkg_add opensmtpd
```

Then you enable the OpenSMTPD service.

```yml
hostname1# rcctl enable smtpd
hostname1# rcctl start smtpd
```

After that, you verify that the OpenSMTPD service is running.

```yml
hostname1# rcctl check smtpd
```

## 4. How to Configure OpenSMTPD

By default, OpenSMTPD is ready to use without any configuration. However, if you want to customize the configuration, you can edit the /etc/mail/smtpd.conf configuration file.

To edit the configuration file using the vi editor, run the following command.

```yml
hostname1# nano /etc/mail/smtpd.conf
```

After making changes to the configuration file, you need to reload the OpenSMTPD service to apply the changes.

```yml
hostname1# rcctl reload smtpd
```

This is just a brief example of how to set up your own simple email server. There's much more you can do, from adding redundancy with multiple email servers to performing DNSBL and Bayesian analysis and filtering incoming email for SPAM.