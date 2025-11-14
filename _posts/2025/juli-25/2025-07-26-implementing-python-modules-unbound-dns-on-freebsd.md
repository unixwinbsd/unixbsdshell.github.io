---
title: Implementing Python Modules for Unbound on FreeBSD Servers
date: "2025-07-26 13:32:21 +0100"
updated: "2025-07-26 13:32:21 +0100"
id: implementing-python-modules-unbound-dns-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/18-install_python_module_for_unbound.jpg
toc: true
comments: true
published: true
excerpt: Unbound DNS Server is a buildable DNSSEC validating and recursive server with support for Python modules. You can improve the capabilities and functions of the Unbound DNS server with python scripts.
keywords: dns, server, unbound, dnssec, python, modules, freebsd
---

Unbound DNS Server is a buildable DNSSEC validating and recursive server with support for Python modules. You can improve the capabilities and functions of the Unbound DNS server with python scripts.

**Benefits of using python scripts in unbound:**
- Authoritative responses to queries can be generated on the fly.
- Responses to queries obtained from the public DNS can be modified before being returned to the DNS client. This could be interesting, say, to increase or lower the TTL of a particular set of records, or to lie.
- Every incoming and outgoing package can be recorded.

The first item is particularly interesting because we can obtain data from the myriad of sources Python and its modules have to offer, do you want to build a customized DNS blacklist that uses a fast database, Redis cacheDB, say, as a backend?. Want to query Twitter statuses over DNS, or provide a DNS gateway to a REST weather API?. Do you have a parts database you want exposed over the DNS?. Any and all of these and more are possible using Unbound DNS server, some Python script and a bit of imagination.


## 1. Activate the Python Module

To activate the Python module in Unbound, we have to "Reinstall" the Unbound application. Python modules can only be activated with FreeBSD system ports. The following is the command used to activate the python module.

```yml
root@ns6:~ # portmaster -af
root@ns6:~ # portupgrade -af
```

The script above is to update and upgrade the FreeBSD ports system.

```yml
root@ns6:~ # cd /usr/ports/dns/unbound && make config
```

![install python module for unbound](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/18-install_python_module_for_unbound.jpg)


The make config command will display the Unbound module and library selection menu. Select python `"Python bindings or support"` After that do `"Reinstall"`.

```yml
root@ns6:/usr/ports/dns/unbound # make reinstall
```

Well, now we have a python module in the Unbound system, then we will use the python module to configure Unbound.


## 2. Configure the unbound.conf file

The main Unbound config file is located at "/usr/local/etc/unbound/unbound.conf". Python modules can be activated in the file. The first step is to create a modules folder.

```yml
root@ns6:/usr/ports/dns/unbound # mkdir -p /usr/local/etc/unbound/modules
```

To enable python module on file **"/usr/local/etc/unbound/unbound.conf"**, Insert the script below into the file.

```console
module-config: "validator python iterator"


python:
# Script file to load
#python-script: "/tmp/indexer/indexer/lib/python3.9/site-packages/ubsplitmap.py"
#python-script: "/usr/local/etc/unbound/modules/nxforward.py"
#python-script: "/usr/local/etc/unbound/modules/pythonmod_conf.py"
#python-script: "/usr/local/etc/unbound/modules/mod.py"
#python-script: "/usr/local/etc/unbound/modules/dns-firewall.py"
python-script: "/usr/local/etc/unbound/modules/main.py"
```

You can create a single python file or many python files. Open the `/usr/local/etc/unbound/modules` folder and create a file with the name `"main.py"`.

```yml
root@ns6:~ # cd /usr/local/etc/unbound/modules
root@ns6:/usr/local/etc/unbound/modules # touch main.py
root@ns6:/usr/local/etc/unbound/modules # chmod +x main.py
root@ns6:/usr/local/etc/unbound/modules # chown -R unbound:unbound main.py
```

Insert the script below into the `/usr/local/etc/unbound/modules/main.py` file.

```console
def init(id, cfg):
    return True

def deinit(id):
    return True

def inform_super(id, qstate, superqstate, qdata):
    return True

domains = [
    "unixwinbsd.site.",
    "datainchi.com.",
]


def operate(id, event, qstate, qdata):
    if event == MODULE_EVENT_NEW or event == MODULE_EVENT_PASS:

        if qstate.qinfo.qname_str.endswith(tuple(localhost_domains)):
            if (qstate.qinfo.qtype == RR_TYPE_AAAA):
                msg = DNSMessage(qstate.qinfo.qname_str, RR_TYPE_AAAA, RR_CLASS_IN, PKT_QR | PKT_RA | PKT_AA)
                msg.answer.append("%s 10 IN AAAA ::1" % qstate.qinfo.qname_str)
            if (qstate.qinfo.qtype == RR_TYPE_A):
                msg = DNSMessage(qstate.qinfo.qname_str, RR_TYPE_A, RR_CLASS_IN, PKT_QR | PKT_RA | PKT_AA)
                msg.answer.append("%s 10 IN A 127.0.0.1" % qstate.qinfo.qname_str)
            if (qstate.qinfo.qtype == RR_TYPE_ANY):
                msg = DNSMessage(qstate.qinfo.qname_str, RR_TYPE_AAAA, RR_TYPE_A, RR_CLASS_IN, PKT_QR | PKT_RA | PKT_AA)
                msg.answer.append("%s 10 IN AAAA ::1" % qstate.qinfo.qname_str)
                msg.answer.append("%s 10 IN A 192.168.5.2" % qstate.qinfo.qname_str)
            if not msg.set_return_msg(qstate):
                qstate.ext_state[id] = MODULE_ERROR
                return True
            # We don't need validation, result is valid
            qstate.return_msg.rep.security = 2
            qstate.return_rcode = RCODE_NOERROR
            qstate.ext_state[id] = MODULE_FINISHED
            log_info("mod.py: returned localhost for %s" % qstate.qinfo.qname_str)
            return True

        if qstate.qinfo.qname_str.endswith(tuple(ignore_aaaa_domains)):
            if (qstate.qinfo.qtype == RR_TYPE_AAAA):
                msg = DNSMessage(qstate.qinfo.qname_str, RR_TYPE_A, RR_CLASS_IN, PKT_QR | PKT_RA | PKT_AA)
                if not msg.set_return_msg(qstate):
                    qstate.ext_state[id] = MODULE_ERROR
                    return True
                # We don't need validation, result is valid
                qstate.return_msg.rep.security = 2
                qstate.return_rcode = RCODE_NOERROR
                qstate.ext_state[id] = MODULE_FINISHED
                log_info("mod.py: removed AAAA record from %s" % qstate.qinfo.qname_str)
                return True

        qstate.ext_state[id] = MODULE_WAIT_MODULE
        return True

    if event == MODULE_EVENT_MODDONE:
        qstate.ext_state[id] = MODULE_FINISHED
        return True

    log_err("mod.py: error in module occured")
    qstate.ext_state[id] = MODULE_ERROR
    return True




log_info("pythonmod: script loaded")
```

After that, Restart Unbound.

```console
root@ns6:~ # service unbound restart
Stopping unbound.
Waiting for PIDS: 59702.
Obtaining a trust anchor...
Starting unbound.
```

When Unbound processes a DNS query, it calls the modules listed in module-config from left to right. In this article we have activated the python module, and we can use the python command together with the Unbound command.