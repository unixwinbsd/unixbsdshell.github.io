---
title: FreeBSD Tutorial - Setting up Apache mod OpenSSL for HTTPS
date: "2025-08-10 10:13:21 +0100"
updated: "2025-08-10 10:13:21 +0100"
id: tutorials-freebsd-setup-apache-mod-ssl-tls-https
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://pbs.twimg.com/media/GEvRQ5Xa0AA2OJV?format=jpg&name=large
toc: true
comments: true
published: true
excerpt: Secure Sockets Layer Protocol, often referred to as SSL, is a security protocol that can be placed between the TCP/IP network layer protocol and the HTTP application layer protocol. The SSL mod in Apache provides secure communication between clients and servers
keywords: freebsd, tutorials, apache, web server, mod, ssl, openssl, tls, https, key, module
---

The Apache web server has been around for many years, and its user base continues to grow. mod_ssl provides enhanced security for Apache web servers and can be installed on almost all versions of Apache and all operating systems, including FreeBSD, Linux, macOS, and Windows.

Secure Sockets Layer Protocol, often referred to as SSL, is a security protocol that can be placed between the TCP/IP network layer protocol and the HTTP application layer protocol. The SSL mod in Apache provides secure communication between clients and servers. This mod performs authentication and uses digital signatures for integrity and encryption for privacy. Currently, two versions of SSL are in use: version 2 and version 3.

SSL/TLS uses Public Key Cryptography (PKC), also known as Asymmetric PKC Cryptography. Public key cryptography is used in situations where the client and server do not share the same secret, such as between a browser and a web server, but both want to establish a secure system with a trusted channel for their communication.

Public Key Cryptography, or PKC, defines an algorithm that uses two keys, each of which can be used to encrypt a message. If one key is used to encrypt a message, the other key must be used to decrypt it. This process allows for secure message reception by publishing only one key (the public key) and keeping the other key (the private key) secret.

Public keys can be encrypted by anyone, but only the owner of the private key can read them. For example, if Mary sends a private message to the owner of the key pair (e.g., your web server), the message from Mary will be encrypted using the public key issued by your server. Only you can decrypt it using the corresponding private key.

See the image below.

![symentric cryptography apache mod ssl](https://pbs.twimg.com/media/GEvRQ5Xa0AA2OJV?format=jpg&name=large)

This guide will help you enable SSL for websites served on the Apache web server. This article focuses solely on establishing SSL in Apache using the OpenSSL application.


## 1. How to Install OpenSSL
OpenSSL is a utility for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols. OpenSSL is free and one of the most widely used cryptographic libraries. Its primary purpose is to secure connections on servers and within your software.

The OpenSSL installation process on FreeBSD is quite straightforward, with no startup `rc.d` settings required. However, the setup and implementation are somewhat complex and sometimes confusing. Please use the steps in this article.

```yml
root@ns3:~ # pkg install perl5
```

Once you've installed `Perl`, you can install `OpenSSL` directly. We recommend using the FreeBSD port for a smoother installation.

```yml
root@ns3:~ # cd /usr/ports/security/openssl
root@ns3:/usr/ports/security/openssl # make config
root@ns3:/usr/ports/security/openssl # make install clean
```

FreeBSD has many applications similar to OpenSSL, such as `ca_root_nss, LibreSSL`, and others. To make FreeBSD use OpenSSL security by default for encryption and decryption, type the following command in `/etc/make.conf`.

```yml
DEFAULT_VERSIONS+=ssl=openssl
```

## 2. Create server.crt and server.key files
The first step you need to take to enable Apache to connect to OpenSSL is to create the `server.key and server.crt` files. To do this, we first create the SSL folder.

```yml
root@ns3:~ # cd /usr/local/etc/apache24
root@ns3:/usr/local/etc/apache24 # mkdir -p ssl
root@ns3:/usr/local/etc/apache24 # cd ssl
```

Generate `server.key` using openssl.

```console
root@ns3:/usr/local/etc/apache24/ssl # openssl genrsa -des3 -out server.key 1024
Generating RSA private key, 1024 bit long modulus (2 primes)
..+++++
.............................................+++++
e is 65537 (0x010001)
Enter pass phrase for server.key:
Verifying - Enter pass phrase for server.key:
```
The above command will create a `server.key` file and prompt for a password. Be sure to remember this password. You'll need it the next time you start Apache.

Next, create a certificate request file, `"server.csr"`. This file will use the `server.key` file mentioned above.

```yml
root@ns3:/usr/local/etc/apache24/ssl # openssl req -new -key server.key -out server.csr
```

The final step is to create a self-signed ssl certificate (server.crt) using the `server.key and server.csr` files above.

```yml
root@ns3:/usr/local/etc/apache24/ssl # openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```

## 3. Enable SSL mod
The instructions below will guide you through enabling SSL mode in Apache. This allows OpenSSL and Apache to communicate with each other to secure your web server.

On almost all operating systems, the Apache configuration file is called `"httpd.conf"` the only difference being the location. On FreeBSD, this file is located in the `"/usr/local/etc/apache24"` directory. Open the file and enable the SSL script within it, as in the example below.

```console
LoadModule ssl_module libexec/apache24/mod_ssl.so
LoadModule socache_shmcb_module libexec/apache24/mod_socache_shmcb.so
Include etc/apache24/extra/httpd-ssl.conf
```

In the script above, we activate the `httpd-ssl.conf` file. Open the file and delete all the contents of the script, then put the script below into the file `"/usr/local/etc/apache24/extra/httpd-ssl.conf"`.

```console
Listen 443

SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES

SSLHonorCipherOrder on 

SSLProtocol all -SSLv3
SSLProxyProtocol all -SSLv3

SSLPassPhraseDialog  builtin
SSLSessionCache        "shmcb:/var/run/ssl_scache(512000)"
SSLSessionCacheTimeout  300

<VirtualHost _default_:443>
DocumentRoot "/usr/local/www/apache24/data"
ServerName www.datainchi.com:443
ServerAdmin datainchi@gmail.com
ErrorLog "/var/log/httpd-error.log"
TransferLog "/var/log/httpd-access.log"

SSLEngine on

SSLCertificateFile "/usr/local/etc/apache24/ssl/server.crt"
SSLCertificateKeyFile "/usr/local/etc/apache24/ssl/server.key"

<FilesMatch "\.(cgi|shtml|phtml|php)$">
    SSLOptions +StdEnvVars
</FilesMatch>
<Directory "/usr/local/www/apache24/cgi-bin">
    SSLOptions +StdEnvVars
</Directory>

BrowserMatch "MSIE [2-5]" nokeepalive ssl-unclean-shutdown downgrade-1.0 force-response-1.0
CustomLog "/var/log/httpd-ssl_request.log" "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"

</VirtualHost>
```

Take a look at the script above. it's the OpenSSL file we created earlier. To test all of the above configurations, restart the Apache server.

```console
root@ns3:~ # service apache24 restart
Performing sanity check on apache24 configuration:
Syntax OK
Stopping apache24.
Waiting for PIDS: 36862.
Performing sanity check on apache24 configuration:
Syntax OK
Starting apache24.
Apache/2.4.58 mod_ssl (Pass Phrase Dialog)
Some of your private key files are encrypted for security reasons.
In order to read them you have to provide the pass phrases.

Private key www.datainchi.com:443:0 (/usr/local/etc/apache24/ssl/server.key)
Enter pass phrase:

OK: Pass Phrase Dialog successful.
```

You will be prompted to enter a password; type the password from the OpenSSL file you created above.

The next test is to open the Google Chrome web browser and type `"https://192.168.5.2/"`.

This tutorial demonstrates the basic installation and use of mod_ssl on an Apache server with OpenSSL. Although the command is very simple, its ability to protect web servers is very reliable and has been proven, as many people use OpenSSL as their SSL security system on Apache servers.