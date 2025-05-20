---
title: "Статья о FreeBSD : Создание пользовательской темы Drupal"
date: 2024-07-24 09:00:00+03:00
excerpt: "freebsd-guide-creating-custom-drupal-theme"
id: freebsd-guide-creating-custom-drupal-theme
lang: ru
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "WebServer"
keywords: drupal, freebsd, theme, custome, php, composer, tutorials
---
Надежность и гибкость Drupal помогут вам создавать темы очень высокой сложности. Система Drupal поможет вам найти множество способов решения возникающих проблем, но вам необходимо знать, как Drupal работает с темами, чтобы создать лучшую и наиболее адаптивную тему. Обладая знаниями, необходимыми для создания темы Drupal, вы можете минимизировать свой код и упростить последующее обслуживание.

Это не значит, что вам нужно изучать весь код Drupal только для того, чтобы создать тему для своего веб-сайта. Просто изучите соответствующий код Drupal, чтобы создать тему, или вы можете узнать все, что вам нужно, чтобы помочь вашему проекту Drupal. Однако, чтобы начать создавать тему Drupal, вам необходимо ознакомиться со следующими приложениями.

- HTML и CSS (основа для создания тем).
- PHP (большая часть кода Drupal написана с использованием PHP).
- JavaScript и jQuery (если тема, которую вы создаете, поддерживает Java script).
- Терминология Drupal.

В этой статье мы объясним, как создать тему для Drupal без необходимости обладать специальными знаниями, например, языка программирования PHP. Эта статья была написана с использованием FreeBSD server 13.2 и Drupal версии 10.2.3.

## 1. Создайте папки пользовательских тем
В Drupl есть основная тема, которая находится в пользовательской основной папке, вам также необходимо создать папку для пользовательской темы вашего веб-сайта. Эта папка будет содержать такую информацию, как название, описание и тип темы, которые можно просмотреть в файле .yml.

В Drupal 10 вы можете легко использовать HTML/CSS фреймворк и его возможности для разработки интерфейса веб-сайта Drupal. Благодаря новейшим функциям, которыми обладает Drupal 10, это облегчит вашу работу и сделает вашу тему очень привлекательной.

Вам важно знать, что в Drupal 10 папка themes находится в разделе core/theme. Все файлы тем Drupal 10 по умолчанию, такие как claro, olivero и другие темы, хранятся в этой папке. В этой папке темы есть подпапки для изображений, CSS, JS, шаблонов, src, конфигурации, изображений и других подпапок, необходимых для оформления вашей темы.

Большинство людей используют командную строку для создания пользовательских папок тем. Этот метод очень прост в использовании. Запустите приведенную ниже команду, чтобы создать новую пользовательскую папку темы.

```
root@ns3:~ # cd /usr/local/www/drupal10/core/themes
root@ns3:/usr/local/www/drupal10/core/themes # mkdir -p custom
root@ns3:/usr/local/www/drupal10/core/themes # cd custom
root@ns3:/usr/local/www/drupal10/core/themes/custom # mkdir freebsdtheme
root@ns3:/usr/local/www/drupal10/core/themes/custom # cd freebsdtheme
root@ns3:/usr/local/www/drupal10/core/themes/custom/freebsdtheme #
```

Все вышеперечисленные команды используются для создания пользовательской темы под названием "freebsdtheme". Теперь у нас есть новая папка для пользовательских тем, которую мы создадим сами.

## 2. Create a *.info.yml File

In the root folder of the FreeBSDTheme theme, create a main file with the extension "yml". This file is an important file in every Drupal theme. The name of this file must be the same as the theme folder named after the theme you created, namely FreeBSDTheme and also the info file. In our example, the theme yml file will be named "FreeBSDTheme.info.yml".

```
root@ns3:/usr/local/www/drupal10/core/themes/custom/FreeBSDTheme # touch FreeBSDTheme.info.yml.info.yml
```

Добавьте скрипт ниже в файл "[/usr/local/www/drupal10/core/themes/custom/freebsdtheme/freebsdtheme.info.yml](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/freebsdtheme.info.yml)".


После этого создайте другой файл с именем "FreeBSDTheme.библиотеки.yml". Введите приведенный ниже скрипт в файл "[/usr/local/www/drupal10/core/themes/custom/freebsdtheme/freebsdtheme.libraries.yml](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/freebsdtheme.libraries.yml)".


Чтобы заполнить 2 файла, указанные выше, мы создаем еще один файл с именем "freebsdtheme.theme". Введите приведенный ниже скрипт в файл "[/usr/local/www/drupal10/core/themes/custom/freebsdtheme/freebsdtheme.theme](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/freebsdtheme.theme)".



## 3. Добавьте css и js

В этом разделе мы создадим файлы CSS и Java. Kia создает две папки, а именно CSS и JS.

```
root@ns3:/usr/local/www/drupal10/core/themes/custom/freebsdtheme # mkdir -p css js
```

В папке CSS мы создаем сразу 3 файла, а именно bootstrap.css, colors.css и style.css.

```
root@ns3:/usr/local/www/drupal10/core/themes/custom/freebsdtheme # cd css
root@ns3:/usr/local/www/drupal10/core/themes/custom/freebsdtheme/css # touch bootstrap.css colors.css style.css
```

Ниже приведен скрипт для этой последней версии.


[/usr/local/www/drupal10/core/themes/custom/freebsdtheme/css/bootstrap.css](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/bootstrap.css)

[/usr/local/www/drupal10/core/themes/custom/freebsdtheme/css/style.css](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/style.css.)

[/usr/local/www/drupal10/core/themes/custom/freebsdtheme/global.js](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/global.js)

## 4. Создайте папку с шаблонами

Чтобы применить макет ко всем страницам вашего веб-сайта Drupal, используя пользовательскую тему, которую вы создали выше, создайте файл page-front.twig.html находится в каталоге / usr/local/www/drupal10/core/themes/custom/freebsdtheme / templates.

```
root@ns3:/usr/local/www/drupal10/core/themes/custom/freebsdtheme # mkdir -p templates
root@ns3:/usr/local/www/drupal10/core/themes/custom/freebsdtheme # cd templates
root@ns3:/usr/local/www/drupal10/core/themes/custom/freebsdtheme/templates # touch page--front.twig.html
```

После этого в файле "/usr/local/www/drupal10/core/themes/custom/freebsdtheme/templates/page--front.twig.html" добавьте скрипт ниже.

[**/usr/local/www/drupal10/core/themes/custom/ freebsdtheme/templates/page--front.twig.html**](https://www.opencode.net/unixbsdshell/building-a-drupal-web-server-with-freebsd/-/raw/main/page--front.twig.html)

## 5. Протестируйте и перепроверьте скрипт
Прежде чем тестировать пользовательскую тему Drupal, которую вы создали выше, ознакомьтесь с остальной частью скрипта. Если не будет обнаружено никаких ошибок или пропусков, мы проведем тест. В веб-браузере Google Chrome введите "http://192.168.5.2/drupal/".

Если с приведенным выше скриптом все в порядке, то созданная вами тема появится на экране вашего монитора.

Creating a custom theme in Drupal is a tough job, but the results will give you extra motivation to continue developing the theme. The appearance of the theme you created yourself is not owned by anyone else, but is only displayed on your Drupal website. The guide in this article only helps you to start creating your own Drupal theme. You can read other articles to increase your knowledge about Drupal.
