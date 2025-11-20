---
title: ClamAV Antivirus Engine Installation Guide on Fedora
date: "2025-11-20 15:34:21 +0000"
updated: "2025-11-20 15:34:21 +0000"
id: clamav-antivirus-engine-installation-guide-on-fedora
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: SysAdmin
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-021.jpg
toc: true
comments: true
published: true
excerpt: In this tutorial, we'll show you how to install ClamAV on Fedora Linux. ClamAV is a versatile open-source antivirus engine designed primarily to detect trojans, viruses, malware, and other malicious threats.
keywords: ubuntu, clamav, antivirus, key, keyring, certificates, engine, ssl, openssl, tls, installation, guide, fedora
---

ClamAV is a powerful antivirus tool that offers essential protection for Fedora Linux systems against malicious software, including viruses and trojans. Here are some of ClamAV's key features:

- **Versatile Protection:** ClamAV diligently protects against various forms of malware, providing a secure environment for your Fedora Linux system.
- **Regular Updates:** With frequent database updates, ClamAV ensures your system is protected against the latest known threats, enhancing your security landscape.
- **Command-Line Interface:** ClamAV operates through a user-friendly command-line interface, making it easy to access and navigate for users familiar with terminal commands.
- **Scanning Options:** The tool offers flexible scanning options, allowing users to thoroughly examine files, directories, and other system areas for infection.
- **Open Source:** ClamAV is an open-source project that invites community contributions, leading to continuous improvements and updated features.

In this tutorial, we'll show you how to install ClamAV on Fedora Linux. ClamAV is a versatile open-source antivirus engine designed primarily to detect trojans, viruses, malware, and other malicious threats. It's particularly effective at scanning email attachments and web gateway traffic. ClamAV's flexibility makes it an excellent choice for Fedora Linux users looking to improve their system's security.

This article assumes at least a basic knowledge of Linux and familiarity with the shell command line. Installation is fairly simple and assumes you're running it as root; otherwise, you may need to add 'sudo' to the command to gain root privileges.

<img alt="ClamAV Antivirus Engine Installation Guide on Fedora" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-021.jpg' | relative_url }}">

## A. Install ClamAV with the DNF Command

The first command you should run is to update your Fedora system. To avoid conflicts during the ClamAV installation, ensure all packages are up-to-date and have the latest versions.

```console
[root@ns1 ~]# sudo dnf clean all
[root@ns1 ~]# sudo dnf update
[root@ns1 ~]# dnf upgrade --refresh
```

By default, ClamAV is available in the standard repositories. Fedora focuses on upstream releases, so the versions provided are generally up-to-date and compatible with other Linux distributions. To install ClamAV and its GUI interface on an rpm-based system like Fedora, simply use dnf and run the following command.

```yml
[root@ns1 ~]# sudo dnf -y install clamav clamd clamav-update
```

The above command will install the ClamAV core package, along with its required dependencies, and the clamav-update package, which is responsible for updating the virus database. Once the installation process is complete, you can verify that ClamAV was successfully installed by checking its version. Run the following command.

```yml
[root@ns1 ~]# sudo clamscan --version
```

If ClamAV is installed correctly, you will see the ClamAV version information displayed in your terminal shell menu.

## B. Update the ClamAV database

To perform its functions, Clamav uses a database that can read and block viruses. This database changes every month or year. Therefore, you should always update the ClamAV database to the latest version. This will further improve ClamAV's performance and ward off malicious viruses that are constantly lurking on your system.

```console
[root@ns1 ~]# sudo systemctl stop clamav-freshclam
```

Now you can directly run the Clamav database update command.

```yml
[root@ns1 ~]# sudo freshclam
```

Once the database is updated, start the `clamav-freshclam` service and enable it to run automatically when the system boots.

```yml
[root@ns1 ~]# sudo systemctl enable clamav-freshclam --now
```

It's important that if you ever decide you don't want Clamav enabled, you can disable it without uninstalling it.

```yml
[root@ns1 ~]# sudo systemctl disable clamav-freshclam --now
```

### b.1. Automatic Updates

To ensure your ClamAV installation stays up-to-date with the latest database versions, we recommend setting up automatic updates (to save you the hassle). You can do this by configuring your crontab file to run freshclam periodically.

Open the crontab file and edit the script as shown below.

```console
[root@ns1 ~]# sudo crontab -e

0 2 * * * /usr/bin/freshclam --quiet
```

With this cron job, ClamAV will automatically update its virus definitions every day at a specified time.

## C. Configuring ClamAV

With ClamAV installed on your Fedora system, it's time to configure it so it can run smoothly and provide optimal protection for your system. To do this, you must edit Clamav's main configuration file, `"freshclam.conf"`.

### c.1. Edit the freshclam.conf file

The `freshclam.conf` file contains configuration settings for the freshclam component, which is responsible for updating the virus database. To edit this file, use the following command.

```yml
[root@ns1 ~]# sudo nano /etc/freshclam.conf
```

In the script file, you can adjust various settings such as update frequency, database mirroring, and proxy settings. Be sure to uncomment and change the necessary options based on your needs.

### c.2. Edit the clamd.conf file

The `clamd.conf` file is used to configure the clamd daemon, which provides real-time scanning and monitoring. Open the file with the following command.

```yml
[root@ns1 ~]# sudo nano /etc/clamd.conf
```

You must configure the script in this file, including scan settings, log file location, and maximum file size for scanning. Adjust the settings according to your needs, then save the changes.

### c.3. systemd Clamav

ClamAV also offers on-access scanning, which automatically scans files as they are accessed or modified. To enable on-access scanning, you need to configure the clamd daemon to run as a service. Follow these steps.

```console
[root@ns1 ~]# sudo nano /etc/systemd/system/clamd.service

[Unit]
Description=ClamAV Antivirus Daemon
After=network.target

[Service]
Type=forking
ExecStart=/usr/sbin/clamd
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Save the changes and rerun Clamav.

```yml
[root@ns1 ~]# sudo systemctl enable --now clamd
```

With configured access scanning, ClamAV will actively monitor and scan files in real-time, providing an additional layer of protection for your computer.

In this article, you don't need to perform manual Clamav antivirus scans, as everything is done automatically by systemd and crontab. You can read another article on how to perform antivirus scans with Clamav.

Congratulations! You have successfully installed ClamAV. Thank you for using this tutorial to install ClamAV on your Fedora system.
