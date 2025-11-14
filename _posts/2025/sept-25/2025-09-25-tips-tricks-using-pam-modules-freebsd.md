---
title: Tips and Tricks for Using PAM Modules in FreeBSD 14
date: "2025-09-25 08:07:56 +0100"
updated: "2025-09-25 08:07:56 +0100"
id: tips-tricks-using-pam-modules-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: On FreeBSD systems, by default the PAM configuration is in the /etc/pam.d folder and the pam package is in /usr/local/etc/pam.d. Below is an example of the contents of the /etc/pam.d folder. Each daemon has its own configuration file, named after its respective program
keywords: pam, modules, freebsd 14, Pluggable Authentication Module, openpam, modular, xsso
---

The Pluggable Authentication Module (PAM) library is a common API for authentication systems, the PAM module makes it easy for a system administrator to add new authentication methods just by installing the PAM module, besides that a system administrator can also modify authentication policies by editing configuration files.

PAM was defined and developed in 1995 by Vipin Samar and Charlie Lai of Sun Microsystems. In 1997, the Open Group published the initial X/Open Single Sign-on (XSSO) specification, which standardized and copyrighted the PAM API by adding several additional extensions.

Although Pluggable Authentication Modules (PAM) have long been used, the truth is that PAM modules are the least understood, yet most widely used, part of FreeBSD. Every FreeBSD system uses PAM, via the OpenPAM package. Most sysadmins don't touch it, probably because of the complexity of configuring it. Actually, the PAM module is not as complicated as you imagine. FreeBSD's OpenPAM, like Solaris' primordial PAM, only handles authentication and authentication-related tasks.

This article describes the basic principles and mechanisms of the Pluggable Authentication Modules (PAM) library, and explains how to configure PAM, how to integrate PAM into applications. The contents of this article have been implemented by the author on the FreeBSD 13.2 system.


## A. PAM Configuration

As the name suggests, the advantage of PAM is that it is pluggable and modular. New PAM modules can be added quite easily and are relatively independent of other existing modules. Another advantage is that a module can be used to authenticate various existing programs. As a result, developers only need to implement an authentication system that is specific to the program and an authentication system that is general and has become standard does not need to be repeated.

On FreeBSD systems, by default the PAM configuration is in the `/etc/pam.d` folder and the pam package is in `/usr/local/etc/pam.d`. Below is an example of the contents of the `/etc/pam.d` folder. Each daemon has its own configuration file, named after its respective program, that defines PAM policies. Below are the contents of the `/etc/pam.d` folder.

```
root@ns1:~ # ls /etc/pam.d
README	  cron	  ftpd	 login	 passwd	   sshd	   sudo	    telnetd
atrun	  ftp	  imap	 other	 pop3	   su	   system   xdm
```

From the contents of the `/etc/pam.d` folder above, it can be seen that each daemon has its own configuration file and is named after its respective program. For example, the SSH application has the sshd configuration in the `/etc/pam.d` folder, the telnet application has the telnetd configuration and others. Now let's look at the contents of the sshd configuration file in the `/etc/pam.d` folder.

```
root@ns1:~ # cat /etc/pam.d/sshd
# PAM configuration for the "sshd" service
#
# auth
auth         sufficient     pam_opie.so         no_warn no_fake_prompts
auth         requisite      pam_opieaccess.so   no_warn allow_local
#auth        sufficient     pam_krb5.so         no_warn try_first_pass
#auth        sufficient     pam_ssh.so          no_warn try_first_pass
#auth        required       pam_unix.so         no_warn try_first_pass
auth         required       pam_unix.so         nodelay
#auth        required       pam_tally.so        deny=3
#pam.d
#auth        requisite      pam_nologin.so
# account
account      required       pam_nologin.so
#account     required       pam_krb5.so
account      required       pam_login_access.so
account      required       pam_unix.so
#account     required       pam_tally.so
#session
#session     optional       pam_ssh.so          want_agent
session      required       pam_permit.so
#password
#password    sufficient     pam_krb5.so         no_warn try_first_pass
password     required       pam_unix.so         no_warn try_first_pass
```

Each line is one PAM rule. Each rule has four components: type, control, module, and module argument. The first statement here has the auth type, sufficient control, pam_opie.so module, and no_warn and no_fake_prompt options.

In the sshd configuration example above on the first line,

```
auth         sufficient         pam_opie.so         no_warn no_fake_prompts
```

The rules above are authentication rules for SSH, which explain the LogIn rules where every time someone logs in with SSH they will be granted permission or denial via login credentials with SSH. This rule is enough. If the module is successful, the authentication request is granted, and rule processing stops immediately. The module is `pam_opie.so`.

The pam_opie man page tells us that it supports OPIE. You'll have to do a little more research to see that OPIE is a One-Use Password Over Everything. This rule states that if someone authenticates with OPIE, they get immediate access. Now let's look at the second rule.

```
auth     requisite     pam_opieaccess.so     no_warn allow_local
```

The second rule explains, If LogIn fails, processing stops immediately. This rule is for another OPIE module, pam_opieaccess. If OPIE users are directly given access to the previous rules, why do we have other OPIE rules? The pam_opieaccess check shows that this module checks whether the user is configured to require OPIE. Users who require OPIE, who enter their OPIE information correctly, may not violate this rule.

In the pam_unix Module checking the password and user is the first step performed, and is standard username and password authentication. So, this policy can be summarized as follows:

1. If the user is successful in OPIE, immediately allow them to log in. If not, move on.
2. If users need OPIE, deny them. OPIE user with the right password
     will never be able to enter.
3. If the user enters the correct username and password, let them log in.


## B. Added Authentication Method

In the PAM module we can add new authentication methods, such as Google Authenticator, or Yubikey, or Cisco Duo. You can even add special authentication methods such as reading fingerprints. The rules below will add a PAM module with voice, fingerprint and scent methods.

```
auth         required             pam_voice.so
auth         required             pam_finger.so
auth         required             pam_aroma.so
```

These three rules are mandatory. Users must submit the correct fingerprint and thumbprint to be able to log in to the FreeBSD system. After these rules are created, add debug rules. PAM provides very little explicit debugging. Three options that can be applied to debug arguments, `pam_echo, and pam_exec`.

Adding debug arguments throughout your policy will not break the module's PAM. The following is an example of a PAM module debug argument with fingerprint authentication.


```
auth       optional         pam_echo.so        “auth policy starting, trying voice”
auth       sufficient       pam_voice.so
auth       optional         pam_echo.so “       voice failed, trying finger”
auth       sufficient       pam_finger.so
auth       optional         pam_echo.so        “finger failed, taking a whiff”
auth       required         pam_aroma.so
auth       optional         pam_echo.so        “how did we get here?”
```


## C. Securing User Authentication

Even though by default on FreeBSD systems the PAM configuration module is located in `/etc/pam.d`, you can move it to the `/etc/pam.conf` file. If you use the `/etc/pam.conf` file, the rules are slightly different from `/etc/pam.d`. In `/etc/pam.conf` the service name as the first token in the configuration line. For example, the following line in `/etc/pam.d/login:`


```
auth     required     pam_unix.so     nulok
```

The rules will change in `/etc/pam.conf` to:

```
login     auth     required     pam_unix.so     nulok
```

If we look at the rules above, in general we can conclude that there are four types of PAM management services:

- Auth management.
- Account management.
- Password management.
- and session management.

Many linux distributions ship with user authentication that is not secure enough. This section discusses some of the ways you can create secure user authentication in your system. While doing these things will make your system more secure, but don't overthink that your system can't be hacked. Certainly every application system has its advantages and disadvantages.

All files in `/etc/pam.d/contain` configuration for a specific service. A notable exception to this rule is the /etc/pam.d/other file. This file contains configuration for any service that does not have its own configuration file. For example, if service xyz (imaginary) tries to authenticate, PAM will look for the file `/etc/pam.d/xyz`. If not found, authentication for xyz will be determined by the `/etc/pam.d/other` file.

Because `/etc/pam.d/other` is the configuration for the fallback PAM service, it is considered safe. The following is an example of the `/etc/pam.d/other` configuration file.


```
auth             required         pam_deny.so
auth             required         pam_warn.so
account          required         pam_deny.so
account          required         pam_warn.so
password         required         pam_deny.so
password         required         pam_warn.so
session          required         pam_deny.so
session          required         pam_warn.so
```

With this configuration, whenever an unknown service tries to access one of the four configuration types, PAM denies authentication (via the pam_deny.so module) and then logs a syslog warning (via the pam_warn.so module).