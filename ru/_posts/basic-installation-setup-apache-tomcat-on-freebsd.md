---
title: Базовая установка и настройка Apache Tomcat на сервере FreeBSD
date: "2025-04-16 12:20:15 +0100"
id: basic-installation-setup-apache-tomcat-tomcat-on-freebsd
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "WebServer"
excerpt: Apache и Apache Tomcat — два известных сервера веб-приложений, используемых во всем мире. Apache — это бесплатный веб-сервер с открытым исходным кодом, который позволяет пользователям размещать и обрабатывать динамические веб-сайты.
keywords: apache, tomcat, setup, freebsd, web server, https, unix, download, openbsd, ssl
---
Apache Tomcat — это программное обеспечение с открытым исходным кодом, разработанное Apache Foundation. Tomcat написан на Java и впервые был выпущен в 1999 году. Джеймс Дункан Дэвидсон был его первоначальным основателем, который в то время работал архитектором программного обеспечения. Он начал разрабатывать программное обеспечение Apache Tomcat для реализации сервлетов. Что такое сервлеты? Проще говоря, сервлет — это серверная технология, которая помогает обрабатывать http-запросы и ответы клиентов.

Apache и Apache Tomcat — два известных сервера веб-приложений, используемых во всем мире. Apache — это бесплатный сервер веб-сайтов с открытым исходным кодом, который позволяет пользователям размещать и обрабатывать динамические веб-сайты, в то время как Apache Tomcat — это сервер сервлетов и контейнеров JSP, используемый для размещения веб-приложений Java.

Оба сервера могут работать вместе, но их функции и цели различаются. Apache — это статический сервер, который не поддерживает сервлеты или JSP, в то время как Apache Tomcat используется только для поддержки веб-приложений Java.

Additionally, Apache handles HTTP requests and Apache Tomcat is used to host Java code such as servlets and JSP. Apache can be used with PHP, Python, and other programming languages, while Apache Tomcat is used exclusively for Java applications.

gambar

## 1. системные требования
- ОС: FreeBSD 14.1
- Имя хоста: ns7
- IP-адрес: 192.168.5.2
- Версия Java: openjdk version "20.0.2" 2023-07-18
- Версия Tomcat: tomcat9

## 2. Что такое Apache и Apache Tomcat
Apache — это бесплатный веб-сервер, позволяющий размещать веб-страницы, скрипты и другие файлы на веб-сайтах. Apache отличается высокой производительностью, надежностью и гибкостью настройки. Apache поддерживает множество протоколов, включая HTTP, HTTPS и FTP.

Apache Tomcat — это сервер приложений, предназначенный для запуска приложений Java в среде Java Servlet и JavaServer Pages. Tomcat — отличный выбор для веб-приложений с открытым исходным кодом, таких как форумы и системы управления контентом.

Apache Tomcat в основном используется для обработки динамического контента, тогда как Apache — для обработки статического контента. Apache может функционировать как интерфейсный веб-сервер, который обращается к серверу приложений Tomcat для обработки динамического контента.

## 3. Различия в функциональности
Apache — это веб-сервер, используемый для обслуживания статических страниц и файлов, таких как HTML, CSS, JavaScript и изображения. Apache также может использоваться для создания простых скриптов CGI на Perl или Python. С другой стороны, Apache Tomcat — это контейнер сервлетов и JSP. Это означает, что Tomcat используется для выполнения кода Java и приложений, созданных на платформе Java.

Кроме того, Apache и Apache Tomcat различаются по использованию протоколов. Apache обычно используется для обработки HTTP-запросов, а Tomcat — для обработки сетевых запросов Java по HTTPS.

Также стоит отметить, что Apache имеет расширенные настройки безопасности и аутентификации, которые являются важными аспектами для решения проблемы доступа к конфиденциальным данным. Tomcat также имеет параметры настройки безопасности, но они ориентированы на веб-приложения, работающие на этом сервере.

В целом, Apache и Apache Tomcat имеют разные цели и области применения, но оба могут быть полезными инструментами веб-разработки и хостинга в зависимости от потребностей пользователя.

## 4. Языки программирования Apache24 и Apache Tomcat
Как и другие веб-серверы, Apache поддерживает множество языков программирования, от стандартных HTML и CSS до языков сценариев, таких как JavaScript и PHP. Помимо основного языка, Apache может работать с такими языками программирования, как Perl и Python, что делает его универсальным и гибким решением для веб-разработки.

В отличие от Apache, Apache Tomcat — это контейнер веб-приложений, разработанный для запуска динамических страниц с использованием таких языков программирования, как Java, JavaScript и JSP. Apache Tomcat можно использовать для создания и запуска веб-приложений, часто используемых в электронной коммерции и других задачах, требующих динамической функциональности веб-сайта. Ниже приведены языки программирования, поддерживаемые обоими.
- Apache24: HTML, CSS, JavaScript, PHP, Perl, Python и другие.
- Apache Tomcat: Java, JavaScript, JSP, dll.

Необходимость выбора между Apache и Apache Tomcat может зависеть от языка, используемого на сайте. Если на сайте используются только простые HTML, CSS и JavaScript, вы можете выбрать Apache. Если на сайте используются такие языки программирования, как Java и JSP, то Apache Tomcat будет лучшим выбором.

В этой статье мы попробуем установить, настроить и запустить Apache Tomcat на сервере FreeBSD 13.2.

## 5. Установка Tomcat
Поскольку Apache Tomcat использует язык программирования Java, основным требованием для установки Apache Tomcat на сервер FreeBSD является правильная установка приложения Java.

Для выполнения процесса установки Tomcat в этой статье мы будем использовать систему портов FreeBSD. С помощью системы портов все зависимости Tomcat могут быть установлены полностью. Ниже приведены команды, которые можно ввести для установки Tomcat.

```
root@ns1:~ # find /usr/ports/www/ -name tomcat\* -type d
/usr/ports/www/tomcat85
/usr/ports/www/tomcat9
/usr/ports/www/tomcat-native
/usr/ports/www/tomcat101
/usr/ports/www/tomcat-devel
```

Скрипт выше используется для поиска версии Tomct в системе портов FReeBSD. Этот скрипт будет очень полезен, если мы не знаем последнюю версию приложения. Из результатов скрипта, показанного выше, мы установим "tomcat9".

```
root@ns1:~ # cd /usr/ports/www/tomcat9
root@ns1:/usr/ports/www/tomcat9 # make config
root@ns1:/usr/ports/www/tomcat9 # make install clean
```

The commands from the script above are used to install Tomcat, wait until the installation is complete.

## 6. Конфигурация Tomcat
Следующий шаг после процесса установки — процесс настройки. Первый шаг настройки Tomcat — создание скрипта Boot Start UP rc.d. Введите следующую команду в файл /etc/rc.conf.

```
root@ns1:~ # ee /etc/rc.conf
tomcat9_enable="YES"
tomcat9_java_home="/usr/local/openjdk17"
tomcat9_catalina_user="www"
tomcat9_catalina_home="/usr/local/apache-tomcat-9.0"
tomcat_catalina_base="/usr/local/apache-tomcat-9.0/conf/server.xml"
tomcat_catalina_tmpdir="/usr/local/apache-tomcat-9.0/temp"
tomcat9_classpath=""
tomcat9_java_opts=""
tomcat9_wait="30"
tomcat9_umask="0077"
```

Теперь мы проверим, сможет ли Tomcat нормально работать на сервере FreeBSD. Введите следующий скрипт.

```
root@ns1:~ # service tomcat9 restart
Stopping tomcat9.
Waiting for PIDS: 3291.
Starting tomcat9.
```

Из результатов скрипта выше, если мы читаем, Tomcat успешно ЗАПУЩЕН на сервере FreeBSD, мы можем увидеть это из слов "Starting tomcat9". Тогда что еще нам нужно сделать после Tomcat RUNNING. Следующий шаг - это шаг, которого мы ждали, а именно запуск Tomcat.

## 7. Запуск Tomcat
Главный файл конфигурации или файл конфигурации Tomcat находится в папке /usr/local/apache-tomcat-9.0/conf. По умолчанию Tomcat работает на порту 8080 и IP-адресе 127.0.0.1. Поскольку IP-адрес loopback не может быть удаленным от компьютера Windows, мы заменим IP-адрес loopback 127.0.01 на частный IP-адрес нашего сервера FreeBSD, в этой статье частный IP-адрес FreeBSD — 192.168.5.2. Чтобы изменить IP-адрес, отредактируйте файл /usr/local/apache-tomcat-9.0/conf/server.xml.

По умолчанию IP-адрес 127.0.01 не записан в файле скрипта. Ниже приведен пример исходного скрипта до его редактирования.

```
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443"               
               maxParameterCount="1000"
               />
```

Теперь добавьте IP 192.168.5.2, и скрипт изменится следующим образом.

```
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443"
	       address="192.168.5.2"
               maxParameterCount="1000"
               />
```

В целях безопасности доступ к приложениям Tomcat Manager и Host Manager по умолчанию заблокирован для localhost (сервера, на котором они развернуты). Отредактируйте файл "/usr/local/apache-tomcat-9.0/conf/tomcat-users.xml".

```
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
<role rolename="manager-gui"/>
<user username="tomcat" password="router" roles="manager-gui"/>
<role rolename="manager-status"/>
<user username="robot" password="router" roles="manager-status"/>
<role rolename="admin-gui"/>
<user username="admin" password="router" roles="admin-gui"/>
</tomcat-users>
```

Для приложения Tomcat Manager введите следующий скрипт в файл «/usr/local/apache-tomcat-9.0/webapps/host-manager/META-INF/context.xml».

```
<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|192.168.5.2"
allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|192.168.5.*"
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
```

Для приложения Tomcat Manager введите следующий скрипт в файл «/usr/local/apache-tomcat-9.0/webapps/manager/META-INF/context.xml».

```
<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|192.168.5.2"
allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|192.168.5.*" 
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
```

Следующий шаг — перезапуск Tomcat.

```
root@ns1:~ # service tomcat9 restart
Stopping tomcat9.
Waiting for PIDS: 3291.
Starting tomcat9.
```

Пришло время запустить Tomcat, поскольку Tomcat — это веб-сервер, для запуска Tomcat мы открываем Google Chrome, Yandex или другой браузер. В меню адресной строки введите IP выше, а именно «http://192.168.5.2:8080». Если с конфигурацией выше все в порядке, панель инструментов Tomcat появится в вашем веб-браузере.

![dashboard apache tomcat9](https://www.opencode.net/unixbsdshell/balena-etcher-portable-173/-/raw/main/dashboard_apache_tomcat9.jpg)

Apache Tomcat — мощный, универсальный и надежный веб-сервер, доказавший свою ценность в мире веб-хостинга. Его совместимость с приложениями Java, расширенные функции и активное сообщество делают его выбором номер один для многих пользователей открытого исходного кода и веб-разработчиков. От малого бизнеса до крупных предприятий Apache Tomcat пользуется доверием, поскольку обеспечивает высокую производительность, безопасность и высокую масштабируемость.
