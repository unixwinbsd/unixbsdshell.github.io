---
title: OpenBSD OpenNTPD Installations prozess zum Synchronisieren der Uhr mit dem NTP Server
date: "2025-04-18 20:21:14 +0100"
id: openbsd-openntpd-ntp-time-server-clock
lang: de
layout: single
author_profile: true
categories:
  - OpenBSD
tags: "SysAdmin"
excerpt: OpenNTPD ist ein Daemon, der die Protokolle SNTP Version 4 und NTP Version 3 implementiert, um die lokale Systemzeit mit einem Remote NTP Server oder einem lokalen Zeitabweichungssensor zu synchronisieren.
keywords: ntp, openntpd, openbsd, time, clock, server, freebsd, unix
---

Das OpenBSD Projekt ist für seine hohen Sicherheitsstandards bekannt und hat sich im Laufe der Zeit als sehr sicheres, UNIX ähnliches freies Betriebssystem bewährt. Einer der bekanntesten Daemons von OpenBSD ist OpenNTPD. Als Teil von OpenBSD kann OpenNTPD auf fast jedem Betriebssystem ausgeführt werden.

OpenNTPD ist ein Daemon, der die Protokolle SNTP Version 4 und NTP Version 3 implementiert, um die lokale Systemzeit mit einem Remote-NTP-Server oder einem lokalen Zeitverschiebungssensor zu synchronisieren. Der OpenNTPD Daemon kann als NTP-Server für Clients fungieren, die mit diesem Protokoll kompatibel sind.

Die OpenNTPD Anwendung wurde von [Henning Brauer](https://www.henningbrauer.com/) als Teil des OpenBSD Projekts entwickelt. Das Hauptziel dieses Projekts ist die Erstellung eines sicheren, einfach zu konfigurierenden, relativ genauen und kostenlos verteilten (Open Source) Zeitmanagementservers.

## A. Ersteinrichtung
OpenBSD geht davon aus, dass Ihre Hardwareuhr auf UTC (Universal Coordinated Time) und nicht auf die Ortszeit eingestellt ist. Dies kann zu Problemen beim Multi Boot führen. Die meisten anderen Betriebssysteme können auf die gleiche Weise wie OpenBSD konfiguriert werden, um dieses Problem zu vermeiden.

Wenn die Verwendung von UTC Probleme verursacht, können Sie diese Einstellung in der Datei "sysctl.conf" ändern. Fügen Sie beispielsweise das folgende Skript zur Datei "/etc/sysctl.conf" hinzu. Der Zweck dieses Skripts besteht darin, OpenBSD so zu konfigurieren, dass die Hardwareuhr auf die lokale Zeit oder die Zeit einer anderen Region eingestellt wird.

```
kern.utc_offset=-300
```

Es ist wichtig zu beachten, dass die Uhr auf dem OpenBSD-Server mit der obigen Konfiguration und den erforderlichen Offsets laufen muss, bevor der OpenBSD-Server bootet, da sonst die Systemzeit während des Bootens falsch eingestellt wird.

Normalerweise wird die Zeitzone während des Installationsvorgangs eingestellt. Wenn Sie die Zeitzone ändern müssen, können Sie in der Datei **"/usr/share/zoneinfo"** einen neuen symbolischen Link zur entsprechenden Zeitzonendatei erstellen. Konfigurieren Sie die Maschine beispielsweise so, dass sie die Zeitzone des westlichen Teils Indonesiens als neue lokale Zeitzone auf Ihrem OpenBSD-Server verwendet.

**Lokalzeit Symlink erstellen**
```
ns2# ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
```

## B. OpenNTPD Konfiguration
Da OpenNTP ein von den OpenBSD-Entwicklern erstellter Daemon ist, müssen Sie ihn nicht installieren. OpenNTPD wird auf OpenBSD-Systemen automatisch installiert. Sie müssen es also nur konfigurieren.

Auf OpenBSD-Systemen befindet sich die Hauptkonfigurationsdatei von OpenNTPD in der Datei **"/etc/ntpd.conf"**. Die erste Zeile in Ihrer Datei **"/etc/ntpd.conf"** definiert die Schnittstelle, die eine Verbindung zum Internet herstellt. Wenn wir über Schnittstellen sprechen, sollten wir IP Adressen nicht ignorieren.

Anschließend definieren Sie den Server, den Sie synchronisieren möchten. NTP verwendet ein hierarchisches "hourly level" System.  Level 1 wird mit einer hochpräzisen Uhr wie GPS, GLONASS oder einem Atomzeitstandard synchronisiert. Level 2 wird mit einer der Level 1 Maschinen synchronisiert und so weiter.

Es ist jedoch wichtig, sich daran zu erinnern, dass der Füllstand nicht immer ein Indikator für die Genauigkeit ist. Normalerweise werden Server der dritten Ebene zum Synchronisieren der Benutzercomputer verwendet. Wenn Sie den NTP-Server in Ihrer Gegend nicht kennen, verwenden Sie pool.ntp.org und wählen Sie einen Server in Ihrer Region aus.

Unten finden Sie ein Beispiel für ein Skript zur Datei "/etc/ntpd.conf", das Sie ausprobieren können.

```
# $OpenBSD: ntpd.conf,v 1.5 2019/11/11 16:44:37 deraadt Exp $
# sample ntpd configuration file, see ntpd.conf(5)

# Addresses to listen on (ntpd does not listen by default)
listen on 192.168.5.3

# sync to a single server
#server ntp.example.org

# use a random selection of NTP Pool Time Servers
# see http://support.ntp.org/bin/view/Servers/NTPPoolServers
servers pool.ntp.org

# time server with excellent global adjacency
server time.cloudflare.com
servers pool.ntp.org
server time.cloudflare.com
server time.windows.com
server time.nist.gov

# use a specific local timedelta sensor (radio clock, etc)
sensor *

# use all detected timedelta sensors
#sensor *

# get the time constraint from a well-known HTTPS site
constraint from "9.9.9.9"		# quad9 v4 without DNS
constraint from "2620:fe::fe"		# quad9 v6 without DNS
constraints from "www.google.com"	# intentionally not 8.8.8.8
```

Anda dapat mengganti alamat Ip 192.168.5.3, dengan menggunakan alamat IP server OpenBSD yang sedang anda gunakan saat ini.

## C. So aktivieren Sie OpenNTPD
Obwohl der OpenNTPD Daemon standardmäßig auf OpenBSD-Systemen installiert ist, ist er nicht sofort aktiv. In diesem Abschnitt aktivieren wir OpenNTPD bei jedem Neustart des OpenBSD-Servers.

Um OpenNTPD zu aktivieren, können Sie die Datei **"/etc/rc.conf"** öffnen und ein Skript wie im folgenden Beispiel hinzufügen.

```
ntpd_flags="-s"
ntpctl_flags="-s"
```

Anschließend führen Sie den folgenden Befehl aus, um den OpenNTPD-Server zu aktivieren.

```
ns2# rcctl restart ntpd
```

Führen Sie außerdem den folgenden Befehl aus, um sicherzustellen, dass der OpenNTPD-Daemon ausgeführt wird.

```
ns2#  ntpd -dnv
configuration OK
ns2# ntpd -f /etc/ntpd.conf
ntpd: ntpd already running
```

## D. Überwachung von OpenNTPD
Sobald der OpenNTPD Daemon synchronisiert wurde und normal läuft, können Sie die Aktivität des Zeitservers mit dem folgenden Befehl überwachen.

```
ns2# ntpctl -s all
ns2# ntpctl -s peers
ns2# ntpctl -s Sensors
ns2# ntpctl -s status
```

Wenn Ihr Windows Computer beim Synchronisieren ein oder zwei Stunden hinterherhinkt, stellen Sie sicher, dass er die "Daylight Savings Time". Doppelklicken Sie im Menü der Systemsteuerung auf "Date and Time" und klicken Sie dann auf die Registerkarte "Time Zone". Stellen Sie sicher dass "Automatically adjust clock for daylight savings changes" aktiviert ist.

![Synchronize date and time in windows system](https://raw.githubusercontent.com/iwanse1977/qiita-article/refs/heads/main/Synchronize%20date%20and%20time%20in%20windows%20system.jpg)

Eine einigermaßen genaue aktuelle Zeitangabe vom US Naval Observatory erhalten Sie unter: [http://tycho.usno.navy.mil/cgi-bin/timer.pl](http://tycho.usno.navy.mil/cgi-bin/timer.pl).
