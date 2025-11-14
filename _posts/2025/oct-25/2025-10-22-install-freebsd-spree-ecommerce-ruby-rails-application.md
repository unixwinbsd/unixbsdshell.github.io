---
title: FreeBSD How to Install Spree E-Commerce into a Ruby on Rails Application
date: "2025-10-22 08:51:24 +0100"
updated: "2025-10-22 08:51:24 +0100"
id: freebsd-spree-ecommerce-ruby-rails-application
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: /img/oct-25/oct-25-127.jpg
toc: true
comments: true
published: true
excerpt: In this article, we will explain the installation and configuration process of Spree Commerce with Ruby on Rails on a FreeBSD machine and the entire content of this article is written using the following applications and utilities
keywords: freebsd, mysql, sprre, ecommerce, commerce, ruby, rails, gem, bundle, bundler, jekyll
---

Spree Commerce, created by Sean Schofield and now developed by Spark Solutions, is a modular and versatile open-source e-commerce platform that allows for easy integration with any third-party integration. Spree Commerce is built with Ruby on Rails and is a solution for merchants using e-commerce platforms. Because Spree Commerce is open-source, modular, and API-driven, it is very easy and secure to use.

Spree eCommerce's open-source B2B e-commerce platform is aimed at merchants running online businesses, which are currently experiencing rapid growth. Each new major release includes several different gems and modules. Spree also uses the ImageMagick library to process and manipulate product images, thereby attracting consumers to view and purchase.

Today, Spree Commerce is accessible not only on computers; its comprehensive features are also conveniently used on mobile devices. Furthermore, Spree Commerce's open-source e-commerce software utilizes the Open Graph protocol to enhance product sharing on social media channels like LinkedIn, Instagram, Facebook, and Twitter.

In short, Spree Commerce is a comprehensive e-commerce framework that offers scalable, open-source solutions for entrepreneurs. Simply put, it's a collection of free code that web developers can use to shape and build beautiful digital storefronts.

As an open-source e-commerce solution, Spree Commerce offers a unique experience for those building profitable online stores. Unlike other hosted e-commerce solutions for building your online store, Spree Commerce gives you a lot of freedom.

You can essentially build any website suitable for your business, as long as you're comfortable with the coding language.

On the positive side, Spree Commerce offers a wide range of in-depth design customization options, with a variety of features and payment gateways to explore. Conversely, you'll need some website builder knowledge to start building your e-commerce website.

<br/>

![spree commerce diagram](/img/oct-25/oct-25-127.jpg)

<br/>

In this article, we will explain the installation and configuration process of Spree Commerce with `Ruby on Rails` on a FreeBSD machine and the entire content of this article is written using the following applications and utilities:

- Operating system: FreeBSD 13.3
- IP Addres: 192.168.5.2
- Name server: ns3
- Ruby version: ruby 3.1.4p223 (2023-03-30 revision 957bb7cb81) [amd64-freebsd13]
- Bundler version: Bundler 2.3.6
- Gem version: gems 3.5.7
- Database: Postgresql15-server
- Web Server: Apache24 (optional)
- Database: Postgresql15-server, SQLite3 or MySQL

## 1. Spree Commerce Installation

Before we begin installing Spree Commerce, ensure all the above applications are properly installed on your FreeBSD computer. Otherwise, you won't be able to run Spree Commerce on FreeBSD. If you're having trouble installing Ruby, please read our previous article. [Complete Guide to Installing the Ruby Programming Environment](https://unixwinbsd.site/freebsd/ruby-gem-bundler-environment-path).

One drawback of FreeBSD is that the Spree Commerce repository isn't available as a PKG package or system port. You can download Spree from its GitHub repository. Run the following command to clone Spree Commerce.

```sh
root@ns3:~ # cd /usr/local/www
root@ns3:/usr/local/www # git clone https://github.com/spree/spree.git
```

Next, you create users and groups for Spree Commerce, this is so that Spree Commerce can run smoothly and not collide with other Ruby applications.

```sh
root@ns3:/usr/local/www # pw add group spree
root@ns3:/usr/local/www # pw add user -n spree -g spree -s /sbin/nologin -c "spree user"
```

Run the chown and chmod commands to grant permissions and ownership to Spree Commerce.

```sh
root@ns3:/usr/local/www # chown -R spree:spree /usr/local/www/spree/
root@ns3:/usr/local/www # chmod -R 775 /usr/local/www/spree
```

## 2. Prepare Spree Commerce

The next step is to configure Spree Commerce. This section is quite lengthy, so don't skip any configurations or scripts.

### a. Bundler Settings

Before you install the gem, run the Initialize Bundler command.

```sh
root@ns3:/usr/local/www # cd spree
root@ns3:/usr/local/www/spree # rm Gemfile
root@ns3:/usr/local/www/spree # bundle init
```

### b. Add Spree gems to your Gemfile

In this section, we install the Spree gem so you can use its extension generator. In your Spree directory, open the Gemfile file and type the script below in the Gemfile file.

```
root@ns3:/usr/local/www/spree # ee Gemfile
# frozen_string_literal: true
source "https://rubygems.org"

gem "rails"
gem "spree"
gem "spree_backend"
gem "spree_frontend"
gem "spree_emails"
gem "spree_sample"
gem "spree_auth_devise"
gem "spree_gateway"
gem "spree_i18n" 
# only needed for MacOS and Ruby 3+
gem "sassc", github: 'sass/sassc-ruby', branch: 'master'
gem "railties"
```

### c. Process of installing gems Gemfile

Then install the Spree Commerce extension dependencies.

```sh
root@ns3:/usr/local/www/spree # bundle install
root@ns3:/usr/local/www/spree # bundle update
```
After that, in the `/usr/local/www/spree/bin` directory, run the command below.

```sh
root@ns3:/usr/local/www/spree # bin/bundle_ruby.sh
root@ns3:/usr/local/www/spree # bin/build.sh
root@ns3:/usr/local/www/spree # git config --global --add safe.directory /usr/local/www/spree
root@ns3:/usr/local/www/spree # rake db:migrate
```

### d. Create a new Rails application

Run the `rails new` command to create a new Rails application with the default directory structure and configuration at the path you specified, namely `/usr/local/www/spree/weblog`.

```sh
root@ns3:/usr/local/www/spree # rails new /usr/local/www/spree/weblog
root@ns3:/usr/local/www/spree # rails _7.1.3.2_ new weblog
root@ns3:/usr/local/www/spree # rails new weblog --api
root@ns3:/usr/local/www/spree # rails new weblog --skip-action-mailer
```

The above command will create a new rails directory named `"weblog"`.

### e. Generator installation process

The next step is to run the installation generator on the Rails weblog you created above. This command is used to set up Spree Commerce. Before running the installation generator, add the following script to the Gemfile in the `/usr/local/www/spree/weblog` directory.

```sh
root@ns3:/usr/local/www/spree # cd weblog
root@ns3:/usr/local/www/spree/weblog # ee Gemfile
gem "spree"
gem "spree_backend"
gem "spree_frontend"
gem "spree_emails"
gem "spree_sample"
gem "spree_auth_devise"
gem "spree_gateway"
gem "spree_i18n" 
# only needed for MacOS and Ruby 3+
gem "sassc", github: 'sass/sassc-ruby', branch: 'master'
gem "railties"
```
Run the installation generator on the Rails weblog.

```sh
root@ns3:/usr/local/www/spree/weblog # bundle install
root@ns3:/usr/local/www/spree/weblog # bundle update
```

<br/>

```
root@ns3:/usr/local/www/spree/weblog # bin/rails g spree:install --user_class=Spree::User
root@ns3:/usr/local/www/spree/weblog # bin/rails g spree:backend:install
root@ns3:/usr/local/www/spree/weblog # bin/rails g spree:frontend:install
root@ns3:/usr/local/www/spree/weblog # bin/rails g spree:auth:install
root@ns3:/usr/local/www/spree/weblog # bin/rails g spree_gateway:install
```

In the `/usr/local/www/spree/weblog` directory, run the Run bin/setup command.

```
root@ns3:/usr/local/www/spree/weblog # bin/setup
```

### f. Installation options

By default, when you run the installation generator command, the migration will run automatically and add the seed. This can be disabled using the command.

```sh
root@ns3:/usr/local/www/spree/weblog # bin/rails g spree:install --migrate=false --sample=false --seed=false
```

You also run the command below.

```sh
root@ns3:/usr/local/www/spree/weblog # bin/rake railties:install:migrations
root@ns3:/usr/local/www/spree/weblog # bin/rails db:migrate
root@ns3:/usr/local/www/spree/weblog # bin/rails db:seed
root@ns3:/usr/local/www/spree/weblog # bin/rake spree_sample:load
```

### g. Installing the Spree Spree Commerce machine

When you run the rails g spree:install command, it will automatically install Spree, installing the Spree::Core::Engine component by automatically inserting this line into `config/routes.rb`.

```
root@ns3:/usr/local/www/spree/weblog # mount Spree::Core::Engine, at: '/'
```

## 3. Run Spree Commerce

Once you've completed all the Spree Commerce configuration steps above, the next step is to run Spree Commerce. Type the following command into your shell menu.

```sh
root@ns3:/usr/local/www/spree/weblog # rails s -b 192.168.5.2
```
Open your favorite web browser, such as Google Chrome, and type `http://192.168.5.2:3000/admin`. This will bring up the login menu. If you haven't changed your username and password, the default Spree Commerce username and password are:

- user: **spree@example.com**
- password: **spree123**

<br/>

![spree commerce login](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/oct-25/oct-25-128.jpg)

<br/>

Once you have successfully logged into Spree Commerce, your monitor screen will appear as shown in the image below.

<br/>

![api key spree commerce](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/oct-25/oct-25-129.jpg)

<br/>

![spree commerce dashboard](https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/oct-25/oct-25-130.jpg)

<br/>

In this tutorial, we've explained how to install and configure the Spree Commerce e-commerce platform on a FreeBSD server. You can continue to hone and explore all of Spree Commerce's features so you can use it to sell goods and products online and grow your business.
