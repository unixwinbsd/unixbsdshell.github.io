---
title: FreeBSD SSO - Drupal and GitHub integration With Drupal OAuth Client
date: "2025-10-06 08:43:21 +0100"
updated: "2025-10-06 08:43:21 +0100"
id: freebsd-sso-drupal-and-github-integration-drupal-oauth-client
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-43.jpg
toc: true
comments: true
published: true
excerpt: The Drupal OAuth Client Module functionality will enable Single Sign-On i.e. SSO for Drupal websites with any Identity Provider that uses OAuth or OpenID connection protocols. Here we will go through the steps to configure the module with GitHub. Once this configuration is complete, users will be able to log in to the Drupal site using their GitHub credentials.
keywords: freebsd, sso, drupal, drush, cli, github, integration, oauth, client
---


The Authorization Code Grant Type is the most common and widely used OAuth 2.0 grant type. Providing authorization codes is commonly used by web and mobile applications. The presence of OAuth will force clients to exchange authorization codes with the OAuth server for access tokens.

The Drupal OAuth Client Module functionality will enable Single Sign-On i.e. SSO for Drupal websites with any Identity Provider that uses OAuth or OpenID connection protocols. Here we will go through the steps to configure the module with GitHub. Once this configuration is complete, users will be able to log in to the Drupal site using their GitHub credentials.

Drupal's integration with GitHub simplifies and secures the login process, eliminating the need to store, remember, and reset multiple passwords.

![oct-25-43](/img/oct-25/oct-25-43.jpg)


In this article we will try to help you configure GitHub as an OAuth Provider and make Drupal an OAuth Client. Follow all the steps in this article guide, so you can easily configure OAuth/OpenID SSO between GitHub and your Drupal website. The goal of writing this article is to enable your users to log in to your Drupal site using their GitHub credentials.


## 1. Single Sign-On (SSO) With miniorange

In this chapter we will integrate a Drupal website with a Github server via miniOrange SSO using the OAuth/OpenID protocol. The Drupal OAuth 2.0/OpenID connection module provides the ability to enable login using OAuth 2.0/OIDC Single Sign-On between Drupal and Github websites.

There are many ways to activate the Miniorange OAuth Client in Drupal. For those of you who are familiar with PHP, you can use Composer, but for those of you who like shell menus, you can use Drush.

Below is a guide to install and activate Miniorange OAuth Client with composer PHP and Drush.

```
root@ns3:~ # cd /usr/local/www/drupal10
root@ns3:/usr/local/www/drupal10 # composer require drupal/miniorange_oauth_client
```

Activate Miniorange OAuth Client with Drush.

```
root@ns3:/usr/local/www/drupal10 # cd /usr/local/www/drupal10/modules/contrib
root@ns3:/usr/local/www/drupal10/modules/contrib # drush en miniorange_oauth_client
```

With the command above, you have successfully activated Miniorange OAuth Client on the Drupal site.

If you want to delete, run the following command.

```
root@ns3:/usr/local/www/drupal10/modules/contrib # drush pm-uninstall miniorange_oauth_client
```


## 2. Setup Drupal as OAuth Client

After installing and activating the Miniorange OAuth Client module, you must configure it to connect to the Github server. Configuring Miniorange OAuth Client can only be done in a web browser. Open Google Chrome and type `"http://192.168.5.2/drupal/"`.

**Follow the instructions below to start configuring Miniorange OAuth Client:**

**1. Click Menu Extend**


![oct-25-44](/img/oct-25/oct-25-44.jpg)



**2. Click Menu OAuth / OpenID Connect**


![oct-25-45](/img/oct-25/oct-25-45.jpg)



Client ID and Client Secret come from your Github account. Open your Github account, and log in.

**3. Click Menu Setting**


![oct-25-46](/img/oct-25/oct-25-46.jpg)



**4. Click Menu Developer Settings (The very bottom)**


![oct-25-47](/img/oct-25/oct-25-47.jpg)



**5. Click Menu OAuth Apps**


![oct-25-48](/img/oct-25/oct-25-48.jpg)


**6. In the "Register a new OAuth application" menu, type in accordance with the data in the "Miniorange OAuth Client" that you opened on the Drupal site.**


![oct-25-49](/img/oct-25/oct-25-49.jpg)



After that the "Application created successfully" menu appears.

![oct-25-50](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-50.jpg)



**7. Click Generate a new client secret**


![oct-25-51](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/images/oct-25-51.jpg)



**8. Copy the Client ID and Client secrets to the Miniorange OAuth Client that you opened on the Drupal site and click the "Save Configuration" button.**

![oct-25-52](/img/oct-25/oct-25-52.jpg)



**9. Click the "Perform Test Configuration" button**


![oct-25-53](/img/oct-25/oct-25-53.jpg)

<br/>

![oct-25-54](/img/oct-25/oct-25-54.jpg)

<br/>

![oct-25-55](/img/oct-25/oct-25-55.jpg)


After studying the entire content of the article, it is clear that the post provides useful knowledge about Configuring Github As Oauth Provider With Drupal As Oauth Client For SSO. Throughout the article, the author illustrates a lot of knowledge about the topic, supplemented with images will make it easier for readers to learn Drupal.