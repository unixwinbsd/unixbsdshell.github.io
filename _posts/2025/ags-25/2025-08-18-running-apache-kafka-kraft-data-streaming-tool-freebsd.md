---
title: Running Apache Kafka Kraft - Data Streaming tool on FreeBSD
date: "2025-08-18 09:36:43 +0100"
updated: "2025-08-18 09:36:43 +0100"
id: running-apache-kafka-kraft-data-streaming-tool-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/18diagram_apache_kafka.jpg
toc: true
comments: true
published: true
excerpt: By definition, Apache Kafka is an open-source distributed event streaming platform used for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.
keywords: installation, apache, kafka, kraft, streaming, tool, data, module, freebsd
---

For those of you who are currently researching or studying data engineering, you must be familiar with one of the mandatory tools that data engineers must master, namely Apache Kafka. Apache Kafka tools are generally used by data engineers to help carry out data streaming, which is the process of collecting data continuously to follow up on information.

Actually, when talking about data engineering, there are many other tools besides Apache Kafka that you need to master too, including:

- **Apache Hive**

Tools used to analyze large datasets stored in HDFS Hadoop and Amazon S3 filesystems.

- **Apache Airflow**

Tools used to schedule and organize workflows or data pipelines for coordinating, organizing, scheduling and managing complex data pipelines from different sources.

- **Tableau**

Tools used to help make it easier to create visual analyzes in the form of dashboards, translate data into visual form, manage metadata, import various sizes and ranges of data, and create visualizations without the need for coding.

- **Snowflake**

Tools used to store and calculate data.

- **Power BI**

Tools used to combine, analyze and create data visualizations.

If you are currently learning more about Apache Kafka, then read this article for more complete information about the definition of Apache Kafka, concepts, case studies, and recommendations for places to learn and practice Apache Kafka tools!


## 1. Definition of Apache Kafka

By definition, Apache Kafka is an open-source distributed event streaming platform used for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications. There are several main advantages of Apache Kafka so that it is used by many data engineers in various companies including large companies, including:

- **Distributed**

Apache Kafka can be used to receive, store, and send messages or data from various nodes.

- **Horizontally-scalable**

Apache Kafka can be used in clusters or groups so that with increasing data flow speed or data volume, data engineers only need to add new machines to the cluster without having to do vertical-scaling.

- **Fault-tolerant**

Apache Kafka can be used to replicate data to other nodes.

- **Scalability**

Apache Kafka can be used to handle millions of messages in a short time so it can be relied on to process data on a large scale.

- **High performance**

Apache Kafka has very fast performance and can handle large amounts of data at the same time.

- **Failure recovery**

Apache Kafka can save data and recover quickly if a failure occurs.

Kafka combines two messaging models, queue and publish-subscribe, to provide consumers with the key benefits of each model. Look at the image below.

![diagram apache kafka](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/18diagram_apache_kafka.jpg)


Apache Kafka also has concepts that you need to know, including:

**1. Producer**

Application that sends messages to Apache Kafka.

**2. Consumer**

Application that uses data from Kafka.

**3. Message**

Data sent by the producer application to the consumer application via Kafka.

**4. Node**

Single server engine in an Apache Kafka cluster.

**5. Connection**

TCP connection between the Kafka cluster and the application.

**6. Topic**

Category that receives data and is sent to the consumer application.

**7. Replicas**

Replication of cluster nodes.

**8. Consumer groups**

A group of consumers who are interested in the same topic.

**9. Offset**

Offset from consumer.

**10. Topic partition**

Category of each partition on the engine node.

**11. Cluster**

A group of nodes or servers.


## 2. Installing Apache Kafka

Kafka requires dependencies, to run library files. Before you install Kafka, install the following dependencies.

```
root@ns3:~ # pkg install -y librdkafka bash git gradle openjdk17 zookeeper
```

On FreeBSD the Kafka repository is available, you can install it directly via the PKG package or the Ports system. In this article we will install Kafka with the FreeBSD ports system. Run the command "make install" to start the installation process.

```
root@ns3:~ # cd /usr/ports/net/kafka
root@ns3:/usr/ports/net/kafka # make install clean
```

After that, you run the command so that Kafka runs automatically on the FreeBSD server. Open the `/etc/rc.conf` file, and type the following script in the file.

```
kafka_enable="YES"
kafka_user="kafka"
kafka_group="kafka"
kafka_config="/usr/local/etc/kafka/kraft/server.properties"
kafka_log4j_config="/usr/local/etc/kafka/log4j.properties"
kafka_log_dir="/var/log/kafka"
```

Next, you run the chmod and chown commands so that the Kafka server has file access rights and file ownership.

```
root@ns3:~ # chown -R kafka:kafka /usr/local/etc/kafka
root@ns3:~ # chmod -R 775 /usr/local/etc/kafka
root@ns3:~ # chown -R kafka:kafka /var/db/kafka-kraft
```

Open the `"/usr/local/etc/kafka/kraft/server.properties"` file, and activate the script below.

```
process.roles=broker,controller
node.id=1
controller.quorum.voters=1@127.0.0.1:9093
listeners=PLAINTEXT://127.0.0.1:9092,CONTROLLER://:9093
controller.listener.names=CONTROLLER
log.dirs=/var/db/kafka-kraft
delete.topic.enable=true
```

Run the restart command, so that you can use Apache Kafka immediately.

```
root@ns3:~ # service kafka restart
```


## 3. Start the Apache Kafka Server

Now that the Apache Kafka server is active on your FreeBSD server, it's time to start running the Apache Kafka server. To start Apache Kafka use the command "kafka-server-start.sh". You must pass the path to the properties file you want to use.

You need to know, in FreeBSD, the files to run the Kafka server are located in the `/usr/local/share/java/kafka/bin` directory. This directory contains all Kafka `"sh"` files and can be used to run a Kafka server.

The first step to start Apache Kafka is to use the kafka-storage tool to generate a Cluster UUID and format the storage with the generated UUID when running Kafka in KRaft mode. 

You must explicitly create a cluster ID for the KRaft cluster, and format the storage that specifies that ID. Run the following command to create a Cluster UUID.

```
root@ns3:~ # cd /usr/local/share/java/kafka/bin
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-storage.sh random-uuid
6rUpPQPAQhyX85qPrvxyPQ
```

After you have successfully created the Cluster UUID, run the command below.

```
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-storage.sh format -t 6rUpPQPAQhyX85qPrvxyPQ -c /usr/local/etc/kafka/kraft/server.properties
```

Run Apache Kafka Server.

```
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-server-start.sh /usr/local/etc/kafka/kraft/server.properties
```


## 4. Debugging Kraft Mode

In this section we will study the debugging aspects of Apache Kafka Kraft. Debugging in Kafka is critical to maintaining the health and performance of Kafka data pipelines. This process will involve identifying and resolving issues that can arise in a Kafka deployment, ranging from configuration errors to performance bottlenecks.

You can view the runtime status of the cluster metadata partition with the `"kafka-metadata-quorum.sh"` command. Run the following command to display the quorum metadata summary.

```
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-metadata-quorum.sh --bootstrap-server  127.0.0.1:9092 describe --status
ClusterId:              6rUpPQPAQhyX85qPrvxyPQ
LeaderId:               1
LeaderEpoch:            7
HighWatermark:          84514
MaxFollowerLag:         0
MaxFollowerLagTimeMs:   0
CurrentVoters:          [1]
CurrentObservers:       []
```

You can also debug log segments and snapshots for the cluster metadata directory. Use the `"kafka-dump-log.sh"` command to decode and print the log in the first log segment.

```
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-dump-log.sh --cluster-metadata-decoder --files /var/db/kafka-kraft/__cluster_metadata-0/00000000000000000000.log
```

If you want to check partition metadata interactively, use the command `"kafka-metadata-shell.sh"`. The example below shows how to open a shell.
```
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-metadata-shell.sh --snapshot /var/db/kafka-kraft/__cluster_metadata-0/00000000000000008983-0000000004.checkpoint
```


## 5. Testing the Cluster

To successfully record data, you need to test the cluster by creating a topic. Use the command `"kafka-topics.sh"` use the default port which is **9092**.

```
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-topics.sh --create --topic FreeBSDTest --bootstrap-server 127.0.0.1:9092
Created topic FreeBSDTest.
```


The above command is used to create a FreeBSDTest topic. In the example above the topic was created with only one partition, because we did not specify the number of partitions. You can check it with the following command.

```
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-topics.sh --describe --topic FreeBSDTest --bootstrap-server 127.0.0.1:9092
Topic: FreeBSDTest      TopicId: R2R936jdT8GAB43vI5lz2Q PartitionCount: 1       ReplicationFactor: 1    Configs: segment.bytes=1073741824
Topic: FreeBSDTest      Partition: 0    Leader: 1       Replicas: 1     Isr: 1
```

Now your topic is ready, we can write a message on that topic. Luckily, Kafka comes with a console utility that allows us to do this. Run the command `"kafka-console-producer.sh"` to write a message on the topic.

```
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-console-producer.sh --topic FreeBSDTest --bootstrap-server 127.0.0.1:9092
>Hello FreeBSD
>FreeBSD The Power To Server
```

Now we need to read the messages we have created above. To do this, run the command `"kafka-console-consumer.sh"`.

```
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-console-consumer.sh --topic FreeBSDTest --bootstrap-server 127.0.0.1:9092
```

Close the user and call again, but with different settings. The command is still the same, but with the addition of `"--consumer-property"`, where we pass the setting `"auto.offset.reset=earliest"`. The earliest value indicates that reading the record will start with the earliest available message.

```
root@ns3:/usr/local/share/java/kafka/bin # ./kafka-console-consumer.sh --topic FreeBSDTest --bootstrap-server 127.0.0.1:9092 --consumer-property auto.offset.reset=earliest
```

To be able to use various data engineering tools such as Apache Kafka, it is not enough to just master the theory, but you also have to practice by practicing these tools directly. You can learn data engineering as well as practice directly various data engineering tools using the FreeBSD server.