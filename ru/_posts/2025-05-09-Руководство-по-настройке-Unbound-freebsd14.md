---
title: Руководство по настройке Unbound для кэширования и DOT на портах 853 и 53 с FreeBSD 14
date: "2025-05-08 20:10:15 +0100"
id: Руководство-по-настройке-Unbound-freebsd14
lang: de
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "DNSServer"
excerpt: DNSSEC обеспечивает аутентификацию записей DNS с использованием цифровых подписей, которые защищают их от возможной замены
keywords: unbound, freebsd, doh, dot, unix, dnssec, установить, конфигурация
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
После этого создайте файл журнала Unbound.

```
root@ns4:~ # mkdir -p /usr/local/etc/unbound/log
root@ns4:~ # touch /usr/local/etc/unbound/log/unbound.log
root@ns4:~ # chown -R unbound:unbound /usr/local/etc/unbound/log
```
Следующий шаг — редактирование файла unbound.conf, который находится по адресу /usr/local/etc/unbound/unbound.conf

Прежде чем редактировать файл unbound.conf, в этом разделе мы разделим его на 3 сеанса, а именно:

1. Unbound Server как DNS-кэширование (порт 53).
2. Server Unbound как DNS-кэширование и DNS через TLS (порт 853)

Это было специально создано, чтобы читателям было легче понять и изучить Unbound-сервер.
<br/>
<p>
## Поддерживать

Если вы считаете, что моя статья ценна и полезна для вас.

Пожалуйста, рассмотрите возможность сделать пожертвование.

Ваше пожертвование очень ценно для написания следующих статей более высокого качества.

#### Спасибо.

##### Payeer: P1052173944
##### Paypal: datainchi@gmail.com
##### Faucetpay: datainchi@gmail.com
##### Bitcoin Payeer: 32RW6hDPRA5bNtcHS4HQX8S4FSGsEvmJ9T
##### Bitcoin Faucetpay: 1QPJFAXtrLZWJLi9PPTeYXVEZKwydXQoY
</p>


### a. Unbound Server как DNS-кэширование (порт 53)
Чтобы unbound функционировал как DNS-кэширование, мы должны отредактировать файл unbound.conf. В этом файле вы активируете только несколько скриптов, а именно, удаляя знак "#" перед скриптом. Скрипт ниже является примером скрипта, который вы должны активировать в файле "/usr/local/etc/unbound".

```
interface: 192.168.5.71
interface: 127.0.0.1
port: 53
do-ip4: yes
do-udp: yes
do-tcp: yes
access-control: 192.168.5.0/24 allow
access-control: 127.0.0.0/8 allow
username: "unbound"
directory: "/usr/local/etc/unbound"
logfile: "/usr/local/etc/unbound/log/unbound.log"
pidfile: "/usr/local/etc/unbound/unbound.pid"
root-hints: "/usr/local/etc/unbound/root.hints"
hide-identity: yes
hide-version: yes
private-domain: "miner4pool.org"
domain-insecure: "miner4pool.org"
domain-insecure: "5.168.192.in-addr.arpa"
control-interface: 127.0.0.1
control-port: 8953
server-key-file: "/usr/local/etc/unbound/unbound_server.key"
server-cert-file: "/usr/local/etc/unbound/unbound_server.pem"
control-key-file: "/usr/local/etc/unbound/unbound_control.key"
control-cert-file: "/usr/local/etc/unbound/unbound_control.pem"
forward-zone:
  name: "."
  forward-addr: 1.1.1.1
  forward-addr: 1.0.0.1
  forward-addr: 68.105.28.12
  forward-addr: 68.105.29.11
  forward-addr: 8.8.8.8
```
В скрипте интерфейса введите IP-адрес в соответствии с IP-адресом вашего сервера FreeBSD.

После завершения процесса редактирования файла unbound.conf перезапустите unbound-сервер с помощью команды "restart".

```
root@ns4:~ # service unbound restart
```
После этого мы делаем тест, несвязанный DNS-сервер как кэширующий. Мы протестируем "linkedin.com". Сконфигурированный нами выше несвязанный DNS сервер работает нормально или нет?

```
root@ns4:~ # dig linkedin.com

; <<>> DiG 9.18.26 <<>> linkedin.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 60421
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;linkedin.com.                  IN      A

;; ANSWER SECTION:
linkedin.com.           300     IN      A       150.171.22.12

;; Query time: 37 msec
;; SERVER: 192.168.5.71#53(192.168.5.71) (UDP)
;; WHEN: Thu May 08 09:34:13 WIB 2025
;; MSG SIZE  rcvd: 57
```
Из примера команды выше, unbound dns запустился нормально. Мы видим, что IP linkedin.com был кэширован unbound dns IP вашего сервера FreeBSD. Обратите внимание на IP 192.168.5.71, этот IP является IP unbound сервера, который вы настроили.

Теперь мы используем команду nslookup для проверки unbound DNS.

```
root@ns4:~ # nslookup linkedin.com
Server:         192.168.5.71
Address:        192.168.5.71#53

Non-authoritative answer:
Name:   linkedin.com
Address: 150.171.22.12
Name:   linkedin.com
Address: 2620:1ec:50::12
```

До этого момента вы успешно запускали несвязанный DNS-сервер как DNS-кэширующий. Теперь мы продолжим, настроив несвязанный DNS Over TLS, работающий на порту 853.

### Unbound Server как DNS Caching и DNS Over TLS
Другим более современным способом защиты DNS-трафика является протокол DNS-over-TLS, описанный в стандарте RFC7858, который представляет собой инкапсуляцию данных в стандартный TLS. Мы рекомендуем использовать порт 853 для доступа. Как и DNSCrypt, предполагается, что DNS-клиент, который обычно является тем же локальным кэширующим DNS, обращается к удаленному серверу, который поддерживает DNS-over-TLS.

Вышеупомянутый Unbound имеет встроенную поддержку этого протокола, поэтому для его использования не требуется дополнительного программного уровня, как в случае с DNSCrypt.

Для запуска Unbound как DNS-over-TLS ему нужен только список серверов в зоне пересылки, как и в файле конфигурации выше, но есть несколько вещей, которые необходимо изменить. Настройка Unbound как сервера, обслуживающего запросы DNS-over-TLS, также проста. Для этого можно использовать существующий сертификат TLS, например openssl.

Первый шаг, который необходимо предпринять для реализации unbound как сервера DNS Over TLS, — это создание сертификата SSL. Мы поместим этот файл unbound SSL в каталог /etc/ssl/unbound. Для этого в меню консоли Putty введите следующую команду.

```
root@ns4:~ # cd /etc
root@ns4:/etc # mkdir -p ssl
root@ns4:/etc # mkdir -p /etc/ssl/unbound
root@ns4:/etc # cd /etc/ssl/unbound
root@ns4:/etc/ssl/unbound #
```

В текущем активном каталоге (/etc/ssl/unbound) вы создаете SSL сертификат с помощью команды openssl, как в примере ниже.

```
root@ns4:/etc/ssl/unbound # openssl genrsa -des3 -out myCA.key 2048
root@ns4:/etc/ssl/unbound # openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
root@ns4:/etc/ssl/unbound # openssl req -new -newkey rsa:2048 -nodes -keyout mydomain.key -out mydomain.csr
root@ns4:/etc/ssl/unbound # openssl x509 -req -in mydomain.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out mydomain.pem -days 1825 -sha256
```
После завершения создания SSL-сертификата продолжите, изменив файл скрипта "/usr/local/etc/unbound/unbound.conf".

В файле "/usr/local/etc/unbound/unbound.conf" вы активируете еще несколько скриптов, которые соответствуют непривязанной конфигурации для порта 853. Ниже приведен пример скрипта, который необходимо активировать в файле "/usr/local/etc/unbound/unbound.conf".

```
interface: 192.168.5.71@853
tcp-upstream: yes
do-not-query-localhost: no
tls-service-key: "/etc/ssl/unbound/mydomain.key"
tls-service-pem: "/etc/ssl/unbound/mydomain.pem"
tls-port: 853
forward-zone:
name: "."
forward-first: no
forward-ssl-upstream: yes
forward-addr: 1.1.1.1@853
forward-addr: 1.0.0.1@853
forward-addr: 68.105.28.12@853
forward-addr: 68.105.29.11@853
forward-addr: 8.8.8.8@853
```
Прежде чем запустить unbound, мы сначала проверим SSL-сертификат, который мы создали выше для защиты Unbound DNS сервера. Запустите команду ниже, чтобы проверить SSL-сертификат.

```
root@ns4:~ # openssl s_client -connect 192.168.5.71:853
root@ns4:~ # openssl s_client -connect 1.1.1.1:853
```
После этого перезапустите непривязанный сервер.
```
root@ns4:~ # service unbound restart
Stopping unbound.
Waiting for PIDS: 941.
Obtaining a trust anchor...
Starting unbound.
```
Следующий шаг  проверить unbound, запущен ли unbound на порту 853. Используйте команду dig для проверки unbound.
```
root@ns4:~ # dig linkedin.com -p 853

; <<>> DiG 9.18.26 <<>> linkedin.com -p 853
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 63430
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;linkedin.com.                  IN      A

;; ANSWER SECTION:
linkedin.com.           187     IN      A       150.171.22.12

;; Query time: 112 msec
;; SERVER: 192.168.5.71#853(192.168.5.71) (UDP)
;; WHEN: Thu May 08 10:51:57 WIB 2025
;; MSG SIZE  rcvd: 57

root@ns4:~ #
```
Ответ сервер: 192.168.5.71#853, это означает, что порт NDS Over TLS 853 непривязанного сервера активен.

Чтобы проверить, открыт ли порт 853 или нет. Введите следующую команду, чтобы увидеть DNS-порт 853, работающий на вашем сервере FreeBSD.
```
root@ns4:~ # sockstat -P udp -p 53,853
USER     COMMAND    PID   FD  PROTO  LOCAL ADDRESS         FOREIGN ADDRESS
unbound  unbound      974 3   udp4   192.168.5.71:53       *:*
unbound  unbound      974 5   udp4   127.0.0.1:53          *:*
unbound  unbound      974 7   udp4   192.168.5.71:853      *:*
root@ns4:~ #
```
Из открытых портов выше мы видим, что открыты порты 853 и 53. Это указывает на то, что Server Unbound DNS Over TLS РАБОТАЕТ.

### D. Создание Unbound файла журнала
Последний шаг создание файла журнала. В консоли Putty введите команду ниже и введите скрипт в файл /etc/newsyslog.conf.
```
root@ns4:~ # ee /etc/newsyslog.conf

/usr/local/etc/unbound/log/unbound.log  unbound:wheel     640  7     *    @T12  JBR   /usr/local/etc/unbound/log_reopen
```
Следующим шагом мы создаем файл log_reopen и вводим в него следующий скрипт.

```
root@ns4:~ # ee /usr/local/etc/unbound/log_reopen

#!/bin/sh
/usr/local/sbin/unbound-control -q log_reopen
exit 0
```
Затем перезапустите несвязанные и системные файлы журнала.

```
root@ns4:~ # service unbound restart
Stopping unbound.
Waiting for PIDS: 974.
Obtaining a trust anchor...
Starting unbound.
root@ns4:~ # service newsyslog restart
Creating and/or trimming log files.
root@ns4:~ #
```
DNS через TLS или DNS через TCP, но заключенный в сеанс TLS, будет шифровать ваши запросы и ответы сервера, а также опционально позволит вам проверить подлинность сервера.

Преимущество — защита от прослушивания и манипуляции вашим трафиком DNS. Недостатком является небольшое снижение производительности и потенциальные проблемы обхода брандмауэра, поскольку он работает через нестандартный порт (TCP-порт 853), который может быть заблокирован в некоторых сетях.

Это руководство помогло вам в настройке и конфигурировании Unbound DNS Over TLS. Эти руководства подробно обсуждаются и структурируются, с надеждой, что вы сможете легко их понять.
