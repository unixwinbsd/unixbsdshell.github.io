---
title: Creating a Gnome Keyring on Ubuntu Desktop
date: "2025-11-19 07:33:45 +0000"
updated: "2025-11-19 07:33:45 +0000"
id: creating-gnome-keyring-on-ubuntu-desktop
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/nop-25-0019.jpg
toc: true
comments: true
published: true
excerpt: Gnome Keyring is not available on other platforms and systems and it is not even easy to transfer or even sync your key-ring to other Ubuntu Desktop systems you may be using.
keywords: ubuntu, gnome, keyring, desktop, windows, linux, debian, mate
---

Gnome Keyring, sometimes called "Passwords and Keys," is the default manager for all your secrets during your Ubuntu Desktop session. It is an integral part of the Ubuntu Desktop system and is therefore installed by default.

The keyring is a database storage for your user profile. The keyring is encrypted with your login passphrase and associated with your session. Once you log out, the keyring and everything within it are closed.

The next time you log in, the keyring is decrypted and all login credentials are available again, leaving you with only your Ubuntu Desktop password. This means that all passwords, passphrases, used by any application, or network connection during your desktop session are managed and remembered in the keyring.

While having an integrated solution on your desktop for managing your secrets is convenient, it remains a local solution limited to your Ubuntu desktop system.

Gnome Keyring is not available on other platforms and systems, and it is not easy to transfer or even synchronize your keyring to other Ubuntu Desktop systems you may be using.

<img alt="Gnome Keyring and KeePassXC on Ubuntu Desktop" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/nop-25-0019.jpg' | relative_url }}">

Mozilla Firefox and Thunderbird products use their own password and certificate stores. Therefore, login credentials for websites and email servers are not managed by Gnome Keyring.

Gnome Keyring also manages access to your SSH keys, certificates, and TLS (x.509) keys. Unfortunately, the Gnome Keyring agent is no longer compatible with newer versions of OpenSSH.

## A. Disabling SSH Gnome-Keyring

- It doesn't handle newer SSH key formats (ed22519, etc.).
- It automatically loads all keys in ~/.ssh on startup.
- You can't remove these keys, even with ssh-add -D, and
- The agent doesn't respect certain important restrictions on added keys, such as the -c option, which requires me to confirm the use of loaded keys.

The agent is started automatically at each login by the desktop file gnome-keyring-ssh.desktop in the system configuration folder /etc/xdg/autostart/. You can disable this by copying the desktop file to the user configuration folder ~/.config/autostart and then adding a configuration command to disable autostart.

Because user-specific configurations take precedence over system-wide settings, only your personal desktop file will be used.

**Copy the file to the desktop:**

```console
$ mkdir -p ~/.config/autostart
$ cp /etc/xdg/autostart/gnome-keyring-ssh.desktop ~/.config/autostart/
```

Add the following line to disable autostart:

```console
$ echo 'X-GNOME-Autostart-enabled=false' \
    >> ~/.config/autostart/gnome-keyring-ssh.desktop
```

This will be active on your next login. For your current session, restart (aka "replace") the already running Gnome Keyring Daemon, without the agent part.

```yml
$ /usr/bin/gnome-keyring-daemon --replace --components keyring,pkcs11
```

## B. KeePassXC

The best thing a computer can do is store information.

You don't have to waste time trying to remember and type passwords. KeePassXC can securely store your passwords and automatically type them into your everyday websites and applications.

KeePassXC is perhaps the single most important software program and personal database.

It's primarily designed for secure password storage, but it can be used for any information that needs to be kept confidential. Such as:

- bank account numbers,
- credit card information,
- PIN codes for various devices and your ATM cards,
- etc.

Any information that needs to be kept confidential should be stored in a KeePass database.

In addition to running on our Ubuntu Desktop, the KeePass database format can be read by applications running on the following platforms:

- All Linux and Unix systems
- Mac OSX
- Windows
- Android
- Windows Phones
- Windows Mobile
- Blackberry
- Mobile Phones (running Java Mobile Edition, e.g, Symbian)
- iPhone and iPad
- Chrome OS
- Palm OS

## C. Installation Process

To get the latest available version, the following `PPA` (Personal Package Archive) can be added first.

```yml
$ sudo add-apt-repository ppa:phoerious/keepassxc
$ sudo apt update
```

After that, run the following command

```yml
$ sudo apt install keepassxc
```

This is probably all we can explain about the process of creating a Gnome Keyring on the Ubuntu Desktop. You can read other articles to gain a clearer understanding of Gnome Keyring.
