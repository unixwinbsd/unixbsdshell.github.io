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





Menggunakan Perintah Chown di FreeBSD - Mengubah Kepemilikan File Secara Rekursif
