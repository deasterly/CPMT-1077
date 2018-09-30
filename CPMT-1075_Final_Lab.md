# CPMT-1075 Final Lab

#### Topic 101: System Architecture
#### Topic 102: Linux Installation and Package Management
#### Topic 103: GNU and Unix Commands
#### Topic 104: Devices, Linux Filesystems, Filesystem Hierarchy Standard

BEFORE YOU BEGIN:
1. Reset the OpenSUSE VM that came with the book to the "BASE" snapshot
2. Add 2 new hard drives of 2GB to the OpenSUSE VM in VirtualBox
  * Click the VM Settings > Storage > SATA Controller > +(Add Hard Disk) in VirtualBox
    * Exact menu items may vary between versions
  * Contact the instructor if you need help adding hard drives to your VM
3. Power up the VM and log in as the user "student"
4. Install "git"
  *  Run `sudo zypper install git` in a terminal
5. Use "git" to download the class materials into "/home/student/"
  * Run `cd ~ ; git clone https://github.com/deasterly/CPMT-1077.git` as "student"
6. Copy the lab data files and scripts to "/usr/local/bin/" and make them executable
  * Run `sudo cp -R ~/CPMT-1077/scripts/*  /usr/local/bin/ ; sudo chmod +x /usr/local/bin/*.sh`
7. Save a new snapshot of the VM as "1075-Final"
---


#### Lab Tasks

1. Configure the system to automatically boot to "graphical.target"
  * Remember `systemctl get-default` and `systemctl set-default [TAB][TAB]`
2. Start and enable the "rpcbind.service" SystemD unit
  * Remember `systemctl [TAB][TAB]`
3. Start and enable the "nfs.service" SystemD unit
---
4. On the first added hard drive ("/dev/sdb") create a Linux (Type 83) partition using the full 2GB
  * Remember `fdisk --help`
5. Create an EXT4 filesystem on the new partition with a label of "SR-71"
  * Remember `mkfs --help` and `man mkfs.ext4`
  * Do not worry about mounting it yet
---
6. Make the second hard drive ("/dev/sdc") an LVM Physical Volume.
  * Remember `pvcreate --help` and `man pvcreate`
7. Create an LVM Volume Group called "SquadVG"
  * Remember `vgcreate --help` and `man vgcreate`
8. Create two LVM Logical Volumes of 750MB each.
  * Name the first LV "Squad1" and the second LV "Squad2"
  * Remember `lvcreate --help` and `man lvcreate`
---
9. Create an EXT4 filesystem on the "/dev/SquadVG/Squad1" LV
  * Do not worry about mounting it yet
10. Create an EXT4 filesystem on the "/dev/SquadVG/Squad2" LV
  * Do not worry about mounting it yet
---
11. Edit "/etc/login.defs" to enable the automatic creation of private user groups
  * Check `man login.defs` for "USERGROUPS_ENAB"
12. Edit "/etc/login.defs" to enable the automatic creation of user home directories
  * Check `man login.defs` for "CREATE_HOME"
---
14. Create the groups in Table 1 (below)
  * Remember `groupadd --help` and `man groupadd`
15. Create the user accounts in Table 2  
  * Remember `useradd --help`, `usermod --help`, and the manual pages
  * Be sure each user has a private primary group
    * Remember to edit "/etc/login.defs" or to use `useradd --user-group [options]... LOGIN`
  * Be sure to set the GECOS comment field to contain __exactly__ what is shown in the "Full Name" column
  * Be sure each user has a home directory created at "/home/_<USERNAME>_" 
    * Remember to edit "/etc/login.defs" or to use `useradd --create-home [options]... LOGIN`
  * Also be sure to set a umask in "~/.bashrc" for each user that needs a umask different from your system default  
--- 
16. Create the following directories:
  * "/blackbird/"
  * "/squad1/"
  * "/squad2/"
17. Edit "/etc/fstab" to mount the EXT4 filesystem labeled "SR-71" under "/blackbird/" using the default options
18. Edit "/etc/fstab" to mount the EXT4 filesystem on the "Squad1" LV under "/squad1/" using the default options
19. Edit "/etc/fstab" to mount the EXT4 filesystem on the "squad2" LV under "/squad2/" using the default options
20. Confirm all filesystems mount successfully by rebooting or running `mount -av`
---
21. Create/configure the files and directories in Table 3
  * Be sure to double check the owner, group, and permissions
  * Remember `chown --help` and `chmod --help` 
---
21. Refer to the [Lab Answer Key](./CPMT-1075_Final_Key.md) to check your work



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
