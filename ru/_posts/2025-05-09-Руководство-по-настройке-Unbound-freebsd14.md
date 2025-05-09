---
title: Руководство по настройке Unbound для кэширования и DOT на портах 853 и 53 с FreeBSD 14
date: "2025-05-09 20:10:15 +0100"
id: installation-process-examples-using-swoole-php-freebsd
lang: de
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "DNSServer"
excerpt: Swoole ist in der Programmiersprache C oder C++ geschrieben und wird als PHP-Erweiterung installiert.
keywords: swoole, php, framewotk, freebsd, unix, laravel
---

Служба DNS или система доменных имен является базовой службой Интернета, а также других сетей, работающих на основе семейства протоколов TCP/IP, и используется для получения соответствующего имени хоста в сети с соответствующим цифровым адресом. Несмотря на простоту описания, DNS, пожалуй, самая сложная сетевая служба по своей структуре и набору взаимодействий, и ее надежная работа зависит от надежной работы всех и вся.

DNSSEC обеспечивает аутентификацию записей DNS с использованием цифровых подписей, которые защищают их от возможной замены. Однако, в то же время, все данные всегда передаются в открытом виде и никоим образом не защищены от просмотра во время передачи. При отсутствии цифровой подписи, при желании, ее можно легко модифицировать для различных целей  от криминальных до цензурных.

В этой статье объясняется, как настроить и использовать несвязанный Unbound DNS server как в качестве кэширующего, DNSSEC, так и в качестве DNS по протоколу TLS.

Unbound  это высокозащищенный проверяющий, рекурсивный и кэширующий DNS-сервер, разработанный компаниями NLnet Labs, VeriSign Inc, Nominet и Kirei. Это программное обеспечение распространяется бесплатно по лицензии BSD. Двоичные файлы написаны с повышенным вниманием к безопасности и очень строгим кодом на языке Си.

![Root Authoritative DNS Servers](https://www.opencode.net/unixbsdshell/balena-etcher-portable-173/-/raw/main/Root_Authoritative_DNS_Servers.jpg)

Чтобы улучшить конфиденциальность в Интернете, Unbound поддерживает DNS-over-TLS и DNS-over-HTTPS, что позволяет клиентам шифровать свои сообщения. Кроме того, он поддерживает различные современные стандарты, которые ограничивают объем данных, обмениваемых с официальными серверами. Этот стандарт не только улучшает конфиденциальность, но и помогает повысить надежность DNS.

Наиболее важными из них являются минимизация имен запросов, активное использование кэша, проверенного DNSSEC, и поддержка зон полномочий, которые можно использовать для загрузки копии корневой зоны.

## A. Технические характеристики системы
OS: FreeBSD 14.3-PRERELEASE stable/14-c0c5d01e5374
Hostname: ns4
Domain: miner4pool.org
IP LAN Private: 192.168.5.71/24
Unbound Caching DNS Server: 192.168.5.71@53
Unbound Caching DNS over TLS: 192.168.5.71@853
Unbound version : Version 1.19.3
Bind-Tools version : bind-tools-9.18.26_1
WGET version: wget-1-24.5

## B. Unbound установка
Как правило, для установки Unbound на сервер FreeBSD вы можете использовать две вещи, а именно порты и pkg. В этой статье мы обсудим установку с помощью pkg.

На первом этапе, пожалуйста, войдите на свой сервер FreeBSD через консоль FreeBSD или удаленный SSH с помощью PuTTY, затем запустите следующие командные строки:

```
root@ns4:~ #  pkg update
root@ns4:~ #  pkg upgrade
```
После завершения обновления пакета pkg мы продолжаем установку unbound, введите следующую команду для установки unbound.

```
root@ns4:~ #  pkg install unbound bind-tools ca_root_nss
```

Чтобы unbound сервер мог запускаться автоматически при каждом выключении или перезапуске сервера FreeBSD, вы должны сначала добавить следующую команду в rc.conf, введя приведенный ниже сценарий в файл /etc/rc.conf.

```
### example /etc/rc.conf ###

root@miner4:~ # ee /etc/rc.conf

unbound_enable="YES"
unbound_config="/usr/local/etc/unbound/unbound.conf"
unbound_pidfile="/usr/local/etc/unbound/unbound.pid"
unbound_anchorflags=""
```

После этого в файле "resolv.conf" введите скрипт, указанный ниже. Для добавления скрипта используйте приложение FreeBSD по умолчанию, а именно "ee".

```
### example /etc/resolv.conf ###

root@miner4:~ # ee /etc/resolv.conf

domain miner4pool.org
nameserver 192.168.5.71
```
Отредактируйте файл hosts, используйте команду ee /etc/hosts, затем введите следующий синтаксис.
```
### example /etc/hosts ###

root@ns4:~ # ee /etc/hosts

127.0.0.1      localhost localhost.miner4pool.org
192.168.5.71    ns4 ns4.miner4pool.org
```
## C. Конфигурация Unbound
Прежде чем мы начнем настраивать unbound.conf, для приложения unbound требуется файл "root.hints", в котором указан основной DNS-сервер. Приложение Unbound DNS Server содержит в своем коде список корневых DNS-серверов, но оно обеспечивает актуальную копию на каждом сервере. Рекомендуется обновлять этот файл каждые шесть месяцев.

По умолчанию файл unbound.conf находится в каталоге /usr/local/etc/unbound. В консоли Putty введите следующую команду.

```
root@ns4:~ # wget ftp://FTP.INTERNIC.NET/domain/named.cache -O /usr/local/etc/unbound/root.hints
--2025-05-08 08:55:15--  ftp://ftp.internic.net/domain/named.cache
           => ‘/usr/local/etc/unbound/root.hints’
Resolving ftp.internic.net (ftp.internic.net)... 192.0.47.9, 2620:0:2d0:200::9
Connecting to ftp.internic.net (ftp.internic.net)|192.0.47.9|:21... connected.
Logging in as anonymous ... Logged in!
==> SYST ... done.    ==> PWD ... done.
==> TYPE I ... done.  ==> CWD (1) /domain ... done.
==> SIZE named.cache ... 3311
==> PASV ... done.    ==> RETR named.cache ... done.
Length: 3311 (3.2K) (unauthoritative)

named.cache                     100%[====================================================>]   3.23K  --.-KB/s    in 0s

2025-05-08 08:55:30 (369 MB/s) - ‘/usr/local/etc/unbound/root.hints’ saved [3311]
```
Кроме того, для Unbound требуется файл "auto-trust-anchor". Этот файл содержит ключи для проверки DNSSEC. Чтобы сгенерировать root.key, выполните следующую команду в консоли putty.
```
root@ns4:~ # unbound-anchor -a "/usr/local/etc/unbound/root.key"
```
Следующим шагом будет создание необходимых ключей для Unbound, которые будут управляться unbound-control. Введите команду ниже, чтобы запустить настройку unbound-control.
```
root@ns4:~ # unbound-control-setup /usr/local/etc/unbound
setup in directory /usr/local/etc/unbound
Certificate request self-signature ok
subject=CN = unbound-control
removing artifacts
Setup success. Certificates created. Enable in unbound.conf file to use
root@ns4:~ #
```





