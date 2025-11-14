---
title: How to Use the ls Command in FreeBSD with Examples
date: "2025-02-26 07:55:45 +0100"
updated: "2025-02-26 07:55:45 +0100"
id: how-to-use-ls-command-freebsd-example
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: In FreeBSD, the ls command is one of the most commonly used commands. This command is used to list the files and subdirectories in the current directory
keywords: ls, command, shell, freebsd, example, kernel
---

In FreeBSD, the "ls" command is one of the most commonly used commands. This command is used to list the files and subdirectories in the current directory. If you are new to the command line, the first command you should learn is probably ls. This command can be used by both regular users and system administrators.

The ability to see what files are in a directory is what makes ls so important. This command will be used most often to list the contents of a directory. While this is not a complicated command, it comes with a number of options to list files along with additional information. While ls is always sufficient for listing contents, you may find some of these options very useful.

## 1. "ls:" Command Options in FreeBSD
The ls command in FreeBSD, has the following basic syntax:

```
ls [ Options ] [File]
```
Following are some frequently used options in the FreeBSD ls command:

|  Option      | Description    |
|  ----------- | -----------     |
| ls -a        | list all files including hidden files starting with '.'. |
| ls -d         | View directory listings - with ' */'. |
| ls -l         | long format list - show permissions. |
| ls -F | Add an indicator (one of */=>@) to the entry. |
| ls -lh | This command will show the file size in human readable format. |
| ls -r | list in reverse order. |
| ls -i | list of inode(index) numbers of files. |
| ls -ltr | View Reverse Output Order by Date. |
| ls -t | Sort by time & date. |
| ls -n | Used to print group ID and owner ID, not their names. |
| ls -m | The list of entries separated by commas must fill the width. |
| ls -g | This allows you to exclude the owner and group information columns. |
| ls -q | Force printing of non-graphic characters in filenames as `?'; characters. ls -Q Place double quotes around entry names. |

## 2. Basic example of ls command in FreeBSD
Here, we will see a basic example of the ls command in a FreeBSD environment along with all the available options.

### 2.1. The 'ls' command is used to list files and directories.
The contents of your current working directory, which is a technical way of saying the directory your terminal is currently in, will be listed if you run the "ls" command without any further options.


```
root@ns4:/usr/local/etc # ls
```
### 2.2. Show hidden files and directories
Use the -a option of the ls command to display hidden files and directories in the current directory.

```
root@ns4:/usr/local/etc # ls -a
```
Files starting with a dot are hidden (.). The current directory (.) and parent directory (..) can be seen with the command "ls -a".

### 2.3. Display complete information about the file
The "ls -l" option displays the contents of the current directory in a long listing format, one per line. The line begins with the file or directory permissions, owner and group names, file size, creation/modification date and time, file/folder name as some attributes.

```
root@ns4:/usr/local/etc # ls -l
```

### 2.4. Display Classify files with special characters
The ls command categorizes files using the -F parameter. This indicates, Directories that end with a slash (/), Executable files with an asterisk (*), Symbolic links with a trailing rate symbol (@), FIFOs with a trailing vertical bar (|), and Regular files that contain nothing.

```
root@ns4:/usr/local/etc # ls -F
```

### 2.5. Displaying File Index Number
For internal purposes, you may need to know the index number of a file. To display the index number, use the "ls -i" option. You can delete files with special characters in their names by using the index number.

```
root@ns4:/usr/local/etc # ls -i
```

### 2.6. View the last edited files
The last modified file will be displayed first because files are sorted by modification time. Use the ls and head commands together to access the last edited file in the current directory.

```
root@ns4:~ # ls -t
root@ns4:~ # ls -t | head -1
```

### 2.7. Displaying File Size in Human Readable Format
Another frequently used ls option is -h or -human-readable and -h should be used with -l and -s to print sizes such as 1K 234M 2G, etc. This will display the file sizes in human readable format, not bytes.

```
root@ns4:~ # ls -lh
total 113258
drwxr-xr-x  3 root wheel    3B Mar  9 01:29 .bundle
drwxr-xr-x  6 root wheel    6B Mar 26 13:01 .cache
drwxr-xr-x  3 root wheel    3B Mar 26 13:23 .config
-rw-r--r--  2 root wheel  1.1K Apr 13 12:41 .cshrc
-rw-r--r--  1 root wheel  114B Apr 17 21:14 .gitconfig
drwxr-xr-x  3 root wheel    3B Apr 12 19:10 .ipython
-rw-r--r--  1 root wheel   66B Sep 12  2024 .k5login
drwxr-xr-x  4 root wheel    4B Mar 14 00:34 .local
-rw-r--r--  1 root wheel  316B Sep 12  2024 .login
drwxr-xr-x  3 root wheel    3B Apr 15 13:11 .m2
drwxr-xr-x  3 root wheel    3B Apr 13 09:14 .mono
drwxr-xr-x  4 root wheel    5B Mar 20 22:10 .npm
-rw-r--r--  2 root wheel  592B Mar 26 16:44 .profile
-rw-------  1 root wheel    0B Mar 23 12:49 .sh_history
-rw-r--r--  1 root wheel  1.1K Sep 12  2024 .shrc
drwx------  2 root wheel    6B Mar  9 23:32 .ssh
drwxr-xr-x  3 root wheel    3B Mar 26 13:00 go
drwxr-xr-x  5 root wheel    9B Apr 19 20:58 latihan
-rw-------  1 root wheel  214M Apr 12 11:21 ldconfig.core
```
If you use ls -lh, all information about the file or directory name will be displayed, whereas if you use ls -sh, only the size and name of the file or directory will be displayed.

```
root@ns4:~ # ls -sh
total 113258
     1 .bundle               5 .gitconfig            5 .login                5 .profile              1 go
     1 .cache                1 .ipython              1 .m2                   1 .sh_history           9 latihan
     1 .config               1 .k5login              1 .mono                 5 .shrc            113213 ldconfig.core
     5 .cshrc                1 .local                1 .npm                  9 .ssh
```

### 2.8. Displaying Reverse Output Order Based on Date
In the above command, the l argument is used for long listing format, the t argument sorts all files and directories by modification time and lists the newest ones first, and the r argument is used to reverse the sort order.

```
root@ns4:~ # ls -ltr
```
As a result, the ls -ltr command lists all directories and file names sorted by modified date in reverse order.

### 2.9. List all files and directories in reverse order
The "ls -r" option lists all files and directories in reverse order. All files and directories are arranged in reverse alphabetical order.

```
root@ns4:~ # ls -r
```

### 2.10. Displaying UID and GID List of files and directories
The "ls -n" command displays the UID (User ID) and GID (Group ID) of each file and directory, one per line. The common user and group (UID and GID) have 1000, but the root UID and GID have zero.

```
root@ns4:~ # ls -n
```

### 2.11. Listing files and directories separated by commas
The "ls -m" command displays all files and directories separated by commas.

```
root@ns4:~ # ls -m
```

### 2.12. List all files and directories without owner details
The "ls -g" option is similar to the "ls -l" option, but the '-g' option skips the file and directory owner details.

```
root@ns4:~ # ls -g
```

### 2.13. Display Subdirectories without other files
This "ls -d */" command can be used to display only subdirectories and hide all other files.


```
root@ns4:~ # ls -d */
```

### 2.14. Displaying the ls command Help page
By using this "ls --help" you can see the guide for the ls command. This command has many more options. Some of them are given below for reference.

```
root@ns4:~ # man ls
```
In this article, some options for the ls command are listed above along with examples. This is one of the simplest commands in FreeBSD. Even if you are familiar with this command, you may not be familiar with all the conditions it specifies.
