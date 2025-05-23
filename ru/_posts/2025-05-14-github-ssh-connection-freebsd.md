---
title: Создание соединения с Github по SSH во FreeBSD
date: "2025-05-14 11:05:19 +0100"
id: github-ssh-connection-freebsd
lang: ru
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "SysAdmin"
excerpt: Git - это бесплатный проект с открытым исходным кодом, поэтому многие крупные программные проекты используют Git для контроля версий
keywords: github, freebsd, ssh, connection, https, git, openssh
---

Система управления является наиболее важной частью компьютерного мира. С помощью системы управления любой пользователь может изменять, удалять или добавлять файлы на сервер. Учитывая важность этой системы, в 2005 году Линус Торвальдс, создатель ядра знаменитой операционной системы Linux, создал систему управления под названием "GIT".

Git - это бесплатный проект с открытым исходным кодом, поэтому многие крупные программные проекты полагаются на Git для контроля версий, включая коммерческие проекты с открытым исходным кодом. Разработчики, которые работали с Git, широко представлены в пуле доступных специалистов по разработке программного обеспечения и хорошо работают с различными операционными системами и IDE (интегрированными средами разработки).

Помимо бесплатного распространения, Git был разработан с учетом требований производительности, безопасности и гибкости.

**a. Гибкость**

Одной из целей разработки Git является гибкость. Git отличается высокой гибкостью во многих отношениях, особенно в поддержке различных типов нелинейных рабочих процессов разработки, а также в своей эффективности как в крупных, так и в малых и средних проектах. Надежность его совместимости поддерживается многими существующими системами и протоколами.

**b. Производительность**

По сравнению с другими подобными приложениями, основные характеристики производительности Git очень высоки. GIT может вносить изменения "на лету", создавать ответвления, объединять и сравнивать предыдущие версии, которые оптимизированы для повышения производительности. Алгоритмы, реализованные в Git, используют преимущества глубокого знания общих атрибутов фактического дерева файлов исходного кода, того, как они обычно изменяются с течением времени и каковы шаблоны доступа.
Производительность Git очень надежна, поскольку Git не будет обманут именами файлов при определении того, каким должно быть хранилище дерева файлов и история версий, вместо этого он фокусируется на содержимом самого файла. В конце концов, файлы с исходным кодом часто переименовываются, разделяются и переупорядочиваются. Формат файловых объектов репозитория Git использует комбинацию дельта-кодирования (сохранение различий в содержимом).

**c. Безопасность**

С момента своего создания Git разрабатывался с учетом целостности управляемого открытого исходного кода. Содержимое файлов, а также фактические взаимосвязи между файлами и каталогами, версиями, тегами и развертываниями - все объекты в этом репозитории Git защищены криптографически безопасным алгоритмом хэширования SHA1. Он защищает код и историю изменений от случайных и вредоносных изменений и гарантирует, что история полностью отслеживается.

## 1. Процесс установки Git
Прежде чем вы начнете загружать файлы с вашего локального компьютера на сервер GitHub, убедитесь, что GIT установлен на вашей FreeBSD. Ниже приведены команды, которые вы можете использовать для установки GIT на FreeBSD.

Есть два способа установить Git во FreeBSD:
- С помощью FreeBSD PKET PKG и
- Системные порты FreeBSD

Перед установкой Git убедитесь, что пакет PKG был обновлен.
```
root@ns7:~ # pkg update -f
root@ns7:~ # pkg upgrade -f
```

Выполните следующую команду для установки Git.
```
root@ns7:~ # pkg install git
```

Порты - это набор из более чем 20 000 сторонних программ, доступных бесплатно во FreeBSD. Процесс установки намного медленнее, поскольку он включает в себя сборку, то есть компиляцию пакетов из исходного кода.

Выполните следующие действия, чтобы установить Git во FreeBSD с использованием системы портов.

```
root@ns7:~ # cd /usr/ports/devel/git
root@ns7:/usr/ports/devel/git # make install clean
```

## 2. Включите ssh-кейген

Если вы хотите иметь приватный репозиторий на GitHub и хотите, чтобы другие пользователи могли его читать, нам нужен SSH-ключ для подключения к серверу Github. На самом деле существует множество способов подключения к серверу Github, SSH - самый удобный и простой способ.

Вы можете легко создать открытый SSH-ключ с помощью следующей команды.

```
root@ns7:~ # ssh-keygen -t ed25519 -C "datainchi@gmail.com"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/root/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_ed25519
Your public key has been saved in /root/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:sLvnhsWTo7EGWTUFkTgbhlOmLcBtxkTp109BUi+GojA datainchi@gmail.com
The key's randomart image is:
+--[ED25519 256]--+
| ..=o+o.+B+      |
|  ..O+= +o..     |
|  E+oo+*..o..    |
|   o.o++....     |
|    .+..S+       |
|    o ..* .      |
|     ..* o       |
|      =.o        |
|     ..+.        |
+----[SHA256]-----+
root@ns7:~ #
```

В приведенной выше команде файлы "id_ed25519 " и "id_ed25519.pub " хранятся в каталоге /root /.ssh.

```
root@ns7:~ # cd /root/.ssh
root@ns7:~/.ssh # ls
id_ed25519      known_hosts
id_ed25519.pub  known_hosts.old
```
Содержимое файла "id_ed25519.pub", который мы разместим в вашем аккаунте на Github.

## 3. Как добавить ключи SSH на Github

GitHub позволяет использовать ключи SSH для аутентификации. Убедитесь, что у вас есть учётная запись Github и вы вошли в систему. Вот как добавить ключи SSH на Github.
- Откройте сайт Github по адресу https://github.com.
- Нажмите на свой логотип в правом верхнем углу.
- Нажмите на меню «Настройки».
- В левой части нажмите «SSH и GPG ключи» со значком «ключ».

После этого следуйте инструкциям на изображении ниже.

![How to Insert SSH Keys into Github](https://gitflic.ru/project/iwanse1212/ispolzovanie-git-i-github-na-servere-freebsd/blob/raw?file=How%20to%20Insert%20SSH%20Keys%20into%20Github.jpg&commit=620f5526f1f99d1a63abf0aef3c6b3c2330026aa)
<br/>
![How to Insert SSH Keys into Github2](https://gitflic.ru/project/iwanse1212/ispolzovanie-git-i-github-na-servere-freebsd/blob/raw?file=How%20to%20Insert%20SSH%20Keys%20into%20Github2.jpg&commit=37ff218710150be52d81caf06c20b6cf5237381c)

## 4. Как загрузить репозиторий на Github
Теперь вы подключились к серверу Github через SSH-порт 22. Далее вы можете загрузить репозиторий с локального компьютера на сервер Github.

Следуйте приведенным ниже инструкциям, чтобы загрузить репозиторий на Github.

- Откройте сайт Github по адресу «https://github.com/».
- Выберите учётную запись Github, если у вас их несколько.
- Нажмите «Репозитории» вверху.
- Нажмите кнопку «Новый репозиторий».
- Следуйте инструкциям на картинке.

![How to Connect to github server with SSH key](https://gitflic.ru/project/iwanse1212/ispolzovanie-git-i-github-na-servere-freebsd/blob/raw?file=How%20to%20Connect%20to%20github%20server%20with%20SSH%20key.jpg&commit=0c883e9b71509f6d55942b2feabfd625b787801d)

Теперь у вас есть общедоступный репозиторий под названием "blogmetatag", который мы разместим в папке "/usr/local/etc/". На вашем локальном компьютере откройте Putty и перейдите в папку "/usr/local/etc/blogmetatag".

```
root@ns7:~ # cd /usr/local/etc/blogmetatag
root@ns7:/usr/local/etc/blogmetatag # ls
COMMIT_EDITMSG  FETCH_HEAD      HEAD            Image           config          description     index           packed-refs
root@ns7:/usr/local/etc/blogmetatag #
```

Мы начинаем с загрузки репозитория на сервер Github.

```
root@ns7:/usr/local/etc/blogmetatag # echo "# blogmetatag" >> README.md
root@ns7:/usr/local/etc/blogmetatag # git init
root@ns7:/usr/local/etc/blogmetatag # git add README.md
root@ns7:/usr/local/etc/blogmetatag # git commit -m "first commit"
root@ns7:/usr/local/etc/blogmetatag # git branch -M main
root@ns7:/usr/local/etc/blogmetatag # git remote add origin git@github.com:unixwinbsd/blogmetatag.git
root@ns7:/usr/local/etc/blogmetatag # git push -u origin main
Enter passphrase for key '/root/.ssh/id_ed25519': Enter the SSH password
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Writing objects: 100% (3/3), 225 bytes | 225.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To github.com:unixwinbsd/blogmetatag.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
root@ns7:/usr/local/etc/blogmetatag #
```

".gitignore " - это текстовый файл, в котором перечислены файлы и каталоги, которые необходимо исключить. Файл ".gitignore" не отслеживается и не загружается в репозиторий git. Вы можете использовать его, чтобы прекратить отслеживание некоторых скрытых файлов или исключить загрузку больших файлов. Github ограничивает размер файла, максимальный размер каждого файла составляет 100 МБ.
