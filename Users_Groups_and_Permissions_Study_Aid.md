# User, Group, and Basic Permissions Administration
## A study aid for the CompTIA Linux+/LPIC-1 CPMT-107{5..7} series

Managing user accounts, groups and file/directory permissions is an essential Linux system administration task.  When new employees need login credentials or share access or when existing users are reassigned or promoted and need new and different access privileges, it is the SysAdmin's job to **get it right the first time.**

To prepare you not only for the Linux+/LPIC-1 exams, but an actual career doing IT administration you must practice using these skills to fully internalize the knowledge expected of a certified Linux admin.  These exercises are intended to give you the opportunity to practice these skills.  If you download the grading scripts associated with these exercises you can even evaluate your own success and identify the areas of opportunity where you may need to study and practice more.

These exercises will first assign you a series of tasks to accomplish on a freshly installed Linux system.  If you are using virtualization like VirtualBox, VMware, or Hyper-V saving a snapshot before performing these exercises will give you an opportunity to quickly reset and practice again.

### Create your organization

Users and groups must have a reason to exist, and having logically organized users and groups is an important part of securing an organization's data.  Let's create a fictitious organization, complete with imaginary users and groups.

### Table 1
| Groups     | GIDs | Members                  |
|------------|:----:|--------------------------|
|bridge      |5001  |jkirk,spock,pchekov,nuhura,hsulu,jrand|
|officers    |5002  |jkirk,spock,mscott|
|tactical    |5003  |pchekov,hsulu|
|science     |5004  |spock,hsulu,lmccoy|
|engineering |5005  |mscott,pcheckov|
|comms       |5006  |nuhura,jrand|
|medical     |5007  |lmccoy,cchapel|
|topsecret   |7000  |jkirk,mscott|

### Table 2
| Username | Full Name         | UID | GID | Groups           | UMASK |
|----------|-------------------|:---:|:---:|------------------|:-----:|
|jkirk     |James T. Kirk      |1500 |1500 |jkirk,bridge,officers,topsecret|0077|
|spock     |Spock              |1501 |1501 |spock,bridge,officers,science|0027|
|mscott    |Montgomery Scott   |1502 |1502 |mscott,officers,engineering,topsecret|0027|
|pchekov   |Pavel Chekov       |1503 |1503 |pchekov,bridge,tactical,engineering|0022|
|nuhura    |Nyota Uhura        |1504 |1504 |nuhura,bridge,comms|0022|
|hsulu     |Hikaru Sulu        |1505 |1505 |hsulu,bridge,tactical,science|0022|
|jrand     |Janice Rand        |1506 |1506 |jrand,bridge,comms|0022|
|lmccoy    |Dr. Leonard McCoy  |1507 |1507 |lmccoy,medical,science|0077|
|cchapel   |Christine Chapel   |1508 |1508 |cchapel,medical|0027|

### Table 3
| File/Directory             | Owner   | Group     | Permissions |
|----------------------------|:-------:|:---------:|------------:|
|/engineering/               |mscott   |engineering|drwxrwxr-x.  |
|/engineering/reports/       |mscott   |engineering|drwxrwx---.  |
|/engineering/mscott.log     |mscott   |mscott     |-rw-rw-r--.  |
|/engineering/pchekov.log    |pchekov  |pchekov    |-rw-rw-r--.  |
|/engineering/reports/fuel/  |pchekov  |engineering|drwxrwx---.  |
|/science/                   |spock    |science    |drwxr-xr-x.  |
|/science/research/          |root     |science    |drwxrws--T.  |
|/science/research/spock.log |spock    |science    |-rw-r--r--.  |
|/medical/                   |root     |medical    |drwxrws---.  |
|/medical/lmccoy.log         |lmccoy   |lmccoy     |-rw-rw----.  |
|/medical/cchapel.log        |cchapel  |medical    |-rw-r-----.  |
|/communications/            |root     |comms      |drwxrwxr-x.  |
|/communications/starfleet/  |nobody   |topsecret  |d---rws--T.  |
|/communications/comms.log   |nuhura   |comms      |-rw-r--r--.  |
|/officers/                  |nobody   |officers   |d---rwx--T.  |
|/officers/jkirk.log         |jkirk    |jkirk      |-rw-r-----.  |



1. Create the groups in Table 1.
..* Remember `groupadd --help` and `man groupadd` to find the options and order of arguments.
2. Run the script _grade-groups-lab.sh_.
..* Remember! The _./scripts/_ and _./scripts/DATA_FILES/_ directories should have been copied recursively to /usr/local/bin/ and made executable with `sudo chmod +x /usr/local/bin/*` if you followed the README file.
..* Correct any errors identified by the grading script until you are successful.

3. Create the user accounts in Table 2.  
..* Remember `useradd --help`, `usermod --help`, and the manual pages for help with options and the order of command arguments.
..* Be sure to set the GECOS comment field to contain exactly what is shown in the "Full Name" column.  The grading script WILL check for this.
..* Be sure each user has a home directory created at /home/USERNAME. Also be sure to set a umask in ~/.bashrc for each user that needs a umask different from your system default.  If your distribution does not create user home directories by default, you may need to edit `/etc/login.defs` or use `useradd --create-home [options]... LOGIN` .
..* If your distribution does create a private group for each user with a GID number that matches the UID by default, you may need to edit `/etc/login.defs` or use `useradd --user-group [options]... LOGIN` .
4. Go to the _./scripts/_ directory of the GIT repository where you downloaded this file and run the script _grade-users-lab.sh_. 
..* Correct any errors identified by the grading script until you are successful.

5. Create the files and directories in Table 3.
..* Be sure to double check the owner, group, and permissions.  The grading script WILL check for this.
6. Go to the _./scripts/_ directory of the GIT repository where you downloaded this file and run the script _grade-files-lab.sh_. 
..* Correct any errors identified by the grading script until you are successful.

