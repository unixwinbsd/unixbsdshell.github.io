---
title: OpenBSD CloudFlare CFSSL Certificate - Creating a CA Private PKI TLS Certificate For DNS Server Clients
date: "2025-10-16 20:46:29 +0100"
updated: "2025-10-16 20:46:29 +0100"
id: openbsd-cloudflare-cfssl-certificate-pki-tls
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: UnixShell
background: https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/oct-25-87.jpg
toc: true
comments: true
published: true
excerpt: Once you've successfully installed Golang, proceed to install CFSSL. The CFSSL installation process is similar to GO, and it's not particularly difficult. You can install CFSSL on OpenBSD with just one command. Here's the command to install CFSSL.
keywords: openbsd, cloudflare, certificate, ca, private, pki, tls, dns, server, client
---


The CloudFlare PKI/TLS tool, CFSSL, is written in Golang and is one of the open-source programs released by Cloudflare. CFSSL is a command-line tool and HTTP API server for signing, validating, and aggregating TLS certificates. Cloudflare specifically released the CFSSL application to simplify the creation of PKI/TLS certificates. CFSSL's performance is truly impressive, achieving a balance between performance, security, and interoperability.

The CFSSL Public Key Infrastructure is not only a tool for certificate aggregation but can also be used as a certificate authority. This is possible because it includes basic certificate creation functions, including private key generation and certificate signing requests. The CFSSL application is ideal for DNS servers running the TLS protocol.

The presence of CFSSL significantly improves your internet network security system, as SSL certificates are designed to mitigate several security issues on internet networks. SSL certificates link domain names to server names and business names to locations, thus establishing a foundation of trust on the internet by guaranteeing the identity of a website. In other words, the certificate contains the server name, a trusted certification authority (CA) that verifies the certificate's authenticity, and the server's public encryption key.

In this article, we'll learn how to set up Cloudflare CFSSL on OpenBSD. The article covers the installation process for Go, CFSSL, and the configuration and certificate creation process.


## 1. Install Go Lang

Because CFSSL is written in the Go language, the primary requirement for your OpenBSD is that Go is installed on OpenBSD. It's worth reviewing the Go installation process. Installing Go on OpenBSD isn't too difficult. The Go repository is provided in the PKG package. You can run the installation directly without having to download it from another repository.


```sh
ns3# pkg_add go
```

Since many versions of GO have been released, and it's fair to say that no two operating systems run the same version of GO, you can check the GO version before running it.


```sh
ns3# go version
go version go1.22.1 openbsd/amd64
```

Golang also has multiple PATHs that you can customize. For more details on creating a PATH environment variable, you can read our previous article, ["Install Go Lang on OpenBSD with PATH Environment"](https://unixwinbsd.site/freebsd/go-lang-freebsd14-golang-install).


## 2. Install Clodflare CFSSL

Once you've successfully installed Golang, proceed to install CFSSL. The CFSSL installation process is similar to GO, and it's not particularly difficult. You can install CFSSL on OpenBSD with just one command. Here's the command to install CFSSL.


```sh
ns3# pkg_add cfssl
```

You can see the installed version of CFSSL with the following command.


```sh
ns3# cfssl version
Version: 1.6.4
Runtime: go1.22.1
```

Now that you have the CFSSL application set up, we need to understand how it works and the process of creating a certificate with CFSSL.

## 3. Cloudflare CFSSL Configuration

By default CFSSL provides two basic configuration files, namely:

- CSR_configuration, and
- signing_configuration.


The CSR configuration file contains the configuration for creating the key pair you'll be creating. It includes signing the configuration by name, setting up configuration rules, and so on. We'll show you how to initialize a Root CA for your OpenBSD server environment. First, we need to save the default cfssl options for future use.

### a. Create ROOT CA

The first step to create a CA ROOT certificate, we create a directory to store the certificate, after that we do the configuration to create a key for the CA itself.


```sh
ns3# mkdir -p /etc/ssl/cfssl
ns3# cd /etc/ssl/cfssl
ns3# cfssl print-defaults config > ca-config.json 
ns3# cfssl print-defaults csr > ca-csr.json
```

The above cfssl command will generate two json format files:

- ca-config.json
- ca-csr.json

Open both files and type the script as in the example below.


```sh
{
    "signing": {
        "default": {
            "expiry": "8760h"
        },
        
        "profiles": {        	
            "intermediate_ca": {
        "usages": [
            "signing",
            "digital signature",
            "key encipherment",
            "cert sign",
            "crl sign",
            "server auth",
            "client auth",
            "www auth"
        ],
        "expiry": "8760h",
        "ca_constraint": {
            "is_ca": true,
            "max_path_len": 0, 
            "max_path_len_zero": true
        }
      },
      
          "peer": {
        "usages": [
            "signing",
            "digital signature",
            "key encipherment", 
            "client auth",
            "server auth",
            "www auth"
        ],
        "expiry": "8760h"
      },
            	
            "www": {
                "expiry": "8760h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "www auth"
                ]
            },
            
 "server": {
        "usages": [
          "signing",
          "digital signing",
          "key encipherment",
          "server auth"
        ],
        "expiry": "8760h"
      },
      
      "client": {
        "usages": [
          "signing",
          "digital signature",
          "key encipherment", 
          "client auth"
        ],
        "expiry": "8760h"
      }
            
        }
    }
}
```

<br/>

```sh
{
    "CN": "Servers Intermediate CA",
    "hosts": [
        "kursor.my.id",
        "www.kursor.my.id"
    ],
    "key": {
        "algo": "ecdsa",
        "size": 256
    },
    "names": [
        {
            "C": "US",
            "ST": "CA",
            "L": "San Francisco",
            "O": "OpenBSD Education",
            "OU": "Tutor"
        }        
    ],
     "ca": {
    "expiry": "8760h"
 }
}
```

Replace the domain "kursor.my.id" with your OpenBSD server's domain. Next, we'll create a certificate to create a CA with the options we specified.


```
ns3# cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
```

The above command will generate three new files consisting of:

- ca-key.pem (private key).
- ca.csr (certificate signing request).
- ca.pem (root CA public key)

### b. Create Intermediate CA

Now we move on to the next step, after we have the root CA, which is the most important file. The Root CA will allow us to create intermediate certificates. Intermediate certificates can be used like CAs to create other intermediate certificates or to directly sign certificates and keys.

In this case, the Root CA key is stored on an offline machine and is only used when you need to sign an intermediate CA certificate. To create an intermediate CA, we need the following configuration file.


```sh
ns3# mkdir -p /etc/ssl/cfssl/intermediate
ns3# cd /etc/ssl/cfssl/intermediate       
ns3# touch intermediate.json
```

Open the intermediate.json file and enter the script as in the example below.


```sh
{
  "CN": "Servers Intermediate CA",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
    {
	"C": "US",
        "ST": "CA",
        "L": "San Francisco",
        "O": "OpenBSD Education",
        "OU": "Tutor"
    }
  ],
  "ca": {
    "expiry": "8760h"
  }
}
```

Once you include the script in that file, you can proceed with generating the intermediate public and private keys along with the intermediate signing request.


```sh
ns3# cfssl gencert -initca intermediate.json | cfssljson -bare intermediate_ca
ns3# cfssl sign -ca /etc/ssl/cfssl/ca.pem -ca-key /etc/ssl/cfssl/ca-key.pem -config /etc/ssl/cfssl/ca-config.json -profile intermediate_ca intermediate_ca.csr | cfssljson -bare intermediate_ca
```

### c. Create a final certificate

Each web server or DNS server has its own unique certificate. Suppose you want to obtain a certificate for a DNS server with a domain name like cursor.my.id. The first thing you'll need to do is create a Certificate Signing Request (CSR) for your DNS server. To create a certificate, you'll need to create a new file, as shown in the example below.


```sh
ns3# mkdir -p /etc/ssl/cfssl/CADNSServer
ns3# cd /etc/ssl/cfssl/CADNSServer
ns3# touch kursor.my.id.json
```

Then you enter the script below into the cursor.my.id.json file.


```sh
{
  "CN": "server.computingexample.com",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
  {
            "C": "US",
            "ST": "CA",
            "L": "San Francisco",
            "O": "OpenBSD Education",
            "OU": "Tutor"
  }
  ],
  "hosts": [
    "ns3.kursor.my.id",
    "localhost"
  ]
}
```

To create a DNS server certificate with the configuration in the json file above, just do this.


```
ns3# cfssl gencert -ca /etc/ssl/cfssl/intermediate/intermediate_ca.pem -ca-key /etc/ssl/cfssl/intermediate/intermediate_ca-key.pem -config /etc/ssl/cfssl/ca-config.json -profile=server kursor.my.id.json | cfssljson -bare DNSServer1
```

## 4. Create Bundling Certificates

Some Apache, Java, and DNS server-based applications, such as Unbound, require the Root and Intermediate certificates to be combined into a single file. Cloudflare CFSSL can generate the combined certificates required by both the server and the client.

You can use the cfssl-mkbundle command to create the root and intermediate bundles used to verify certificates. This essentially links the final certificate with the public keys of the intermediate CA and the Root CA. Follow the instructions below to create the bundled certificate.


```
ns3# cd /etc/ssl/cfssl                                                  
ns3# cfssl-mkbundle -f /etc/ssl/cfssl/CADNSServer/DNSserverbundle.crt CADNSServer
```

The above command creates a certificate bundle by combining the existing certificates in `/etc/ssl/cfssl` with `/etc/ssl/cfssl/CADNSServer`. The resulting merge will be stored in `/etc/ssl/cfssl/CADNNSServer`.

You can also use the above command to combine the certificates in `/etc/ssl/cfssl` with `/etc/ssl/cfssl/intermediate`.


```sh
ns3# cd /etc/ssl/cfssl
ns3# cfssl-mkbundle -f /etc/ssl/cfssl/intermediate/Intermediatebundle.crt intermediate
```

## 5. How to Use CFSSL Certificate in Unbound

After you've successfully created the ROOT CA certificate, create a certificate for the DNS server. Now we'll deploy that certificate to the DNS server. In this example, we'll deploy the Unbound DNS server. In the Unbound root directory, open the unbound.conf file. Find the TLS script and replace it with the one below.


```sh
tls-port: 853
tls-cert-bundle: "/etc/ssl/cfssl/CADNSServer/DNSserverbundle.crt"
tls-service-key: "/etc/ssl/cfssl/CADNSServer/DNSServer1-key.pem"
tls-service-pem: "/etc/ssl/cfssl/CADNSServer/DNSServer1.pem"
```

Restart your Unbound server, and run the command below, to check if the Unbound server can open port 853 TLS.


```sh
ns3# dig -p 853 yahoo.com @192.168.5.3
```

## 6. How to Use CFSSL Certificate on NGINX Web Server

You can also use a CFSSL certificate on an NGINX web server. In your virtual host file, insert a script like the example below. (We're creating an HTTPS port on the Nginx virtual host).


```sh
server {
        listen       443;
        listen       [::]:443;
        server_name  datainchi.com;
        root         /var/www/htdocs/nginxssl;
ssl on;
ssl_certificate /etc/ssl/cfssl/intermediate/Intermediatebundle.crt;
ssl_certificate_key /etc/ssl/cfssl/intermediate/intermediate_ca-key.pem;
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
        root  /var/www/htdocs/nginxssl;
        }
    }
```

The example above is a simple Nginx HTTPS script. You can customize it to suit your OpenBSD system. After inserting the CFSSL certificate into the Nginx configuration, the next step is to restart the Nginx server to implement the HTTPS port on the Nginx server.


```sh
ns3# rcctl restart nginx
```

After that, open Google Chrome and type `"https://192.168.5.3"`. The result: Nginx's HTTPS port 443 opens immediately.

TLS is the foundation of modern cryptography. When configured correctly, TLS provides strong and secure encryption that verifies all parties involved in the process. CFSSL is a simple, fast, and easy-to-use tool for deploying SSL certificates.

CFSSL is a self-signed certificate that helps secure internet networks by establishing a key exchange infrastructure for encrypted connections.