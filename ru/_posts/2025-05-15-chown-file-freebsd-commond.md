---
title: Использование команды Chown во FreeBSD - рекурсивное изменение владельца файла
date: "2025-05-14 08:09:19 +0100"
id: chown-file-freebsd-commond
lang: ru
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "SysAdmin"
excerpt: Команда chown используется для изменения владельца файла и информации о группе
keywords: chown, freebsd, chmod, commond, ownership, recursively, user, root, chmod
---
Управление правами собственности на файлы и каталоги очень важно при работе с операционной системой FreeBSD. Правильное использование команды chown может помешать нежелательным пользователям вносить изменения в ваши файлы и защитить их от безответственных посторонних.

Команда chown используется для изменения владельца файла и информации о группе. Мы запускаем команду chmod, чтобы изменить права доступа к файлам, такие как чтение, запись и доступ. Если вы используете систему FreeBSD, то могут возникнуть ситуации, когда вам захочется изменить владельца файла или каталога и информацию, связанную с группой, и основной командой для выполнения этой задачи является chown. Поэтому Chown часто называют "Владельцем файла".

Как мы знаем, системы на базе UNIX, такие как FreeBSD, способны одновременно обслуживать большое количество пользователей и групп. Каждый из различных пользователей и групп в операционной системе FreeBSD обладает правами собственности и разрешениями для обеспечения безопасности файлов и ограничения круга лиц, которые могут изменять содержимое этих файлов.

В операционной системе FreeBSD существует множество пользователей и групп, которые используют систему одновременно. Мы можем классифицировать каждого пользователя и группу пользователей системы по их правам и обязанностям, включая:

- Root User: часто называемый суперпользователем, это человек, который имеет доступ ко всем каталогам и файлам в операционной системе и может выполнять все операционные команды в системе. Важно отметить, что только пользователь root может изменять права доступа или права собственности на файлы, которые ему не принадлежат. Таким образом, пользователь root - это тот, кто имеет полный контроль над операционной системой.
- Regular User: обычный пользователь или гость имеет ограниченный доступ к файлам и каталогам и может изменять только те файлы, которые ему принадлежат. Для обычных пользователей права доступа к файлам в системе устанавливаются пользователем Root.

Вы можете ознакомиться с базовым сценарием для команды Chown в "Руководстве системного менеджера FreeBSD" следующим образом.

```
NAME
     chown – change file owner and group

SYNOPSIS
     chown [-fhvx] [-R [-H | -L | -P]] owner[:group] file ...
     chown [-fhvx] [-R [-H | -L | -P]] :group file ...

DESCRIPTION
     The chown utility changes the user ID and/or the group ID of the
     specified files.  Symbolic links named by arguments are silently left
     unchanged unless -h is used.

     The options are as follows:

     -H      If the -R option is specified, symbolic links on the command line are followed and hence unaffected by the command.  (Symbolic links encountered during traversal are not followed.)

     -L      If the -R option is specified, all symbolic links are followed.

     -P      If the -R option is specified, no symbolic links are followed. This is the default.

     -R      Change the user ID and/or the group ID of the file hierarchies rooted in the files, instead of just the files themselves. Beware of unintentionally matching the “..” hard link to the parent directory when using wildcards like “.*”.

     -f      Do not report any failure to change file owner or group, nor modify the exit status to reflect such failures.

     -h      If the file is a symbolic link, change the user ID and/or the group ID of the link itself.

     -v      Cause chown to be verbose, showing files as the owner is modified.  If the -v flag is specified more than once, chown will print the filename, followed by the old and new numeric user/group ID.

     -x      File system mount points are not traversed.
```

Поскольку команда chown используется для изменения владельца файла и групп, мы можем просто написать сценарий команды Chown следующим образом.

```
chown owner-user namafile
chown owner-user:owner-group namafile
chown owner-user:owner-group namadirectory
chown options owner-user:owner-group namafile
```

Ниже приведен пример использования команды chown. В этом примере мы будем использовать файлы xmrig.JSON, обратите внимание на пользователя и группу владельцев файла.

```
root@ns1:~ # ls -l
-r--r-x---  1 root  wheel         0 Aug  4 09:23 xmrig.json
```

В примере с xmrig.json, приведенном выше, пользователь-владелец: root и группа-владелец: wheel. Теперь мы даем файлу команду chown. Но сначала мы создадим пользователя и группу до этого. В этом случае мы создадим пользователя: gunung и группу: semeru. Рассмотрим следующий пример создания пользователя и группы "gunung и semeru".

```
root@ns1:~ # pw add group semeru
root@ns1:~ # pw add user -n gunung -g semeru -s /sbin/nologin -c "gunung"
```

После того, как мы создадим пользователя и группу “gunung semeru", мы перейдем к предоставлению прав собственности на файл xmrig.json.

```
root@ns1:~ # chown gunung xmrig.json
```

Теперь давайте посмотрим на изменения,

```
root@ns1:~ # ls -l
-r--r-x---  1 gunung  wheel         0 Aug  4 09:23 xmrig.json
```

"owner-user" был изменен, и root становится "Mount". Затем, как изменить группу владельцев, вот пример того, как изменить группу владельцев.

```
root@ns1:~ # chown :semeru xmrig.json
root@ns1:~ # ls -l
-r--r-x---  1 gunung  semeru         0 Aug  4 09:23 xmrig.json
```

В приведенном выше скрипте "группа владельцев" была изменена с wheel на semeru, не правда ли, это просто. Теперь мы снова тренируемся, чтобы изменить владельца-пользователя и группу владельцев putty file.exe.

```
root@ns1:~ # ls -l
-rw-r--r--  1 root    wheel          0 Aug 11 07:28 putty.exe
```

Исходные файлы owner-user и owner-Group в putty files.exe до того, как была дана команда Chown. Теперь мы дадим команду Chown файлам owner-user и owner-Group. Вы увидите изменения.

```
root@ns1:~ # chown gunung:rinjani putty.exe
root@ns1:~ # ls -l
-rw-r--r--  1 gunung  rinjani   1647912 Feb 11 22:09 putty.exe
```

Владелец-пользователь и группа владельцев файлов putty.Исполняемый файл был изменен с root:wheel на Mount:rinjani. Теперь вы смогли понять, как использовать команду chown? Чтобы лучше понять это, мы применим на практике команду Chown в каталоге/папке. Обратите внимание на информацию из следующей папки с упражнениями.

```
root@ns1:~ # ls -l
drwxr-xr-x  5 root    wheel         10 Aug  3 21:51 folderlatihan
```

Теперь мы используем команду Chown,

```
root@ns1:~ # chown danau:ranukumbolo folderlatihan
root@ns1:~ # ls -l
drwxr-xr-x  2 danau   ranukumbolo         2 Aug 11 07:39 folderlatihan
```

В другом примере мы создадим новую папку с именем "learning folder" в каталоге /usr/local/etc.

```
root@ns1:/usr/local/etc # mkdir -p /usr/local/etc/folderbelajar
root@ns1:/usr/local/etc # ls -l
drwxr-xr-x   2  root     wheel       2 Aug 11 07:44 folderbelajar
```

Отправьте запрос в каталог "/usr/local/etc/learning".

```
root@ns1:/usr/local/etc # chown gunung:semeru /usr/local/etc/folderbelajar
root@ns1:/usr/local/etc # ls -l
drwxr-xr-x   2 gunung   semeru       2 Aug 11 07:44 folderbelajar
```

Чтобы было понятнее, я приведу еще один пример.

```
root@ns1:~ # chown -R www:www /usr/local/www/apache24
root@ns1:~ # ls -l /usr/local/www
drwxr-xr-x   6 www  www   6 Aug  1 20:15 apache24
```

Опция -R, указанная выше, приведет к рекурсивному изменению владельца каталога вместе с его содержимым.

Надеемся, что из приведенной выше статьи вы сможете понять команду chown и ее применение в системах FreeBSD. На что вам нужно обратить внимание, так это на написание заглавных и строчных букв, поскольку почти все команды, основанные на командной оболочке, чувствительны к заглавным и строчным буквам, и если вы неправильно напишете заглавные и строчные буквы, используемая вами команда не будет работать.
