---
title: Creating Passphrases Keys and Certificates in Ubuntu
date: "2025-11-20 07:21:11 +0000"
updated: "2025-11-20 07:21:11 +0000"
id: creating-passphrases-key-certificates-in-ubuntu
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-020.jpg
toc: true
comments: true
published: true
excerpt: If you trust your computer's ability to generate random numbers, you can use xkcdpass. Install xkcdpass from the Ubuntu Software Center or via the command line
keywords: ubuntu, gnome, , key, keyring, certificates, passphrases, ssl, openssl, tls, https
---

Essentially, any computer you use personally, whether it's a desktop, notebook, or even a TV, as long as it's running Ubuntu Desktop or something similar, can and should use passphrases, keys, and certificates to enhance your computer's security.

## A. Passphrases

Throughout this article, we'll use the term "passphrase" because a single word will never be a good passphrase.

There are only three passphrases you need to remember and keep.

- Your password database (e.g., KeePass).
- User logins on your desktop computer.
- Access to your encrypted storage media (USB sticks, disks, etc.).

Everything else can be accessed from a database on any of your devices. It can be quite long and complex, as you don't need to use it from memory.

<img alt="Creating Passphrases Keys and Certificates in Ubuntu" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://raw.githubusercontent.com/unixwinbsd/unixbsdshell.github.io/refs/heads/main/img/nop-25/nop-25-020.jpg' | relative_url }}">

## B. Strong but Easy to Remember

Tools like APG or pwgen are available, but the passwords they generate can be difficult to remember. The best solution currently is to use Diceware, which generates very strong but still easy-to-remember passphrases.

The resulting passphrase will look something like the example below:

```yml
timid bingle heath js duck
```

Write down and store the code safely. Every time you use it, try to write it down from memory before looking at it. After a few days, you won't need to look at it anymore.

If you trust your computer's ability to generate random numbers, you can use [xkcdpass](https://github.com/redacted/XKCD-password-generator). Install xkcdpass from the Ubuntu Software Center or from the command line:

```yml
$ sudo apt install xkcdpass
```

## C. Strong but Easy to Type and Remember

Even if you don't need to remember another passphrase, I still recommend generating some passphrases using the Diceware method, rather than KeePassXC's built-in generator. This isn't because passphrases are easy to remember, but because they're easy to type.

Passphrase generators, like the one in KeePassXC, can generate secure passwords, but they typically look something like this:

```console
svkUi]jw?Ue_E&3 Y4/'H;-RYD)vb ?P
```

That's fine, as long as you don't have to type it yourself. You can use KeePassXC's AutoType feature or copy and paste it on your device. Browser apps, email clients, or keychains like Seahorse will provide the passphrase for you most of the time.

However, what if you're not working on your own computer? You can still use your password database, like the one you have on your smartphone, but you'll have to read the credentials from one device's screen and type them on another.

Another scenario is if something is damaged, stolen, or lost. You might need to access data (e.g., backups) without having access to your usual comfortable work environment.

The examples above, timid bingle heath js duck and qvkUj]jw?Ud_E&3 Y4/'H;-RYD)vb ?R, are both equally strong at 208 bits. However, while the former is easy for checking webmail or downloading something from your cloud while at a friend's house, the latter is nearly impossible to read correctly.

Some passphrases that might fall into this category:

- Personal email account (webmail).
- Cloud storage account (fast download or upload).
- NAS user account (access to backups).
- Frequently used social networks.
- Third-party identity providers (e.g., Mozilla Persona, Google Account).
- Server administrator login (root user).
- Database management (MySQL server root user).

D. How many words?

Each additional word used in a passphrase increases security.

The following table is based on estimates of the computing power available to a large government organization. Keep in mind that we don't know for sure and that new technologies can change the game at any time.

| Words       | Entropy          | Time to Crack        |  Safe until        |
| ----------- | -----------   | ----------- | ----------- |
| 4          | 51.6 bits          | less than a day          | Not safe          |
| 5          | 	64.6 bits      | less then 6 months          | 2013          |
| 6          | 77.5 bits          | 	3,505 years          | 2020          |
| 7          | 	90.4 bits      | 	27 million years          | 2030          |
| 8          | 	103.0 bits          | Unknown          | 2050          |

Based on these assumptions, the following are suggested to balance convenience, ease of use and security.

| User for       | Entropy          | Word        | 
| ----------- | -----------   | ----------- |
| Password Safe (KeePass)          | Highest          | 7          |
| GPG Private Key          | Highest      | 7          |
| Administrator Login          | Highest     | 7          |
| CA Root Key          | Highest          | 7          |
| CA Intermediate Key          | High          | 6          |
| Storage Encryption          | High          | 6          |
| SSH Private Key          | High          | 6          |
| TLS Client Certificates          | High          | 6          |
| User Login          | Medium          | 5          |
| Mail & IM Accounts          | Medium          | 5          |
| Cloud Storage          | Medium          | 5          |
| Wireless Network          | Moderate          | 4          |

Of course, the higher the better, and you're welcome to use more words. However, this document is intended primarily for personal use and is less intended for terrorist organizations, activists, large corporations, or government agencies.

We consider clients, servers, and networks to be insecure from the outset (especially wireless networks). Incoming and outgoing mail from insecure third-party services like Gmail or Hotmail is prohibited. If you must handle highly sensitive data, encrypt it with GPG or store it on an encrypted drive.

## E. KEY

A key is essentially a very large passphrase created using highly sophisticated mathematical methods. A printed passphrase is impossible for a human to memorize or type. If printed on paper, it could easily fill several pages of gibberish.

Therefore, keys are stored in a file. However, because files can be stolen, the key file is encrypted and password-protected. This way, only the intended user who knows the password can use the key.

### e.1. SSH Client Keys

#### e.1.1. ed25519

ed25519 is a very fast and highly secure public key signature system. It uses small keys (32 bits) and small signatures (64 bits).

Currently, ed25519 offers the best speed, key size, and security options for SSH public key authentication. However, because it is relatively new (available since OpenSSH 6.5, released in January 2014), RSA keys are still required for older systems and devices.

```console
$ ssh-keygen -t ed25519 -o -a 100
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/user/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/user/.ssh/id_ed25519.
Your public key has been saved in /home/user/.ssh/id_ed25519.pub.
The key fingerprint is:
7b:e1:23:2c:66:4c:6a:7c:41:bb:3e:13:fe:5b:86:4b user@Host
```

#### e.1.2. RSA

The default value will generate a 2048-bit RSA key, while the recommended value is at least 3072 bits.

```console
$ ssh-keygen -t rsa -b 4096 -o -a 100
```

## F. Certificates

A certificate is essentially a key that has been certified by another party, certifying that the key belongs to a person or device.

Certificates signed by commercial certificate authorities are typically generated directly on their websites using built-in web browser functionality, requiring minimal user interaction.

Here, we will manually generate a CSR for the certification authority to sign.

### f.1. Preparation

Create a private directory to store the configuration, keys, CSR, and certificates:

```yml
$ mkdir -p ~/.ssl/{certs,private}
$ chmod 700 ~/.ssl/private
```

Set some environment variables:

```console
$ export CN=$HOSTNAME.example.net
$ export emailAddress=john.doe@example.net
```

### f.2. Personal User Certificate Request

Personal certificates can be used to log in to websites and to sign and encrypt emails. The certificate includes information about the individual.

### f.3. OpenSSL Configuration

Create a new OpenSSL configuration file `~/.ssl/openssl-user.cnf`:

```console
#
# OpenSSL configuration for generation of client certificate requests.
#
# Environment variables 'emailAddress' **MUST** be defined or else
# OpenSSL aborts:
#    export emailAddress=user@example.net
#
# To use this configuration as default:
#    export OPENSSL_CONF=./openssl-user.cnf
#

emailAddress    = $ENV::emailAddress
HOME            = $ENV::HOME/.ssl
RANDFILE        = $HOME/private/.rnd
oid_section     = new_oids

[ new_oids ]
xmppAddr = 1.3.6.1.5.5.7.8.5

[ req ]
default_bits        = 2048
default_keyfile     = $HOME/private/$emailAddress.key.pem
encrypt_key         = yes
default_md          = sha256
req_extensions      = user_req_ext
prompt              = no
distinguished_name  = req_distinguished_name
string_mask         = utf8only
utf8                = yes

[ user_req_ext ]
keyUsage                = digitalSignature
extendedKeyUsage        = clientAuth, emailProtection
subjectKeyIdentifier    = hash
subjectAltName          = @subj_alt_names

[ req_distinguished_name ]
countryName             = US
stateOrProvinceName     = California
localityName            = Los Angeles
organizationName        = example.net
Name                    = John Doe
emailAddress            = $emailAddress

[ subj_alt_names ]
email       = $emailAddress
otherName   = xmppAddr;UTF8:$emailAddress
```

Make the default configuration to be used by OpenSSL:

```yml
$ export OPENSSL_CONF=~/.ssl/openssl-user.cnf
```

### f.4. Certificate Signing Request

Create a personal certificate request and key:

```console
$ openssl req -new -out ~/.ssl/$emailAddress.req.pem
Generating a 2048 bit RSA private key
.......................................+++
...............................+++
writing new private key to '/home/john/.ssl/john.doe@example.net.key.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
```

Protect private key:

```console
$ chmod 400 ~/.ssl/private/$emailAddress.key.pem
```

Run the request command.

```console
$ openssl req -verify -in ~/.ssl/$emailAddress.req.pem \
    -noout -text -nameopt multiline \
    -reqopt no_version,no_pubkey,no_sigdump
```

## G. Certificates for Client Devices

A client host certificate can be used to identify a specific device, specifically to establish a connection to a VPN service. The certificate may also include information about its owner.

In today's connected world, mobile devices are lost and stolen every day. By using a certificate for the device, not its owner, a single lost or stolen device can be locked without affecting other devices belonging to the same person.

### g.1. OpenSSL Configuration

Create a new OpenSSL configuration file `~/.ssl/openssl-client.cnf`:

```console
#
# OpenSSL configuration for generation of client certificate requests.
#
# To use this configuration as default:
#    export OPENSSL_CONF=./openssl-client.cnf
#
# Environment variables '$CN' and 'emailAddress' **MUST** be defined or else
# OpenSSL aborts:
#    export CN=${HOSTNAME}.example.net
#    export emailAddress=user@example.net
#

emailAddress         = $ENV::emailAddress
CN                   = $ENV::CN
HOME                 = $ENV::HOME/.ssl
RANDFILE             = $HOME/private/.rnd
oid_section          = new_oids

[ new_oids ]
id-on-xmppAddr       = 1.3.6.1.5.5.7.8.5

[ req ]
default_bits          = 2048
default_keyfile       = $HOME/private/$CN.key.pem
encrypt_key           = yes
default_md            = sha256
req_extensions        = device_req_ext
prompt                = no
distinguished_name    = req_distinguished_name
string_mask           = utf8only
utf8                  = yes

[ device_req_ext ]
keyUsage              = digitalSignature
extendedKeyUsage      = clientAuth
subjectKeyIdentifier  = hash
subjectAltName        = @subj_alt_names

[ req_distinguished_name ]
countryName           = US
stateOrProvinceName   = California
localityName          = Los Angelees
commonName            = $CN
name                  = John Doe
emailAddress          = $emailAddress

[ subj_alt_names ]
DNS.1                 = $CN
email                 = $emailAddress
otherName             = xmppAddr;UTF8:$emailAddress
```

Make the default configuration to be used by OpenSSL:

```console
$ export OPENSSL_CONF=~/.ssl/openssl-client.cnf
```

### g.2. Certificate Signing Request

Create a client device request:

```console
$ openssl req -new -out ~/.ssl/$CN.req.pem
Generating a 2048 bit RSA private key
.......................................+++
...............................+++
writing new private key to '/home/john/.ssl/host.example.net.key.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
```

Protect private key:

```console
$ chmod 400 ~/.ssl/private/$CN.key.pem
```

Run the request command.

```console
$ openssl req  -verify -in ~/.ssl/$CN.req.pem \
    -noout -text \
    -reqopt no_version,no_pubkey,no_sigdump \
    -nameopt multiline
```

### g.3. Using the Certificate

After the CA verifies and signs the certificate signing request, you will receive the certificate in a file like host.example.net.cert.pem.

To view the certificate:

```console
$ openssl x509 -in $CN.cert.pem \
    -noout -text \
    -certopt no_version,no_pubkey,no_sigdump \
    -nameopt multiline
```

To verify a certificate:

```console
$ openssl verify -issuer_checks -policy_print -verbose \
    -untrusted intermed-ca.cert.pem \
    -CAfile root-ca.cert.pem \
    certs/$CN.cert.pem
```

We feel that this discussion is sufficient. You can apply the above material to your favorite Ubuntu server, whether Desktop or Server.
