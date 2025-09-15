---
title: UNIX BSD boot system and initialization
date: "2025-02-10 12:21:10 +0100"
id: unix-bsd-system-boot-initialization
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "UnixShell"
excerpt: The system startup process is divided into two stages, which are only indirectly connected with each other
keywords: unix, bsd, system, boot, initialization, freebsd, startup, rc.d
---

In this article, the boot and initialization process of a BSD system will be discussed sequentially - from the machine being turned on to the command line prompt. Similar to how this was done for Linux in Greg O'Keefe's famous manuscript, From PowerUp To Bash - the idea of ??which this work is based on.

This discussion is based on the DragonFlyBSD example, but almost everything described is also applicable to FreeBSD, and probably other BSD systems as well.<br><br/>
## 1. What is  system startup
The system startup process is divided into two stages, which are only indirectly connected with each other - its loading and initialization itself.

By loading the operating system, we mean launching a special program called the system kernel image (or kernel) for execution. The kernel image is almost an ordinary executable binary file. And the specificity of its launch is only that if any other program is launched under the control of a particular OS, which reads from the file system that is considered native by this OS, then the kernel must be launched as if by itself, without any operating system (since the kernel is the operating system), and from a medium unknown to the system (since the kernel itself has not yet been loaded). It is no coincidence that in the English-language literature there is a generally accepted metaphor for the boot process called bootstrapping, which can be allegorically translated as "pulling yourself up by the bootstraps." And although in real life not everyone succeeds in this, in the world of POSIX systems this procedure is performed regularly - and, as a rule, successfully.

The system kernel image contains everything necessary for pure bootstrapping. However, this can only be done in this way from media without a file system. Therefore, as far as I know, direct kernel startup is used only when booting from a diskette. During normal OS startup from a hard drive, some external forces also participate in this - a special program called the bootloader. It loads the system kernel, is responsible for determining the hardware, loads object modules (loadable kernel modules) and mounts the root file system (in "read-only" mode). In the meantime, the kernel starts system processes (i.e., not associated with executable files) that manage virtual memory, buffers, memory pages, etc., up to the swapper, and after their completion - the first "normal" (i.e., associated with executable files on the disk) init process (/sbin/init).

After that, the initialization system comes into play. Its role is to ensure, through the appropriate startup scripts (also known as initialization scripts), mounting the file system (and remounting root in "read/write" mode), launching the main system services, or daemons, calling the command to get a terminal (getty process) and user authorization (login). The end of the system startup is marked by an invitation to authorization.

Visually, the boot and initialization stages differ in one or another visual appearance of the displayed messages. In DragonFlyBSD, for example, boot progress messages are displayed in radical white characters, which are replaced by muted white characters at the initialization stage.

Loading and initialization are the first things a user sees in any OS. However, users of POSIX-compliant systems get this pleasure much less often than "windowsills". The normal operating mode of a home Unix machine is to turn it on in the morning and turn it off in the evening. (However, everyone has their own ideas about "morning" and "evening"). And a working Unix machine should not be turned off at all - until it is completely physically damaged. And the need to restart the system while working in Linux or BSD arises extremely rarely. Actually, only after rebuilding and reinstalling a new kernel (or moving the root partition - but this is already an exceptional case) - in all other cases of system reconfiguration, you can do without it.

So what do users care about about how the system boots and how long it takes? However, sometimes some actions are required to configure these two stages of the process. Because when the system boots, not only the boot screen and possibly a menu with boot options are displayed, but also the kernel modules corresponding to the available hardware are loaded, the file system is mounted, the initialization script is started, the virtual terminal is opened, and so on. Of course, of all these actions, only the actual loading of the kernel is absolutely necessary; everything else can be done later. However, wouldn't it be better to configure the system so that as soon as the boot procedure is finished, you get a completely ready-to-use system, rather than having to bring it to this state manually later?

Moreover, understanding the loading and initialization processes will not be superfluous when it comes to interrupting these processes manually. And the need for such intervention - unfortunately - arises from time to time in emergency situations...

So, let's go through the main stages of starting and initializing DragonFly and see what needs to be configured in it, as well as where and how (and most importantly, why) you can interfere with it.<br><br/>
## 2. Regarding booting and bootloader
It is a good idea to start studying system startup from the first stage, i.e. the actual loading. As already mentioned, these stages are controlled by a special program, which in Russian is called bootloader. Although in English two terms are used, namely loader and boot manager (which, as we will see over time, are slightly different things, but now this is not important).

In fact, each bootloader includes two or even three relatively independent parts, even if they are distributed as a single package, such as Lilo or GRUB. To verify this, let's imagine how a machine boots at the "hardware" level, so to speak (i.e. an Intel-compatible personal computer, on other architectures everything is a little different).

First of all, after turning on the power, the program flashed into the computer's ROM (BIOS) is launched. It checks the hardware, after which it finds the drive installed in the BIOS settings as the first boot device (to be more specific, the hard drive), inside it - the first physical block containing the so-called master boot record (MBR - Master Boot Record).

The content of the MBR is, first of all, the disk partition table - four identical partitions, one of which we once installed DragonFly on. And secondly, some code that takes control of the BIOS after its operation is complete. In a standard MBR, which is written to a “freshly installed” hard drive or recovered after the DOS FDISK /mbr command, this code can only find the first physical partition on the disk (the primary partition) and transfer control to its boot sector. Which is enough to boot an operating system like DOS or Windows 9X/ME from the first (or only) partition. But in other cases it is clearly not enough - for example, if several operating systems are installed on one disk, which, of course, cannot be contained in one partition.

Therefore, each bootloader must include a program written in the MBR. Since the volume of the latter is only 512 KB (physical disk block size), part of which is already occupied by the partition table, it is not possible to include very rich functions in this program. Typically, it is able to identify all the primary partitions used, lists them and allows the user to select a partition to boot from, after which it transfers control to the boot sector of the selected partition.

Like the MBR, the boot sector of a partition (Boot Record, no longer Master!) contains information about its layout (Disk Label), depending on the scheme used in a given operating system and the control code that replaces the programs written in the MBR. And this code is the second component of the bootloader. True, its capabilities cannot be rich either - after all, the size of the partition's boot sector is the same 512 KB. And because of this, it is assigned a single function: to transfer control to programs located outside the boot sector. Which, in fact, must recognize the root partition of the operating system and the file system it carries, after which, directly or indirectly, it loads its kernel.

It is easy to guess that the first two components of the bootloader, in essence, have nothing to do with any operating system and are not part of the file system at all. But with the third there are several options. It can be part of a hierarchy of bootable operating system files, like Lilo, or represent something like an independent mini-OS, like GRUB (it is no coincidence that it is strongly recommended to install it on its own disk partition, not mounted by default at the root of a booted operating system). And what about the boot device of our hero, DragonFlyBSD?.<br><br/>
## 3. Booting stages
In this operating system, programs common to all operating systems of the BSD family are used to boot the system. This program has its own name, and, interestingly, this name is BSD Loader (although, as will be explained later, this is somewhat arbitrary). I must admit that for several years of communication with FreeBSD and occasional acquaintance with its brothers (OpenBSD and even NetBSD), I somehow never had a reason to find out the structure of their bootloaders. Well, it loads native systems perfectly and wonderfully (for example, FreeBSD). It also loads other BSD systems, even better. The fact that it can load Linux without any effort is great. And the fact that it is also able to load Windows - it's just a free application......

How would I remain in blissful ignorance if, in some way, in connection with installing FreeBSD on a Toshiba laptop, I didn't have to dig a little with the BSD Loader option. And then it turns out that this is a program with great interactive capabilities, and in addition it has the possibility of being configured. Of course, it cannot be compared with GRUB, but if you are not experimenting with several operating systems on several hard drives, the loading function is more than enough. Which I will try to show below using the example of the DragonFlyBSD operating system. However, almost everything said applies to all other BSD systems (and to FreeBSD, and without reservation "almost").

The main feature of the DragonFly bootloader (although almost everything said applies to all other BSD systems, and to FreeBSD, without the "almost" clause), which differentiates it from Lilo and, to a lesser extent, from GRUB, is that it does not disguise its multiple components, including four (almost) independent programs.

The first part of the bootloader (which is called boot0) is a program written during system installation in the boot sector of the disk from which the machine is booted according to the BIOS settings. Usually this is the Master on the first IDE channel (we will not talk about SCSI disks here), but there may be variations (for example, if there is a hardware ATA RAID or an additional ATA controller). The program is responsible for the first stage of the boot phase, which reads the partition table of the primary disk, displays their list (if there is more than one partition), waits a while for the user to choose (by default, the partition selected in the previous session will be bootable) and after that (or after a fixed waiting period) transfers control to the code written in the boot sector of the selected (or default) partition. The partition is selected by pressing the F1 - F4 keys. If there are two disks, pressing the F5 key will transfer control to the boot sector of the second disk, and then events will flow depending on what is written on it: the second physical disk boot0it itself is not able to read the partition.

The list of partitions to select includes their names according to the file system type identifier, for example:

> F1 : DOS
> 
> F2 : Linux
> 
> F3 : BSD
> 
> F5 : Drive 1

Until now, BSD Loader could not recognize logical partitions within Extended DOS or boot any operating system from them. However, the situation seems to have changed now - this can be concluded from reports about the possibility of installing DragonFlyBSD on an extended partition (the only BSD system capable of this, as far as I know). But is it possible to imagine installing a system without the possibility of booting it with standard tools?

In principle, the presence of the first part of the BSD bootloader is not mandatory - it can easily be replaced by the Linux bootloader (the same Lilo, which transfers control to the boot sector of the BSD segment "along the chain") or multisystem GRUB, which is able to work directly with system files and loads the kernels of several operating systems.

The second part (boot1) is located in the boot sector of the primary partition containing the BSD system (BSD segment). That is, boot0 and boot1 are located not only outside the file system, but also, in fact, outside the BSD segment itself. The third part (boot2) is already inside the segment, but is not included in any logical part.

The second and third parts of the bootloader are essentially one program, separated only by the size limitation of the partition's boot sector (512 bytes). So, the job of boot1 is simply to recognize the BSD segment, find it in boot2 and transfer control to it. And the latter is obliged, after waiting a while, to recognize the root file system, find it and run the executable binary file: /boot/loader, which forms the fourth section of the bootloader; strictly speaking, the term BSD loader refers only to this program.

So, it can be seen that the first three parts of the BSD bootloader (boot0, boot1 and boot2) are outside the file system of the installed BSD operating system. We can only access it by launching the loader - a regular executable file that is placed in the special /boot directory of the root file system.

It is true that in the /boot directory (this is the "default" location of the loader), along with the executable files, you can also see files with the names boot0, boot1 and boot2. However, these files are simply copies of related code located (and executed) outside the BSD file system. The goal is to restore bootability after an emergency situation.

The task of the loader is to quickly load the kernel and a set of default modules, after which it displays a menu with the project logo, recognizable by the dragonfly (replacing the devil with a pitchfork from FreeBSD). The menu contains the following items:

-   **Boot DragonFly [default]**  : normal kernel boot with all the necessary modules (who and where to install them there will be more later) mounting the file system and executing the specified startup script.
-   **Boot DragonFly with ACPI disabled**  : the same thing, only with the acpi disabled module, which may sometimes be needed on some laptops.
-   **Boot DragonFly in Safe Mode**  : boot in safe mode, that is, without connecting modules.
-   **Boot DragonFly in single user mode**  : boot in single user mode, in which only the root file system is mounted (and only for reading), and the initialization stage is ignored.
-   **Boot DragonFly with verbose logging**  : normal boot, but with verbose messages.
-   **Escape to loader prompt**  : exit to the bootloader command line.
-   **Reboot**  : well, we know this like the back of our hand, only better.

If you don't make any selection, the default options will start loading in ten seconds. To avoid this (and give yourself more time to think), just press the space bar - the countdown will stop and not load until you make a clear choice.

After the selection or expiration of the statute of limitations, a rather long hardware detection process begins, during which numerous kernel messages, different from normal messages, are displayed on the screen in bright white "color" symbols. These messages are very interesting, but they are not easy to see. However, this is not scary - you can later view it with the dmesg command. After this, the root file system is mounted and the boot process is started from it (using the usual executable file /sbin/init), and the startup script is processed. To signal this, the bright white color of the kernel messages changes to the usual gray - the boot stage we are interested in today has ended.

## 4. Interactive control of the boot process
The question arises: can the user influence the boot process? The answer will be yes. During the operation of the boot system, the user has the freedom to choose three times: choosing the boot partition at the initial boot0 stage, choosing interactive control at the boot2 stage, and choosing the boot mode immediately after starting the loader. And in all these cases, the user can intervene in the process manually. Why? This is another question, and I hope the answer will be clear in the following presentation.

With the choice of the boot partition, everything is clear: it allows you to boot one of the operating systems, if several of them are installed on a particular machine. But at the boot2 stage of work, it is possible to stop its execution, or rather, prevent its launch by the loader. To do this, in the pause between choosing to boot from the BSD partition and the appearance of a message about loading the kernel and modules (this pause is indicated by the appearance of a flashing symbol on the screen _), you need to press any key. In response there will be a message like the following:

```
>> BSD/i386 BOOT
 Default: 0:ad(0,a)/boot/loader
 boot:
```

And in the message, you can specify boot options other than the default ones. For example, you can boot directly from the system kernel image file. This might make sense after rebuilding the kernel, if the new one turns out to be incorrectly configured enough to boot (but, unfortunately, enough to compile).

To do this, you need to create a path to the old kernel in the image and likeness of the default version. That is, determine:

-   the disk number in the machine in accordance with the BIOS ( 0— the first of the available ones, 1— the second, and so on, regardless of the connection order);
-   its interface - in the example adit symbolizes an ATA disk (for a SCSI disk it would be da, for a floppy disk - fd);
-   number on the IDE channel (0 - master, 1 - slave);
-   partition in the sense used by BSD Label, that is, the part of a slice reserved for the BSD root file system ( a;The name of the old kernel image file is /kernel.old.

If there are several primary partitions of different types on the disk, then the non-BSD type partition will be skipped, and the letter a (obviously, the kernel image can only be on the root file system) will refer to the first subsection of the segment with identifier 165 (even if it is the fourth on the disk).

If you are not sure of the exact name of the file (and there may be several; before installing each new untested kernel, it is recommended to make a copy of the old one, which is known to work), you can enter a question mark on the command line, the answers to which will be a list of root directories (but not deeper: boot2 will not be able to see the contents of subdirectories, even within the same file system, at this stage).

However, the same procedure - loading the old kernel - can (and should, because (it is much simpler) to be done through the loader, taking into account the interactive capabilities we are discussing now.

The menu loaderoffers a sufficient selection of modes for standard situations, but clearly does not cover all the non-standard ones (that's what they are for). In particular, the option to load the old kernel is not provided in the menu. Fortunately, the penultimate menu item solves this problem (and many others).

So, by selecting the sixth menu item — Escape to loader prompt — we find ourselves in the command interpreter environment loader. It has a shell-like interface — commands with their options and arguments are entered after the prompt, which looks like

**OK**

In terms of the convenience of interactive work, GRUB is certainly not one of them: it has no auto-completion, no command history, editing possibilities are limited to the Backspaceloader key. But it does a good job of its main function - entering and executing built-in commands.

In addition, there are quite a few such commands - a complete list of them can be obtained by entering a question mark on the command line. Help is also available,  the help command will give a short hint help

The loader built-in commands can be divided into three parts according to their purpose:

-   to obtain information.
-   to configure the bootloader.
-   actually to manage the loading process.

From the first group of commands, we highlight the following: ls, lsdev, lsmod, show, more. The first is intended to view the root file system and its subdirectories, although only those that are not located in separate subsections. However, since all the files needed for loading are located in subdirectories of the root itself (in /boot, /dev, /modules), this limitation is not significant. The ls -l variant of the command displays a list of files (and directories) indicating their sizes; without this option, directories are simply marked with letters.

The lsdev command lists the disk devices present on the machine, its primary partitions and subpartitions (the latter only for partitions marked according to BSD label rules). The -v option provides output details.

The lsmod command provides a display of the loaded modules of the loader before the menu (or command line) appears. As in the previous case, there is a verbose option - -v.

The show command performs the same function, but with respect to loader variables. Without arguments, this command prints the values of all specified variables. If a variable name is specified as an argument, only its value is displayed. Multiple arguments, separated by semicolons, are allowed.

Well, this command performs more of the same function as its name suggests among Unix utilities. This command allows viewing the contents of a text file, i.e., being in the loader's command interpreter, we can familiarize ourselves with the settings that are important for loading (and others).

Configuration commands allow you to define or clear bootloader variables, load or remove kernel modules. As already mentioned, the kernel itself with a set of predefined modules and variables is loaded before the loader and command interpreter menu. So, using the appropriate commands, this predefined set can be slightly adjusted (or changed completely). This may be necessary if the default kernel configuration is not loaded for some reason (a common case is a conflict between the laptop's power-saving system and the ACPI system module), for debugging purposes, or just to satisfy curiosity.

First, let's look at the module management commands. This is a pair of load commands for unloading and removing modules. The first one is used with the argument, which can be searched (using ls) in the /modules directory if necessary; the name in the argument is given without the *.ko suffix. An unload command with similar arguments will remove the specified module, without arguments; it will remove all modules completely, allowing you to start configuring from scratch.
