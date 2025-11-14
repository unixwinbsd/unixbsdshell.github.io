---
title: How to Use GIT Commands on FreeBSD
date: "2025-11-12 11:35:47 +0000"
updated: "2025-11-12 11:35:47 +0000"
id: how-to-use-git-commands-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://cdn-cdpl.sgp1.cdn.digitaloceanspaces.com/source/634a156d2b7858558437c2588d26eb2f/Untitled-1_4.jpg
toc: true
comments: true
published: true
excerpt: If you're familiar with FreeBSD, you've likely heard of git, or you might be wondering what exactly git is and how to use it.
keywords: git, github, use, sockstat, command, cmd, unix, bsd, freebsd, shell, script
---

If you're familiar with FreeBSD, you've likely heard of git, or you might be wondering what exactly git is and how to use it. Git is the brainchild of Linus Torvalds, who developed it as a source code management system while working on the Linux kernel.

Since then, Git has been adopted by many software projects and developers due to its track record of speed, efficiency, and ease of use. Git has also grown in popularity among writers of all types, as it can be used to track changes to any set of files, not just code.

In general, Git is a free and open-source distributed version control system tool designed to handle small to very large projects with maximum speed and efficiency. Git has steadily evolved from a preferred skill to a must-have skill for many job roles today. Today, Git has become an essential part of the daily application development process. In this tutorial, we'll briefly explain how to use the git command on a `FreeBSD 13.2` machine.

## 1. Installing Git on FreeBSD

Installing Git on a FreeBSD computer is very easy. The installation process can be done using the ports system, the pkg package, or directly from the Git repository on GitHub.

### a. Installing Git with the ports system

```yml
root@ns1:~ # cd /usr/ports/devel/git
root@ns1:/usr/ports/devel/git # make install clean BATCH="yes"
```

### b. Installing git with PKG package

```yml
root@ns1:~ # pkg update
root@ns1:~ # pkg upgrade
root@ns1:~ # pkg install git
```

## 2. How to Configure Git on FreeBSD

Once Git is installed on your FreeBSD system, let's proceed with configuring it. To use Git, we only need to perform basic configuration. The first thing you need to do is configure your email address and username in Git. It's important to note that this isn't used to log in to any services; Git is simply used to document the changes you'll make when recording commits.

The primary requirement for configuring your email address and username is that you already have a GitHub account. If you don't have one, create one now. This article won't explain how to create a GitHub account. You can read other articles that explain how to create a GitHub account.

Okay, now let's move on to configuring your email address and username in Git. In the example below, I already have a GitHub account with the user name: `mary1977` and the email address: `datainchi@gmail.com`. Type the script below to configure the user and email address.

```yml
root@ns1:~ # git config --global user.email "datainchi@gmail.com"
root@ns1:~ # git config --global user.name "mary1977"
```

To see your verified username and email, enter the following:

```console
root@ns1:~ # git config -l
user.email=datainchi@gmail.com
user.name=mary1977
```

## 3. Creating a New Project with Git

To create a new project with Git, the project must first be initialized using the following command:

```console
root@ns1:~ # git init templateblog
hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint: 
hint: 	git config --global init.defaultBranch <name>
hint: 
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint: 
hint: 	git branch -m <name>
Initialized empty Git repository in /root/templateblog/.git/
```

The script above will create a project named `"templateblog"` and save it in the root directory. You can change the directory, for example, you can place the new project in the `/usr/local/etc` folder.

Use the ls command to view the project created above.

```console
root@ns1:~ # ls -s
.gitconfig	    .local		.shrc		templateblog
.bash_history	.history	.login		.ssh
.cshrc		    .k5login	.profile	.wget-hsts
```

Take a look at the contents of the root folder above; a Git project has been created, containing a hidden .gitconfig file and a templateblog folder. When working with Git, it's recommended to make the newly created project folder your working directory.

Now, we'll create the helloworld.c file in the `templateblog` working directory.

```yml
root@ns1:~ # cd templateblog
root@ns1:~/templateblog # touch helloworld.c
root@ns1:~/templateblog # git add .
root@ns1:~/templateblog # git commit -m "First commit of project, just an empty file"
```

The script above will create a file called `helloworld.c`. After creating the helloworld.c file, insert the following script into the file.

```console
root@ns1:~/templateblog # ee helloworld.c
#include
int main(void)
{
    printf("Hello, World!\n");
    return 0;
}
```

Continue with the following script.

```yml
root@ns1:~/templateblog # git add helloworld.c
root@ns1:~/templateblog # git commit -m "added source code to helloworld.c"
```

## 4. Creating a Log File for GIT

Once a Git project is created, you can view the project's log file. Use the following script to view the project's log file.

```console
root@ns1:~/templateblog # git log
commit 5256dbb6f0ab83de90c8756a2fdceb1afc84243d (HEAD -> master)
Author: iwanse1977 <datainchi@gmail.com>
Date:   Tue Aug 1 14:37:49 2023 +0700

    First commit of project, just an empty file

commit b69becc771d9a48c6ab1dfeea4479ca7fa4f0d0c
Author: iwanse1977 <datainchi@gmail.com>
Date:   Tue Aug 1 14:37:08 2023 +0700

    First commit of project, just an empty file
```

From the script above, you can see that each commit is organized by its SHA-1 hash ID, the author's name and email address, the date, and a comment. We'll also notice that the most recent commit is referred to as HEAD in the output.

HEAD represents our current position in the Git project. Now let's look at the contents of the SHA-1 hash ID. Use the following script to open the contents of the SHA-1 hash ID.

```console
root@ns1:~/templateblog # git show 5256dbb6f0ab83de90c8756a2fdceb1afc84243d
commit 5256dbb6f0ab83de90c8756a2fdceb1afc84243d (HEAD -> master)
Author: iwanse1977 <datainchi@gmail.com>
Date:   Tue Aug 1 14:37:49 2023 +0700

    First commit of project, just an empty file

diff --git a/helloworld.c b/helloworld.c
index e69de29..32870e4 100644
--- a/helloworld.c
+++ b/helloworld.c
@@ -0,0 +1,6 @@
+#include 
+int main(void)
+{
+    printf("Hello, World!\n");
+    return 0;
+}
```

## 5. Using Git to Update FreeBSD Ports

The git command can also be used to update FreeBSD ports. You can download FreeBSD ports at https://cgit.freebsd.org/ports. Use the git command below to download and update FreeBSD ports.

```yml
root@ns1:~ # git clone -b release/13.2.0 --depth 1 https://git.FreeBSD.org/ports.git /usr/ports
```

Next, you run the `git pull, git branch and git config` commands.

```yml
root@ns1:~ # cd /usr/ports
root@ns1:/usr/ports # git pull && git branch --all
root@ns1:/usr/ports # git config --global --add safe.directory /usr/ports
```

In this tutorial, we won't cover how to update ports. To complete the port update process, you can read our previous article.

[How to Update FreeBSD Ports with Portsnap and GIT](https://unixwinbsd.site/freebsd/update-upgrade-ports-portsnap-freebsd/)

## 6. Examples of Using GIT Commands

Below, we'll provide some examples of basic Git commands.

### a. View git status

This command is used to display the modification status of existing files and the status of adding new files.

```console
root@ns1:~/templateblog # git status
On branch master
nothing to commit, working tree clean
```

### b. git remote

This command is used to connect your local repository to a remote server.

```yml
root@ns1:~/templateblog # git remote add origin https://github.com/git/git.git
```

### c. git push

This command is used to push changes made from the master branch to the remote repository.

```console
root@ns1:~/templateblog # git push origin master
Username for 'https://github.com': 
Password for 'https://iwanse1977@github.com': 
remote: Support for password authentication was removed on August 13, 2021.
remote: Please see https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls for information on currently recommended modes of authentication.
```

### d. git clone

This command is used to create a copy of a repository from an existing URL. So, if you want to copy a repository from a remote server to your local computer, use this command.

```console
root@ns1:~ # git clone https://github.com/git/git.git
Cloning into 'git'...
remote: Enumerating objects: 352259, done.
remote: Counting objects: 100% (924/924), done.
remote: Compressing objects: 100% (442/442), done. 
```

### e. git branch

This command lists all available branches in the repository.

```console
root@ns1:~/templateblog # git branch -a 
* master
```

### f. git checkout

Perintah ini digunakan untuk berpindah dari satu cabang ke cabang lainnya.

```console
root@ns1:~/templateblog # git checkout master
Already on 'master'
```

### g. git stash

This command is to temporarily save all modified tracked files.

```yml
root@ns1:~/templateblog # git stash save
```

### h. git revert

The git revert command is used to offer a safe way to revert changes in Git.

```yml
root@ns1:~/templateblog # git revert --continue
```

### i. git diff

The git diff command compares the changes made to files in the working directory with the changes made in the staging area. If you've updated a file on your computer but aren't sure what you've changed, use this command to highlight the changes in the file, as shown below.

```yml
root@ns1:~/templateblog # git diff helloworld.c
```

### j. git merge

This command merges the history of the specified branch into the current branch.

```yml
root@ns1:~/templateblog # git merge
```

### k. git rebase

The git rebase command applies changes from one branch to another.

```yml
root@ns1:~/templateblog # git rebase master
Current branch master is up to date.
```

Now you have a basic understanding of how to install, configure, and use Git to work with local repositories and remote servers. You can expand your Git knowledge by joining the growing Git community that leverages the power and efficiency of Git as a distributed revision control system.
