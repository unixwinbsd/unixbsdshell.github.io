---
title: How to Configure Jenkins Continuous Integration on FreeBSD
date: "2025-02-04 07:31:25 +0100"
updated: "2025-06-04 20:22:11 +0100"
id: configuration-installation-jenkins-ci-cid-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-002.jpg
toc: true
comments: true
published: true
excerpt: Continuous Integration (CI) is the most important part of DevOps which is used to integrate various stages of DevOps. Jenkins is the most famous Continuous Integration tool. Jenkins is an open source application automation tool written in Java with plugins built for continuous integration.
keywords: jenkins, ci, cid, freebsd, installation, github, gitlab
---


Continuous Integration (CI) is the most important part of DevOps that is used to integrate various stages of DevOps. Jenkins is the most popular Continuous Integration tool. Jenkins is an open-source application automation tool written in Java with plugins built for continuous integration.

Jenkins is used to build and test software projects continuously, making it easy for developers to integrate changes to the project, and easy for users to get the latest version of the application they are using. Jenkins also allows its users to continuously deliver software by continuously integrating a large number of testing and deployment technologies.

With Jenkins, organizations can accelerate the software development process through automation. Jenkins integrates all types of development lifecycle processes, including building, documenting, testing, packaging, staging, deploying, static analysis, and more.

Jenkins can achieve its purpose as a continuous integration tool with the help of plugins. Plugins allow integration of various stages of DevOps. If we want to integrate a particular tool, we are required to install a plugin for that tool. For example, Git, Maven 2 project, Amazon EC2, HTML publisher and others.

Jenkins is an open-source continuous integration (CI) server written in Java. It is a web application that allows you to automate various software development tasks such as building, testing, and deploying. Jenkins can be used for a variety of projects, regardless of their size or complexity.

Jenkins is a great tool that can help automate the software development process and improve its quality. If you are looking for a way to improve your software development process, Jenkins is a great choice.

## A. Jenkins Benefits
The Jenkins platform has many advantages that make it very popular for automating software development processes. Here are some of the most obvious advantages of this platform:

- Free and Open Source: It is a free, open source platform, meaning it is free to use and contribute to its development.
- Powerful: It has many features that allow you to automate various software development tasks.
- Extensible: It has many plugins that you can use to add new features and integrate with other tools.
- Community: It has a large and active community of users and developers who can provide support and assistance.
- Very easy to install.

## B. What is Continuous Integration?
Continuous Integration (CI) is a development practice that requires developers to push source code changes to a shared repository multiple times a day or more frequently. Any commits made to that repository are then committed.

This allows teams to detect issues early. Additionally, depending on the Continuous Integration tool, there are several other features such as deploying the build application to a test server, sharing build and test results with a group of stakeholders, etc.

Continuous [integration is a DevOps software development practice](https://aws.amazon.com/id/devops/continuous-integration/) in which developers regularly merge their code changes into a central repository, after which automated builds and tests are run. Continuous integration most often refers to the build or integration phase of the software release process and requires both an automation component (e.g., CI or build services) and a cultural component (e.g., learning to integrate regularly).

The primary goals of continuous integration are to find and resolve bugs faster, improve software quality, and reduce the time it takes to validate and release new software updates.

In software engineering, Continuous Integration is often defined as a form of [quality control](https://www.atlassian.com/continuous-delivery/continuous-integration), where small efforts are applied frequently, as opposed to the more traditional method of applying quality control after development is complete. Integration is verified by automated builds that are used to detect integration errors as early as possible and test the software.

Development teams use a continuous integration approach to software development because it allows them to develop in a faster and more efficient manner than if they were working in isolation for a longer period of time.

## C. ## Continuous Integration with Jenkins

Imagine a scenario where the complete source code for an application has been built and then deployed to a test server for testing. This seems like an ideal way to develop software, but the process has many drawbacks. I will try to explain them one by one.
- Developers have to wait until the full test results of the software are developed.
- There is a high probability that the test results will show some errors. Developers have a hard time finding bugs because they have to check the entire source code of the application.
- Slows down the software delivery process.
- There is no continuous feedback on issues such as coding or architecture issues, build failures, test status, and release file uploads, which can reduce the quality of the software.
- The entire process is done manually, increasing the risk of frequent failures.

From the above problems, it can be seen that the software delivery process is not only slow, but the quality of the software also decreases. This leads to customer dissatisfaction. Therefore, to overcome this chaos, a system is needed that allows developers to continuously run builds and tests for every change made to the source code. That is the purpose of CI. Jenkins is the most mature CI tool available, so let's see how continuous integration with Jenkins has overcome the above shortcomings.

First, I will explain to you the general scheme of continuous integration with Jenkins so that it becomes clear how Jenkins overcomes the above shortcomings:

- First, the developer commits the code to the source code repository. Meanwhile, the Jenkins server regularly checks the repository for changes.
- Once a commit occurs, the Jenkins server detects the changes made in the source code repository. Jenkins will commit these changes and start preparing a new version.
- If the build fails, the appropriate team is notified.
- If the build succeeds, Jenkins deploys the built-in testing server.
- After testing, Jenkins generates feedback and then notifies the developer about the build and test results.
- Jenkins will continue to check the source code repository for changes made to the source code, and the whole process will repeat itself.

Since Jenkins is built on Java, it is a good idea to read the article about Java that we have written before ["Installing and Configuring Java OpenJDK 20 on FreeBSD 14"](https://unixwinbsd.site/en/freebsd/2025/02/14/installing-java-openjdk20-on-freebsd14.1stable/).

To install Jenkins, we must first install Java. Let's say you have read the Java article above and the Java system has been installed on your FreeBSD computer. So now let's continue the process of installing Jenkins on your FreeBSD computer. In this article we will install Jenkins on FreeBSD 13.2 OS. Here is how to install Jenkins.

To install Jenkins, we must first install Java. Let's assume you have read the Java article above and the Java system has been installed on your FreeBSD computer. So now let's continue with the process of installing Jenkins on your FreeBSD computer. In this article we install Jenkins on FreeBSD 13.2 OS. Here is how to install Jenkins.

```console
root@ns1:~ # cd /usr/ports/devel/jenkins root@ns1:/usr/ports/devel/jenkins # make install clean
```

After the installation process is complete, continue by editing the `/etc/rc.conf` file, to start rc.d. Enter the following command in the `/etc/rc.conf` file.

```console
root@ns1:~ # ee /etc/rc.conf  jenkins_enable="YES"
jenkins_home="/usr/local/jenkins"
jenkins_args="--webroot=${jenkins_home}/war --httpListenAddress=192.168.5.2 --httpPort=8180"
jenkins_java_home="/usr/local/openjdk11"
jenkins_user="jenkins"
jenkins_group="jenkins"
jenkins_log_file="/var/log/jenkins.log"
```

Then we proceed to the next step, which is to restart Jenkins to activate Jenkins on the FreeBSD system.

```console
 root@ns1:~ # service jenkins restart  Stopping jenkins.
Waiting for PIDS: 913.
Starting jenkins.
```

Up to here the Jenkins configuration via the Command Line interface menu is complete, now we will continue the Jenkins configuration via the GUI menu. It's easier because there are images like we are using Windows. To configure Jenkins with GUI, we open the Google Chrome or Yandex web browser.

In the new address menu, type the IP address and port that we have specified earlier **http://192.168.5.2:8180/jenkins/**, after pressing the "enter" button an image will appear as below.

<br/>
![Please wait a moment Jenkins will be ready to use](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-002.jpg)
<br/>

Jenkins password can be seen in the file `/usr/local/jenkins/secrets/initialAdminPassword`, open the file and copy and paste the password to open Jenkins.

```console
root@ns1:~ # ee /usr/local/jenkins/secrets/initialAdminPassword  79fa6b92b88b4ec593fd2ae77ffc501f
```

**_79fa6b92b88b4ec593fd2ae77ffc501f_** is the Jenkins password. With this password we can enter the Jenkins GUI menu and can change the password. After the Jenkins menu opens, the first time Jenkins will synchronize, wait a few moments until the synchronization process is complete.

<br/>
![unlock jenkins](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-003.jpg)
<br/>

![wellcome to jenkins](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/oct-25-004.jpg)
<br/>

As mentioned at the beginning of this post, the discussion in this article is just a brief introduction to Continuous Integration with Jenkins on FreeBSD.

You are advised to check the online documentation about Jenkins and Continuous Integration on the official Jenkins website. Jenkins also provides many ready-to-use plugins that extend its functionality. You can check the available plugins for Jenkins here and install them as needed.