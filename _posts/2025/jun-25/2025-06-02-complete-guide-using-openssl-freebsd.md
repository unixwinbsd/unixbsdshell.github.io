---
title: Guide to Using OpenSSL Commands in FreeBSD
date: "2025-06-02 13:11:01 +0100"
updated: "2025-06-02 13:11:01 +0100"
id: complete-guide-using-openssl-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: CAcert is a certificate authority that issues free SSL Certificates. If you are new to SSL Certificates, this site is a great place to learn about the SSL Certificate signing process. You can create a certificate signing request as described in this guide and have it signed by CAcert
keywords: complete, openssl, ssl, tls, command, certificate, freebsd, ca, cert
---

OpenSSL is an open source toolkit and cryptographic library that implements the SSL (Secure Sockets Layer) and TLS (Transport Layer Security) protocols. OpenSSL is an independent project maintained by volunteers from all over the world. In short, OpenSSL provides a cryptographic toolkit for securing network connections. A common implementation of SSL is to secure web pages with HTTPS (HyperText Transfer Protocol secured with encryption). OpenSSL encryption over the HTTP protocol consists of the following steps:
- An HTTP client (web browser) sends an HTTPS request to a web server.
- The server responds by sending an SSL Certificate to the client containing the public key, domain name, and issuing SSL certificate authority.
- The client sends a message encrypted using the server's public SSL key.
- The server decrypts this message using its private SSL key.
- The server finally sends the decrypted message back to the client.
- If the client receives the correct message, both parties can begin to exchange information securely, assuming the issuing certificate authority is trusted by the client.

OpenSSL provides the tools needed to create certificate signing requests, private server keys, and self-signed certificates. When combined with a recognized certificate authority, trusted server certificates can be created for use with TCP protocols such as HTTP, SMTP, IMAP, and so on.

OpenSSL is based on the SSLeay library originally developed by Eric A. Young and Tim J. Hudson. SSLeay is an open source implementation of Netscape's Secure Socket Layer protocol, which was used in the Netscape Secure Server and Navigator browsers in the mid-1990s.

OpenSSL is very easy to install on FreeBSD, here's how to install OpenSSL on a FreeBSD system.

```console
root@router2:~ # cd /usr/ports/security/openssl
root@router2:/usr/ports/security/openssl # make DISABLE_VULNERABILITIES=yes install clean
root@router2:/usr/ports/security/openssl # echo "DEFAULT_VERSIONS+=ssl=openssl" >> /etc/make.conf
```
Before configuring OpenSSL, back up or copy the openssl.cnf file so that if something goes wrong during configuration, the original file is still there.

```console
root@router2:~ # cd /usr/local/openssl
root@router2:/usr/local/openssl # cp openssl.cnf openssl.cnf.backup
```
Now we can directly modify the openssl.cnf file, but before that check the version of OpenSSL you are using.

```console
root@router2:/usr/local/openssl # openssl version
OpenSSL 1.1.1t-freebsd  7 Feb 2023
```

## A. Create CA Certificate
In this section, SSL Certificate will be created using CA.pl script (Perl script) installed by OpenSSL port. You can create an official certificate to sign your SSL Certificate by sending a request. Certificate authority needs a certificate request file to create a valid SSL Certificate for your server. We will use `CA.pl` script included with OpenSSL to create a certificate request. The following script will copy `CA.pl` file to `/usr/local/openssl/certs` folder.

```console
root@router2:~ # cd /usr/local/openssl
root@router2:/usr/local/openssl # cp misc/CA.pl certs
```
Run the script below to generate a certificate request.

```console
root@router2:~ # cd /usr/local/openssl/certs
root@router2:/usr/local/openssl/certs # setenv OPENSSL /usr/local/bin/openssl
root@router2:/usr/local/openssl/certs # ./CA.pl -newreq
Use of uninitialized value $1 in concatenation (.) or string at ./CA.pl line 133.
====
/usr/local/bin/openssl req  -new  -keyout newkey.pem -out newreq.pem -days 365
Ignoring -days; not generating a certificate
Generating a RSA private key
..........+++++
...................+++++
writing new private key to 'newkey.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:id
State or Province Name (full name) [Some-State]:jawa barat
Locality Name (eg, city) []:bekasi
Organization Name (eg, company) [Internet Widgits Pty Ltd]:mediatama
Organizational Unit Name (eg, section) []:networking
Common Name (e.g. server FQDN or YOUR name) []:router2.unixexplore.com
Email Address []:datainchi@gmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
==> 0
====
Request is in newreq.pem, private key is in newkey.pem
root@router2:/usr/local/openssl/certs #
```

After entering the command, you will be asked series of questions. Your answers to these questions will be embedded in the CSR.

Answer the questions as described below:

| Command       | code          | 
| ----------- | -----------   | 
| Country Name (2 letter code)          | The two-letter country code where your company is legally located.          | 
| State or Province Name (full name)          | The state/province where your company is legally located.          | 
| Locality Name (e.g., city)          | The city where your company is legally located.          | 
| Organization Name (e.g., city)          | The city where your company is legally located.          | 
| Organizational Unit Name (e.g., section)          | The name of your department within the organization. (You can leave this option blank; simply press Enter.)          | 
| Common Name (e.g., server FQDN)          | The fully-qualified domain name (FQDN) (e.g., www.google.com).          | 
| Email Address          | Your email address. (You can leave this option blank; simply press Enter.)          | 
| A challenge password          | Your email address. (You can leave this option blank; simply press Enter.)          | 
| An optional company name          | Leave this option blank (simply press Enter).          | 

When creating the certificate above, what needs to be noted is to write `"Common Name (eg server FQDN or YOUR name)"`. In this section we must enter the hostname and domain of our FreeBSD server, in this article `"router2"` is the hostname and `"unixexplore.com"` is the domain name.

Running the `CA.pl` file script above will produce `"newkey.pem"` and `"newreq.pem"` files, both files contain encrypted SSL certificates for private servers. For easy identification, copy the file to `router2.unixexplore.com-encrypted-key.pem` using the following command.

```console
root@router2:/usr/local/openssl/certs # cp newkey.pem router2.unixexplore.com-encrypted-key.pem
root@router2:/usr/local/openssl/certs # cp newreq.pem router2.unixexplore.com-req.pem
```
The `router2.unixexplore.com-encrypted-key.pem` file is encrypted with the password you entered earlier. It is important that you remember this password. You will need to enter it whenever an SSL application uses it.

If this file is to be used on an unattended server, it is probably a very good idea to decrypt it, so that the daemon can read it without user intervention. To remove the encryption and create an unencrypted file that is readable only by root, use the following script.

```console
root@router2:/usr/local/openssl/certs # openssl rsa -in router2.unixexplore.com-encrypted-key.pem -out router2.unixexplore.com-unencrypted-key.pem
Enter pass phrase for router2.unixexplore.com-encrypted-key.pem:
writing RSA key
root@router2:/usr/local/openssl/certs # chmod 400 router2.unixexplore.com-unencrypted-key.pem
```

## B. Create a Self-Signed SSL Certificate
One way to create your own certificate is to use the `CA.pl` file. Note that creating your own certificate will cause the Untrusted Certificate dialog box to appear in application clients (web browsers, email clients, etc.).

You can install your server certificate file on the client system to avoid this. Here is a script to create your own 3-year SSL certificate.

```console
root@router2:~ # cd /usr/local/openssl
root@router2:/usr/local/openssl # cp misc/CA.pl certs
root@router2:/usr/local/openssl # sed -I .old 's/365/1095/' openssl.cnf
```
Run the following script to create your own SSL certificate authority.

```console
root@router2:~ # cd /usr/local/openssl/certs
root@router2:/usr/local/openssl/certs # setenv OPENSSL /usr/local/bin/openssl
root@router2:/usr/local/openssl/certs # ./CA.pl -newca
CA certificate filename (or enter to create)

Making CA certificate ...
====
/usr/local/bin/openssl req  -new -keyout ./demoCA/private/cakey.pem -out ./demoCA/careq.pem
Generating a RSA private key
.........+++++
...................+++++
writing new private key to './demoCA/private/cakey.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:id
State or Province Name (full name) [Some-State]:jawa barat
Locality Name (eg, city) []:bekasi
Organization Name (eg, company) [Internet Widgits Pty Ltd]:mediatama
Organizational Unit Name (eg, section) []:networking
Common Name (e.g. server FQDN or YOUR name) []:router2.unixexplore.com
Email Address []:datainchi@gmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
==> 0
====
====
/usr/local/bin/openssl ca  -create_serial -out ./demoCA/cacert.pem -days 1095 -batch -keyfile ./demoCA/private/cakey.pem -selfsign -extensions v3_ca  -infiles ./demoCA/careq.pem
Using configuration from /usr/local/openssl/openssl.cnf
Enter pass phrase for ./demoCA/private/cakey.pem:
Check that the request matches the signature
Signature ok
Certificate Details:
        Serial Number:
            4b:b7:ad:37:c3:24:ea:c9:62:0a:1b:d5:be:ec:57:4f:e5:94:33:c8
        Validity
            Not Before: Jun 30 13:17:27 2023 GMT
            Not After : Jun 29 13:17:27 2026 GMT
        Subject:
            countryName               = id
            stateOrProvinceName       = jawa barat
            organizationName          = mediatama
            organizationalUnitName    = networking
            commonName                = router2.unixexplore.com
            emailAddress              = datainchi@gmail.com
        X509v3 extensions:
            X509v3 Subject Key Identifier:
                DA:90:FF:39:70:F4:F3:93:E8:CF:29:6E:35:BE:0C:74:EB:38:89:CB
            X509v3 Authority Key Identifier:
                keyid:DA:90:FF:39:70:F4:F3:93:E8:CF:29:6E:35:BE:0C:74:EB:38:89:CB

            X509v3 Basic Constraints: critical
                CA:TRUE
Certificate is to be certified until Jun 29 13:17:27 2026 GMT (1095 days)

Write out database with 1 new entries
Data Base Updated
==> 0
====
CA certificate is in ./demoCA/cacert.pem
root@router2:/usr/local/openssl/certs #
```
To create the above certificate request, use the following command.

```console
root@router2:/usr/local/openssl/certs #  ./CA.pl -newreq
Use of uninitialized value $1 in concatenation (.) or string at ./CA.pl line 133.
====
/usr/local/bin/openssl req  -new  -keyout newkey.pem -out newreq.pem -days 365
Ignoring -days; not generating a certificate
Generating a RSA private key
..............................................................................+++++
..................................+++++
writing new private key to 'newkey.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:id
State or Province Name (full name) [Some-State]:jawa barat
Locality Name (eg, city) []:bekasi
Organization Name (eg, company) [Internet Widgits Pty Ltd]:mediatama
Organizational Unit Name (eg, section) []:networking
Common Name (e.g. server FQDN or YOUR name) []:router2.unixexplore.com
Email Address []:datainchi@gmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
==> 0
====
Request is in newreq.pem, private key is in newkey.pem
root@router2:/usr/local/openssl/certs #
```
Using the `copy` command, copy all the certificates to the `/usr/local/openssl/certs` directory, use the following script to do this.

```console
root@router2:/usr/local/openssl/certs # cp newreq.pem router2.unixexplore.com-cert.pem
root@router2:/usr/local/openssl/certs # cp newkey.pem router2.unixexplore.com-encrypted-key.pem
root@router2:/usr/local/openssl/certs # cp demoCA/cacert.pem ./unixexplore.com-CAcert.pem
root@router2:/usr/local/openssl/certs # cp demoCA/private/cakey.pem ./unixexplore.com-encrypted-CAkey.pem
```
To remove encryption and make unencrypted files readable only by root, use the following script.

```console
root@router2:/usr/local/openssl/certs # openssl rsa -in router2.unixexplore.com-encrypted-key.pem -out router2.unixexplore.com-unencrypted-key.pem
Enter pass phrase for router2.unixexplore.com-encrypted-key.pem:
writing RSA key
root@router2:/usr/local/openssl/certs # chmod 400 router2.unixexplore.com-unencrypted-key.pem
```
Now we will export the CA certificate or root certificate so that it can be installed on the system that will use your SSL Certificate. This is necessary to eliminate the Untrusted SSL Root Certificate Warning message. This message appears to warn the end user that there is a potential problem with the SSL Certificate.

It is harder to detect a real SSL session hijacking if this unnecessary warning is not removed. Most client systems (Windows and Mac OS X) recognize SSL certificate files encoded in the DER (Distinguished Encoding Rules) binary format. To convert a text-based PEM (Privacy Enhanced Mail) certificate to DER format, type the following command.

```console
root@router2:/usr/local/openssl/certs # openssl x509 -in unixexplore.com-CAcert.pem -inform PEM -out unixexplore.com-CAcert.cer -outform DER
```
You can send a DER encoded certificate via email with this command.

```console
root@router2:/usr/local/openssl/certs # uuencode unixexplore.com-CAcert.cer unixexplore.com-CAcert.cer | mail -s "Subject" datainchi@gmail.com
```
CAcert is a certificate authority that issues free SSL Certificates. If you are new to SSL Certificates, this site is a great place to learn about the SSL Certificate signing process. You can create a certificate signing request as described in this guide and have it signed by CAcert.

Certificates signed by CAcert have limited support; most web browsers do not include their root certificates in their database of trusted CAs. However, CAcert root certificates are included in FreeBSD and some Linux distributions.