---
title: How to Configure Traffic Shaping and Quality of Service in PFSense
date: "2025-08-01 08:01:25 +0100"
id: configuration-traffic-shaping-quality-of-service-pfsense
lang: en
layout: single
author_profile: true
categories:
  - Networking
tags: Router
excerpt: Traffic shaping is used to optimize or guarantee network traffic performance, improve latency, and increase usable bandwidth for some packet types by delaying others. Therefore, traffic shaping is an effort to control network traffic to optimize bandwidth and ensure network performance.
keywords: pfsense, router, firewall, shell, command, qos, traffic, networking, traffic shaping, quality of service, voip, games, low, priority, hing
---

Traffic shaping is used to optimize or guarantee network traffic performance, improve latency, and increase usable bandwidth for some packet types by delaying others. Therefore, traffic shaping is an effort to control network traffic to optimize bandwidth and ensure network performance.

Traffic shaping is a QoS (Quality of Service) technique that can be used to enforce lower bitrates than the physical interface can handle. Most ISPs use `"traffic shaping"` or policing to enforce "traffic contracts" with their customers. For example, when your internet connection uses traffic shaping, it will buffer traffic at a certain bitrate; policing will stop traffic when it exceeds a predetermined bitrate.

Let's discuss an example of why you or your internet service provider might use traffic shaping to streamline network traffic.

Your ISP sells you a fiber optic connection with a traffic and bandwidth contract of 10 Mbits, but the fiber interface is capable of transmitting 100 Mbits per second. Most ISPs will configure policing to stop all traffic above 10 Mbits. This prevents your internet network from using more bandwidth than you paid for.

They might also downgrade to 10 Mbps, but shaping means they have to buffer the data, while policing means they can simply discard it. The 10 Mbps we pay for is called the Committed Information Rate (CIR).

As we know, routers can only send data bits at the physical clock speed. For example, let's say you have a serial link with a bandwidth of 128 kbps. Imagine you want to shape it to 64 kbps. To achieve this speed, you need to ensure that you're sending packets 50% of the time and stopping 50% of the time. 50% of 128 kbps = an effective CIR of 64 kbps.

As another example, let's say you have the same 128 kbps link, but your CIR speed is 96 kbps. This means we'll be transmitting 75% of the time and stopping 25% of the time (96 / 128 = 0.75).

For more clarity, see the following Traffic Shaping Terminology image.

![Terminology Traffic Shaping](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh01sH-uLHWpVLu4llg4AXv_ZVWaSOP-OwhT3v2Yip1Fg0Ozzi3-eBeyFDmWd3wSBzQ8EeaqXGYkskX790B17TThJpHI0K96XEVVfXZNWN8Wai80QW3gSBPvZwoOh5y1oGcZFY-6AU1aIuegE-2VYegB3v87zJ3JAUHs11j_aWi7sdyk7VGgLI4E1mg3X6P/s16000/Terminology%20Traffic%20Shaping.jpg)

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

![firewall traffic shaping](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj2PhAa-7ZxFLXRwlL0V2n-sKflpBzGqL2zQcTMpuOtNDjuEFQHqD0CGUt98ajHP2y7OelInMTkS6oM0se2zwzkQGEV7eonKEpoziDkDORq3AoGgJfyEA16ErBd3LiTIcNgauoNwhmzlagwfKCaxgNa2Oy1eOEZRPaAq1yzu6m3fb9mJlDSYjmNHR-aImal/s16000/firewall%20traffic%20shaping.jpg)


![menu wizard traffic shaper](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgEy1xK19aUav66E0hMtacazdt-7MGNL8bKlIxx3xapGtJiMaPpu5kjP1eWaNVNgg7LT4LQhClaHMtsmU0ANkOxfGv8pRjJvve8hTHG_WFCxFy6ARK4ZkbmdXt5PKZ1eFOQhfsgvIGLnsvN9khmoe13ZZcwC0gKwwLS-N0cw38pF7w0hIvB17ud1arTd_Wb/w640-h334/menu%20wizard%20traffic%20shaper.jpg)


If your computer uses two WAN (WAN) interfaces connected to the modem, or three WANs and one LAN, or two LANs, or even up to eight LANs, it's highly recommended to select the Multiple LAN/WAN menu. However, if your Pfsense router only has one WAN, click Dedicated Links.

In this article, there's only one interface connected to the modem (WAN), so select the `"dedicated links"` menu. Next, click `traffic_shaper_wizard_dedicated.xml`.

Type 1 in `"Enter number of WAN type connections"` because we only have one WAN, then click Next. Next, we'll move on to step 1 of 8. For more details, see the following image.



![pfsense traffic shaper](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj7S-ZQUZ9Uq_IL5UCgV1ahmXmfGAXvV-Q0IbXEr9IzZuyP5_Ca_ZrC1X0slQ70OJ6co6Cc6SZGu9pgcIWI3cT_tHFsLe_othR4nHXFZ7pozC3iI1Tf6iI5C4YQX-DhpCh8I9W7eC6LOhN1ZJi6_uOs6DQgNXlzionczSPN47igOR2Ta6Iua33Hjwu9TrJ8/s16000/pfsense%20traffic%20shaper.png)



![pfsense shaper configuration](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVTy8hjpWLg6LXFlY9kJVlbosmaZN9nqN2szqrDcQmVy_Ovwx6e-T7DFp_uhzK1JyAqU3WcsJ-fYYtwFcJk1t3McvD3tbp6AWqYQUsF7X12ykyHJx4xFcD08ft-rkwxhHJQonzZOFUFK0dE0DrW5E874fUpjAfAxJ8Xv-MLjHKnDVHe26rXi-caDaBQ8Pz/s1129/pfsense%20shaper%20configuration.png)



Step 2 of 8 is to enable the Voice over IP (VOIP) menu. If your home internet doesn't have a VoIP server, you can skip this step. If your office or home internet does, this parameter must be filled in.


Let's assume there's no VOIP server at your office or home, so we can skip this step or don't enable this menu. Then, click Next, and we'll move on to Step 3 of 8.

![voice over IP](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEguLvae6lZzn7jzZw-NLGmqkhRSjC7SN-1CKoo9_dP__2Iw_j4g8XQvstFVuTbOEQ1SKfsmvqC3I97rU4f6LJB-1A9JDQDAox9Xkw7wyAGX__SyefcUtMaZhQbnBwXciNx2NfbYIeD08GW2_uqG6ntgIrFKdt5ECZbDy_-Ys6-nQSObGre2JLOaDqC7cLyR/s16000/voice%20over%20IP.png)


Step 3 of 8 is often referred to as a `bandwidth hog` meaning that one of the users on your computer network is using a lot of bandwidth. A bandwidth hog is a device, user, or application that consumes a large portion of the available internet bandwidth, leaving less for other users on the network.

Common Causes of High Bandwidth Usage:
Streaming Video dan Musik.
Unduhan File Besar.
Permainan Daring.
Pembaruan Perangkat Lunak Otomatis.
Berbagi File dan Jaringan P2P.
Beberapa Perangkat yang Terhubung.
To address `Bandwidth Hogs` you can configure them in this section. For example, if the `Bandwidth Hog` IP address is `192.168.9.100`, you'll grant that person 2% bandwidth. In the case of "Bandwidth Hogs," pfSense accepts a range of 2% to 15%.

![menu penalty box](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiFXL6xxui-xVsn3u5aDEG0oi0-_dewfDxh42WDTCfpWiH9EThE7EE1visI2ybYLX0bjnZUoyNGBK6GBg95YOVNCOO_p9iP0ZgJOtGGseLIkzq0-BPMin9rp4orLMJLQ2ibR8Kl35r1XencX2Fli9ssL5GN3mrpo1Tw-1gDYD322VSeoo5IBWuloA_BE4cu/s16000/menu%20penalty%20box.png)


What if there are multiple "Bandwidth Hogs" on a single network? In this case, we can create multiple IP addresses for each "Bandwidth Hog" by clicking the Firewall - Alias - IP menu.

After completing step 3 of 8, click Next, and we'll move on to step 4 of 8. This step contains the Peer-to-Peer network parameters, or those related to torrent files. Let's skip step 4 of 8.

![peer to peer networking](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEimMbmyKhZUfSN7ZoNqRY8Eu__i9IPfRQhhURulabgp1bPZlJR1HKERi0YVk-127ywbZflA3351ICm7u_XmqvSZbaCnv1evlLlhIxH6md74IHQGImP9Xcqgnnh8HRO1NZPtncydIYYlUwu4_RsYQOhQWnMa9pV1q9B1-TzUbUuSq-rUlU-jdo6j4h8KzIfO/s16000/peer%20to%20peer%20networking.png)


JUST GOT HERE. Continue...

Next, we'll move on to step 5 of 8, which contains the Network Game parameters.

![menu networks games](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhk-n5hp4-h7a_GjIpu7EFRbVlekF8B3J8Zx8jTHm_MxBN2MtbSIUTABAan2y-wqJZ5jzVA5j-nb_yVhM8vOHsICdGpUCRd-vjZlhruOQp4hDGAE-h29FykzlX1elLOS-sbTQ9NDPBPD7XuQrOn6TPZScEzIeANJh4gpmYzYtPN3KGYQUrR3bFo7jeX6XA8/s16000/menu%20networks%20games.png)


In the image above, you can adjust it according to your needs. Select only frequently used online games.

Let's move on to step 6 of 8, which contains the Raise or Lower Other Applications parameter. Step 6 of 8 is very important because it's often used on computer network servers. You can also adjust it as needed. In this article, I'll only be filling in a few parameters.

- Enable = checklist
- HTTP = Higher priority
- SMTP = Lower priority
- POP3 = Lower priority
- IMAP = Lower priority
- DNS = Higher priority

![menu raise or lower](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhdIxeNEa1G9XQspUcHXjm3loDSsGwZ9Tl7EjOEQCxGlGs5sScm4SJvJdWe62tRBoHS5IYGhQxcqJ33NoD7TZQgy9rNGMpdBDR9Ng_7Rsv7-Y_sB_DykeuHJezdQUxCBfRZXM5bzDpbIgZHW0V00XlAv7ObQFDw_x81j5QRAMkJphPMi9oFtMW5A9Y0q1la/s16000/menu%20raise%20or%20lower.png)


After that, click Next. We'll move on to step 7 of 8, which is Reload profile or Finish.

![reload profile](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj3yr6TQzPDEcfHyPyF7njXRVOWwe_GUXV52EGW_KBYtZNi5eYUUE1R8tDVDyYANHR08aSZhML7f9zmo3ubxgdT1CrPstIjyTUMgoQ8mr6I4I6jgpzVCY7r-DEyc_H6uqpkSHLff-vgjfu8eNsEqZB4ZD7gHiwoQ9SaN3-gaxmIyDOskZ36y5nQWZuNsgpK/s16000/reload%20profile.png)


Excessive bandwidth usage can significantly impact network performance, especially as data-intensive devices and applications become part of everyday life.

Understanding what causes excessive bandwidth usage and how to manage it effectively is crucial to ensuring a smooth and high-performance internet experience. By using tools like QoS, monitoring your network, and educating users, you can better allocate bandwidth and minimize the impact of a large number of users or devices on your network.