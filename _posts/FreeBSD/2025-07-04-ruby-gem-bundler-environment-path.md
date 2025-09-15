---
title: FreeBSD Ruby Gemfile and Bundle Installation With Environment Path
date: "2025-07-04 09:15:23 +0100"
id: ruby-gem-bundler-environment-path
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: WebServer
excerpt: Gems, rbenv, and Bundler are essential tools for managing your Ruby application dependencies. Gems, rbenv, and Bundler can help you manage your application’s gem dependencies, ensuring your application runs smoothly and avoiding conflicts between different gem versions
keywords: ruby, gem. bundler, bundle, jekyll, freebsd, path, environment, installation
---

For beginner programmers, many may still be unfamiliar with Ruby because it is rarely used as a base. Ruby is one of the superior programming languages ​​for developing website applications. The Ruby programming language is designed with a focus on simplicity and productivity. Its intuitive and English-like syntax makes it easy to understand and use, especially for programming beginners.

One of Ruby's advantages is that it has a web development framework known as Ruby on Rails or often abbreviated as Rails. Before Rails, developers often spent a lot of time writing code over and over again. However, with Rails, this process is faster because Rails has the CoC (Convention over Configuration) principle and the DRY (Don't Repeat Yourself) principle.

CoC is an approach where the system provides built-in conventions to simplify common tasks, reducing the need for developers to configure every detail. While DRY encourages reducing duplication in code. This principle emphasizes the importance of storing information or logic in a single place in the code, ensuring that the code is easier to maintain, and minimizing errors.

On FreeBSD, managing and running Ruby applications usually involves specifying the Ruby version and the dependencies that will form the libraries to reference our project. Ruby has many dependencies, and you must install them all according to the project you are working on. See the image below.


<br/>

![FreeBSD Ruby Path environment](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/8_FreeBSD_Ruby_Path_environment.jpg)

<br/>



> Ruby adalah bahasa pemrograman berorientasi objek yang dinamis. Ruby dirancang dengan fokus pada kesederhanaan dan produktivitas..

<br/>


In this article, we will learn the Ruby installation process and the file library dependencies for Ruby. To complete the content of this article, we will also explain the process of creating Ruby PATH. We have implemented the entire content of this article on a FreeBSD 13.3 server, and you can also apply it to FreeBSD 14.


## 1. Install Ruby from the ports and PKG system
There are two ways to install applications on FreeBSD, namely the ports system and PKG packages. In this article, we will use both methods. Before you start installing Ruby, update and install Ruby dependencies. Follow the methods below.

```console
root@ns3:~ # pkg update -f
root@ns3:~ # pkg upgrade -f
```
```console
root@ns3:~ # portmaster -a
root@ns3:~ # portupgrade -a
```
Proceed with installing dependencies.

```console
root@ns3:~ # pkg install libffi autoconf automake libyaml libedit libunwind rubygem-atk rubygem-fpm rubygem-minitar-cli puppetdb-terminus7 puppetdb-terminus8 rubygem-activemodel61
```
Once you have finished installing the dependencies, proceed with installing Ruby.

```console
root@ns3:~ #  pkg install ruby32
```
```console
root@ns3:~ # cd /usr/ports/lang/ruby32
root@ns3:/usr/ports/lang/ruby32 # make install clean
```
By default, Ruby binary files are `"ruby32"`. Change the file to `"ruby"` by creating a symbolic link.

```console
root@ns3:~ # cd /usr/local/bin
root@ns3:/usr/local/bin # ln -s ruby32 /usr/local/bin/ruby
```
Check Ruby version.

```console
root@ns3:/usr/local/bin # ruby --version
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [amd64-freebsd13]
```

## 2. Creating PATH Environment Variable
By default, FreeBSD stores Ruby files (lib and bin) in the `/usr/local/lib/ruby` directory. To make it easier for you to manage Ruby files that will be used for work projects, we can change $PATH $HOME as desired.

In this article we will create $PATH $HOME for Ruby, Gem and Bundler. The method is very easy, you only need to add the script to .cshrc and csh.cshrc.

### a. Creating $PATH Directory
Before we start creating the $PATH environment variable for Ruby, first create a directory to place the $PATH file. Follow the instructions below.

```console
root@ns3:~ # mkdir -p /usr/local/ruby
root@ns3:~ # mkdir -p /usr/local/ruby/gems
root@ns3:~ # mkdir -p /usr/local/ruby/gems/lib
root@ns3:~ # mkdir -p /usr/local/ruby/bundle
root@ns3:~ # mkdir -p /usr/local/ruby/bundle/lib
```

### b. $PATH $HOME Ruby
To create a Path environment in a Ruby file, open the csh.cshrc file and add the script below.

```console
root@ns3:~ # ee /etc/csh.cshrc
setenv RUBY_VERSION "3.2+"
setenv RUBY_HOME /usr/local/ruby
```
Also open the `.cshrc` file and type the script below in that file.

```console
root@ns3:~ # ee .cshrc
set path = ($RUBY_HOME/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
```

### c. $PATH $HOME GEM
How to create $PATH $HOME for GEM is almost the same as Ruby. To avoid mess, we will place the working directory with the Ruby working directory. Follow the steps below to create $PATH $HOME GEM.

```console
root@ns3:~ # ee /etc/csh.cshrc
setenv GEM_HOME /usr/local/ruby/gems
setenv GEM_PATH /usr/local/ruby/gems/lib
```
Then in the `/root/.cshrc` file, type the script below.

```console
root@ns3:~ # ee .cshrc
set path = ($GEM_HOME/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
set path = ($GEM_PATH/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
```

### d. $PATH $HOME Bundler
In this section, we will create a $PATH $HOME Bundler. Not much different from above, open the `/etc/csh.cshrc` file, and type the script below.

```console
root@ns3:~ # ee /etc/csh.cshrc
setenv BUNDLE_HOME /usr/local/ruby/bundle
setenv BUNDLE_PATH /usr/local/ruby/bundle/lib
```
Then in the `/root/.bashrc` file, you add the script below.

```console
root@ns3:~ # ee .cshrc
set path = ($BUNDLE_HOME/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
set path = ($BUNDLE_PATH/bin /sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin $HOME/bin)
```

## 3. How to Install GEMS
Installing Ruby gems is an essential skill for developers. Ruby gems are an essential tool in your web development toolkit, simplifying the process of extending Ruby’s capabilities. Installing them correctly is essential for efficient and error-free coding.

RubyGems is a Ruby utility system designed to simplify, facilitate the creation, sharing, and installation of libraries. On Linux systems, RubyGems is nearly identical to the apt-get distribution packaging system for Ruby software. RubyGems is the de-facto method for sharing gems.

In this section, we will learn the process of installing RubyGems and how to use it on FreeBSD. Run the following command to install RubyGems.

```console
root@ns3:~ # cd /usr/ports/devel/ruby-gems
root@ns3:/usr/ports/devel/ruby-gems # make install clean
```

### a. Update Gems
Before starting a new project, run the update gem command to its latest version to get the latest features and fixes. Usually professional developers use some tricks to optimize the Ruby development environment and keep it up to date.

```console
root@ns3:~ # gem -v
3.4.20
```
```console
root@ns3:~ # gem update --system
```

### b. Install App with gems
A gem is a collection of related code used to solve a specific problem. Gems can be used to install Ruby Apps. See the example below to install an App with Gems.

```console
root@ns3:~ # gem install httparty
When you HTTParty, you must party hard!
Successfully installed httparty-0.21.0
Parsing documentation for httparty-0.21.0
Done installing documentation for httparty after 1 seconds
1 gem installed
```
To install Multiple Gems, you can also install multiple gems at once by listing them all in one gem install command.

```console
root@ns3:~ # gem install rails puma nokogiri
```
You can run the update command to update the Application.

```console
root@ns3:~ # gem update httparty
root@ns3:~ # gem update rails puma nokogiri
```

### c. Viewing the list of installed gems
You can view a list of all the gems installed with Ruby.

```console
root@ns3:~ # gem list
```
Run the following command, to check whether the installed gem is out of date.

```console
root@ns3:~ # gem outdated
```

### d. Remove Gems
To remove installed gems, run the uninstall gems command.

```console
root@ns3:~ # gem uninstall httparty
Remove executables:
        httparty

in addition to the gem? [Yn]  y
Removing httparty
Successfully uninstalled httparty-0.21.0
```

## 4. How to Install Bundler
Bundler is a Ruby utility for creating a consistent application environment for your application, allowing you to specify library versions for the project you are working on. Bundler provides a consistent environment for your Ruby projects.

Bundler can track and install the right gems and versions for the project you are working on. Bundler can also prevent dependencies and ensure that the gems you need are in development, preparation, and production. Run the following command to install bundler on your FreeBSD server.

```console
root@ns3:~ # cd /usr/ports/sysutils/rubygem-bundler
root@ns3:/usr/ports/sysutils/rubygem-bundler # make install clean
```
In this article, we will explain how to use Bundler on FreeBSD. For example, we create a new working directory, after which we create a Gemfile. Follow the guide below.

```console
root@ns3:~ # mkdir -p /usr/local/www/FreeBSD_Gem
root@ns3:~ # cd /usr/local/www/FreeBSD_Gem
root@ns3:/usr/local/www/FreeBSD_Gem # touch Gemfile
```
After that, in the Gemfile file, type the script below.

```console
root@ns3:/usr/local/www/FreeBSD_Gem # ee Gemfile
source 'https://rubygems.org'

gem 'rails'
gem 'httparty'

gem 'fui', '~> 0.3.0'
gem 'nokogiri'
gem 'second_curtain', '~> 0.2.3'
gem 'puma'
```
After creating the Gemfile, run bundle install to install or bundle update to update according to your Gemfile's constraints.

```console
root@ns3:/usr/local/www/FreeBSD_Gem # bundle install
root@ns3:/usr/local/www/FreeBSD_Gem # bundle update
```
Run the bundle dated command to list the gems in your project that have newer versions.

```console
root@ns3:/usr/local/www/FreeBSD_Gem # bundle outdated
Fetching gem metadata from https://rubygems.org/...........
Resolving dependencies...

Gem             Current  Latest  Requested  Groups
fui             0.3.0    0.5.0   ~> 0.3.0   default
json            1.8.6    2.7.1
mustache        0.99.8   1.1.1
second_curtain  0.2.4    0.6.0   ~> 0.2.3   default
```
To verify installed gems, you can run the gem list command.

```
root@ns3:/usr/local/www/FreeBSD_Gem # gem list
```

## 5. How to Install rbenv
rbenv is a utility for the Ruby programming language on Unix-like systems such as FreeBSD. rbenv is very useful for switching between multiple versions of Ruby on the same machine. In addition, rbenv is also useful for ensuring that every project you work on always runs on the correct version of Ruby.

To install rbenv on FreeBSD is very easy, you just run the install command, as in the example below.

```console
root@ns3:~ # cd /usr/ports/devel/rbenv
root@ns3:/usr/ports/devel/rbenv # make install clean
```
After that, you check the version of rbenv used on FreeBSD.

```console
root@ns3:~ # rbenv --version
rbenv 1.2.0
```
You can create an rbenv project by running the following command.

```console
root@ns3:~ # cd /usr/local/www/FreeBSD_Gem
root@ns3:/usr/local/www/FreeBSD_Gem # rbenv init
```
Gems, rbenv, and Bundler are essential tools for managing your Ruby application dependencies. Gems, rbenv, and Bundler can help you manage your application’s gem dependencies, ensuring your application runs smoothly and avoiding conflicts between different gem versions. By understanding how Gems and Bundler work, you can make your Ruby applications more powerful, easier to manage, and more enjoyable to use.