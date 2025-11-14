---
title: FreeBSD OpenSearch - Configuring OpenSearch TLS Plugins and Certificates with OpenSSL
date: "2025-08-14 07:05:27 +0100"
updated: "2025-08-14 07:05:27 +0100"
id: configuration-opensearch-tls-plugins-certificates-openssl-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/FreeBSD_Apache_Kafka.jpg
toc: true
comments: true
published: true
excerpt: OpenSearch was born out of community participation and support from major companies like Red Hat, SAP, Capital One, and others. The OpenSearch system is often used for full-text web search because it can store and analyze logs, as well as visualize and analyze the information received.
keywords: freebsd, opensearch, plugins, certificate, tls, openssl, configuration, web server
---

OpenSearch is an open-source utility widely used as a search engine and also as a powerful tool for data analysis. OpenSearch is based on the Elasticsearch 7.10.2 codebase. The OpenSearch system includes:

- Storage and search engine.
- Web interface.
- OpenSearch Dashboard data visualization environment.
- Add-ons that allow you to use some of the Elasticsearch engine's features.

OpenSearch was born out of community participation and support from major companies like Red Hat, SAP, Capital One, and others. The OpenSearch system is often used for full-text web search because it can store and analyze logs, as well as visualize and analyze the information received.

OpenSearch can be combined with Beat's data delivery platforms (Filebeat, Winlogbeat, etc.), allowing OpenSearch users to build a full log management cycle, including collection, organization, and search.

![Opensearch kafka ON freebsd](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/FreeBSD_Apache_Kafka.jpg)


## A. Specifications of the System Used
- OS: FreeBSD 13.3
- Hostname: ns3
- IP address: 192.168.5.2
- Logstash version: logstash8-8.11.3
- Opensearch version: Opensearch-2.11.1
- Dependencies: bash jna

**Java version :**
- openjdk version "17.0.9" 2023-10-17
- OpenJDK Runtime Environment (build 17.0.9+9-1)
- OpenJDK 64-Bit Server VM (build 17.0.9+9-1, mixed mode, sharing)

## B. Setting up Transport layer TLS
In this section, we'll explain how to configure the Opensearch security plugin on FreeBSD. Opensearch offers many plugins you can use, all of which require an SSL certificate to support many additional features and configuration methods. You can configure a TLS certificate using tools like OpenSSL.

Adding a TLS certificate provides additional security for your Opensearch host. The TLS certificate allows clients to verify the node's identity and encrypt traffic between the client and the host. The TLS certificate is configured in the opensearch.yml file, which we'll store in the `/usr/local/etc/opensearch` directory. Follow the steps below to create a `self-signed certificate`.


```yml
root@ns3:~ # cd /usr/local/etc/opensearch
root@ns3:/usr/local/etc/opensearch # rm -f *pem
```

### a. Generate root certificate
Before we go any further, let's first create a private key for the `root` certificate. The root certificate is used to sign other certificates.

```console
root@ns3:/usr/local/etc/opensearch # openssl genrsa -out root-ca-key.pem 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
.........................................+++++
.............................+++++
e is 65537 (0x010001)
```
After that, you create your own self-signed `root CA certificate`. Use the -subj parameter to provide your host-specific information.


```yml
root@ns3:/usr/local/etc/opensearch # openssl req -new -x509 -sha256 -key root-ca-key.pem -out root-ca.pem -days 730
```

### b. Generate Administrator Certificate
Next, create a certificate for the administrator. To create an `administrator certificate`, first generate a new key so the administrator can perform administrative tasks related to the security plugin.

```yml
root@ns3:/usr/local/etc/opensearch # openssl genrsa -out admin-key-temp.pem 2048
```

To make the administrator certificate usable with Java programs, convert the key to `PKCS` format.

```yml
root@ns3:/usr/local/etc/opensearch # openssl pkcs8 -inform PEM -outform PEM -in admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin-key.pem
```

Next, create a `certificate signing request (CSR)` for the administrator certificate (Certificate Signing Request) based on the private key. This file acts as an application to the CA for the certificate you just signed.

```yml
root@ns3:/usr/local/etc/opensearch # openssl req -new -key admin-key.pem -out admin.csr
```

Now that the private key and signing request have been created, sign the `administrator certificate` using the root certificate and private key you created earlier.

```yml
root@ns3:/usr/local/etc/opensearch # openssl x509 -req -in admin.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out admin.pem -days 730
```

### c. Create Node Certificate
Creating a node certificate is almost the same as the steps for creating an administrator certificate above. In this section, we'll create a key and CSR with a new file name for each node and client certificate. To create a node or client certificate, first create a new key.

```yml
root@ns3:/usr/local/etc/opensearch # openssl genrsa -out node1-key-temp.pem 2048
```

Then convert the private key to `PKCS format`, so that it can be used by Java applications.

```yml
root@ns3:/usr/local/etc/opensearch # openssl pkcs8 -inform PEM -outform PEM -in node1-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out node1-key.pem
```

Next, create a new `CSR` for the host certificate based on the private key.

```yml
root@ns3:/usr/local/etc/opensearch # openssl req -new -key node1-key.pem -out node1.csr
```

For all host and client certificates, you must specify `a subject alternative name (SAN)`.
Before creating a signed certificate, create a SAN extension file containing the hostname and domain name.

```yml
root@ns3:/usr/local/etc/opensearch # echo 'subjectAltName=DNS:node1.datainchi.com' > node1.ext
```

Next, create the certificate.

```console
root@ns3:/usr/local/etc/opensearch # openssl x509 -req -in node1.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out node1.pem -days 730 -extfile node1.ext
```

Next, convert the CA root certificate to .crt format so that the `CA` root certificate can be installed on the Opensearch server.

```yml
root@ns3:/usr/local/etc/opensearch # openssl x509 -outform der -in root-ca.pem -out root-ca.crt
```

Change the ownership and permissions of the directory to `opensearch:opensearch`.

```yml
root@ns3:/usr/local/etc/opensearch # chown -R opensearch:opensearch /usr/local/etc/opensearch/
```

### d. Preparing Certificates for Opensearch
Once you've created all the certificates, proceed to install them and add them to your OpenSearch configuration file,  `"opensearch.yml"` Open `"/usr/local/etc/opensearch/opensearch.yml"` and at the very bottom of the script (the end of the script), add the following script.

```console
root@ns3:/usr/local/etc/opensearch # ee opensearch.yml
plugins.security.ssl.transport.pemcert_filepath: /usr/local/etc/opensearch/node1.pem
plugins.security.ssl.transport.pemkey_filepath: /usr/local/etc/opensearch/node1-key.pem
plugins.security.ssl.transport.pemtrustedcas_filepath: /usr/local/etc/opensearch/root-ca.pem
plugins.security.ssl.http.enabled: true
plugins.security.ssl.http.pemcert_filepath: /usr/local/etc/opensearch/node1.pem
plugins.security.ssl.http.pemkey_filepath: /usr/local/etc/opensearch/node1-key.pem
plugins.security.ssl.http.pemtrustedcas_filepath: /usr/local/etc/opensearch/root-ca.pem
plugins.security.allow_default_init_securityindex: true
plugins.security.authcz.admin_dn:
  - 'CN=A,OU=UNIT,O=ORG,L=TORONTO,ST=ONTARIO,C=CA'
plugins.security.nodes_dn:
  - 'CN=node1.datainchi.com,OU=UNIT,O=ORG,L=TORONTO,ST=ONTARIO,C=CA'
plugins.security.audit.type: internal_opensearch
plugins.security.enable_snapshot_restore_privilege: true
plugins.security.check_snapshot_restore_write_privileges: true
```

## C. Plugin Installation Process
As we know, Opensearch includes several core plugins as part of its release installation. In Opensearch, plugins are used to enhance core functions and features. In addition to core plugins, you can also write your own custom plugins, and there are also community-created plugins available on GitHub.

For plugins to function properly and connect with Opensearch, all plugins must be able to access data in the cluster. Before using a plugin, you must first understand its function and benefits. Then, you should learn what plugins are available in Opensearch. You can view the available plugins by running the command below.

```console
root@ns3:~ # cd /usr/local/lib/opensearch/bin
root@ns3:/usr/local/lib/opensearch/bin # ./opensearch-plugin list
analysis-extension
analysis-fess
analysis-icu
configsync
minhash
opensearch-alerting
opensearch-anomaly-detection
opensearch-asynchronous-search
opensearch-cross-cluster-replication
opensearch-custom-codecs
opensearch-geospatial
opensearch-index-management
opensearch-job-scheduler
opensearch-knn
opensearch-ml
opensearch-neural-search
opensearch-notifications
opensearch-notifications-core
opensearch-observability
opensearch-performance-analyzer
opensearch-reports-scheduler
opensearch-security
opensearch-security-analytics
opensearch-sql
```

Full list of supported additional plugins:

**repository-gcs**
Added support for Google Cloud Storage service as a snapshot repository.

**analysis-icu**
Added the Lucene ICU module with extended Unicode support and use of the ICU library. This module provides improved Asian language analysis, Unicode normalization, Unicode case conversion, matching support, and transliteration.

**repository-azure**
Added support for Azure Blob storage as a snapshot repository.

**analysis-kuromoji**
Added Lucene kuromoji analysis module for Japanese.

**analysis-nori**
Added Lucene nori analysis module for Korea.

**analysis-phonetic**
Provides a token filter that converts expressions to their phonetic representation using Soundex, Metaphone, and other algorithms.

**repository-s3**
Added support for AWS S3 as a snapshot repository.

**analysis-smartcn**
Added Smart Chinese Lucene analysis module for Chinese text or mixed Chinese, English text.

**analysis-stempel**
Added Lucene Stamp analysis module for Polish language.

**ingest-attachment**
Extract file attachments in common formats (such as PPT, XLS, and PDF) using the Apache Tika text extraction library.

**mapper-annotated-text**
Indexing text is a combination of plain text and special markup. This combination is used to identify objects, such as people or organizations.

**mapper-murmur3**
Computes the hash of the field value based on the index time and stores it in the index.

**mapper-size**
Provides the metadata field size, which indexes the size in bytes of the source.

**repository-hdfs**
Added support for HDFS file systems as snapshot repositories.

**transport-nio**
A non-blocking client-server network library built using Netty.


## D. How to use the Opensearch plugin
Opensearch's functionality and features can be enhanced by adding custom plugins. Examples of plugins that can enhance Opensearch's functionality include adding custom mapping types, engine scripts, and more. In this section, we'll learn how to use Opensearch plugins. Here's a sample script for installing a plugin:

```yml
/usr/local/lib/opensearch/bin/opensearch-plugin install plugin-name
```

To further your understanding of plugins, here's an example of how to install a plugin.

```console
root@ns3:~ # cd /usr/local/lib/opensearch/bin
root@ns3:/usr/local/lib/opensearch/bin # ./opensearch-plugin install org.codelibs.opensearch:opensearch-analysis-fess:2.9.0
root@ns3:/usr/local/lib/opensearch/bin # ./opensearch-plugin install org.codelibs.opensearch:opensearch-analysis-extension:2.9.0
root@ns3:/usr/local/lib/opensearch/bin # ./opensearch-plugin install org.codelibs.opensearch:opensearch-minhash:2.9.0
root@ns3:/usr/local/lib/opensearch/bin # ./opensearch-plugin install org.codelibs.opensearch:opensearch-configsync:2.9.0
root@ns3:/usr/local/lib/opensearch/bin # ./opensearch-plugin install analysis-icu
root@ns3:/usr/local/lib/opensearch/bin # ./opensearch-plugin install org.opensearch.plugin:opensearch-anomaly-detection:2.2.0.0
```

## E. How to Delete Plugins
Once you've learned how to install a plugin, you'll probably want to know how to remove it. The script is almost identical to installing a plugin, but here's the syntax for removing a plugin:

```yml
/usr/local/lib/opensearch/bin/opensearch-plugin remove plugin-name
```

Below, we show you how to `remove` a plugin.

```yml
root@ns3:/usr/local/lib/opensearch/bin # ./opensearch-plugin remove org.codelibs.opensearch:opensearch-configsync:2.9.0
root@ns3:/usr/local/lib/opensearch/bin # ./opensearch-plugin remove analysis-icu
```

In this post, we've detailed the process of creating an SSL certificate and how to install and remove the Opensearch plugin. We recommend reading all pages of the Opensearch documentation to gain a deeper understanding and make it easier to use its functions and features.