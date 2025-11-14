---
title: A Simple Way to Create and Manage Private Root CA Certificates for OpenBSD
date: "2025-08-11 09:01:33 +0100"
updated: "2025-08-11 09:01:33 +0100"
id: create-and-manage-private-root-ca-ertificates-for-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: SysAdmin
background: https://raw.githubusercontent.com/unixwinbsd/FreeBSD_Lighttpd_Mod_OpenSSL/refs/heads/main/usr/local/openbsd%20ca%20authority.jpg
toc: true
comments: true
published: true
excerpt: The certificate system may seem complicated and difficult, but it is. While writing this article, I conducted numerous experiments, but it wasn't easy to fully understand how to create an SSL certificate
keywords: create, manage, private, rrot, ca, certificate, openbsd, openssl, ssl, key
---

The certificate system may seem complicated and difficult, but it is. While writing this article, I conducted numerous experiments, but it wasn't easy to fully understand how to create an SSL certificate. Therefore, in this article, we will briefly describe the general configuration and processing flow of the system, including two-tier private certificate authorities (Root CA, Signing CA), servers and clients that use the certificates, and then explain how to create the CA. We will also outline the specific steps involved.

![openbsd ca authority](https://raw.githubusercontent.com/unixwinbsd/FreeBSD_Lighttpd_Mod_OpenSSL/refs/heads/main/usr/local/openbsd%20ca%20authority.jpg)


Although the purposes for which certificates are issued and used by each party differ, the steps leading to certificate issuance are broadly as follows.

The party receiving the certificate:
- Generate a private key.
- Create a Certificate Signing Request (CSR) from the private key. (Include the X.509v3 extension if necessary).
- Submit the CSR to the CA.

The party issuing the certificate:
- Sign the CSR (the certificate is complete). Include the X.509v3 extensions in the certificate that correspond to the certificate's purpose. Furthermore, in the case of a Signing CA, if the extensions included in the CSR are not included in the extensions above, copy them into the certificate.
- Send the certificate to the requester.

CSRs and certificates are exchanged between entities, and as mentioned above, each can include X.509v3 extensions. There are various extensions, but the figure shows an example of an extension that specifies the purpose of the certificate. The section names in the OpenSSL configuration file are shown in the figure, so if you'd like to learn more, please refer to the relevant section of the configuration file.

## 1. Create a root certificate authority (Root CA)
First, make sure OpenSSL is installed on your OpenBSD server, check by running the openssl version command to see the OpenSSL version.

```
root@ns3:~# openssl version
OpenSSL 3.0.13 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)
```

We'll place all OpenBSD certificate configuration files in the OpenBSD_ca directory. Create the directories and files we'll use to configure the certificates.

```
ns3# mkdir -p /etc/ssl/OpenBSD_CA/root-ca
ns3# cd /etc/ssl/OpenBSD_CA/root-ca
ns3# mkdir -p certs crl db newcerts private
ns3# chmod 700 /etc/ssl/OpenBSD_CA/root-ca/private
```
Create a serial file to store subsequent incremental serial numbers. Using random serial numbers, rather than incremental serial numbers, is a recommended security practice.

```
ns3# touch /etc/ssl/OpenBSD_CA/root-ca/db/index && touch /etc/ssl/OpenBSD_CA/root-ca/root-ca.cnf
ns3# openssl rand -hex 16 > /etc/ssl/OpenBSD_CA/root-ca/db/serial
ns3# echo "1001" > /etc/ssl/OpenBSD_CA/root-ca/db/crlnumber
```
The OpenSSL configuration for the root certificate authority is in the `/etc/ssl/OpenBSD_CA/root-ca/root-ca.cnf` file.

```
# OpenBSD root-ca.cnf --- unixwinbsd.site

HOME			= .
RANDFILE		= $ENV::HOME/.rnd
#oid_file		= $ENV::HOME/.oid
oid_section		= new_oids

[ new_oids ]
tsa_policy1 = 1.2.3.4.1
tsa_policy2 = 1.2.3.4.5.6
tsa_policy3 = 1.2.3.4.5.7

[ default ]
name		= root-ca

[ ca ]
default_ca	= CA_default	

[ CA_default ]
dir		= /etc/ssl/OpenBSD_CA/root-ca	
certs		= $dir/certs	
crl_dir		= $dir/crl	
database	= $dir/db/index	
unique_subject	= no		
new_certs_dir	= $dir/newcerts
revoked		= $dir/newcerts/$name.pem
certificate	= $dir/certs/$name.crt
serial		= $dir/db/serial
crlnumber	= $dir/db/crlnumber
crl		= $dir/crl/$name.crl	
private_key	= $dir/private/$name.key
RANDFILE	= $dir/private/.rnd
x509_extensions	= usr_cert		
name_opt 	= ca_default
cert_opt 	= ca_default
copy_extensions = none
crl_extensions	= crl_ext
default_days	= 3650	
default_crl_days = 365	
default_bits	= 2048
default_md	= sha256
preserve	= no	
policy		= policy_match

[ policy_match ]
countryName		= match
stateOrProvinceName	= match
organizationName	= match
organizationalUnitName	= optional
commonName		= supplied
emailAddress		= optional

[ policy_anything ]
countryName		= optional
stateOrProvinceName	= optional
localityName		= optional
organizationName	= optional
organizationalUnitName	= optional
commonName		= supplied
emailAddress		= optional

[ req ]
default_bits		= 2048
default_keyfile 	= privkey.pem
default_md		= sha256
distinguished_name	= req_distinguished_name
attributes		= req_attributes
x509_extensions	= v3_ca	# The extentions to add to the self signed cert
string_mask = utf8only
req_extensions = v3_req # The extensions to add to a certificate request

[ req_distinguished_name ]
countryName			= Country Name (2 letter code)
countryName_default		= US
countryName_min			= 2
countryName_max			= 2

stateOrProvinceName		= State or Province Name (full name)
stateOrProvinceName_default	= Texas

localityName			= Locality Name (eg, city)
localityName_default		= Austin

0.organizationName		= Organization Name (eg, company)
0.organizationName_default	= Internet Widgits Pty Ltd

# we can do this but it is not needed normally :-)
#1.organizationName		= Second Organization Name (eg, company)
#1.organizationName_default	= World Wide Web Pty Ltd

organizationalUnitName		= Organizational Unit Name (eg, section)
organizationalUnitName_default	= Networking

commonName			= Common Name (e.g. server FQDN or YOUR name)
commonName_max			= 64
commonName_default		= unixwinbsd.site

emailAddress			= Email Address
emailAddress_max		= 64
emailAddress_default		= unixwinbsd@gmail.com

[ req_attributes ]
challengePassword		= A challenge password
challengePassword_min		= 4
challengePassword_max		= 20
unstructuredName		= An optional company name

[ usr_cert ]

basicConstraints=CA:FALSE
nsComment			= "OpenBSD Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment

[ v3_ca ]

subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer
basicConstraints = critical,CA:true
keyUsage = critical,cRLSign, keyCertSign
nsCertType = sslCA, emailCA

[ v3_sub_ca ]
authorityKeyIdentifier	= keyid:always,issuer
basicConstraints	= critical,CA:true,pathlen:0
extendedKeyUsage	= clientAuth,serverAuth
keyUsage		= critical,keyCertSign,cRLSign
subjectKeyIdentifier	= hash

[ name_constraints ]
permitted;DNS.0	= example.org
permitted;DNS.1	= example.com
excluded;IP.0	= 0.0.0.0/0.0.0.0
excluded;IP.1	= 0:0:0:0:0:0:0:0/0:0:0:0:0:0:0:0

[ crl_ext ]
authorityKeyIdentifier=keyid:always

[ proxy_cert_ext ]
basicConstraints=CA:FALSE
nsComment			= "OpenBSD OpenSSL Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
proxyCertInfo=critical,language:id-ppl-anyLanguage,pathlen:3,policy:foo

[ tsa ]
default_tsa = tsa_config1	

[ tsa_config1 ]
dir		= ./demoCA		
serial		= $dir/tsaserial	
crypto_device	= builtin		
signer_cert	= $dir/tsacert.pem 	
certs		= $dir/cacert.pem	
signer_key	= $dir/private/tsakey.pem
default_policy	= tsa_policy1		
other_policies	= tsa_policy2, tsa_policy3	
digests		= md5, sha1		
accuracy	= secs:1, millisecs:500, microsecs:100
clock_precision_digits  = 0	
ordering		= yes	
tsa_name		= yes	
ess_cert_id_chain	= no
```

### a. Generate a new CSR and Key

The following command generates a new password-protected EC or RSA key and a certificate signing request for the root.


```
ns3# cd /etc/ssl/OpenBSD_CA/root-ca
ns3# openssl ecparam -name secp384r1 -genkey | openssl ec -out /etc/ssl/OpenBSD_CA/root-ca/private/root-ca.key -aes256
```
```
ns3# openssl req -new \
        -config /etc/ssl/OpenBSD_CA/root-ca/root-ca.cnf \
        -key /etc/ssl/OpenBSD_CA/root-ca/private/root-ca.key \
        -out /etc/ssl/OpenBSD_CA/root-ca/root-ca.csr \
        -sha512
```

### b. Self-Signing the Root Certificate

If everything looks good, self-sign your request.


```
ns3# openssl ca \
        -config /etc/ssl/OpenBSD_CA/root-ca/root-ca.cnf \
        -in /etc/ssl/OpenBSD_CA/root-ca/root-ca.csr \
        -out /etc/ssl/OpenBSD_CA/root-ca/certs/root-ca.crt \
        -md sha512 -selfsign -extensions v3_ca
```
```
ns3# openssl x509 -in /etc/ssl/OpenBSD_CA/root-ca/certs/root-ca.crt -out /etc/ssl/OpenBSD_CA/root-ca/certs/root-ca.notext
```

### c. Creating a Certificate Revocation List

Root CAs publish Certificate Revocation Lists periodically or when a certificate is revoked. Root CAs are expected to only issue revocations of self-signed or Intermediate CA certificates. No revocations have occurred yet, but clients and servers verifying one of our certificates will request the latest CRL for the web address published in the certificate.

```
ns3# openssl ca -gencrl -config /etc/ssl/OpenBSD_CA/root-ca/root-ca.cnf -out /etc/ssl/OpenBSD_CA/root-ca/crl/root-ca.crl
```
To create a certificate revocation list, navigate to the `/etc/ssl/OpenBSD_CA/root-ca/db directory`. Find the index file and open the script's contents.

```
ns3# cat /etc/ssl/OpenBSD_CA/root-ca/db/index
V       340530094721Z           E4929714F26C79914F27932A76173963        unknown /C=US/ST=Texas/O=Internet Widgits Pty Ltd/CN=unixwinbsd.site/emailAddress=unixwinbsd@gmail.com
```
Next, navigate to the `/etc/ssl/OpenBSD_CA/root-ca/newcerts` directory. Within that directory, you'll find the file `"E4929714F26C79914F27932A76173963.pem"`. Then, run the revoke command with the target file `"E4929714F26C79914F27932A76173963.pem"`.

```
ns3# openssl ca \
        -config /etc/ssl/OpenBSD_CA/root-ca/root-ca.cnf \
        -revoke /etc/ssl/OpenBSD_CA/root-ca/newcerts/9B9ECA2E94B2ADA9668785CD951C451E.pem \
        -crl_reason keyCompromise
```
Now take a look at the `/etc/ssl/OpenBSD_CA/root-ca/db/index` script.

```
ns3# cat /etc/ssl/OpenBSD_CA/root-ca/db/index
R	340530094721Z	240601102047Z,keyCompromise	E4929714F26C79914F27932A76173963	unknown	/C=US/ST=Texas/O=Internet Widgits Pty Ltd/CN=unixwinbsd.site/emailAddress=unixwinbsd@gmail.com
```

## 2. Create a Signing Certificate Authority (CA)

Certificate authorities use a specific directory structure to secure keys, signed certificates, signing requests, and revocation lists. To setup a Signing CA, run the command below, which will generate the Signing CA's private key.

```
ns3# mkdir -p /etc/ssl/OpenBSD_CA/signing-ca
ns3# cd /etc/ssl/OpenBSD_CA/signing-ca
ns3# mkdir -p certs crl db newcerts private
ns3# chmod 700 /etc/ssl/OpenBSD_CA/signing-ca/private
```
Several data files are required to track issued certificates, their serial numbers, and revocations.

```
ns3# touch /etc/ssl/OpenBSD_CA/signing-ca/db/index && touch /etc/ssl/OpenBSD_CA/signing-ca/signing-ca.cnf
ns3# openssl rand -hex 16 > /etc/ssl/OpenBSD_CA/signing-ca/db/serial
ns3# echo "1001" > /etc/ssl/OpenBSD_CA/signing-ca/db/crlnumber
```
The configuration for the signing certificate authority (Signing CA) is in the `/etc/ssl/OpenBSD_CA/signing-ca/signing-ca.cnf` file.

```
# OpenBSD signing-ca.cnf --- unixwinbsd.site
HOME			= .
RANDFILE		= $ENV::HOME/.rnd
oid_section		= new_oids

[ new_oids ]
tsa_policy1 = 1.2.3.4.1
tsa_policy2 = 1.2.3.4.5.6
tsa_policy3 = 1.2.3.4.5.7

[ default ]
name		= signing-ca

[ ca ]
default_ca	= CA_default

[ CA_default ]
dir		= /etc/ssl/OpenBSD_CA/signing-ca		
certs		= $dir/certs	
crl_dir		= $dir/crl	
database	= $dir/db/index	
unique_subject	= no		
new_certs_dir	= $dir/newcerts	
certificate	= $dir/certs/$name.crt
serial		= $dir/db/serial
crlnumber	= $dir/db/crlnumber	
crl		= $dir/crl/$name.crl	
private_key	= $dir/private/$name.key
RANDFILE	= $dir/private/.rand	
x509_extensions	= usr_cert		
name_opt 	= ca_default		
cert_opt 	= ca_default		
copy_extensions = copy
crl_extensions	= crl_ext
default_days	= 365			
default_crl_days = 30			
default_bits	= 2048
default_md	= sha256		
preserve	= no			
policy		= policy_match

[ policy_match ]
countryName		= match
stateOrProvinceName	= match
organizationName	= match
organizationalUnitName	= optional
commonName		= supplied
emailAddress		= optional

[ policy_anything ]
countryName		= optional
stateOrProvinceName	= optional
localityName		= optional
organizationName	= optional
organizationalUnitName	= optional
commonName		= supplied
emailAddress		= optional

[ req ]
default_bits		= 2048
default_keyfile 	= privkey.pem
default_md		= sha256
distinguished_name	= req_distinguished_name
attributes		= req_attributes
x509_extensions	= v3_ca
string_mask = utf8only
req_extensions = v3_req

[ req_distinguished_name ]
countryName			= Country Name (2 letter code)
countryName_default		= US
countryName_min			= 2
countryName_max			= 2

stateOrProvinceName		= State or Province Name (full name)
stateOrProvinceName_default	= Texas

localityName			= Locality Name (eg, city)
localityName_default		= Austin

0.organizationName		= Organization Name (eg, company)
0.organizationName_default	= Internet Widgits Pty Ltd

# we can do this but it is not needed normally :-)
#1.organizationName		= Second Organization Name (eg, company)
#1.organizationName_default	= World Wide Web Pty Ltd

organizationalUnitName		= Organizational Unit Name (eg, section)
organizationalUnitName_default	= Education

commonName			= Common Name (e.g. server FQDN or YOUR name)
commonName_max			= 64
commonName_default		= unixwinbsd.site

emailAddress			= Email Address
emailAddress_max		= 64
emailAddress_default		= unixwinbsd@gmail.com

[ req_attributes ]
challengePassword		= A challenge password
challengePassword_min		= 4
challengePassword_max		= 20
unstructuredName		= An optional company name

[ usr_cert ]
basicConstraints=CA:FALSE
nsComment			= "OpenBSD Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment

[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer
basicConstraints = critical,CA:true
keyUsage = critical,cRLSign, keyCertSign
nsCertType = sslCA, emailCA

[ v3_sub_ca ]
authorityKeyIdentifier	= keyid:always,issuer
basicConstraints	= critical,CA:true,pathlen:0
extendedKeyUsage	= clientAuth,serverAuth
keyUsage		= critical,keyCertSign,cRLSign
subjectKeyIdentifier	= hash

[ name_constraints ]
permitted;DNS.0	= example.org
permitted;DNS.1	= example.com
excluded;IP.0	= 0.0.0.0/0.0.0.0
excluded;IP.1	= 0:0:0:0:0:0:0:0/0:0:0:0:0:0:0:0

[ server_ext ]
authorityKeyIdentifier	= keyid:always
basicConstraints	= critical,CA:false
extendedKeyUsage	= clientAuth,serverAuth
keyUsage		= critical,digitalSignature,keyEncipherment
nsCertType		= server
subjectKeyIdentifier	= hash

[ client_ext ]
authorityKeyIdentifier	= keyid:always
basicConstraints	= critical,CA:false
extendedKeyUsage	= clientAuth
keyUsage		= critical,digitalSignature,keyEncipherment,nonRepudiation
nsCertType		= client
subjectKeyIdentifier	= hash

[ crl_ext ]
authorityKeyIdentifier=keyid:always

[ proxy_cert_ext ]
basicConstraints=CA:FALSE
nsComment			= "OpenSSL Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
proxyCertInfo=critical,language:id-ppl-anyLanguage,pathlen:3,policy:foo

[ tsa ]
default_tsa = tsa_config1

[ tsa_config1 ]
dir		= ./demoCA	
serial		= $dir/tsaserial
crypto_device	= builtin	
signer_cert	= $dir/tsacert.pem
certs		= $dir/cacert.pem
signer_key	= $dir/private/tsakey.pem 
default_policy	= tsa_policy1		
other_policies	= tsa_policy2, tsa_policy3	
digests		= md5, sha1		
accuracy	= secs:1, millisecs:500, microsecs:100	
clock_precision_digits  = 0	
ordering		= yes	
tsa_name		= yes	
ess_cert_id_chain	= no
```

### a. Generate private key and CSR

Again, you can choose between an EC key and an RSA key. The RSA private key from the intermediate signing certificate must have a strength of `3072` bits.

```
ns3# openssl ecparam -name secp384r1 -genkey | openssl ec -out /etc/ssl/OpenBSD_CA/signing-ca/private/signing-ca.key -aes256
```
```
ns3# openssl req -new \
        -config /etc/ssl/OpenBSD_CA/signing-ca/signing-ca.cnf \
        -key /etc/ssl/OpenBSD_CA/signing-ca/private/signing-ca.key \
        -out /etc/ssl/OpenBSD_CA/signing-ca/signing-ca.csr \
        -sha512
```

### b. Signing the CA certificate with the Root CA

The Signing CA certificate is `signing-ca.crt`. Run the command below to create the `signing-ca.crt` file.

```
ns3# openssl ca \
        -config /etc/ssl/OpenBSD_CA/root-ca/root-ca.cnf \
        -in /etc/ssl/OpenBSD_CA/signing-ca/signing-ca.csr \
        -out /etc/ssl/OpenBSD_CA/signing-ca/certs/signing-ca.crt \
        -md sha512 -extensions v3_sub_ca
```
Remove descriptive text in certificate.

```
ns3# openssl x509 \
        -in /etc/ssl/OpenBSD_CA/signing-ca/certs/signing-ca.crt \
        -out /etc/ssl/OpenBSD_CA/signing-ca/certs/signing-ca.crt.notext
```
```
ns3# openssl ca \
        -gencrl \
        -config /etc/ssl/OpenBSD_CA/signing-ca/signing-ca.cnf \
        -out /etc/ssl/OpenBSD_CA/signing-ca/crl/signing-ca.crl
```

### c. Revoking Certificates from Private Certificate Authorities (CAs) on OpenBSD

In the section on certificate issuance, we explained the procedure for issuing certificates using a private Certificate Authority (CA) on OpenBSD. When communicating between a server and a client, using a certificate allows us to verify that the other party (domain name) is indeed who they claim to be.

However, what if the private key used to create the certificate is lost or leaked? A malicious actor could use a leaked private key to forge certificates and impersonate someone. In such cases, the certificate can no longer be used to certify that the other party is the legitimate party. In such cases, the certificate must be revoked immediately.

In this article, in addition to issuing certificates, we will explain the other roles of a CA: processing certificate revocations and creating a revocation list. The following is an example of revoking a certificate issued by a Signing CA.

```
R	340531023831Z	240602024009Z,keyCompromise	B214F9454080AD17279DDC32952E5DC5	unknown	/C=US/ST=Texas/O=Internet Widgits Pty Ltd/OU=Networking/CN=unixwinbsd.site/emailAddress=unixwinbsd@gmail.com
V	340531024205Z		B214F9454080AD17279DDC32952E5DC6	unknown	/C=US/ST=Texas/O=Internet Widgits Pty Ltd/OU=Education/CN=unixwinbsd.site/emailAddress=unixwinbsd@gmail.com
```
After that, you see the `/etc/ssl/OpenBSD_CA/root-ca/newcerts` directory with the **"ls"** command.

```
ns3# cd /etc/ssl/OpenBSD_CA/root-ca/newcerts
ns3# ls
B214F9454080AD17279DDC32952E5DC5.pem  B214F9454080AD17279DDC32952E5DC6.pem
```
Run the command to revoke the certificate issued by the CA Signer.

```
ns3# openssl ca \
        -config /etc/ssl/OpenBSD_CA/root-ca/root-ca.cnf \
        -revoke /etc/ssl/OpenBSD_CA/root-ca/newcerts/B214F9454080AD17279DDC32952E5DC6.pem \
        -crl_reason superseded
```
Take another look at the `/etc/ssl/OpenBSD)CA/root-ca/db/index` script.

```
R	340531023831Z	240602024009Z,keyCompromise	B214F9454080AD17279DDC32952E5DC5	unknown	/C=US/ST=Texas/O=Internet Widgits Pty Ltd/OU=Networking/CN=unixwinbsd.site/emailAddress=unixwinbsd@gmail.com
R	340531024205Z	240602025145Z,superseded	B214F9454080AD17279DDC32952E5DC6	unknown	/C=US/ST=Texas/O=Internet Widgits Pty Ltd/OU=Education/CN=unixwinbsd.site/emailAddress=unixwinbsd@gmail.com
```
The personal CA creation is now complete. You are now ready to sign server or client certificates.

## 3. Creating server/client certificates

The next step is to create certificates for the server and client. The server and client certificates will be used directly by users running applications like NGINX or Apache24.

```
ns3# mkdir -p /etc/ssl/OpenBSD_CA/san
ns3# cd /etc/ssl/OpenBSD_CA/san && mkdir -p certs private
ns3# touch /etc/ssl/OpenBSD_CA/san/openbsd-san.cnf
```
Create a main configuration file script for server and client certificate generation.

```
# OpenBSD openbsd-san.cnf --- unixwinbsd.site
HOME			= .
RANDFILE		= $ENV::HOME/.rnd
oid_section		= new_oids

[ new_oids ]
tsa_policy1 = 1.2.3.4.1
tsa_policy2 = 1.2.3.4.5.6
tsa_policy3 = 1.2.3.4.5.7

[ ca ]
default_ca	= CA_default

[ CA_default ]
dir		= ./demoCA	
certs		= $dir/certs	
crl_dir		= $dir/crl	
database	= $dir/index.txt
new_certs_dir	= $dir/newcerts	
certificate	= $dir/cacert.pem 
serial		= $dir/serial 	
crlnumber	= $dir/crlnumber
crl		= $dir/crl.pem 	
private_key	= $dir/private/cakey.pem
RANDFILE	= $dir/private/.rand	
x509_extensions	= usr_cert		
name_opt 	= ca_default		
cert_opt 	= ca_default		
default_days	= 365			
default_crl_days= 30		
default_md	= default		
preserve	= no			
policy		= policy_match

[ policy_match ]
countryName		= match
stateOrProvinceName	= match
organizationName	= match
organizationalUnitName	= optional
commonName		= supplied
emailAddress		= optional

[ policy_anything ]
countryName		= optional
stateOrProvinceName	= optional
localityName		= optional
organizationName	= optional
organizationalUnitName	= optional
commonName		= supplied
emailAddress		= optional

[ req ]
default_bits		= 2048
default_keyfile 	= privkey.pem
distinguished_name	= req_distinguished_name
attributes		= req_attributes
x509_extensions	= v3_ca
string_mask = utf8only

[ req_distinguished_name ]
countryName			= Country Name (2 letter code)
countryName_default		= AU
countryName_min			= 2
countryName_max			= 2

stateOrProvinceName		= State or Province Name (full name)
stateOrProvinceName_default	= Mid North Coast

localityName			= Locality Name (eg, city)
localityName_default		= Coffs Harbour

0.organizationName		= Organization Name (eg, company)
0.organizationName_default	= Internet Certificate Service, Pty Ltd.

# we can do this but it is not needed normally :-)
#1.organizationName		= Second Organization Name (eg, company)
#1.organizationName_default	= World Wide Web Pty Ltd

organizationalUnitName		= Organizational Unit Name (eg, section)
organizationalUnitName_default	= IT Networking

commonName			= Common Name (e.g. server FQDN or YOUR name)
commonName_max			= 64
commonName_default		= kursor.my.id

emailAddress			= Email Address
emailAddress_max		= 64
emailAddress_default		= cursor.com

[ req_attributes ]
challengePassword		= A challenge password
challengePassword_min		= 4
challengePassword_max		= 20
unstructuredName		= An optional company name

[ usr_cert ]
basicConstraints=CA:FALSE
nsComment			= "OpenBSD SAN Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName	= $ENV::OPENSSL_SAN

[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer
basicConstraints = CA:true

[ crl_ext ]
authorityKeyIdentifier=keyid:always

[ proxy_cert_ext ]
basicConstraints=CA:FALSE
nsComment			= "OpenBSD Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
proxyCertInfo=critical,language:id-ppl-anyLanguage,pathlen:3,policy:foo

[ tsa ]
default_tsa = tsa_config1

[ tsa_config1 ]
dir		= ./demoCA	
serial		= $dir/tsaserial
crypto_device	= builtin	
signer_cert	= $dir/tsacert.pem
certs		= $dir/cacert.pem
signer_key	= $dir/private/tsakey.pem
default_policy	= tsa_policy1
other_policies	= tsa_policy2, tsa_policy3	
digests		= md5, sha1	
accuracy	= secs:1, millisecs:500, microsecs:100
clock_precision_digits  = 0	
ordering		= yes	
tsa_name		= yes	
ess_cert_id_chain	= no
```
The first command you have to run is `"exports"`. Notice the example below.

```
ns3# cd /etc/ssl/OpenBSD_CA/san
ns3# export OPENSSL_SAN="IP:192.168.5.3"
```
Create a private key file and place it in the `/etc/ssl/OpenBSD_CA/san/private` directory.

```
ns3# openssl genrsa \
        -out /etc/ssl/OpenBSD_CA/san/private/example_nopass.key 2048
ns3# openssl rsa \
        -in /etc/ssl/OpenBSD_CA/san/private/example_nopass.key \
        -out /etc/ssl/OpenBSD_CA/san/private/example.key -aes256
ns3# openssl rsa \
         -in /etc/ssl/OpenBSD_CA/san/private/example.key \
         -pubout \
         -out /etc/ssl/OpenBSD_CA/san/certs/example.pub \
         -outform PEM
```
Continue with the following commands.

```
ns3# openssl req -new \
            -config /etc/ssl/OpenBSD_CA/san/openbsd-san.cnf \
            -key /etc/ssl/OpenBSD_CA/san/private/example.key \
            -out /etc/ssl/OpenBSD_CA/san/certs/example.csr \
            -sha512 -reqexts v3_req
```

### a. Server certificate

In the first part, we will create a certificate for the server. Follow each command below.

```
ns3# cd /etc/ssl/OpenBSD_CA/signing-ca
ns3# export OPENSSL_SAN="IP:192.168.5.3"
ns3# openssl ca \
        -config /etc/ssl/OpenBSD_CA/signing-ca/signing-ca.cnf \
        -policy policy_anything \
        -in /etc/ssl/OpenBSD_CA/san/certs/example.csr \
        -out /etc/ssl/OpenBSD_CA/san/certs/example.crt \
        -md sha512 -extensions server_ext
```
```
ns3# openssl x509 \
        -in /etc/ssl/OpenBSD_CA/san/certs/example.crt \
        -out /etc/ssl/OpenBSD_CA/san/certs/example.crt.notext
```
The last command is to merge multiple certificate files.

```
ns3# cat /etc/ssl/OpenBSD_CA/san/certs/example.crt.notext \
/etc/ssl/OpenBSD_CA/signing-ca/certs/signing-ca.crt.notext > /etc/ssl/OpenBSD_CA/signing-ca/certs/signing-ca.crt.full
```

### b. Client Certificate

The process for creating a client certificate is almost the same as creating a server certificate, with only a few minor differences. Here are the commands you must run to create a client certificate.

```
ns3# cd /etc/ssl/OpenBSD_CA/signing-ca
ns3# export OPENSSL_SAN="IP:192.168.5.3"
ns3# openssl ca \
        -config /etc/ssl/OpenBSD_CA/signing-ca/signing-ca.cnf \
        -policy policy_anything \
        -in /etc/ssl/OpenBSD_CA/san/certs/example.csr \
        -out /etc/ssl/OpenBSD_CA/san/certs/client.crt \
        -md sha512 -extensions client_ext
```
Delete descriptive text

```
ns3# openssl x509 \
        -in /etc/ssl/OpenBSD_CA/san/certs/client.crt \
        -out /etc/ssl/OpenBSD_CA/san/certs/client.crt.notext
```
Combine certificate

```
ns3# cat /etc/ssl/OpenBSD_CA/san/certs/client.crt.notext \
/etc/ssl/OpenBSD_CA/signing-ca/certs/signing-ca.crt.notext > /etc/ssl/OpenBSD_CA/signing-ca/certs/client.crt.full
```
If you're running an OpenBSD server and need an SSL certificate for a secure connection, you can use the example we've described in this article.