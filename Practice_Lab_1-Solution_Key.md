# Dave's Practice Lab #1 Solution Key

#### System Architecture
#### Linux Installation and Package Management
#### GNU and Unix Commands
#### Devices, Linux Filesystems, Filesystem Hierarchy Standard

A WORD TO THE WISE:  One of the most important parts of a "real IT job" is being able to test and verify your own work.  
The examples below are just one of many different ways to accomplish these objectives on a Linux system.  If you find a better way, use it!

NOTE: Lots of extraneous output was removed from the solutions, so if you see other messages then read them carefully and disregard non-errors.

---


#### Lab Tasks

1. Configure the system to automatically boot to "graphical.target"
<pre>
openSUSE:~ # systemctl get-default 
runlevel5.target
openSUSE:~ # systemctl set-default graphical.target 
rm '/etc/systemd/system/default.target'
ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target'
openSUSE:~ # systemctl get-default 
graphical.target
</pre>
2. Start and enable the "rpcbind.service" SystemD unit
<pre>
openSUSE:~ # systemctl status rpcbind.service 
rpcbind.service - RPC Bind
   Loaded: loaded (/usr/lib/systemd/system/rpcbind.service; disabled)
   Active: inactive (dead)

openSUSE:~ # systemctl enable rpcbind.service ; systemctl start rpcbind.service 
ln -s '/usr/lib/systemd/system/rpcbind.service' '/etc/systemd/system/multi-user.target.wants/rpcbind.service'
ln -s '/usr/lib/systemd/system/rpcbind.socket' '/etc/systemd/system/sockets.target.wants/rpcbind.socket'
openSUSE:~ # systemctl status rpcbind.service 
rpcbind.service - RPC Bind
   Loaded: loaded (/usr/lib/systemd/system/rpcbind.service; enabled)
   Active: active (running) since Sun 2018-09-30 10:45:40 MDT; 4s ago
</pre>
3. Start and enable the "nfs.service" SystemD unit
<pre>
openSUSE:~ # systemctl status nfs.service
nfs.service - LSB: NFS client services
   Loaded: loaded (/etc/init.d/nfs)
  Drop-In: /run/systemd/generator/nfs.service.d
           └─50-insserv.conf-$remote_fs.conf
   Active: inactive (dead)

openSUSE:~ # systemctl start nfs.service ; systemctl enable nfs.service
nfs.service is not a native service, redirecting to /sbin/chkconfig.
Executing /sbin/chkconfig nfs on

openSUSE:~ # systemctl status nfs.service
nfs.service - LSB: NFS client services
   Loaded: loaded (/etc/init.d/nfs)
  Drop-In: /run/systemd/generator/nfs.service.d
           └─50-insserv.conf-$remote_fs.conf
   Active: active (running) since Sun 2018-09-30 10:47:13 MDT; 16s ago
</pre>
---
4. On the first added hard drive ("/dev/sdb") create a Linux (Type 83) partition using the full 2GB
<pre>
openSUSE:~ # fdisk /dev/sdb
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x30ad4f53.

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-4194303, default 2048): 2048
Last sector, +sectors or +size{K,M,G} (2048-4194303, default 4194303): 4194303
Partition 1 of type Linux and of size 2 GiB is set

Command (m for help): p

Disk /dev/sdb: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x30ad4f53

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     4194303     2096128   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
openSUSE:~ # fdisk -l /dev/sdb

Disk /dev/sdb: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x30ad4f53

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     4194303     2096128   83  Linux
</pre>
5. Create an EXT4 filesystem on the new partition with a label of "SR-71"
<pre>
openSUSE:~ # mkfs.ext4 -L "SR-71" /dev/sdb1
mke2fs 1.42.8 (20-Jun-2013)
Filesystem label=SR-71
OS type: Linux...

openSUSE:~ # blkid /dev/sdb1
/dev/sdb1: LABEL="SR-71" UUID="d74f26a8-2e1e-4974-9067-620ba76b335d" TYPE="ext4"
</pre>
---
6. Make the second hard drive ("/dev/sdc") an LVM Physical Volume.
<pre>
openSUSE:~ # lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   12G  0 disk 
├─sda1   8:1    0    1G  0 part [SWAP]
├─sda2   8:2    0   10G  0 part /
└─sda3   8:3    0    1G  0 part /home
sdb      8:16   0    2G  0 disk 
└─sdb1   8:17   0    2G  0 part 
sdc      8:32   0    2G  0 disk 
sr0     11:0    1 1024M  0 rom  
openSUSE:~ # pvcreate /dev/sdc
openSUSE:~ # pvs
  PV         VG   Fmt  Attr PSize PFree
  /dev/sdc        lvm2 a--  2.00g 2.00g
</pre>
7. Create an LVM Volume Group called "SquadVG"
<pre>
openSUSE:~ # vgcreate SquadVG /dev/sdc
openSUSE:~ # pvs
  PV         VG      Fmt  Attr PSize PFree
  /dev/sdc   SquadVG lvm2 a--  2.00g 2.00g
openSUSE:~ # vgs
  VG      #PV #LV #SN Attr   VSize VFree
  SquadVG   1   0   0 wz--n- 2.00g 2.00g
</pre>
8. Create two LVM Logical Volumes of 750MB each.
  * Name the first LV "Squad1" and the second LV "Squad2"
<pre>
openSUSE:~ # lvcreate -n Squad1 -L 750M SquadVG
openSUSE:~ # vgs
  VG      #PV #LV #SN Attr   VSize VFree
  SquadVG   1   1   0 wz--n- 2.00g 1.26g
openSUSE:~ # lvs
  LV     VG      Attr      LSize   Pool Origin Data%  Move Log Copy%  Convert
  Squad1 SquadVG -wi-a---- 752.00m                                           
openSUSE:~ # lvcreate -n Squad2 -L 750M SquadVG
openSUSE:~ # pvs
  PV         VG      Fmt  Attr PSize PFree  
  /dev/sdc   SquadVG lvm2 a--  2.00g 540.00m
openSUSE:~ # vgs
  VG      #PV #LV #SN Attr   VSize VFree  
  SquadVG   1   2   0 wz--n- 2.00g 540.00m
openSUSE:~ # lvs
  LV     VG      Attr      LSize   Pool Origin Data%  Move Log Copy%  Convert
  Squad1 SquadVG -wi-a---- 752.00m                                           
  Squad2 SquadVG -wi-a---- 752.00m                                           
openSUSE:~ # lsblk
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                8:0    0   12G  0 disk 
├─sda1             8:1    0    1G  0 part [SWAP]
├─sda2             8:2    0   10G  0 part /
└─sda3             8:3    0    1G  0 part /home
sdb                8:16   0    2G  0 disk 
└─sdb1             8:17   0    2G  0 part 
sdc                8:32   0    2G  0 disk 
├─SquadVG-Squad1 253:0    0  752M  0 lvm  
└─SquadVG-Squad2 253:1    0  752M  0 lvm  
sr0               11:0    1 1024M  0 rom  
</pre>
---
9. Create an EXT4 filesystem on the "/dev/SquadVG/Squad1" LV
  * Do not worry about mounting it yet
<pre>
openSUSE:~ # mkfs.ext4 /dev/SquadVG/Squad1
mke2fs 1.42.8 (20-Jun-2013)
Filesystem label=
OS type: Linux

openSUSE:~ # blkid /dev/SquadVG/Squad1
/dev/SquadVG/Squad1: UUID="19d42d8a-c1a5-40d8-99ea-b2c6a1509473" TYPE="ext4" 
</pre>
10. Create an EXT4 filesystem on the "/dev/SquadVG/Squad2" LV
  * Do not worry about mounting it yet
<pre>
openSUSE:~ # mkfs.ext4 /dev/SquadVG/Squad2
mke2fs 1.42.8 (20-Jun-2013)
Filesystem label=
OS type: Linux

openSUSE:~ # blkid
/dev/sdb1: LABEL="SR-71" UUID="d74f26a8-2e1e-4974-9067-620ba76b335d" TYPE="ext4" 
/dev/SquadVG/Squad1: UUID="19d42d8a-c1a5-40d8-99ea-b2c6a1509473" TYPE="ext4" 
/dev/sda1: UUID="48814fa2-b9c9-4db1-963d-0ce8b8faf123" TYPE="swap" 
/dev/sda2: UUID="bf931f41-dc31-4b46-ad1b-6c1663fee130" TYPE="ext4" PTTYPE="dos" 
/dev/sda3: UUID="a64ce2de-258f-41a0-bd54-920f0a3e2e94" TYPE="ext4" 
/dev/sdc: UUID="BEiRf5-WFIi-Q9yC-PrdP-MWYu-6QUc-EvS3xE" TYPE="LVM2_member" 
/dev/mapper/SquadVG-Squad2: UUID="2a70b305-332a-4b19-8a07-e79f78748df1" TYPE="ext4"
</pre>
---
11. Edit "/etc/login.defs" to enable the automatic creation of private user groups
12. Edit "/etc/login.defs" to enable the automatic creation of user home directories
<pre>
openSUSE:~ # vim /etc/login.defs 
openSUSE:~ # grep -E 'USERGROUPS_ENAB|CREATE_HOME' /etc/login.defs
#USERGROUPS_ENAB no
USERGROUPS_ENAB yes
#CREATE_HOME     no
CREATE_HOME     yes
</pre>
---
14. Create the groups in Table 1 (below)
<pre>
openSUSE:~ #  groupadd --gid 5001 x-men
openSUSE:~ # groupadd -g 5002 teachers
openSUSE:~ # groupadd -g 5003 squad1 ; groupadd -g 5004 squad2 ; groupadd -g 5005 blackbird
openSUSE:~ # groupadd -g 5006 dangerroom ; groupadd -g 5007 cerebro ; groupadd -g 7000 topsecret
openSUSE:~ # getent group | grep -E '[57][0-9]{3}'
x-men:x:5001:
teachers:x:5002:
squad1:x:5003:
squad2:x:5004:
blackbird:x:5005:
dangerroom:x:5006:
cerebro:x:5007:
topsecret:x:7000:
</pre>
15. Create the user accounts in Table 2  
<pre>
openSUSE:~ # useradd -mUu 1500 -c "Charles Xavier" -G x-men,teachers,cerebro,topsecret prof_x
openSUSE:~ # id prof_x
uid=1500(prof_x) gid=1500(prof_x) groups=5001(x-men),5002(teachers),5007(cerebro),7000(topsecret),1500(prof_x)
openSUSE:~ # useradd -u 1501 -c "Hank McCoy" -G x-men,teachers,squad1,cerebro,topsecret beast
openSUSE:~ # useradd -u 1502 -c "Jean Grey" -G x-men,teachers,squad1,cerebro jgrey
openSUSE:~ # useradd -u 1503 -c "Scott Summers" -G x-men,squad1,blackbird summers
openSUSE:~ # useradd -u 1504 -c "Ororo Munroe" -G x-men,squad1,dangerroom storm
openSUSE:~ # useradd -u 1505 -c "Bobby Drake" -G x-men,squad2 iceman
openSUSE:~ # useradd -u 1506 -c "Kitty Pryde" -G x-men,squad2,dangerroom kpryde
openSUSE:~ # useradd -u 1507 -c "Kurt Wagner" -G x-men,squad2 nightcrawler
openSUSE:~ # useradd -u 1508 -c Logan -G x-men,squad2,blackbird logan
openSUSE:~ # getent passwd | grep -E '150[1-8]'
beast:x:1501:1501:Hank McCoy:/home/beast:/bin/bash
jgrey:x:1502:1502:Jean Grey:/home/jgrey:/bin/bash
summers:x:1503:1503:Scott Summers:/home/summers:/bin/bash
storm:x:1504:1504:Ororo Munroe:/home/storm:/bin/bash
iceman:x:1505:1505:Bobby Drake:/home/iceman:/bin/bash
kpryde:x:1506:1506:Kitty Pryde:/home/kpryde:/bin/bash
nightcrawler:x:1507:1507:Kurt Wagner:/home/nightcrawler:/bin/bash
logan:x:1508:1508:Logan:/home/logan:/bin/bash
openSUSE:~ # ls /home/
beast  iceman  jgrey  kpryde  logan  lost+found  nightcrawler  prof_x  storm  student  summers
</pre>
  * Also be sure to set a umask in "~/.bashrc" for each user that needs a umask different from your system default  
<pre>
openSUSE:~ # su -l -c 'echo umask 077 >> ~/.bashrc ; grep umask ~/.bashrc' prof_x
umask 077
openSUSE:~ # su -lc 'umask' prof_x 
0077
openSUSE:~ # su -l -c 'echo umask 077 >> ~/.bashrc' beast 
openSUSE:~ # su -l -c 'echo umask 027 >> ~/.bashrc' jgrey 
openSUSE:~ # su -l -c 'echo umask 027 >> ~/.bashrc' summers 
openSUSE:~ # su -l -c 'echo umask 077 >> ~/.bashrc' storm 
openSUSE:~ # su -l -c 'echo umask 022 >> ~/.bashrc' iceman 
openSUSE:~ # su -l -c 'echo umask 002 >> ~/.bashrc' kpryde 
openSUSE:~ # su -l -c 'echo umask 022 >> ~/.bashrc' nightcrawler 
openSUSE:~ # su -l -c 'echo umask 077 >> ~/.bashrc' logan

openSUSE:~ # for XMAN in prof_x beast jgrey summers storm iceman kpryde nightcrawler logan ; do \
> su -lc 'whoami ; umask ; id' $XMAN ; \
> done
prof_x
0077
uid=1500(prof_x) gid=1500(prof_x) groups=1500(prof_x),5001(x-men),5002(teachers),5007(cerebro),7000(topsecret)
beast
0077
uid=1501(beast) gid=1501(beast) groups=1501(beast),5001(x-men),5002(teachers),5003(squad1),5007(cerebro),7000(topsecret)
jgrey
0027
uid=1502(jgrey) gid=1502(jgrey) groups=1502(jgrey),5001(x-men),5002(teachers),5003(squad1),5007(cerebro)
summers
0027
uid=1503(summers) gid=1503(summers) groups=1503(summers),5001(x-men),5003(squad1),5005(blackbird)
storm
0077
uid=1504(storm) gid=1504(storm) groups=1504(storm),5001(x-men),5003(squad1),5006(dangerroom)
iceman
0022
uid=1505(iceman) gid=1505(iceman) groups=1505(iceman),5001(x-men),5004(squad2)
kpryde
0002
uid=1506(kpryde) gid=1506(kpryde) groups=1506(kpryde),5001(x-men),5004(squad2),5006(dangerroom)
nightcrawler
0022
uid=1507(nightcrawler) gid=1507(nightcrawler) groups=1507(nightcrawler),5001(x-men),5004(squad2)
logan
0077
uid=1508(logan) gid=1508(logan) groups=1508(logan),5001(x-men),5004(squad2),5005(blackbird)
</pre>
--- 
16. Create the following directories:
  * "/blackbird/"
  * "/squad1/"
  * "/squad2/"
<pre>
openSUSE:~ # mkdir /blackbird /squad{1,2} 
openSUSE:~ # ls -ld /bl* /sq*
drwxr-xr-x 2 root root 4096 Sep 30 11:58 /blackbird
drwxr-xr-x 2 root root 4096 Sep 30 11:58 /squad1
drwxr-xr-x 2 root root 4096 Sep 30 11:58 /squad2
</pre>
17. Edit "/etc/fstab" to mount the EXT4 filesystem labeled "SR-71" under "/blackbird/" using the default options
18. Edit "/etc/fstab" to mount the EXT4 filesystem on the "Squad1" LV under "/squad1/" using the default options
19. Edit "/etc/fstab" to mount the EXT4 filesystem on the "squad2" LV under "/squad2/" using the default options
<pre>
openSUSE:~ # vim /etc/fstab
openSUSE:~ # cat /etc/fstab
/dev/disk/by-id/ata-VBOX_HARDDISK_VB4a721681-599dfb5a-part1     swap            swap    defaults        0 0
/dev/disk/by-id/ata-VBOX_HARDDISK_VB4a721681-599dfb5a-part2     /               ext4    acl,user_xattr  1 1
/dev/disk/by-id/ata-VBOX_HARDDISK_VB4a721681-599dfb5a-part3     /home           ext4    acl,user_xattr  1 2
LABEL="SR-71"                                                   /blackbird      ext4    defaults        1 2
/dev/SquadVG/Squad1                                             /squad1         ext4    defaults        1 2
/dev/mapper/SquadVG-Squad2                                      /squad2         ext4    defaults        1 2
</pre>
20. Confirm all filesystem mount successfully by rebooting or running `mount -av`
<pre>
openSUSE:~ # mount -av
swap                     : ignored
/                        : ignored
/home                    : already mounted
/blackbird               : successfully mounted
/squad1                  : successfully mounted
/squad2                  : successfully mounted
openSUSE:~ # df -h
Filesystem                  Size  Used Avail Use% Mounted on
/dev/sda2                   9.8G  4.8G  4.5G  52% /
/dev/sda3                   976M   16M  894M   2% /home
/dev/sdb1                   2.0G  3.0M  1.9G   1% /blackbird
/dev/mapper/SquadVG-Squad1  725M  760K  671M   1% /squad1
/dev/mapper/SquadVG-Squad2  725M  760K  671M   1% /squad2
openSUSE:~ # lsblk
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                8:0    0   12G  0 disk 
├─sda1             8:1    0    1G  0 part [SWAP]
├─sda2             8:2    0   10G  0 part /
└─sda3             8:3    0    1G  0 part /home
sdb                8:16   0    2G  0 disk 
└─sdb1             8:17   0    2G  0 part /blackbird
sdc                8:32   0    2G  0 disk 
├─SquadVG-Squad1 253:0    0  752M  0 lvm  /squad1
└─SquadVG-Squad2 253:1    0  752M  0 lvm  /squad2
sr0               11:0    1 1024M  0 rom  
</pre>
---
21. Create/configure the files and directories in Table 3
  * Be sure to double check the owner, group, and permissions
<pre>
openSUSE:~ # chown summers:blackbird /blackbird/ ; chmod 2770 /blackbird/
openSUSE:~ # su -lc 'mkdir /blackbird/logan' logan
openSUSE:~ # su -lc 'touch /blackbird/summers.log' summers
openSUSE:~ # ls -laR /bl*
/blackbird:
total 28
drwxrws---  4 summers blackbird  4096 Sep 30 12:12 .
drwxr-xr-x 28 root    root       4096 Sep 30 12:23 ..
drwx--S---  2 logan   blackbird  4096 Sep 30 12:12 logan
-rw-r-----  1 summers blackbird     0 Sep 30 12:12 summers.log

/blackbird/logan:
total 8
drwx--S--- 2 logan   blackbird 4096 Sep 30 12:12 .
drwxrws--- 4 summers blackbird 4096 Sep 30 12:12 ..

openSUSE:~ # mkdir /dangerroom ; chown storm:dangerroom /dangerroom ; chmod 775 /dangerroom
openSUSE:~ # su -lc 'touch /dangerroom/kpryde.log' kpryde 
openSUSE:~ # ls -laR /da*
/dangerroom:
total 8
drwxrwxr-x  2 storm  dangerroom 4096 Sep 30 12:16 .
drwxr-xr-x 28 root   root       4096 Sep 30 12:23 ..
-rw-rw-r--  1 kpryde kpryde        0 Sep 30 12:16 kpryde.log

openSUSE:~ # mkdir /cerebro ; chown prof_x:cerebro /cerebro 
openSUSE:~ # su -lc 'touch /cerebro/prof_x.log' prof_x 
openSUSE:~ # chmod 3770 /cerebro/
openSUSE:~ # ls -laR /ce*
/cerebro:
total 8
drwxrws--T  2 prof_x cerebro 4096 Sep 30 12:18 .
drwxr-xr-x 28 root   root    4096 Sep 30 12:23 ..
-rw-------  1 prof_x prof_x     0 Sep 30 12:18 prof_x.log

openSUSE:~ # chown beast:squad1 /squad1 ; chmod 700 /squad1
openSUSE:~ # chown logan:squad2 /squad2 ; chmod 700 /squad2
openSUSE:~ # ls -ld /sq*
drwx------ 3 beast squad1 4096 Sep 30 11:04 /squad1
drwx------ 3 logan squad2 4096 Sep 30 11:08 /squad2

openSUSE:~ # mkdir /teachers ; chown jgrey:teachers /teachers ; chmod 2770 /teachers
openSUSE:~ # su -lc 'touch /teachers/jgrey.log' jgrey
openSUSE:~ # ls -laR /teachers/
/teachers/:
total 8
drwxrws---  2 jgrey teachers 4096 Sep 30 12:23 .
drwxr-xr-x 28 root  root     4096 Sep 30 12:23 ..
-rw-r-----  1 jgrey teachers    0 Sep 30 12:23 jgrey.log
</pre>
---
22. Ask the instructor for help if parts of this Answer Key are unclear to you


### Table 1
| Groups     | GIDs | Members                                                         |
|------------|:----:|-----------------------------------------------------------------|
|x-men       |5001  |prof_x,beast,jgrey,summers,storm,iceman,kpryde,nightcrawler,logan|
|teachers    |5002  |prof_x,beast,jgrey|
|squad1      |5003  |beast,jgrey,summers,storm|
|squad2      |5004  |iceman,kpryde,nightcrawler,logan|
|blackbird   |5005  |summers,logan|
|dangerroom  |5006  |storm,kpryde|
|cerebro     |5007  |prof_x,jgrey,beast|
|topsecret   |7000  |prof_x,beast|

### Table 2
| Username   | Full Name    | UID | GID | Groups                                      | UMASK |
|------------|--------------|:---:|:---:|---------------------------------------------|:-----:|
|prof_x      |Charles Xavier|1500 |1500 |prof_x,x-men,teachers,cerebro,topsecret      |0077|
|beast       |Hank McCoy    |1501 |1501 |beast,x-men,teachers,squad1,cerebro,topsecret|0077|
|jgrey       |Jean Grey     |1502 |1502 |jgrey,teachers,squad1,cerebro                |0027|
|summers     |Scott Summers |1503 |1503 |summers,x-men,squad1,blackbird               |0027|
|storm       |Ororo Munroe  |1504 |1504 |storm,x-men,squad1,dangerroom                |0077|
|iceman      |Bobby Drake   |1505 |1505 |iceman,x-men,squad2                          |0022|
|kpryde      |Kitty Pryde   |1506 |1506 |kpryde,x-men,squad2,dangerroom               |0002|
|nightcrawler|Kurt Wagner   |1507 |1507 |nightcrawler,x-men,squad2                    |0022|
|logan       |Logan         |1508 |1508 |logan,x-men,squad2,blackbird                 |0077|

### Table 3
| File/Directory       | Owner  | Group     | Permissions |
|----------------------|:------:|:---------:|------------:|
|/blackbird/           |summers |blackbird  |drwxrws---|
|/blackbird/logan/     |logan   |blackbird  |drwx--S---|
|/blackbird/summers.log|summers |blackbird  |-rw-r-----|
|/dangerroom/          |storm   |dangerroom |drwxrwxr-x|
|/dangerroom/kpryde.log|kpryde  |kpryde     |-rw-rw-r--|
|/cerebro/             |prof_x  |cerebro    |drwxrws--T|
|/cerebro/prof_x.log   |prof_x  |prof_x     |-rw-------|
|/squad1/              |beast   |squad1     |drwx------|
|/squad2/              |logan   |squad2     |drwx------|
|/teachers/            |jgrey   |teachers   |drwxrws---|
|/teachers/jgrey.log   |jgrey   |teachers   |-rw-r-----|

### Table 4
| Private Groups | GIDs | Members |
|----------------|:----:|---------|
|prof_x          |1500  |prof_x| 
|beast           |1501  |beast|
|jgrey           |1502  |jgrey|
|summers         |1503  |summers|
|storm           |1504  |storm|
|iceman          |1505  |iceman|
|kpryde          |1506  |kpryde|
|nightcrawler    |1507  |nightcrawler|
|logan           |1508  |logan|
