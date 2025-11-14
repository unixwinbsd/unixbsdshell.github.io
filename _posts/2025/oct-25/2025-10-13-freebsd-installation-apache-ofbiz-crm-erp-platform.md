---
title: FreeBSD Installation and Configuration of Apache OFBiz CRM and Erp Platform
date: "2025-10-13 20:11:36 +0100"
updated: "2025-10-13 20:11:36 +0100"
id: freebsd-installation-apache-ofbiz-crm-erp-platform
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/oct-25/oct-25-72.jpg
toc: true
comments: true
published: true
excerpt: Before starting Apache OFBiz, please note that OFBiz requires the Java Development Kit (JDK) openjdk17 or higher. By default, FreeBSD provides a Java repository that you can install via ports or PKG.
keywords: freebsd, apache, ofbiz, crm, erp, platform, installation, tomcat
---

The presence of an integrated information system is crucial and urgent, creating more effective and efficient work methods, which impact human resource efficiency and business process improvements. This allows managerial functions to be more agile in managing available information, analyzing and determining business strategies for future company development.

Ironically, the implementation of integrated information systems, such as Enterprise Resource Planning (ERP), carries the risk of failure. An information system is a component consisting of people, information technology, and work procedures that process, store, analyze, and disseminate information to achieve a goal.

One of the factors for success in business competition is the support of Information Technology (IT) in managing business transactions. Therefore, IT needs to be managed effectively, such as by ensuring customer and supplier satisfaction levels.

Optimizing the use of new IT in managing daily business transactions can generate extractable information for use as a strategic decision-making tool.

With an integrated information system, large-scale numerical computations can be performed at high speed, providing relatively fast communication, storing large amounts of information for easy access, increasing work effectiveness and efficiency, presenting information in an informative, accurate, up-to-date manner that meets management and user needs, and automating semi-automatic business processes and manual tasks.

The presence of ERP is not a misconception and a fear that people will lose their jobs and be replaced by computers. Instead, it can improve work practices more effectively and efficiently, providing ideas and innovation for strategic business decision-making, contributing to company development.

ERP is an abbreviation of 3 word elements, namely enterprise which means company or organization, resource which means resources and planning which means planning. So ERP reflects a concept that leads to the verb "planning" which means that ERP (Enterprise Resource Planning) emphasizes the planning aspect.

Based on the above, ERP (Enterprise Resource Planning), namely the existence of an integrated planning aspect in an organization or company with the aim of being able to plan and manage organizational resources and being able to respond well to customer needs.

An ERP system can be defined as the terminology given to an integrated information system designed to support transactions or operational processes within a company. The basic concept of an ERP system is shown in the figure below.

<br/>

![freebsd Apache OFBiz Crm dan Erp Platform](/img/oct-25/oct-25-72.jpg)

<br/>

Before starting to install Apache OFBiz, we recommend updating your system ports or PKG packages to the latest versions. You can run the following command to update your system.

```
root@ns3:~ # pkg update -f
root@ns3:~ # pkg upgrade -f
```

## 1. Openjdk17 Java Installation Process

Before starting Apache OFBiz, please note that OFBiz requires the Java Development Kit (JDK) openjdk17 or higher. By default, FreeBSD provides a Java repository that you can install via ports or PKG. Install Java openjdk17 to run OFBiz with the following command.

```
root@ns3:~ # pkg install openjdk17
```
Pada bagian ini, kami tidak akan membahas secara rinci proses instalasi Java openjdk17. Anda dapat membaca artikel kami sebelumnya. [Memasang dan Mengkonfigurasi Java OpenJDK 20 di FreeBSD 14](https://unixwinbsd.site/freebsd/installing-java-openjdk20-on-freebsd14.1stable)


## 2. Setting up the OFBiz Database

Before installing Apache OFBiz, you'll need to set up a database server. Although OFBiz comes with a Hypersonic SQL database installed, you don't need to configure anything to run OFBiz.

However, if you want to use MySQL, MariaDB, or another commercial database, we recommend installing and creating a database for OFBiz first. Follow the instructions below to create an OFBiz database with a MySQL server.


```
root@ns3:~ # mysql -u root -p
Enter password:
root@localhost [(none)]> CREATE DATABASE ofbiz CHARACTER SET utf8;
root@localhost [(none)]> CREATE USER 'userofbiz'@'localhost' IDENTIFIED BY 'router123';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON ofbiz.* TO 'userofbiz'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
root@localhost [(none)]> exit;

root@localhost [(none)]> CREATE DATABASE ofbizolap CHARACTER SET utf8;
root@localhost [(none)]> CREATE USER 'userofbizolap'@'localhost' IDENTIFIED BY 'router123';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON ofbizolap.* TO 'userofbizolap'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
root@localhost [(none)]> exit;

root@localhost [(none)]> CREATE DATABASE ofbiztenant CHARACTER SET utf8;
root@localhost [(none)]> CREATE USER 'userofbiztenant'@'localhost' IDENTIFIED BY 'router123';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON ofbiztenant.* TO 'userofbiztenant'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
root@localhost [(none)]> exit;
```

The above method creates an ofbiz database with user and password.:
- database name: **ofbiz**
- database user: **userofbiz**
- database password: **router123**
- database host: **127.0.0.1**

<br/>

- database name: **ofbizolap**
- database user: **userofbizolap**
- database password: **router123**
- database host: **127.0.0.1**

<br/>

- database name: **ofbiztenant**
- database user: **userofbiztenant**
- database password: **router123**
- database host: **127.0.0.1**


## 3. Apache OFBiz Installation Process

On FreeBSD, the Apache OFBiz repository isn't available. You can clone it from GitHub or download it directly from the official OFBIZ site. In this example, we'll clone OFBiz directly from GitHub. Run the following command.


```
root@ns3:~ # cd /usr/local/www
root@ns3:/usr/local/www # git clone https://github.com/apache/ofbiz-framework.git
```
Next, you migrate OFBiz from Derby to a MySQL database by placing the MySQL JDBC driver in the `build.gradle` file. In the `/usr/local/www/ofbiz-framework/build.gradle` file, add the following script.


```
root@ns3:/usr/local/www # cd ofbiz-framework
root@ns3:/usr/local/www/ofbiz-framework # ee build.gradle
dependencies {
         pluginLibsCompile 'mysql:mysql-connector-java:5.1.6'
    }
```

Open and edit the `/usr/local/www/ofbiz-framework/framework/entity/config/entityengine.xml` file, update the script in the file with the script below.


```
root@ns3:/usr/local/www/ofbiz-framework # cd framework/entity/config
root@ns3:/usr/local/www/ofbiz-framework/framework/entity/config # ee entityengine.xml
<datasource name="localmysql" helper-class="org.apache.ofbiz.entity.datasource.GenericHelperDAO" field-type-name="mysql" check-on-start="true" add-missing-on-start="true" check-pks-on-start="false" use-foreign-keys="true" join-style="ansi-no-parenthesis" alias-view-columns="false" drop-fk-use-foreign-key-keyword="true" table-type="InnoDB" character-set="utf8" collate="utf8_general_ci">
    <read-data reader-name="tenant" />
    <read-data reader-name="seed" />
    <read-data reader-name="seed-initial" />
    <read-data reader-name="demo" />
    <read-data reader-name="ext" />
    <read-data reader-name="ext-test" />
    <read-data reader-name="ext-demo" />
    <inline-jdbc jdbc-driver="com.mysql.jdbc.Driver" jdbc-uri="jdbc:mysql://localhost/ofbiz?autoReconnect=true&amp;characterEncoding=UTF-8" jdbc-username="ofbiz" jdbc-password="ofbiz" isolation-level="ReadCommitted" pool-minsize="2" pool-maxsize="250" time-between-eviction-runs-millis="600000" />
</datasource>
<datasource name="localmysqlolap" helper-class="org.apache.ofbiz.entity.datasource.GenericHelperDAO" field-type-name="mysql" check-on-start="true" add-missing-on-start="true" check-pks-on-start="false" use-foreign-keys="true" join-style="ansi-no-parenthesis" alias-view-columns="false" drop-fk-use-foreign-key-keyword="true" table-type="InnoDB" character-set="utf8" collate="utf8_general_ci">
    <read-data reader-name="seed" />
    <read-data reader-name="seed-initial" />
    <read-data reader-name="demo" />
    <read-data reader-name="ext" />
    <inline-jdbc jdbc-driver="com.mysql.jdbc.Driver" jdbc-uri="jdbc:mysql://localhost/ofbizolap?autoReconnect=true&amp;characterEncoding=UTF-8" jdbc-username="ofbizolap" jdbc-password="ofbizolap" isolation-level="ReadCommitted" pool-minsize="2" pool-maxsize="250" time-between-eviction-runs-millis="600000" />
</datasource>
<datasource name="localmysqltenant" helper-class="org.apache.ofbiz.entity.datasource.GenericHelperDAO" field-type-name="mysql" check-on-start="true" add-missing-on-start="true" check-pks-on-start="false" use-foreign-keys="true" join-style="ansi-no-parenthesis" alias-view-columns="false" drop-fk-use-foreign-key-keyword="true" table-type="InnoDB" character-set="utf8" collate="utf8_general_ci">
    <read-data reader-name="seed" />
    <read-data reader-name="seed-initial" />
    <read-data reader-name="demo" />
    <read-data reader-name="ext" />
    <inline-jdbc jdbc-driver="com.mysql.jdbc.Driver" jdbc-uri="jdbc:mysql://localhost/ofbiztenant?autoReconnect=true&amp;characterEncoding=UTF-8" jdbc-username="ofbiztenant" jdbc-password="ofbiztenant" isolation-level="ReadCommitted" pool-minsize="2" pool-maxsize="250" time-between-eviction-runs-millis="600000" />
</datasource>
```

Don't forget to replace derby with the default mysql database, find the `delegator` script and replace it with the script below.


```
root@ns3:/usr/local/www/ofbiz-framework # cd framework/entity/config
root@ns3:/usr/local/www/ofbiz-framework/framework/entity/config # ee entityengine.xml
<delegator name="default" entity-model-reader="main" entity-group-reader="main" entity-eca-reader="main" distributed-cache-clear-enabled="false">
    <group-map group-name="org.apache.ofbiz" datasource-name="localmysql"/>
    <group-map group-name="org.apache.ofbiz.olap" datasource-name="localmysqlolap"/>
    <group-map group-name="org.apache.ofbiz.tenant" datasource-name="localmysqltenant"/>
</delegator>
     
<delegator name="default-no-eca" entity-model-reader="main" entity-group-reader="main" entity-eca-reader="main" entity-eca-enabled="false" distributed-cache-clear-enabled="false">
    <group-map group-name="org.apache.ofbiz" datasource-name="localmysql"/>
    <group-map group-name="org.apache.ofbiz.olap" datasource-name="localmysqlolap"/>
    <group-map group-name="org.apache.ofbiz.tenant" datasource-name="localmysqltenant"/>
</delegator>
 
<delegator name="test" entity-model-reader="main" entity-group-reader="main" entity-eca-reader="main">
    <group-map group-name="org.apache.ofbiz" datasource-name="localmysql"/>
    <group-map group-name="org.apache.ofbiz.olap" datasource-name="localmysqlolap"/>
    <group-map group-name="org.apache.ofbiz.tenant" datasource-name="localmysqltenant"/>
</delegator>
```

Then download the Gradle wrapper using the provided shell script. This will download the gradle-wrapper.jar file and place it under the `gradle/wrapper` directory.


```
root@ns3:/usr/local/www/ofbiz-framework # gradle init-gradle-wrapper.sh
```

After that, compile `ofbiz` with the following command.


```
root@ns3:/usr/local/www/ofbiz-framework # ./gradlew cleanAll loadAll
```

The final step is to Start the Apache `OFBiz Service`.

```
root@ns3:/usr/local/www/ofbiz-framework # ./gradlew ofbiz
```
Congratulations! You have successfully installed the Apache OFBiz `ERP/CRM` Platform on your FreeBSD 13.2 server. Enjoy the ease of managing CRM, inventory, ERP, and more using Apache OFBiz. Continue learning about ERP/CRM Platforms in the official Apache OFBiz repository and feel free to ask questions to the people who write Apache OFBiz tutorials in the comments section.