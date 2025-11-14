---
title: How to Use Grafana and Prometheus to Monitor OpenBSD Activity
date: "2025-08-16 09:17:21 +0100"
updated: "2025-08-16 09:17:21 +0100"
id: using-grafana-and-prometheus-monitor-openbsd-activity
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/17Monitor_OpenBSD_Activity_with_Grafana_and_Prometheus.jpg
toc: true
comments: true
published: true
excerpt: It turns out everything is quite easy to configure and monitor. The first step is to launch Prometheus. For my setup, I typically run Prometheus and Grafana on separate servers. However, during testing, I was able to run both on a fairly small server.
keywords: grafana, promotheus, monitor, log, openbsd, freebsd, activity, chmod, var
---

It's always recommended to enable some form of monitoring with any OpenBSD deployment. In the past, I've used Zabbix to monitor both the Findelabs public server and my private OpenBSD server. I was going to write an article on installing and configuring the web frontend and backend, but I put it off because the setup was a bit complicated. Last week, I finally migrated to a Grafana dashboard with Prometheus as my monitoring system.

This approach turned out to be less complicated than Zabbix. If you'd like instructions for setting up the various Zabbix components, you can see the backend here and the frontend here. While Zabbix works as intended, I've always found its configuration, even in its interface, a bit cumbersome. Having experienced both Grafana and Prometheus in the past, I figured it should be fairly straightforward to run both on OpenBSD.

It turns out everything is quite easy to configure and monitor. The first step is to launch Prometheus. For my setup, I typically run Prometheus and Grafana on separate servers. However, during testing, I was able to run both on a fairly small server.

![Monitor OpenBSD Activity with Grafana and Prometheus](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/17Monitor_OpenBSD_Activity_with_Grafana_and_Prometheus.jpg)


First, install `Prometheus and node_exporter.` Node_exporter is a small application that exports server metrics on port `9100` from any installed server.

```console
hostname1# pkg_add prometheus node_exporter
```

Next, edit `/etc/prometheus/prometheus.yml`. Here's a sample configuration, with a little more complexity:

```console
# my global config
global:
  scrape_interval:     5s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
# rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'
    static_configs:
    - targets: ['0.0.0.0:9090']

  # This is where you can add new servers to monitor
  - job_name: 'node'
    file_sd_configs:
    - files:
      - '/etc/prometheus/targets.json'
```

This configuration will get it up and running, although we still need to create the `/etc/prometheus/targets.json` file, as this is where Prometheus expects targets to be monitored in this configuration. This file can be quickly updated without restarting Prometheus:

```console
[
  {
    "labels": {
      "job": "node"
    },

    "targets": [
      "server1:9100",
      "server2:9100",
      "server3:9100"
    ]
  }
]
```

Using this target.json file, Prometheus will attempt to get metrics from servers 1/2/3. These servers can also be specified by IP, but Prometheus will store all metrics for each instance and tag them with the values specified in this target.json file.

Therefore, I find it much easier to specify each server by its hostname and update `/etc/hosts` to point to the correct IP, unless I have DNS working for each server.

You can then optionally modify the `/etc/rc.d/prometheus` script to set metric retention. The default retention period is just 15 days, which is fine, but I think it should be longer in my case. I usually specify `--storage.tsdb.retention.time=90` days in daemon_flags, as shown here.

Also note that Prometheus will listen on all interfaces by default, which isn't always ideal. You can specify to listen on localhost, for example with `--web.listen-address="localhost:9090"` in daemon_flags below.

```console
#!/bin/sh
#
# $OpenBSD: prometheus.rc,v 1.1.1.1 2018/01/10 16:26:19 claudio Exp $

daemon="/usr/local/bin/prometheus"
daemon_flags="--config.file /etc/prometheus/prometheus.yml"
daemon_flags="${daemon_flags} --storage.tsdb.path '/var/prometheus' --storage.tsdb.retention.time=90d"
daemon_user=_prometheus

. /etc/rc.d/rc.subr

pexp="${daemon}.*"
rc_bg=YES
rc_reload=NO

rc_start() {
        ${rcexec} "${daemon} ${daemon_flags} < /dev/null 2>&1 | \
                logger -p daemon.info -t prometheus"
}

rc_cmd $1
```

Now we can enable and start the prometheus and node_exporter services. Monitor `/var/log/daemon` to ensure prometheus is connecting properly:

```console
hostname1# rcctl enable prometheus node_exporter
hostname1# rcctl start prometheus node_exporter
hostname1# tail -f /var/log/daemon

# Test to make sure the frontend is accessible
hostname1# curl localhost:9090/graph

# Ensure node_exporter is working
hostname1# curl localhost:9100/metrics
```

Now we can proceed to install and start `grafana`.

```console
hostname1# pkg_add grafana
hostname1# rcctl enable grafana
hostname1# rcctl start grafana
```

When you start the service, go to the dashboard, log out on the 3000th login using the predefined method, and you'll be authenticated as a normal administrator with the predefined administrator credentials. Once a session is started, Grafana will immediately require you to log in as an administrator. Instead of starting in the dashboard, click `"Collect Data"` and then `"Prometheus"`

To configure access to Prometheus, simply enter `"http://localhost:9090"` as the URL, click "Secure," and verify. If Prometheus is running on your server, Grafana can be used to access the data source.

Here, you can create dashboards to monitor OpenBSD servers. He published one of the simple dashboards he uses to monitor a small collection of my services. You can import the dashboard in the Control Panel/Administration and click `"Import"`. When you open the dashboard, you'll be able to quickly view your server metrics.

The monitoring service aggregates, so you can install the node_exporter package on a remote server and update the `/etc/prometheus/targets.json` archive for that server.

Overall, it's great to have Grafana and Prometheus at your disposal for simplicity.