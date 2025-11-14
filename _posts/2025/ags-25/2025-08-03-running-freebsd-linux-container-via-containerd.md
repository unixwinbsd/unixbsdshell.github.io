---
title: Running FreeBSD Linux Containers via containerd
date: "2025-08-03 10:11:35 +0100"
updated: "2025-08-03 10:11:35 +0100"
id: running-freebsd-linux-container-via-containerd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/oct-25/FreeBSDLinuxContainer.jpg
toc: true
comments: true
published: true
excerpt: With the use of Linux containers or LXC, FreeBSD servers can be used as virtual machines that share host resources. Containerization on FreeBSD leverages container run time environments such as docker to create application images that are isolated from other system processes but share the host OS kernel
keywords: docker, container, containerd, freebsd, linux, running
---

What is a virtualization machine? Virtualization is the resources available on a computer such as storage, CPU, RAM and network to create a virtual machine or container that operates like a normal computer. On FreeBSD, virtualization can be achieved through the use of Linux containers or hypervisors. A hypervisor is software installed on a host server to provide an abstraction layer that facilitates the creation of virtual machines.

With the use of Linux containers or LXC, FreeBSD servers can be used as virtual machines that share host resources. Containerization on FreeBSD leverages container run time environments such as docker to create application images that are isolated from other system processes but share the host OS kernel. In this case, containers are lighter and faster than virtual machines.

The concept of containerization is not new, but the method of implementing and managing it may not be used by many people. On Linux systems, we already know the popular container virtualization platform called Docker. But did you know? We can convert the original server to run containers with the help of LXC (Linux Container) technology on FReeBSD.

The development of container deployments is so fast, because containers can basically do anything now. Developers or end users can manage the entire container lifecycle on the host, including transferring and storing container mirrors, executing and managing containers, and building networking.

Let's take a look at the container architecture:

<br/>
{% lazyload data-src="/img/oct-25/FreeBSDLinuxContainer.jpg" src="/img/oct-25/FreeBSDLinuxContainer.jpg" alt="FreeBSD Linux Container" %}
<br/>

Containerd also has many plugins, including Metadata Plugin, GC Plugin, Snapshot Plugin, Runtime Plugin and others. All plugins in containerd are inside modules, and modules are plugins. In general, containerd is divided into three basic parts, namely Storage, Metadata and Runtime. 

The guide in this article will show you the basics of running Linux containers directly on FreeBSD, without the need for a virtual machine. The Open Container Initiative (OCI) that we will install on FreeBSD will run with Linux containers via containerd.


## 1. Install containerd

Containerd is the industry standard container runtime with an emphasis on simplicity, robustness, and portability. It is available as a daemon for Linux, FreeBSD and Windows. Before we start installing containerd, it is recommended to install `"runj" and "nerdctl"`

Runj is an experimental OCI-compatible runtime with a FreeBSD Jail proof of concept. Before you install `"runj"`, put the following script in the `"/etc/make.conf"` file.

```yml
NO_CHECKSUM=yes
```

Run the following command to install `"runj" and "nerdctl"`.

```yml
root@ns3:~ # cd /usr/ports/sysutils/runj
root@ns3:/usr/ports/sysutils/runj # make install clean
root@ns3:/usr/ports/sysutils/runj # cd /usr/ports/sysutils/nerdctl
root@ns3:/usr/ports/sysutils/nerdctl # make install clean
```

Once finished, you can continue by installing containerd with the following command.

```yml
root@ns3:/usr/ports/sysutils/nerdctl # cd /usr/ports/sysutils/containerd
root@ns3:/usr/ports/sysutils/containerd # make install clean
```

After you finish installing containerd, it will automatically produce a set of binary files located in the `/usr/local/bin` directory.
- containerd
- containerd-shim
- containerd-shim-runc-v1
- containerd-shim-runc-v2
- crictl
- ctr

Make containerd run automatically on FreeBSD by adding the script below to the `"/etc/rc.conf"` file.

```yml
containerd_enable="YES"
```

Run containerd.

```yml
root@ns3:~ # service containerd restart
```

## 2. Containerd Configuration

After you activate **"containerd"**, create a **config.toml** file. Follow the steps below.

```yml
root@ns3:~ # cd /etc
root@ns3:/etc # mkdir -p containerd
root@ns3:/etc # cd containerd
root@ns3:/etc/containerd # touch config.toml
root@ns3:/etc/containerd # mkdir -p /var/lib/containerd/io.containerd.snapshotter.v1.zfs
```

The default containerd configuration file is called `"config.toml"`, by default the file is located in the `/etc/containerd/config.toml` directory. You can generate the default configuration with the following command.

```yml
root@ns3:~ # containerd config default > /etc/containerd/config.toml
```

Once you enable containerd, run the containerd command.

```yml
root@ns3:/etc/containerd # containerd
```

By running the command above, the FreeBSD system will create the config.toml script automatically. You can see an example script below.

```console
disabled_plugins = []
imports = []
oom_score = 0
plugin_dir = ""
required_plugins = []
root = "/var/lib/containerd"
state = "/run/containerd"
temp = ""
version = 2

[cgroup]
  path = ""

[debug]
  address = "/run/containerd/debug.sock"
  format = ""
  gid = 0
  level = "info"
  uid = 0

[grpc]
  address = "/run/containerd/containerd.sock"
  gid = 0
  max_recv_message_size = 16777216
  max_send_message_size = 16777216
  tcp_address = ""
  tcp_tls_ca = ""
  tcp_tls_cert = ""
  tcp_tls_key = ""
  uid = 0

[metrics]
  address = ""
  grpc_histogram = false

[plugins]

  [plugins."io.containerd.gc.v1.scheduler"]
    deletion_threshold = 0
    mutation_threshold = 100
    pause_threshold = 0.02
    schedule_delay = "0s"
    startup_delay = "100ms"

  [plugins."io.containerd.internal.v1.opt"]
    path = "/opt/containerd"

  [plugins."io.containerd.internal.v1.restart"]
    interval = "10s"

  [plugins."io.containerd.internal.v1.tracing"]
    sampling_ratio = 1.0
    service_name = "containerd"

  [plugins."io.containerd.metadata.v1.bolt"]
    content_sharing_policy = "shared"

  [plugins."io.containerd.runtime.v2.task"]
    platforms = ["freebsd/amd64"]
    sched_core = false

  [plugins."io.containerd.service.v1.diff-service"]
    default = ["walking"]

  [plugins."io.containerd.service.v1.tasks-service"]
    rdt_config_file = ""

  [plugins."io.containerd.snapshotter.v1.native"]
    root_path = ""

  [plugins."io.containerd.snapshotter.v1.zfs"]
    root_path = ""

  [plugins."io.containerd.tracing.processor.v1.otlp"]
    endpoint = ""
    insecure = false
    protocol = ""

[proxy_plugins]

[stream_processors]

  [stream_processors."io.containerd.ocicrypt.decoder.v1.tar"]
    accepts = ["application/vnd.oci.image.layer.v1.tar+encrypted"]
    args = ["--decryption-keys-path", "/etc/containerd/ocicrypt/keys"]
    env = ["OCICRYPT_KEYPROVIDER_CONFIG=/etc/containerd/ocicrypt/ocicrypt_keyprovider.conf"]
    path = "ctd-decoder"
    returns = "application/vnd.oci.image.layer.v1.tar"

  [stream_processors."io.containerd.ocicrypt.decoder.v1.tar.gzip"]
    accepts = ["application/vnd.oci.image.layer.v1.tar+gzip+encrypted"]
    args = ["--decryption-keys-path", "/etc/containerd/ocicrypt/keys"]
    env = ["OCICRYPT_KEYPROVIDER_CONFIG=/etc/containerd/ocicrypt/ocicrypt_keyprovider.conf"]
    path = "ctd-decoder"
    returns = "application/vnd.oci.image.layer.v1.tar+gzip"

[timeouts]
  "io.containerd.timeout.bolt.open" = "0s"
  "io.containerd.timeout.shim.cleanup" = "5s"
  "io.containerd.timeout.shim.load" = "5s"
  "io.containerd.timeout.shim.shutdown" = "3s"
  "io.containerd.timeout.task.state" = "2s"

[ttrpc]
  address = ""
  gid = 0
  uid = 0
```

## 3. Running The Linux Container

Once containerd is running normally on your FreeBSD server, use the command line client ctr to interact with the daemon and run some containers. The first step you have to do is draw the picture. You can drag it using the ctr command.

```console
root@ns3:~ # ctr image pull --snapshotter zfs public.ecr.aws/samuelkarp/freebsd:13.1-RELEASE
public.ecr.aws/samuelkarp/freebsd:13.1-RELEASE:                                   resolved       |++++++++++++++++++++++++++++++++++++++|
index-sha256:6d39171771533e3702cd67368564d5d2dcf2bebd24003df2ff814aa4c5d889d6:    exists         |++++++++++++++++++++++++++++++++++++++|
manifest-sha256:ea7a4554069ea058b6e6cc495800d24502b8e0cda4feddfd3d116ab297f5ff20: exists         |++++++++++++++++++++++++++++++++++++++|
config-sha256:a7a23666ec0a322705673e135c52fb468f6997f6ba1a141390617086ba23f0ba:   exists         |++++++++++++++++++++++++++++++++++++++|
layer-sha256:46f3d931f5af7f4bd06625cec8f8d8633fc5d21acfd9236b3ca4f2b8f141f433:    exists         |++++++++++++++++++++++++++++++++++++++|
elapsed: 1.5 s                                                                    total:   0.0 B (0.0 B/s)
unpacking freebsd/amd64 sha256:6d39171771533e3702cd67368564d5d2dcf2bebd24003df2ff814aa4c5d889d6...
done: 51.037526ms
root@ns3:~ #
```

Running containers with containerd requires an image, snapshotter, and container runtime. The `runj` source repository includes a runtime for containerd called wtf.sbk.runj.v1. Run containerd with the command below.

```console
root@ns3:~ # ctr run --snapshotter zfs --runtime wtf.sbk.runj.v1 --rm public.ecr.aws/samuelkarp/freebsd:13.1-RELEASE my-container-id sh -c 'echo "Hello, your FreeBSD Containerd is now active!"'
Hello, your FreeBSD Containerd is now active!
root@ns3:~ #
```

Now we will try another ctr command, namely by running a Linux container.

```console
root@ns3:~ # ctr image pull --platform=linux docker.io/library/alpine:latest
docker.io/library/alpine:latest:                                                  resolved       |++++++++++++++++++++++++++++++++++++++|
index-sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b:    exists         |++++++++++++++++++++++++++++++++++++++|
manifest-sha256:6457d53fb065d6f250e1504b9bc42d5b6c65941d57532c072d929dd0628977d0: exists         |++++++++++++++++++++++++++++++++++++++|
layer-sha256:4abcf20661432fb2d719aaf90656f55c287f8ca915dc1c92ec14ff61e67fbaf8:    exists         |++++++++++++++++++++++++++++++++++++++|
config-sha256:05455a08881ea9cf0e752bc48e61bbd71a34c029bb13df01e40e3e70e0d007bd:   exists         |++++++++++++++++++++++++++++++++++++++|
elapsed: 2.0 s                                                                    total:   0.0 B (0.0 B/s)
unpacking linux/amd64 sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b...
done: 19.442453ms
root@ns3:~ #
```

<br/>

```console
root@ns3:~ # ctr run --rm --tty --runtime wtf.sbk.runj.v1 --snapshotter zfs --platform linux docker.io/library/alpine:latest mylinuxcontainer uname -a
Linux 4.4.0 FreeBSD 13.2-RELEASE releng/13.2-n254617-525ecfdad597 GENERIC x86_64 Linux
root@ns3:~ #
```

If you want to see the List of local mirrors, use the following command.

```yml
root@ns3:~ # ctr i ls
```

For more advanced mirror operations, you can use subcontent-commands such as online mirror image dan editing bloband.

```yml
root@ns3:~ # ctr content ls
```

To better understand the use of containerd, we will create a new container on FreeBSD. Use the following command to download the mirror image.

```console
root@ns3:~ # ctr image pull --platform=linux docker.io/library/nginx:alpine
docker.io/library/nginx:alpine:                                                   resolved       |++++++++++++++++++++++++++++++++++++++|
index-sha256:f2802c2a9d09c7aa3ace27445dfc5656ff24355da28e7b958074a0111e3fc076:    exists         |++++++++++++++++++++++++++++++++++++++|
manifest-sha256:b1cfc4e0e01b4dceca3265fd4ca97921569fca1a10919639bedfa8dad9127027: done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:efb7d60b16cfcd8e0daecf965b6f5575423bf03ac868cbd7def5803501b311b1:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:9e03973bc8036b5eecce7b2d9996cc16108ad4fe366bafd5e0b972c57339404e:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:a3a550dcd38681a0c4c41afd0f4977260b70ceec241359a0b35f443e865bdaff:    done           |++++++++++++++++++++++++++++++++++++++|
config-sha256:2b70e4aaac6b5370bf3a556f5e13156692351696dd5d7c5530d117aa21772748:   done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:d18780149b8172369a5d5194091eb33adc7fcbfd32056d7eb3cedde75725bf82:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:619be1103602d98e1963557998c954c892b3872986c27365e9f651f5bc27cab8:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:4ea31a8fb8756a19d3e7710cb8be2b66aea4e678cc836b88c8c8daa4b564d55b:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:6c866301bd2c1af4fb61766a45a078102eedab8c7b910c0796eab6ea99b14577:    done           |++++++++++++++++++++++++++++++++++++++|
layer-sha256:e57ebb3e206791646f52f35d99488b64a61ab4a1d39b7be52b15d82bd3b12988:    done           |++++++++++++++++++++++++++++++++++++++|
elapsed: 8.0 s                                                                    total:  1.8 Mi (234.1 KiB/s)
unpacking linux/amd64 sha256:f2802c2a9d09c7aa3ace27445dfc5656ff24355da28e7b958074a0111e3fc076...
done: 7.903605972s
root@ns3:~ #
```

Create a container.

```yml
root@ns3:~ # ctr c create docker.io/library/nginx:alpine nginx
```

Delete image container.

```yml
root@ns3:~ # ctr image rm docker.io/library/nginx:alpine
```

Containerd running on FreeBSD and runj are both experimental and still under development. While the functionality demonstrated in this article post works, there are still many features missing. You can find ongoing development work in the containerd repository and runj repository on the Github server.