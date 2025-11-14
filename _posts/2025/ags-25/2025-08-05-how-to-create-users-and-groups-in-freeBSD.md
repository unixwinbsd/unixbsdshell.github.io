---
title: How to Create Users and Groups in FreeBSD
date: "2025-08-05 07:45:55 +0100"
updated: "2025-08-05 07:45:55 +0100"
id: how-to-create-users-and-groups-in-freeBSD
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/oct-25/Logo.png
toc: true
comments: true
published: true
excerpt: FreeBSD, like other Unix-like operating systems, allows users to create accounts to access the system interactively. When properly managed, user accounts can provide a layer of system security by allowing users to access only the files and folders they need to complete their tasks.
keywords: user, group, create, permission, add, chmod, chown, freebsd
---

The FreeBSD system allows multiple users to use the machine simultaneously. While only one person can fully control the system, multiple users can log in to a FreeBSD machine over the network with assigned access rights. To access the system, each user must have a unique user account.

FreeBSD, like other Unix-like operating systems, allows users to create accounts to access the system interactively. When properly managed, user accounts can provide a layer of system security by allowing users to access only the files and folders they need to complete their tasks. Typically, a user has users and groups that belong exclusively to that person and are protected by unique passwords.

In FreeBSD, groups are essentially just a catalog of user accounts. Each group in FreeBSD has a group name and a GID, or Group ID, associated with it. Groups work in FreeBSD much like they do in other Unix operating systems, and each process has a list of groups associated with it. Given this list of groups, the User ID determines the actions a process is authorized to perform to make changes to the system.

## 1. How to Create a User in FreeBSD

To add a new user, you can use the adduser utility. This utility can be run interactively, with a prompt to gather information about the new user, or non-interactively, which is preferable for adding multiple users at once. When a new user is added, this utility automatically updates `/etc/passwd and /etc/group`. Using the adduser script will also create or format a folder.

The adduser utility is interactive and walks you through the steps to create a new user account. As seen in Adding a User in FreeBSD, enter the required information or press Return to accept the default values shown in square brackets. Here's an example of using the adduser script.

```console
root@router2:~ # adduser
Username: nasi
Full name: nasi uduk
Uid (Leave empty for default): enter
Login group [nasi]: enter
Login group is nasi. Invite nasi into other groups? []: enter
Login class [default]: enter
Shell (sh csh tcsh bash rbash git-shell nologin) [sh]: enter
Home directory [/home/nasi]: enter
Home directory permissions (Leave empty for default): enter
Use password-based authentication? [yes]: no
Lock out the account after creation? [no]: enter
Username   : nasi
Password   : <disabled>
Full Name  : nasi uduk
Uid        : 1004
Class      :
Groups     : nasi
Home       : /home/nasi
Home Mode  :
Shell      : /bin/sh
Locked     : no
OK? (yes/no): yes
adduser: INFO: Successfully added (nasi) to the user database.
Add another user? (yes/no): no
Goodbye!
root@router2:~ #
```

The example script above creates a user with the name nasi and is in the `/usr/home/nasi` folder.
Apart from the example above, another way to create a new user is with the "pw" script as in the following example.

```yml
root@router2:~ # pw add user -n mahameru
```

By using the script above, a new user will be created with the name `"mahameru"` and without creating or forming a folder. Now we try again with another script.

```yml
root@router2:~ # pw useradd -n bromo -s /bin/csh -m
```

The script above is used to create the bromo user and create a new folder in the home directory, `/usr/home/bromo`. So, the script is the same as the adduser script. Now let's try adding the bromo user to the wheel group.

```yml
root@router2:~ # pw usermod bromo -g wheel
```

We can run the script above, provided the bromo user has been created first. If the `bromo` user hasn't been created, the above command won't work.
Now, we'll create a user by placing its file structure in a dedicated directory. For example, we'll create the `Papandayan` user and place it in the `/usr/home/everest` folder.

```yml
root@router2:~ # pw useradd -m -n everest -d /usr/home/everest
```

After we have successfully created a user, now we will display the information of that user, use the following script to display the user information.

```yml
root@router2:~ # pw show user mahameru
```

## 2. How to Create a Group in FreeBSD

A group is a list of users. Groups are identified by their group name and GID. In `FreeBSD`, the kernel uses a process's UID and the list of groups the process belongs to to determine what the process is allowed to do. To create a group, we can use the "pw" script.

Below is an example of creating the `rinjani and argopuro` groups.

```yml
root@router2:~ # pw groupadd rinjani 
root@router2:~ # pw groupadd argopuro
```

Now let's create a Sindoro group and a Welirang user, then add the `Welirang` user to the `Sindoro` group. To execute these commands, we'll use a script.

```yml
root@router2:~ # pw groupadd sindoro -M welirang
```

Add the `Bromo` user back into the `Sindoro` group, so that the Sindoro group has 2 users, namely the Mahameru user and the Bromo user.

```yml
root@router2:~ # pw groupmod sindoro -m bromo
```

Now let's look at the GID of the group we created above.

```yml
root@router2:~ # pw groupshow sindoro
sindoro:*:1011:
root@router2:~ # pw groupshow rinjani
rinjani:*:1009:
root@router2:~ # pw groupshow argopuro
argopuro:*:1010:
root@router2:~ #
```

To view the currently active users and their group memberships, use the `"id"` command.

```yml
root@router2:~ # id rinjani
```

## 3. How to Delete Users and Groups

Now that we know how to create users and groups, we'll delete them. First, we'll delete the user using the pw userdel or pw deluser command.

```yml
root@router2:~ # pw userdel mahamaeru
root@router2:~ # pw deluser bromo
```

The script above is used to delete the users mahameru and rinjani. How do I delete a group? Use pw groupdel to delete a group.

```yml
root@router2:~ # pw groupdel rinjani
root@router2:~ # pw groupdel argopuro
```

After practicing how to create users, groups, and delete them, it turns out to be very easy to implement on a FreeBSD computer. Once you've mastered the material above, you can immediately put it into practice by setting access restrictions on a FreeBSD server at your office, school, or home.