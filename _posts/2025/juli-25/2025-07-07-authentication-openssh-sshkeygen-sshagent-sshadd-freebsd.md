---
title: OpenSSH authentication on FreeBSD with ssh-keygen ssh-agent ssh-add
date: "2025-07-07 07:51:29 +0100"
updated: "2025-07-07 07:51:29 +0100"
id: authentication-openssh-sshkeygen-sshagent-sshadd-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: The main disadvantage of passwords is that they are usually manually created, making them very simple and short, and easily hacked or stolen. SSH keys offer a safer and more secure alternative to passwords. SSH key pairs can be used for authentication, but instead of a password, each SSH key pair consists of a private key and a public key.
keywords: openssh, ssh, authentication, ssh-keygen, ssh-agent, ssh-add, freebsd, unix, command
---

In the previous article, we discussed the SSH protocol and its OpenSSH application. This article covered how to configure and use an SSH server and SSH client on the FreeBSD operating system. In this article, I want to discuss key pair-based SSH authentication, as well as another program from the software package, the SSH protocol, on FreeBSD systems.

SSH (or secure shell) is a network protocol that protects communications with a server by encrypting data. SSH is the most secure and commonly used way to interact between a server and a client. There are several authentication methods; in this article, we only explain passwordless SSH authentication.

## 1. How do SSH keys work?

Each SSH Server can authenticate clients in a variety of ways, the most common being password-based authentication and [How to Configure OpenSSH Server on FreeBSD](https://unixwinbsd.site/freebsd/github-via-freebsd-command-ssh-repository/).

The main disadvantage of passwords is that they are usually manually created, making them very simple and short, and easily hacked or stolen. SSH keys offer a safer and more secure alternative to passwords. SSH key pairs can be used for authentication, but instead of a password, each SSH key pair consists of a private key and a public key.

The private key functions like a regular password and is stored on the client computer. If a third party learns your private key, they can access the server and steal all your data. Private keys are typically at least 2048 bits long. You can also protect them with a passphrase (this is the password prompted when you try to use the private key). The passphrase can protect the private key from unauthorized access.

Meanwhile, the corresponding public key can be freely disclosed. The public key is used to encrypt messages that can only be decrypted using the private key. To set up SSH key-based authentication, you need to add the public key to the user account on the remote server, typically stored in the ".ssh/authorized_keys" directory.

When a client attempts to connect to the remote server, the SSH server verifies the client's private key; it must match one of the server's public keys. If the two keys match, the client is successfully authenticated and can start a session.

In general, the principle of public key authentication in the SSH protocol is as follows:

- Use the ssh-keygen program to generate a public and private key pair.
- The generated key is kept secret and will never be shown to anyone.
- The public key is copied to the remote SSH server and placed in a special file. On FreeBSD, by default, the public key is located at ~/.ssh/authorized_keys.
- The client sends its public key to the SSH server and requests authentication using this key.
- The server will check the ~/.ssh/authorized_keys directory. If a key is found, the SSH server sends a message to the client encrypted with the found user's public key.
- The client must decrypt the message using its private key. If the private key is password-protected, the ssh program will prompt the user for the password, which will first decrypt the key itself.
- If the message is decrypted, the correct public and private keys are considered a match, and the user is granted access to the system.

## 2. Generating SSH Keys Using ssh-keygen

On the client computer where you will connect to the remote OpenSSH server, you need to generate a key pair (public and private). The private key is stored on the client (do not share it with anyone), and the public key must be copied to the `~/.ssh/authorized_keys` directory on the SSH server. To generate these two keys, use the ssh-keygen utility. By default, this utility creates `2048-bit RSA keys`.

We will be creating an RSA key pair; this is the recommended format. By default, the ssh-keygen utility will generate two files:
- ~/. ssh/id_rsa (private key), and
- ~/. ssh/id_rsa. pub (public key)

<br/>
```console
root@ns6:~ # ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Enter passphrase (empty for no passphrase): router1
Enter same passphrase again: router1
Your identification has been saved in /root/.ssh/id_rsa
Your public key has been saved in /root/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:QlRa74+s1YELKSyHGQUwUPkdyZFM/3cz7UL9DK2+gJU root@ns6
The key's randomart image is:
+---[RSA 4096]----+
|.o+o.===o        |
|  .. o*+ .       |
|   ...o.. .      |
|    .*.  + . . + |
|    + = S + E * +|
|     o o o O + B.|
|          * + o +|
|         o   o . |
|        .     o. |
+----[SHA256]-----+
```

In the example script above, we created the password "router1" for two SSH keys.
<br/>

## 3. Configure Public Key Authentication on the SSH Server
To enable these two keys, an SSH server must be configured. The SSH server (in this example, it's a remote computer running **FreeBSD 13.2** and the OpenSSH service configured) must be configured. Now copy the public key to the remote SSH server.

Example command
`cat id_rsa.pub | ssh username@IPaddress "cat >> ~/.ssh/authorized_keys"`

<br/>
```console
root@ns6:~ # cd .ssh
root@ns6:~/.ssh # ls
id_rsa          id_rsa.pub
root@ns6:~/.ssh # cat id_rsa.pub | ssh root@192.168.5.2 "cat >> ~/.ssh/authorized_keys"
The authenticity of host '192.168.5.2 (192.168.5.2)' can't be established.
ED25519 key fingerprint is SHA256:WpdCFPbgIgcvkDmCr8Cw1XWvU9Yej73honnnS34YsP8.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.5.2' (ED25519) to the list of known hosts.
root@192.168.5.2's password: router
root@ns6:~/.ssh # ls
authorized_keys id_rsa          id_rsa.pub      known_hosts     known_hosts.old
root@ns6:~/.ssh #
```

In the example script above, we used the `username "root" and the password "router"` because router is the password for logging in to the root user. You've now added the public key for the remote user, and the server can accept the private key for authentication.
<br/>

## 4. Using ssh-agent and ssh-add

As mentioned above, each private key is always protected by a password. This creates inconvenience for users, requiring them to enter a password every time they connect to a remote SSH server. With a public key, users don't have to enter a password to connect to an SSH server. OpenSSH provides ssh-agent and ssh-add.

Once a key is generated, you can add the private key to the SSH Agent service, allowing you to easily manage it for authentication. The ssh-agent and ssh-add utilities allow you to store SSH keys in memory, eliminating the need to type a passphrase each time you use the key. The ssh-agent utility provides authentication with the private key loaded into it; to do this, the ssh-agent utility must start an external process.

To use ssh-agent in the shell, pass the shell as a command parameter. So, run `ssh-agent`.

```console
root@ns6:~/.ssh # ssh-agent csh
root@ns6:~/.ssh # ssh-add
Enter passphrase for /root/.ssh/id_rsa: router1
Identity added: /root/.ssh/id_rsa (root@ns6)
root@ns6:~/.ssh #
```

Once everything is configured, edit the `"/etc/ssh/sshd_config"` file, and change the parameters below.

```console
PubkeyAuthentication yes
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
```

Restart the SSH daemon on FreeBSD.

```console
root@ns6:~/.ssh # service sshd restart
```

You've successfully set up SSH authentication on FreeBSD using a public RSA key. You can now use this authentication method to securely access remote SSH servers, utilize automatic port forwarding in SSH tunnels, run scripts, and perform other automated tasks.