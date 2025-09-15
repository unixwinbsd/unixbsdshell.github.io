---
title: Using pfsense for the first time - Installation and Configuration Guide
date: "2025-08-15 07:05:27 +0100"
id: using-pfsense-for-the-first-time-installation-configuration-guide
lang: en
layout: single
author_profile: true
categories:
  - Networking
tags: SysAdmin
excerpt: PFSense is generally used as a firewall or router. But with its myriad of features, PFSense can also be used as a DNS server, DHCP server, proxy server, Bandwith limiter, VPN and so on. All of this can be easily configured simply via Google Chrome.
keywords: pfsense, router, firewall, installation, nat, outbound, interface, freebsd, wan, lan
---

Pfsense is an open source firewall or router application based on FreeBSD. PFSense can be installed on a physical computer or virtual machine to create a custom firewall or router for a network. PFSense is believed to be reliable and offers various features. Not only that, PFSense offers ease of configuration, namely via a web browser such as Google Chrome. With this convenience, PFSense users do not need special knowledge about the system
FreeBSD.

PFSense is generally used as a firewall or router. But with its myriad of features, PFSense can also be used as a DNS server, DHCP server, proxy server, Bandwith limiter, VPN and so on. All of this can be easily configured simply via Google Chrome.

![diagram PFSense Router firewall](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjQdklq6UA7CtF_m1op96JZJZ2vpKAZ92Dl30TWj45nvlqlUzfK1LddT1YJ_hBsP9SFO1VEmmxNDjijPuOmYWuNWJ_OU0P1mqvQjgr4LdxdVJfq347kK06dRuWRWYU1lfgXgIOrxpg-MzHzsvjp-iv9s7gxau54gbKUIdijhNfuHvgMlejzVOpwU6nJ0rp0/s16000/diagram%20router%20firewall%20pfsense.jpg)



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

![download PFSense](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiXUPnZzBglUD6ytqmFOTl_Vx-J9gWxLwuI_M36WOQNgkyIEWrdt7e-3vKOT2Mw9d0jLe62EtkSuhfMQCpiRuHZS19Y5bX17D2q1mxuBjmoUZJC71oN8PuRBFb8XYtX_Ry4tJoOV-S7dK5YB_aBdWIEKZWUf6M8HaY_A3KDD5SOqFmfhx5O6FY8-_l6jWW-/s16000/unduh%20pfsense.png)


The image above will download PFSense with USB stick media. After you have finished downloading PFSense, create a bootable USB Flashdisk with Balena or other applications.


## 3. Install PFSense

In this section we will discuss the PFSense installation process using USB Flash disk media. After you have finished creating a bootable Flashdisk, install PFSense on your computer. The method is very easy, follow all the PFSense installation instructions displayed on your monitor screen.

After the installation process is complete, by default PFSense will display a menu like the image below.

![dashboard PFSense](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjpADWpMZKo3DZh-lFhmBFqNMZbPXOkBeCRw4G7OwODwIZnhn0yoeHg7e-fdMTaVzGSvKAjSKoWzWRhhqjg6RSBVh3UgYNZ6bUWohqNUInLmYnNAIReZsM3H2uivf-96ATnJiYVBmKlYJXcgHkkkBxuWxB-eauZBqrHyhGYH6GjeUaA5mKyQPyFMDcugZ9j/s659/mengaktifkan%20interface%20di%20pfsense.png)



To continue the PFSense installation process, open the Google Chrome web browser and type `192.168.1.1`, so it will appear as shown in the image below.

![PFSEense main dashboard](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjl7LL2QZty_s4TjObCmjX8tPpr815H0HjBV0pTqyiW63TNh4tLnCVTtm6VKfbxNWrqRNTSF5xqVhiWawiTT33d9ZYls8Qu_glzOpudS8g92ymNRCdg9rZ_LHOTrCXa-an6IvTndSiwLx4LfL1B89PARKOZBBLOMjnJ1kBINDlNOwiSPoDfAv6Ai3WMHMJ-/s16000/pfsense%20setup.png)


Click the Next button, to continue.

![setup PFSense](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEirZkDb6wBXEUGw80pAV3UHcJP-7oHIW2l4lxHfqUl2n8I5JhRdqmoLb4tIvzmtNczcf6OH-ViL7qYIdE7hly2BBhiZiajwej3AN-EAQs0Q8bsdjvIZ7TWaXxLkrOQvlJ4RS0kfKVjKIhUIupbm6EBK79WlULAdNVhyphenhyphen0sjR_4bG2Uf5StS3msxxDcUlhHu8/s1131/menu%20wizard%20pfsense%20untuk%20instalasi.png)


After you click the Next button, the DNS server column will appear. You fill in the DNS IP with Public DNS IP `1.1.1.1 and 8.8.8.8`. Don't forget to uncheck the **"DNS Server Override"** option. Click the Next button again, then a display like the image below will appear.

![general information DNS server PFSEnse](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEghDAW8rs_qUzEfy7sWvtlwPRrvmQAVHRmfO4jpYXqh4PruuZonbvRgB68guz5gnHKh9OIoZwEgVZiACH_SFeY7CTNYDy4gUJXy8Q98asyBrn-HKHBI1Rf8_6FKnqn2eQ9dz4hHsSBi8hQ70FdGTwwArMkx-FIlARdQoN6rutnm6lHkU-IPPLFsjj4ad3Mc/s16000/pfsense%20setup%20general%20information.png)


In the `"Time server hostname"` option, fill in the time server. To make things easier, just choose the default PFSense, namely `"2.pfsense.pool.ntp.org"`. And in the `"Timezone"` column, you fill in the time zone where you live. Continue by pressing the Next button.

![time server information PFSEnse](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhiLER49ieJVfZt8_-N1F1QoznDJAUxADfR9iiT3mvvCNiNn_83GzYnZGunnKoW9ViaE0gabL1jUIgCOcauanwFUuN5LydqXe_aozb8881e_2lZEaOtxAyOSIZ1TFSq7767Ns0iE-z-sI1n920dKInk5PU8XmcbrNrmSiwuOrVA3t3vrYhSHwu1IPQdtDOF/s16000/pfsense%20setup%20time%20server%20configuration.png)


In this section, you are required to configure the WAN interface. IP address 192.168.5.2 is the static IP of the WAN interface with Gateway **192.168.5.1**. After you set everything. click the Next button.

![configure WAN Interface](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjOPkxZyx2xdMyqg2fZ9FT1dk646Xpkl9sQcSNiZPou_eke53mVLeZM5bYzbK7QIH78JdDRerHCFRLmXYY_QH11haV0cj1Q4q-DFloHkwNFhDMRnE3eeCaVZBoo-6WjO3XM-kh4tpzGsOocQYzi90m4xjDxKSpImqx7gZUJ-dFUlK1SIEFmO6FQFjgWEkA8/s16000/konfigurasi%20interface%20wan.png)



In the picture above, you have to set the IP address of the LAN interface. In this article we give an example of the LAN IP used **192.168.7.1**. Then click the Next button again.

![configure lan interface](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiIW2thDyiZM2hzKgoUq9dJaPHfmv3BNFe3XRUx2VeNuQ-E2oK3GH1wgIStr6c3fDbCJAYgVyJrYWrR4SqBIsM-yKaN2pp3-S43v6rFdXdyP_Dp4PUkM9Cq4tX6WPjBVSYB6_JDjfSjnZV0QJhBVL3qtKhzL0FF8Mv8hDj1-CJpL6QbFp_zNJOV-V4lc8sc/s16000/konfigurasi%20interface%20lan.png)




## 4. PFSense configuration

The section above is the initial part of the PFSense configuration. In the configuration above, your PFSense is not yet connected to the internet. So that your PFsense can connect to the internet, we continue with the next configuration.

### a. Disable DNS Resolver

Because you have changed the default PFSense IP from `192.168.1.1 to 192.168.7.1`, in Google Chrome type `https://192.168.7.1`. After the PFSense page appears, click the **Service ->> DNS Resolver**, then uncheck the "Enable DNS resolver" option as shown in the image below.

![disable DNS Resolver](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh1cwUnMroeCuvdK3s1mIN74Q6SKEVWBtbg7F9Jt-ClIoULOiLgbX5y6C6SnllW35tUf0OvNCbLJkj-0G35CBYxGRZlpre9O3AQghtni6TMwBlzh0jZaBasgW2xTXDzf6POXh_6770zqZj0RR2HQoxDj8pxHBAXYPF_upeeU1L-4zNCQ6EcvF0AHdtulX0k/s16000/mengaktifkan%20dns%20resolver.png)


### b. Create NAT (Firewall)

Next step, we will configure NAT. Click the `Firewall ->> NAT` menu, then click the **"Outbound"** menu and click again on the **"Manual Outbound NAT rule generation"** menu. (AON - Advanced Outbound NAT)", you create NAT according to the image below.

![Advanced Outbound NAT](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiDctZJOn3XJals5RMcAQuom0Qb8IIPnYwQKrfqpxEMmEaLb7s0v6soWxO_ojLJZVuD0y3AMHPZaBSmfIHclE26Xf3Cy1JBvHEnrCXN9Vkd2GXiCnWJYge8TFocqMwGN7IR2eNzGxuGd_pFVh3aW6mXNZsIcTk8wVlJU6c4WFK61onPFlORluV5_DBjH1T5/s16000/membuat%20firewall%20outbound.png)


### c. Disable DHCPv6 Server

In this basic example, we only enable IP4. Therefore you must disable IP6. To disable IP6, click the `Services ->> DHCPv6 Server`, and uncheck the `"Enable DHCPv6 server on LAN interface"` option. follow the instructions in the image below.

![enable dhcp ipv6 server](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgMoLRdIe9MhtKNcn3yY22sdc7tIcSQQznR0XSxWwFAnrGBfhRSDjafcSNGCreZ_EgXpbWhoJY3OyaJQckj06V29hZzKA6UJpp8cAQcLWI5oMnjMrdJU3sVabNhFRrnqLnkS9iTjeOua7p_zDmhbU2noYuYPQjySti4Kp1ZPaaXEvlfcKib8FbfxxwkWlce/s16000/konfigurasi%20lan%20dhcpv6%20server.png)


### d. Disable Router Advertisement

After that, you also disable Router Advertisement. To do this, click the `Service ->> Router Advertisement`. In the `"Router Mode:"` option, select disable. Look at the example below.

![Router Advertisement](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgBoN8Dh1OJGhFJnX8jq1AXC9Qq5cgSLT0SxVbuab-I9bWH5zcIc_hh7vw5yb6F_dqolzy5Raw5ksSapPwIo6FIAAk4HgtLx6MdwyH8xpmm9LC7dxitUgxPzqNLpXaxwXjuNOFkBK9GTSfgUzPC_osoGjSMTqEZLGHWDuM9oEGrLb4brD6ioICktVhmdC1w/s16000/router%20advertisement.png)


### e. Setup Interface WAN and LAN

In this section we will configure the WAN and LAN interfaces. To understand it more easily, see the image below. Pay attention to the gateway choice. First we will configure the WAN interface.

![wan interface](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhMLX8LXEKr759nKdk62AKA2XREMKN3g1ZmOitguczGn-QgVOqGyTabj1lfDTdAdSejiVfnzXAtSxBSTn-TVnlqfxdB0o17-T0c_mKYAYkrZ3gFRO66CoUZq3swGO7esi5vlDFutsbSpn3U1B1E82GqGFhm3O9gjPw2m6uejmt96z7ywgn0DqpP8iB8IPED/s16000/konfigurasi%20wan%20interface.png)


After that, we configure the interface (without gateway). Look at the image below.

![lan interface](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhS93dVR7z8noBiopuhz1p-JD8JwBnr6naZas0eyYm_6GYXPcX0GHZu8L2N_XuZlRBS2ew0wkPPITnfxeHCSGlBm0tP3hcU8OFV47qMJHrfxFURSoD8qBsrOuTb1MpETma7jFM73EJp1vbiVSreypkep0Tu15aA4nMTrTJI49VqEmkhKcn2Ef_uCRRaGbjC/s16000/konfigurasi%20lan%20interface.png)


### f. Delete Gateway

In PFSense, the gateway has an important role in connecting your PFSense to the internet. Before we create a new Gateway, first delete the default Gateway that was created by PFSense automatically. like the picture below.

To delete the gateway, click the `System ->> Routing` menu. After that, click on the trash can icon, as shown in the image below.

![delete gateway](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh5o_bC5uciUaiGKq2V4uW4JJ9eWfwhyphenhyphen5FmU5Dn7cZLv1iqCgBKh4WcHZCjyqx9pjHLC_bTCkWmyzhTThCseLGCWMjy0Qv3YXp7CHfBmX3KlhQl9EJe788CPZVftvONh2mtO5S1ipbo1opBoDkJOS0ud6-WK7h4H6oz26Z7L2ZF6DwObaD6qsKeM_gMlsYO/s16000/membuat%20routing%20gateway.png)


After you click the trash can icon, the results will look like the image below.

![routing gateway](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi71iy7ctfFNu6RVxszICvzKfeN-6mNyleAiZxi3Lc5jEvLF8dvNmsYTJ0SQedC-jb61hRsqeGfm_4f2irQO-zGNYWQ_ZQybSvu2GdhpPX5B5tdXHGZ5zU-UtnRnFbY8S3syGJYBNHQFfXPQWyrDVFv97kri7-v7UtwFOqbvbpHVceAu15uI7Tp13uZWhrn/s16000/membuat%20gateway%20koneksi.png)


### g. Creating a New Gateway

After that, we continue by creating a new gateway on the WAN interface. Click the `Interfaces ->> WAN` menu. Follow the image guide below. Note the gateway on this interface.

![gateway wan interface](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgvWHhYKP7v4uQdtl-n2p-zLseeongVh1kWttZ4lRsFzDubeljTCKMo4c-MffB7hBxmGILi-ZctdkSEDQYs5JK-gkVyJVtmO619job6IUHVVYZw1Aia6AZnyt7a930C42RLNHwBJafX-hQ9oO86yIcfwxe_-j9ID9bUR22W0c3OoG3o729ub_88__G2OCLV/s16000/membuat%20gateway%20untuk%20interface%20wan.png)


### h. Setup DHCP Server

The next step you have to do is set up the DHCP server. To set up your DHCP server, click the `Services ->> DHCP Server`. Look at the image below, as your reference for configuring the DHCP server.

![service dhcp server lan](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiB1CuSPC4WfajXCj6joaF-7Iz2N7dOG3zzqWnuoDA9j7zyQcdT2htmjwI2SiLmFOFwq_ee9XJGdn7Cwe9HVlfS1khlffxzDFdPCyD7_MjqQfOdqFSa57jYrm7sA5EAXMDrFzt5numS8pcfGCzLlLOxerwj2rLk0kqggJWMBCsuMAkGy_b6WuEoAKl12jMn/s16000/mengaktifkan%20dhcp%20server%20untuk%20lan.png)


![server option](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgeRYuafNimlbq1Z_OlWLylxXG4xhOgOik95xFxC6nkfKs37kpEgv8uznSLRVtJBt7qgvyXKZSKw4obEfPChUA7Uq8Tl6XBkeKfORZ08jD2iIaksBBw4QCRtUrsY-mxdK2eZhEtiwEVRDK48X7iUCCvqhSZglMTiCzw4MLmwliShr9Ui_xPMCnJFr9JDJmF/s16000/mengkonfigurasi%20dhcp%20server%20pfsense.png)


The final step is to reboot your PFSense server. Wait until PFSense returns to running normally. After that, you test by opening Google Chrome and typing "https://www.youtube.com/". If you don't go through each configuration that we have explained, you should be able to open YouTube.

If your PFSense is not connected to the internet, you can start the steps in points "f" and "g".