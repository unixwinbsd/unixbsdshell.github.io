---
title: How to Configure Traffic Shaping and Quality of Service in PFSense
date: "2025-08-01 08:01:25 +0100"
updated: "2025-08-01 08:01:25 +0100"
id: configuration-traffic-shaping-quality-of-service-pfsense
lang: en
author: Iwan Setiawan
categories: Networking
tags: Router
background: https://cdn.publish0x.com/prod/fs/images/c0b87a5a6d626f3d3bbcd09ed357b72cd8b4d93c7008a7bb7aa0866a8dfe49b3.jpg
toc: true
comments: true
published: true
excerpt: Traffic shaping is used to optimize or guarantee network traffic performance, improve latency, and increase usable bandwidth for some packet types by delaying others. Therefore, traffic shaping is an effort to control network traffic to optimize bandwidth and ensure network performance.
keywords: pfsense, router, firewall, shell, command, qos, traffic, networking, traffic shaping, quality of service, voip, games, low, priority, hing
---

Traffic shaping is used to optimize or guarantee network traffic performance, improve latency, and increase usable bandwidth for some packet types by delaying others. Therefore, traffic shaping is an effort to control network traffic to optimize bandwidth and ensure network performance.

Traffic shaping is a QoS `(Quality of Service)` technique that can be used to enforce lower bitrates than the physical interface can handle. Most ISPs use `"traffic shaping"` or policing to enforce "traffic contracts" with their customers. For example, when your internet connection uses traffic shaping, it will buffer traffic at a certain bitrate; policing will stop traffic when it exceeds a predetermined bitrate.

Let's discuss an example of why you or your internet service provider might use traffic shaping to streamline network traffic.

Your ISP sells you a fiber optic connection with a traffic and bandwidth contract of 10 Mbits, but the fiber interface is capable of transmitting 100 Mbits per second. Most ISPs will configure policing to stop all traffic above 10 Mbits. This prevents your internet network from using more bandwidth than you paid for.

They might also downgrade to 10 Mbps, but shaping means they have to buffer the data, while policing means they can simply discard it. The 10 Mbps we pay for is called the Committed Information Rate (CIR).

As we know, routers can only send data bits at the physical clock speed. For example, let's say you have a serial link with a bandwidth of 128 kbps. Imagine you want to shape it to 64 kbps. To achieve this speed, you need to ensure that you're sending packets 50% of the time and stopping 50% of the time. 50% of 128 kbps = an effective CIR of 64 kbps.

As another example, let's say you have the same 128 kbps link, but your CIR speed is 96 kbps. This means we'll be transmitting 75% of the time and stopping `25% of the time (96 / 128 = 0.75)`.

For more clarity, see the following Traffic Shaping Terminology image.

<br/>
<img alt="Terminology Traffic Shaping" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/images/c0b87a5a6d626f3d3bbcd09ed357b72cd8b4d93c7008a7bb7aa0866a8dfe49b3.jpg' | relative_url }}">
<br/>

## 1. Why Traffic Shaping Is Important

Limited network resources make bandwidth prioritization a necessity. Traffic shaping is one of the most important techniques for ensuring high quality of service for business applications and data. It is a crucial requirement for network firewalls.

Traffic shaping, or packet shaping, is a congestion management method that regulates network data transfer by delaying the flow of less important or less desirable packets. Network professionals use traffic shaping to optimize network performance by prioritizing specific traffic flows to ensure traffic rates do not exceed bandwidth limits.
Network professionals can control traffic flow by doing the following:

- Bandwidth limiting. Regulating the flow of packets into the network.

- Rate limiting. Regulating the flow of packets out of the network.


## 2. Benefits of Traffic Shaping
Using a router firewall device such as PFSense, which is equipped with Traffic Shaping has many benefits, including:

- Accelerates and streamlines network traffic.
- Avoids network congestion by detecting abnormal bandwidth consumption.
- Improves application performance.
- Blocks attacker IP addresses.
- Limits unwanted traffic.
- Ensures high transmission quality for critical applications.
- Maximizes resource utilization and prioritizes application programs by allocating bandwidth according to usage.

Leveraging the Traffic Shaping feature on PFSense routers can help ensure critical data and business applications run efficiently with bandwidth appropriate to their usage. Ultimately, traffic shaping ensures better `quality of service (QoS)`, delivers higher performance, maximizes usable bandwidth, reduces latency, and `improves return on investment (ROI)`.

## 3. How to Set Up Traffic Shaping

Now we get to the core of this article: installing traffic shaping on your Pfsense router firewall. However, before implementing traffic shaping, you must first know how much internet bandwidth your internet service provider provides.

Once you know the amount of bandwidth your internet service provider provides, log in to the main Pfsense dashboard. Then, go to the Firewall - Traffic Shaper menu, select Wizards, and the Traffic Shaper Wizards menu will appear, as shown in the following image.

<br/>
<img alt="firewall traffic shaping" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/firewalltrafficshaping.jpg' | relative_url }}">
<br/>

<img alt="menu wizard traffic shaper" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/menuwizardtrafficshaper.jpg' | relative_url }}">
<br/>

If your computer uses two WAN (WAN) interfaces connected to the modem, or three WANs and one LAN, or two LANs, or even up to eight LANs, it's highly recommended to select the Multiple LAN/WAN menu. However, if your Pfsense router only has one WAN, click Dedicated Links.

In this article, there's only one interface connected to the modem (WAN), so select the `"dedicated links"` menu. Next, click `traffic_shaper_wizard_dedicated.xml`.

Type 1 in `"Enter number of WAN type connections"` because we only have one WAN, then click Next. Next, we'll move on to step 1 of 8. For more details, see the following image.

<br/>
<img alt="pfsense traffic shaper" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/1147054586-7a282bde2a34c2a29124b402e5e227327e4279daa4c1f333623304b51c51406b.webp' | relative_url }}">
<br/>

<br/>
<img alt="pfsense shaper configuration" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/pfsenseshaperconfiguration.png' | relative_url }}">
<br/>

Step 2 of 8 is to enable the Voice over IP (VOIP) menu. If your home internet doesn't have a VoIP server, you can skip this step. If your office or home internet does, this parameter must be filled in.

Let's assume there's no VOIP server at your office or home, so we can skip this step or don't enable this menu. Then, click Next, and we'll move on to Step 3 of 8.


![voice over IP](https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/voiceOver-IP.png)


Step 3 of 8 is often referred to as a `bandwidth hog` meaning that one of the users on your computer network is using a lot of bandwidth. A bandwidth hog is a device, user, or application that consumes a large portion of the available internet bandwidth, leaving less for other users on the network.

Common Causes of High Bandwidth Usage:

- Video and Music Streaming.
- Large File Downloads.
- Online Gaming.
- Automatic Software Updates.
- File Sharing and P2P Networking.
- Multiple Connected Devices.

To address `Bandwidth Hogs` you can configure them in this section. For example, if the `Bandwidth Hog` IP address is `192.168.9.100`, you'll grant that person 2% bandwidth. In the case of "Bandwidth Hogs," pfSense accepts a range of 2% to 15%.

![menu penalty box](https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/MenuPenaltyBOX.png)


What if there are multiple **"Bandwidth Hogs"** on a single network? In this case, we can create multiple IP addresses for each "Bandwidth Hog" by clicking the Firewall - Alias - IP menu.

After completing step 3 of 8, click `Next`, and we'll move on to step 4 of 8. This step contains the Peer-to-Peer network parameters, or those related to torrent files. Let's skip step 4 of 8.


<br/>
<img alt="peer to peer networking" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/3419863075-ee5f8c47c2c14047996fd50f5b972d3301b1804223d7ad594b7b1f497b85b33e.webp' | relative_url }}">
<br/>

JUST GOT HERE. Continue...

Next, we'll move on to step 5 of 8, which contains the Network Game parameters.

<br/>
<img alt="menu networks games" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/3419863075-08141d39e591d923bd91b7f2935d770ae34466c605c85130e166a2c3ab4c82e1.webp' | relative_url }}">
<br/>

In the image above, you can adjust it according to your needs. Select only frequently used online games.

Let's move on to step 6 of 8, which contains the Raise or Lower Other Applications parameter. Step 6 of 8 is very important because it's often used on computer network servers. You can also adjust it as needed. In this article, I'll only be filling in a few parameters.

- Enable = checklist
- HTTP = Higher priority
- SMTP = Lower priority
- POP3 = Lower priority
- IMAP = Lower priority
- DNS = Higher priority

<br/>
<img alt="menu raise or lower" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://cdn.publish0x.com/prod/fs/cachedimages/132360959-f4f81a5f0e1736a630d9b2e319a6f7cb15d6cd0f8870623863f34417a0de0b9c.webp' | relative_url }}">
<br/>

After that, click Next. We'll move on to step 7 of 8, which is Reload profile or Finish.

<br/>
<img alt="reload profile" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/ReloadProfile.png' | relative_url }}">
<br/>

Excessive bandwidth usage can significantly impact network performance, especially as data-intensive devices and applications become part of everyday life.

Understanding what causes excessive bandwidth usage and how to manage it effectively is crucial to ensuring a smooth and high-performance internet experience. By using tools like QoS, monitoring your network, and educating users, you can better allocate bandwidth and minimize the impact of a large number of users or devices on your network.