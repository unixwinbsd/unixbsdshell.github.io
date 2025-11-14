---
title: Using pfsense for the first time - Installation and Configuration Guide
date: "2025-08-15 07:05:27 +0100"
updated: "2025-10-11 13:25:42 +0100"
id: using-pfsense-for-the-first-time-installation-configuration-guide
lang: en
author: Iwan Setiawan
categories: Networking
tags: Router
background: https://cdn.publish0x.com/prod/fs/images/ecd5cdb1b8be132a7eeb43100ac1925323b0c71627154552cd49bec425ebfd36.jpg
toc: true
comments: true
published: true
excerpt: PFSense is generally used as a firewall or router. But with its myriad of features, PFSense can also be used as a DNS server, DHCP server, proxy server, Bandwith limiter, VPN and so on. All of this can be easily configured simply via Google Chrome.
keywords: pfsense, router, firewall, installation, nat, outbound, interface, freebsd, wan, lan
---

Pfsense is an open source firewall or router application based on FreeBSD. PFSense can be installed on a physical computer or virtual machine to create a custom firewall or router for a network. PFSense is believed to be reliable and offers various features. Not only that, PFSense offers ease of configuration, namely via a web browser such as Google Chrome. With this convenience, PFSense users do not need special knowledge about the system
FreeBSD.

PFSense is generally used as a firewall or router. But with its myriad of features, PFSense can also be used as a DNS server, DHCP server, proxy server, Bandwith limiter, VPN and so on. All of this can be easily configured simply via Google Chrome.

<br/>
<img alt="diagram PFSense Router firewall" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/images/ecd5cdb1b8be132a7eeb43100ac1925323b0c71627154552cd49bec425ebfd36.jpg' | relative_url }}">
<br/>

## 1. System specifications

- PFSense Version: PFSense 2.7.2-RELEASE (amd64)
- Ethernet Card 1: nfe0 (WAN)
- Ethernet Card 2: rl0 (LAN)
- IP address nfe0: 192.168.5.2 (WAN)
- IP address rl0: 192.168.7.1 (LAN)
- CPU Type: Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz


## 2. Download PFSense

Even though PFSense belongs to the FreeBSD family, the PFSense repository is not available in FreeBSD. To get PFSense you have to download it from the official PFSense website or another repository that provides the PFSense master. In this article we will download PFSense from the official PFSense website, please open the following link:
`https://www.pfsense.org/download/`

<br/>
<img alt="download PFSense" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ '/img/oct-25/Download-PFSense.jpg' | relative_url }}">
<br/>

The image above will download PFSense with USB stick media. After you have finished downloading PFSense, create a bootable USB Flashdisk with Balena or other applications.

## 3. Install PFSense

In this section we will discuss the PFSense installation process using USB Flash disk media. After you have finished creating a bootable Flashdisk, install PFSense on your computer. The method is very easy, follow all the PFSense installation instructions displayed on your monitor screen.

After the installation process is complete, by default PFSense will display a menu like the image below.

<br/>
<img alt="dashboard PFSense" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/enable-interface-in-pfsense.jpg' | relative_url }}">
<br/>

To continue the PFSense installation process, open the Google Chrome web browser and type `192.168.1.1`, so it will appear as shown in the image below.

<br/>
<img alt="PFSEense main dashboard" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/pfsense-setup.png' | relative_url }}">
<br/>

Click the Next button, to continue.

<br/>
<img alt="setup PFSense" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/menu-wizard-pfsense.jpg' | relative_url }}">
<br/>

<img alt="general information DNS server PFSEnse" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/1439957621-a37fd7311028310eb7119e89b3362816bef4b89fa06d67cccf53aaf86d3b6a2d.webp' | relative_url }}">
<br/>

<img alt="reload configuration" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/reload-configuration.png' | relative_url }}">
<br/>

After you click the Next button, the DNS server column will appear. You fill in the DNS IP with Public DNS IP `1.1.1.1 and 8.8.8.8`. Don't forget to uncheck the **"DNS Server Override"** option. Click the Next button again, then a display like the image below will appear.

<br/>
<img alt="pfsense setup genaral information" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/1439957621-a37fd7311028310eb7119e89b3362816bef4b89fa06d67cccf53aaf86d3b6a2d.webp' | relative_url }}">
<br/>

In the `"Time server hostname"` option, fill in the time server. To make things easier, just choose the default PFSense, namely `"2.pfsense.pool.ntp.org"`. And in the `"Timezone"` column, you fill in the time zone where you live. Continue by pressing the Next button.

<br/>
<img alt="time server information PFSEnse" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/pfsense-time-server-configuration.png' | relative_url }}">
<br/>

In this section, you are required to configure the WAN interface. IP address **192.168.5.2** is the static IP of the WAN interface with Gateway **192.168.5.1**. After you set everything. click the Next button.

<br/>
<img alt="configure WAN Interface" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/2109907659-71646fc26367b7fe39707d698782c4b7b654e10ed0ebc8d809ab13b625b15f16.webp' | relative_url }}">
<br/>

In the picture above, you have to set the IP address of the LAN interface. In this article we give an example of the LAN IP used **192.168.7.1**. Then click the Next button again.


## 4. PFSense configuration

The section above is the initial part of the PFSense configuration. In the configuration above, your PFSense is not yet connected to the internet. So that your PFsense can connect to the internet, we continue with the next configuration.

### a. Disable DNS Resolver

Because you have changed the default PFSense IP from `192.168.1.1 to 192.168.7.1`, in Google Chrome type `https://192.168.7.1`. After the PFSense page appears, click the **Service ->> DNS Resolver**, then uncheck the "Enable DNS resolver" option as shown in the image below.

<br/>
<img alt="disable DNS Resolver" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/447643017-abe6f745a0972eedc9999b69b85615dc552fcdd464b6afbe27149ea8ea6e704a.webp' | relative_url }}">
<br/>

### b. Create NAT (Firewall)

Next step, we will configure NAT. Click the `Firewall ->> NAT` menu, then click the **"Outbound"** menu and click again on the **"Manual Outbound NAT rule generation"** menu. (AON - Advanced Outbound NAT)", you create NAT according to the image below.

<br/>
<img alt="Advanced Outbound NAT" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/create-firewall-outbound.jpg' | relative_url }}">
<br/>

### c. Disable DHCPv6 Server

In this basic example, we only enable IP4. Therefore you must disable IP6. To disable IP6, click the `Services ->> DHCPv6 Server`, and uncheck the `"Enable DHCPv6 server on LAN interface"` option. follow the instructions in the image below.

<br/>
<img alt="enable dhcp ipv6 server" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/1444463442-e0892343e1283127309dd1970cc0784be33bef5b0b52e4560e23fd3c9d5b28bf.webp' | relative_url }}">
<br/>

### d. Disable Router Advertisement

After that, you also disable Router Advertisement. To do this, click the `Service ->> Router Advertisement`. In the `"Router Mode:"` option, select disable. Look at the example below.

<br/>
<img alt="Router Advertisement" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/router-advertisement.jpg' | relative_url }}">
<br/>

### e. Setup Interface WAN and LAN

In this section we will configure the WAN and LAN interfaces. To understand it more easily, see the image below. Pay attention to the gateway choice. First we will configure the WAN interface.

<br/>
<img alt="wan interface Setup" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/3028355640-5b9b1217bac92afd0857bf6f9f9cde32b790a77769c6f96e9bfb2a75f1d8bb86.webp' | relative_url }}">
<br/>

After that, we configure the interface (without gateway). Look at the image below.

<br/>
<img alt="lan interface" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/lan-rl0.jpg' | relative_url }}">
<br/>

### f. Delete Gateway

In PFSense, the gateway has an important role in connecting your PFSense to the internet. Before we create a new Gateway, first delete the default Gateway that was created by PFSense automatically. like the picture below.

To delete the gateway, click the `System ->> Routing` menu. After that, click on the trash can icon, as shown in the image below.

<br/>
<img alt="delete gateway" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/3667570957-8f002142b09a8505094a6bf516810163b3ca19b244af8c4fe27ae1389f2ca519.webp' | relative_url }}">
<br/>

After you click the trash can icon, the results will look like the image below.

<br/>
<img alt="routing gateway" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/make-gateway.png' | relative_url }}">
<br/>

### g. Creating a New Gateway

After that, we continue by creating a new gateway on the WAN interface. Click the `Interfaces ->> WAN` menu. Follow the image guide below. Note the gateway on this interface.

<br/>
<img alt="gateway wan interface" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/2109907659-a7df619d74f9dd612618fa0b290522d3c3da155aada3c53eb1451ce559d94727.webp' | relative_url }}">
<br/>

### h. Setup DHCP Server

The next step you have to do is set up the DHCP server. To set up your DHCP server, click the `Services ->> DHCP Server`. Look at the image below, as your reference for configuring the DHCP server.

<br/>
<img alt="service dhcp server lan" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/enable-dhcpserver-pfsense.jpg' | relative_url }}">

<br/>
<img alt="Setup DHCP Server" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/2109907659-3c657d10ef9d085463142de4013c7f9b92ba380c326794eea9f53cdd95520890.webp' | relative_url }}">
<br/>

The final step is to reboot your PFSense server. Wait until PFSense returns to running normally. After that, you test by opening Google Chrome and typing `"https://www.youtube.com/"`. If you don't go through each configuration that we have explained, you should be able to open YouTube.

If your PFSense is not connected to the internet, you can start the steps in points `"f" and "g"`.
