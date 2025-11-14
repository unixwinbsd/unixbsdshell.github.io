---
title: Adding a TLS SSL Certificate to a MariaDB database with OpenSSL
date: "2025-10-24 09:28:02 +0100"
updated: "2025-10-24 09:28:02 +0100"
id: adding--tls-ssl-certificate-mariadb-database-with-openssl
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DataBase
background: /img/oct-25/oct-25-133.jpg
toc: true
comments: true
published: true
excerpt: In this tutorial, I'll walk you through how to set up a MariaDB server with TLS/SSL, and how to establish a secure connection between the server and a MariaDB client.
keywords: adding, certificate, tls, sll, mariadb, database, server, with, openssl, sql, query, key
---

By default, MariaDB transmits data between the server and client without encryption. This is generally acceptable when the server and client are running on the same host or within a network that is secure through other means.

However, in cases where the server and client are on separate networks or within a high-risk network, the lack of encryption does pose a security issue, as malicious actors could potentially eavesdrop on traffic as it travels between them.

To mitigate this issue, MariaDB allows you to encrypt data in transit between the server and client using the Transport Layer Security (TLS) protocol. TLS was formerly known as Secure Socket Layer (SSL), but strictly speaking, SSL is a predecessor to TLS, and that version of the protocol is now considered insecure.

Documentation still frequently uses the term SSL, and for compatibility reasons, server systems and TLS-related state variables still use the ssl prefix, but internally, MariaDB only supports its secure successor.

In this tutorial, I'll walk you through how to set up a MariaDB server with TLS/SSL, and how to establish a secure connection between the server and a MariaDB client.

from the console and a PHP/Python script. MariaDB is a database server that offers direct replacement functionality for MySQL. It was created by some of MySQL's original authors, with support from the broader free and open source software developer community.

In addition to MySQL's core functionality, MariaDB offers a comprehensive suite of feature enhancements, including other storage engines, server optimizations, and patches.

## 1. Compatibility

Client and server connections are encrypted using the TLS protocol to encrypt replicated data, so both master and slave servers require a secure connection to be enabled.

While the above procedure allows the server to use TLS-encrypted connections with clients, it's important to note that this doesn't force data encryption in any way. To ensure that connections with specific clients `(users @host)` are encrypted, the database user profile must be edited with the TLS-specific GRANT option.

<br/>

![HTTP and HTTP Encryption and Non-encryption](/img/oct-25/oct-25-133.jpg)

<br/>

Support for TLS encrypted connections varies widely across MariaDB and MySQL server versions. This guide assumes MariaDB version 10.2.x dynamically connecting with the OpenSSL TLS library, which supports at least TLSv1.2.

To check the availability of TLS encrypted connections on your MariaDB database server, run the command below.

```
SHOW VARIABLES LIKE 'have_ssl';
Variable_name             Value
have_ssl                        YES

SHOW VARIABLES LIKE 'have_openssl';
Variable_name                Value
have_openssl                   YES
```

## 2. Create a Certificate Authority for MariaDB

The certificates used between the database server and the client should not be issued by a public or commercial certificate authority, as this is not about securing public services.

The goal here is to protect the private data flowing between the server and our own private clients. Therefore, all entities must authenticate themselves on both sides of the connection with a valid certificate issued by our own private certificate authority.

Using OpenSSL certificates in MariaDB is optimally done on a separate device, such as a flash drive (aka an encrypted USB stick) for the CA. Okay, without further ado, let's get started with how to create a TLS/SSL certificate. Let's start with the command below.

```
$ cd /media/$USER/safe_storage
```

## 3. Create Directories and files

After that, you create a directory named database-ca on your secure storage device (USB) with the command below.

```
$ mkdir -p database-ca/{certreqs,certs,crl,newcerts,private}
$ cd /database-ca
```

The directory used to store the private key should not be accessible to others, run the chmod command.

```
$ chmod 700 private
```

Several data files are required to track issued certificates, serial numbers, and revocations.

```
$ touch database-ca.index
$ echo 00 > database-ca.crlnum
$ echo 00 > database-ca.serial
```

## 4. OpenSSL Configuration

Create an OpenSSL configuration file for the new CA database database_ca.cnf with the following script.

```
# Example script database_ca.cnf
# OpenSSL configuration for the MariaDB/MySQL Database Clients and Servers
# Certification Authority.
#

#
# This definition doesn't work if HOME isn't defined.
CA_HOME                 = .
RANDFILE                = $ENV::CA_HOME/private/.rnd

#
# Default Certification Authority
[ ca ]
default_ca              = database_ca

#
# Database Certification Authority
[ database_ca ]
dir                     = $ENV::CA_HOME
certs                   = $dir/certs
serial                  = $dir/database-ca.serial
database                = $dir/database-ca.index
new_certs_dir           = $dir/newcerts
certificate             = $dir/database-ca.cert.pem
private_key             = $dir/private/database-ca.key.pem
default_days            = 368 # Two years
crl                     = $dir/database-ca.crl
crl_dir                 = $dir/crl
crlnumber               = $dir/database-ca.crlnum
name_opt                = multiline, align
cert_opt                = no_pubkey
copy_extensions         = copy
crl_extensions          = crl_ext
default_crl_days        = 60
default_md              = sha256
preserve                = no
email_in_dn             = no
policy                  = cert_policy
unique_subject          = yes

#
# Distinguished Name Policy for the CA
[ ca_policy ]
organizationName        = supplied
commonName              = supplied

#
# Distinguished Name Policy Server and Client Certificates
[ cert_policy ]
commonName              = supplied

#
# CA Request Options
[ ca_req ]
default_bits            = 4096
default_keyfile         = private/mariadatabase-ca.key.pem
encrypt_key             = yes
default_md              = sha256
string_mask             = utf8only
utf8                    = yes
prompt                  = no
req_extensions          = database_ca_req_ext
distinguished_name      = ca_distinguished_name
subjectAltName          = @subject_alt_name

#
# CA Request Extensions
[ database_ca_req_ext ]
subjectKeyIdentifier    = hash

#
# Distinguished Name (DN)
[ ca_distinguished_name ]
organizationName        = example.net
commonName              = example.net Database Clients and Servers Certification Authority

#
# CA Certificate Extensions
[ ca_ext ]
basicConstraints        = critical, CA:true
keyUsage                = critical, keyCertSign, cRLSign
subjectKeyIdentifier    = hash
subjectAltName          = @subject_alt_name
authorityKeyIdentifier  = keyid:always
issuerAltName           = issuer:copy
authorityInfoAccess     = @auth_info_access
crlDistributionPoints   = crl_dist

#
# CRL Certificate Extensions
[ crl_ext ]
authorityKeyIdentifier  = keyid:always
issuerAltName           = issuer:copy

#
# Clients and Servers Certificate Extensions
[ cert_ext ]
basicConstraints        = CA:FALSE
keyUsage                = critical, digitalSignature, keyEncipherment
extendedKeyUsage        = critical, serverAuth, clientAuth
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid:always

# EOF
```

After that you have to set the OpenSSL configuration file for the CA database.

```
$ export OPENSSL_CONF=./database-ca.cnf
```

## 5. Generate CSR and Create a new Key

The following command creates a new key and certificate signing request for root.

```
$ openssl req -new -out database-ca.req.pem
Generating a 4096 bit RSA private key
.......................................................................++
.......................................................................++
.......................................................................++
.......................................................................++
writing new private key to 'private/database-ca.key.pem'
Enter PEM pass phrase: ********
Verifying - Enter PEM pass phrase: ********
-----
```

## 6. Sign the certificate created yourself

After you run the generate certificate command, proceed to sign the certificate you're creating. To do this, you can run the following script.

```
$ openssl ca -selfsign \
    -in database-ca.req.pem \
    -out database-ca.cert.pem \
    -extensions ca_ext \
    -startdate `date +%y%m%d000000Z -u -d -1day` \
    -enddate `date +%y%m%d000000Z -u -d +5years+1day`
```

The above order will create a signature that is valid for the next five years.


## 7. Revocation List (CRL)

We continue by creating an initial empty CRL from the CA database we created above.

```
$ openssl ca -gencrl -out crl/database-ca.crl
```

## 8. Copy to Target System

The CA is now ready to sign certificate requests. Copy the following files to any systems (database servers and clients) that initiate or accept connections using certificates from this CA.

- CA certificate.
- CRL file.

```
$ scp database-ca.cert.pem crl/database-ca.crl aiken.example.net:/etc/mysql/ssl/
$ scp database-ca.cert.pem crl/database-ca.crl margaret.example.net:/etc/mysql/ssl/
$ scp database-ca.cert.pem crl/database-ca.crl gannibal.example.net:/etc/mysql/ssl/
```

You can also apply the above command to your workstation server.


## 9. Certificate Signing Request

Create a certificate signing request on the server and any clients connected to the server and other clients. Run the following command to create a certificate signing request.

```
$ sudo mkdir -p /etc/mysql/ssl/private
```

Then you create the OpenSSL configuration file `/etc/mysql/ssl/openssl.cnf` with the following script.

```
#
# OpenSSL configuration for generation of MariaDB/MySQL servers and client
# certificate requests.
# Environment variable '$CN' **MUST** be defined or else OpenSSL aborts.

CN                          = $ENV::CN
HOME                        = .
RANDFILE                    = $ENV::HOME/.rnd

[ req ]
default_bits                = 3072
default_keyfile             = ${HOME}/private/${CN}.key.pem
encrypt_key                 = no
default_md                  = sha256
req_extensions              = req_extensions
prompt                      = no
distinguished_name          = req_distinguished_name

[ req_extensions ]
keyUsage                    = digitalSignature, keyEncipherment
extendedKeyUsage            = serverAuth, clientAuth
subjectKeyIdentifier        = hash

[ req_distinguished_name ]
commonName                  = ${CN}
```

Create a new certificate signing request with the following script.

```
$ cd /etc/mysql/ssl
$ sudo -s
$ export OPENSSL_CONF=/etc/mysql/ssl/openssl.cnf
$ export CN=aiken.example.net
$ openssl req -new -out ${CN}.req.pem
Generating a 3072 bit RSA private key
..........................................................................
........................................................................++
................................................................++
writing new private key to './private/aiken.example.net.key.pem
```

## 10. Sign the certificate

Return to the certificate authority environment stored on your secure device (USB).

```
$ cd /media/$USER/safe_storage/database-ca
```

Copy the certificate signing request from the database server.

```
$ scp aiken.example.net:/etc/mysql/ssl/aiken.example.net.req.pem certreqs/
```

The final step is to sign the CSR file.

```
$ export OPENSSL_CONF=./database-ca.cnf
$ openssl ca \
    -in ./certreqs/aiken.example.net.req.pem \
    -out ./certs/aiken.example.net.cert.pem \
    -extensions cert_ext --policy cert_policy
Using configuration from ./database-ca.cnf
Enter pass phrase for ./private/database-ca.key: ********
```

You've learned how to set up and install SSL certificates between MariaDB servers and clients. For more information, see the official MariaDB website. Also, check out the update-ca-certificates command.