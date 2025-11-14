---
title: FreeBSD Guide To Packing and Unpacking WinZip WinRAR tar gz gzip tgz bzip2 xz
date: "2025-10-02 08:07:10 +0100"
updated: "2025-10-02 08:07:10 +0100"
id: freebsd-packing-unpacking-winzip-winrar-tar-gz-gzip-tgz-bzip2-xz
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/oct-25/oct-25-53.jpg
toc: true
comments: true
published: true
excerpt: Zip, tar, rar is one of the software designed to help you archive and unarchive files efficiently, these utilities are very easy to use. You will be able to get your work done with a few command lines
keywords: freebsd, packing, unpacking, winzip, winrar, tar, gz, gzip, tgz, bzip2, xz
---

When using or working with a computer, you often find files in the format .tar .gz .zip or .rar. Files with this format are often called packed or compressed files. Its function is to store many files or folders in one file and compress them so that they are easier to send and require less drive space because the size is smaller than the original file.

Or if you work as a system administrator and have to manage lots of large and small files, you must feel how difficult and annoying the job is. Not only do you have to organize them based on Hard Disk space availability, but you also have to spend a lot of time uploading them to the Internet when you want to send them via SSH, Samba or FTP. You should save time by using packaging software that will keep your files compressed and ready to use at all times.

Zip, tar, rar is one of the software designed to help you archive and unarchive files efficiently, these utilities are very easy to use. You will be able to get your work done with a few command lines. Not only that, this utility is able to move all large files into a compressed folder which has a size smaller than the total size of each file.

The FreeBSD operating system has a built-in function for packing and unpacking these files. If you use a FreeBSD Desktop such as GhostBSD or NomadBSD, it becomes easier to use. But it will be more difficult if you use the shell command. Even though it has a different way of operating, this utility plays a role in making the work of a system administrator easier who every day deals with a large number of files.

In this article, we will explain how to pack and unpack rar zip tar gz gzip tgz bzip2 xz files using the FreeBSD server. So it's clear enough, you will be dealing a lot with shell commands.


## 1. Install the Pack and Unpack Application

Before you use this utility, there are several applications that must be installed on the FreeBSD server. There are lots of pack and unpack applications. In this article we will use applications that correspond to file extensions that are commonly used by many people. The first application you have to install is `zip`.

```
root@ns3:~ # cd /usr/ports/archivers/zip
root@ns3:/usr/ports/archivers/zip # make install clean

root@ns3:/usr/ports/archivers/zip # cd /usr/ports/archivers/unzip
root@ns3:/usr/ports/archivers/unzip # make install clean
```

After that you install rar and unrar, if you usually use Windows this application is called Winrar. Run the command below to install `Winrar`.

```
root@ns3:/usr/ports/archivers/unzip # pkg install rar unrar
```

After that you install `bzip3`.

```
root@ns3:/usr/ports/archivers/unzip # pkg install bzip3
```

You don't need to install all the applications above, use them according to the file type. If you are working with zip files or Winzip install zip and unzip. If you usually use rar files, install rar and unrar. Actually, FreeBSD has a default application that you don't have to install, namely `tar`.


## 2. How to use Winzip on FreeBSD

To make the learning process easier, we will create a new folder in `/var` called `"ExercisePackUnpack"`. In this folder we will place zip, rar and other files.

```
root@ns3:~ # mkdir /var/ExercisePackUnpack
root@ns3:~ # cd /var/ExercisePackUnpack
root@ns3:/var/ExercisePackUnpack #
```

After you have finished creating the `/var/ExercisePackUnpack` folder, download the file with the zip extension. Use the fetch command to download the zip file.

```
root@ns3:/var/ExercisePackUnpack # fetch https://github.com/github/codeql/archive/refs/tags/codeql-cli/v2.12.0.zip
root@ns3:/var/ExercisePackUnpack # ls
v2.12.0.zip
```

Run the unzip command, to extract the v2.12.0.zip file. We will place the extracted file in the `"/var/ExercisePackUnpack/resultZIP"` folder.

```
root@ns3:/var/ExercisePackUnpack # mkdir resultZIP
root@ns3:/var/ExercisePackUnpack # unzip v2.12.0.zip -d /var/ExercisePackUnpack/resultZIP
```

See the extract results.

```
root@ns3:/var/ExercisePackUnpack # cd resultZIP
root@ns3:/var/ExercisePackUnpack/resultZIP # ls
codeql-codeql-cli-v2.12.0
```

Now we will try to pack or compress files/folders. Packing or compressing files or folders into one compact zip file package. When you compress files, the original files will remain in their original location, so you can safely pack them without worrying about losing them or reducing the file size. Run the zip command to pack or compress files.

In this example, the folder that we will pack or compress is called `"codeql-codeql-cli-v2.12.0"`, this folder contains many types of files with a total folder size of around `52,054 KB`.


```
root@ns3:/var/ExercisePackUnpack/resultZIP # zip -r ResultCompress.zip *
```

View the results with the ls command.

```
root@ns3:/var/ExercisePackUnpack/resultZIP # ls
ResultCompress.zip              codeql-codeql-cli-v2.12.0
```


## 3. How to use WinRAR on FreeBSD

WinRAR or RAR files, with the acronym RAR which stands for Roshal Archive, is very famous for compressing and archiving files or folders. Currently RAR files are widely used to store and share large numbers of files efficiently and effectively.

There are many reasons people use RAR files:

1. Supports splitting large files into small files without reducing the number and quality of files
2. Facilitates archive comments and customizable compression settings
3. Using lossless data compression techniques

To start learning about RAR files, you have to download the RAR file that we will practice in this article. We will place the downloaded files in the `/var/ExercisePackUnpack/resultRAR` folder. Use the fetch command to start downloading the RAR file.

```
root@ns3:~ # cd /var/ExercisePackUnpack
root@ns3:/var/ExercisePackUnpack # mkdir -p resultRAR
root@ns3:/var/ExercisePackUnpack # cd resultRAR
root@ns3:/var/ExercisePackUnpack/resultRAR # fetch https://www.rarlab.com/themes/WinRAR_Orbital_32x32.theme.rar
```

After you have finished downloading the `WinRAR_Orbital_32x32.theme.rar` file, now we will extract the file with the unrar command.

```
root@ns3:/var/ExercisePackUnpack/resultRAR # unrar e WinRAR_Orbital_32x32.theme.rar RARresults/

UNRAR 6.24 freeware      Copyright (c) 1993-2023 Alexander Roshal


Extracting from WinRAR_Orbital_32x32.theme.rar

Creating    RARresults                                                OK
Extracting  RARresults/winrar_theme_description.txt                   OK
Extracting  RARresults/AboutLogo.bmp                                  OK
Extracting  RARresults/Add.bmp                                        OK
Extracting  RARresults/Benchmark.bmp                                  OK
Extracting  RARresults/Comment.bmp                                    OK
Extracting  RARresults/Convert.bmp                                    OK
Extracting  RARresults/Delete.bmp                                     OK
Extracting  RARresults/Estimate.bmp                                   OK
Extracting  RARresults/Exit.bmp                                       OK
Extracting  RARresults/Extract.bmp                                    OK
Extracting  RARresults/ExtractTo.bmp                                  OK
Extracting  RARresults/Find.bmp                                       OK
Extracting  RARresults/FolderUp.bmp                                   OK
Extracting  RARresults/Info.bmp                                       OK
Extracting  RARresults/Lock.bmp                                       OK
Extracting  RARresults/Print.bmp                                      OK
Extracting  RARresults/Protect.bmp                                    OK
Extracting  RARresults/RarSmall.bmp                                   OK
Extracting  RARresults/Repair.bmp                                     OK
Extracting  RARresults/Report.bmp                                     OK
Extracting  RARresults/SFX.bmp                                        OK
Extracting  RARresults/SFXLogo.bmp                                    OK
Extracting  RARresults/SortDown.bmp                                   OK
Extracting  RARresults/SortUp.bmp                                     OK
Extracting  RARresults/Test.bmp                                       OK
Extracting  RARresults/View.bmp                                       OK
Extracting  RARresults/VirusScan.bmp                                  OK
Extracting  RARresults/Wizard.bmp                                     OK
Extracting  RARresults/WizardLogo.bmp                                 OK
Extracting  RARresults/DragCopy.cur                                   OK
Extracting  RARresults/DiskOff.ico                                    OK
Extracting  RARresults/DiskOn.ico                                     OK
Extracting  RARresults/File.ico                                       OK
Extracting  RARresults/PasswordOff.ico                                OK
Extracting  RARresults/PasswordOn.ico                                 OK
Extracting  RARresults/RAR.ICO                                        OK
Extracting  RARresults/REV.ico                                        OK
Extracting  RARresults/Setup.ico                                      OK
Extracting  RARresults/SFX.ico                                        OK
Extracting  RARresults/Tray.ico                                       OK
All OK
```

The unrar command above will extract the `WinRAR_Orbital_32x32.theme.rar` file and place the extracted file in a new folder called `"RARresults"`. Please open the new folder and see the results using the ls command.

```
root@ns3:/var/ExercisePackUnpack/resultRAR # cd RARresults
root@ns3:/var/ExercisePackUnpack/resultRAR/RARresults # ls
AboutLogo.bmp                   DragCopy.cur                    Info.bmp                        RarSmall.bmp                    SortUp.bmp
Add.bmp                         Estimate.bmp                    Lock.bmp                        Repair.bmp                      Test.bmp
Benchmark.bmp                   Exit.bmp                        PasswordOff.ico                 Report.bmp                      Tray.ico
Comment.bmp                     Extract.bmp                     PasswordOn.ico                  SFX.bmp                         View.bmp
Convert.bmp                     ExtractTo.bmp                   Print.bmp                       SFX.ico                         VirusScan.bmp
Delete.bmp                      File.ico                        Protect.bmp                     SFXLogo.bmp                     Wizard.bmp
DiskOff.ico                     Find.bmp                        RAR.ICO                         Setup.ico                       WizardLogo.bmp
DiskOn.ico                      FolderUp.bmp                    REV.ico                         SortDown.bmp                    winrar_theme_description.txt
```

After that, you pack or compress the extracted files with the rar command. Our compressed file is named `"Compress_RAR.rar"`.


```
root@ns3:/var/ExercisePackUnpack/resultRAR # rar a Compress_RAR.rar RARresults/
```

View the results with the ls command.

```
root@ns3:/var/ExercisePackUnpack/resultRAR # ls
Compress_RAR.rar                RARresults                      WinRAR_Orbital_32x32.theme.rar
```


## 4. How to use TAR Command

On FreeBSD systems, the TAR command is used to combine several files into one file. Almost the same as the rar, zip commands. The tar command is an abbreviation for `“tape archiving”`, which means storing one or more files onto magnetic tape. As usual, before we learn the TAR command, we download the TAR file as practice material.

```
root@ns3:~ # cd /var/ExercisePackUnpack
root@ns3:/var/ExercisePackUnpack # mkdir -p resultTAR
root@ns3:/var/ExercisePackUnpack # cd resultTAR
root@ns3:/var/ExercisePackUnpack/resultTAR # fetch http://www.rarlab.com/rar/rarlinux-x64-5.3.0.tar.gz
rarlinux-x64-5.3.0.tar.gz                             1122 kB  632 kBps    02s
```

After you have finished downloading the rarlinux-x64-5.3.0.tar.gz file, extract the file with the tar command.

```
root@ns3:/var/ExercisePackUnpack/resultTAR # tar -xzvf rarlinux-x64-5.3.0.tar.gz
```

The following is an explanation of the options on TAR:
- x : *Extract to disk from archive.*
- v : *Produce verbose output.*
- f  : *file Read archives from or write archives to the specified file.*
- z --gunzip,  : *--gzip Compress the resulting archive with gzip.*
- c  : *Create a new archive containing the specified items.*
- j  : *Compress the resulting archive with bzip2.*

With the publication of this article, hopefully you will understand how to use WinZIP and WinRAR and also run the tar command on a FreeBSD server. Packing and compressing files using WinRAR and WinZip is an easy process whether you use the desktop interface or the command line.