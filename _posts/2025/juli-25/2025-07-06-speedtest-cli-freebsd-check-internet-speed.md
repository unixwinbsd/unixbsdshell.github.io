---
title: Speedtest CLI On FreeBSD To Check Internet Speed
date: "2025-07-06 09:17:13 +0100"
updated: "2025-07-06 09:17:13 +0100"
id: speedtest-cli-freebsd-check-internet-speed
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/13Using_Speedtest_CLI_on_FreeBSD.jpg
toc: true
comments: true
published: true
excerpt: Speedtest CLI allows FreeBSD users to test internet speed using a command-line interface (CLI). This CLI command can be used by software developers, system administrators, and computer enthusiasts to measure bandwidth speed
keywords: speedtest, cli, speedtest cli, freebsd, check, internet, speed, bandwith, queu
---

Speedtest CLI allows FreeBSD users to test internet speed using a command-line interface (CLI). This CLI command can be used by software developers, system administrators, and computer enthusiasts to measure bandwidth speed. Speedtest CLI natively measures internet connection performance metrics such as download, upload, latency, and packet loss without relying on a web browser.

Typically, most people measure bandwidth speed using a web browser, which can sometimes lead to inaccurate measurements depending on their internet subscription plan. Speedtest CLI brings the trusted technology and global server network behind Speedtest servers to a command-line interface. Built for software developers, system administrators, and computer enthusiasts, Speedtest CLI is the first official Linux-based Speedtest application supported by **Ookla**.

**Benefits of Using Speedtest CLI:**

- Measure internet connection performance metrics like download, upload, latency, and packet loss natively without relying on a web browser.
- Test the internet connection of Linux desktops, Windows, remote servers, or even low-power devices like Raspberry Pis with Speedtest Server Network.
- Set up automated scripts to collect connection performance data, including trends over time.
- Use Speedtest in your programs by wrapping it in your preferred programming language.
- View test results as CSV, JSONL, or JSON.

<br/>
<img alt="Using Speedtest CLI on FreeBSD" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/13Using_Speedtest_CLI_on_FreeBSD.jpg' | relative_url }}">
<br/>


Now let's practice installing and using the Speedtest CLI on FreeBSD.
If you're using FreeBSD, you can install the Speedtest CLI using the pkg package or the FreeBSD port. The Speedtest CLI runs in Python, so before installing the Speedtest CLI, you'll need to install Python first.

<br/>

```console
root@router2:~ # pkg update
root@router2:~ # pkg upgrade -y
```

After updating and upgrading pkg, proceed with installing python and Speedtest.


```console
root@router2:~ # pkg install -g libidn2 ca_root_nss
root@router2:~ # pkg install python39
root@router2:~ # pkg install py-speedtest-cli
```

If using the system port, follow the following script.


```console
root@router2:~ # cd /usr/ports/lang/python39
root@router2:/usr/ports/lang/python39 # make install clean

root@router2:~ # cd /usr/ports/net/py-speedtest-cli
root@router2:/usr/ports/net/py-speedtest-cli # make install clean
```

Once you've installed Speedtest CLI, it's time to use it to test your internet speed. Use the `"speedtest-cli"` script.

```console
root@router2:~ # speedtest-cli
Retrieving speedtest.net configuration...
Testing from PT Telkom Indonesia (36.90.9.6)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by PT. Telekomunikasi Indonesia (Bandung) [118.58 km]: 4.875 ms
Testing download speed............................................
Download: 14.82 Mbit/s
Testing upload speed..............................................
Upload: 6.19 Mbit/s
root@router2:~ #
```

Now we use the `"speedtest-cli --secure"` script, notice the difference.


```console
root@router2:~ # speedtest-cli --secure
Retrieving speedtest.net configuration...
Testing from PT Telkom Indonesia (36.90.9.6)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by JSN Jaringanku (Ponorogo) [545.49 km]: 75.286 ms
Testing download speed.................................................................
Download: 35.15 Mbit/s
Testing upload speed..............................................
Upload: 5.63 Mbit/s
root@router2:~ #
```

With the `"speedtest --single"` script.


```
root@router2:~ # speedtest --single
Retrieving speedtest.net configuration...
Testing from PT Telkom Indonesia (36.90.9.6)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by PT. Telekomunikasi Indonesia (Bandung) [118.58 km]: 5.736 ms
Testing download speed............................................
Download: 16.02 Mbit/s
Testing upload speed..............................................
Upload: 5.01 Mbit/s
root@router2:~ #
```

In JSON or CSV format.


```console
root@router2:~ # speedtest --secure --csv
45311,Pemerintah Kota Surabaya,Surabaya,2023-06-19T06:35:09.977058Z,663.1603865242897,12.454,21602493.377905495,6490160.553338757,,36.90.9.6
root@router2:~ #
```
<br/>

```console
root@router2:~ # speedtest --secure --json
{"download": 20362205.216706, "upload": 6426336.491038609, "ping": 12.445, "server": {"url": "http://speedtest.surabaya.go.id:8080/speedtest/upload.php", "lat": "-7.2667", "lon": "112.7333", "name": "Surabaya", "country": "Indonesia", "cc": "ID", "sponsor": "Pemerintah Kota Surabaya", "id": "45311", "host": "speedtest.surabaya.go.id:8080", "d": 663.1603865242897, "latency": 12.445}, "timestamp": "2023-06-19T06:36:59.906721Z", "bytes_sent": 8208384, "bytes_received": 31958486, "share": null, "client": {"ip": "36.90.9.6", "lat": "-6.1741", "lon": "106.8296", "isp": "PT Telkom Indonesia", "isprating": "3.7", "rating": "0", "ispdlavg": "0", "ispulavg": "0", "loggedin": "0", "country": "ID"}}
root@router2:~ #
```

In this short tutorial, we'll learn how to install `speedtest-cli` to test internet bandwidth using Ookla's speedtest.net on a Unix FreeBSD server or desktop system. Ookla's Speedtest service is also available in a web browser, so you can try it and compare the results with Speedtest CLI.
