# Dave's Practice Lab #2

#### Shells, Scripting and Data Management
#### User Interfaces and Desktops
#### Administrative Tasks
#### Essential System Services
#### Networking Fundamentals
#### Security

BEFORE YOU BEGIN:
1. Create 2 new Virtual Machines in your hypervisor
  * Name one VM Rocky9 and the other Ubuntu_2404
  * Give each VM 2GB of RAM and a single 20GB hard disk
  * Give each VM 2 Network Adapters
    * Network Adapter 1 for both VMs should be bridged to the interface your system uses to access the Internet
      * This assumes that your Internet connection provides DHCP
    * Network Adapter 2 for both VMs should be attached to an "Internal" or "VM only" network
2. If needed, download the necessary DVD ISO images
  * Find where to download the ISOs from https://distrowatch.com or go directly to https://rockylinux.org and https://ubuntu.com
3. Install Rocky 9 on the Rocky9 VM
  * Under "Network & Host Name" turn on the first Network Interface Card (NIC)
    * This NIC should be bridged to your Internet connected NIC/WiFi adapter and should get an IPv4 address via DHCP
  * Under "Date & Time" be sure to set your time zone and enable Network Time Protocol (NTP)
  * Under "Software Selection" be sure to choose "Server with GUI" under the "Base Environment"
    * Also select "MariaDB Database Server" under "Add-Ons for Selected Environment"
  * Under "Installation Destination" select the default partition/LVM configuration on /dev/sda
  * Set the "root" password to something reasonably secure that you will not forget
  * Create the user "student" as an administrator with a reasonably secure password that you will not forget
  * After rebooting, accept the License Agreement if prompted and finish the configuration
4. Install Ubuntu 24.04 Server on the Ubuntu2404 VM
  * The Ubuntu Server DVD ISO _does NOT_ provide a GUI - the installation is all text-based
  * Be sure the first NIC gets an IPv4 address via DHCP
  * Accept the default installation source settings 
  * Accept the default storage configuration 
  * Set your server's name to "ubuntu"
  * Create the user "student" with a reasonably secure password that you will not forget
5. After rebooting both VMs after the installation save a snapshot in your hypervisor so you can start over as needed

---


#### Lab Tasks

1. Install all available updates for the Ubuntu and Rocky systems
  * Remember `apt [TAB][TAB]` and `yum [TAB][TAB]`
2. Install the package "gnome-shell" and its dependencies on the Ubuntu server
3. Configure the Ubuntu server to boot to "graphical.target"  
  * Remember `systemctl [TAB][TAB]`
---
4. Configure the Ubuntu system to act as a remote rsyslog server using TCP port 514
  * Remember `man rsyslog.conf`
5. Configure the Rocky system to send all rsyslog logs to the Ubuntu log server using TCP
  * Remember `man rsyslog.conf`
---
6. Configure both the Ubuntu and Rocky systems to have a default password aging policy that requires users to change their passwords after 90 days with a warning 14 days prior to the password expiration.  Expired passwords should be enforced after a 10 day inactivity period.
  * Remember `man chage` and `man 5 shadow`
7. Create the groups defined in Table 1 on the Ubuntu system
  * Remember `groupadd --help` and `man 5 group`
8. Create the users defined in Table 2 on the Ubuntu system
  * Remember `man 5 passwd` and `useradd --help`
  * Also be sure to set a umask in "~/.bashrc" for each user that needs a umask different from your system default  
9. Set a password of P@ssw0rd for all the users in Table 2
10. Force the users in Table 2 to change their passwords at the next login
  * Remember `man chage` and `man 5 shadow`
---
11. Start and enable the MariaDB server on the Rocky system
  * Remember `systemctl[TAB][TAB]`
12. Secure the installation of MariaDB server on the Rocky system
  * Require a password for the root database user
  * Disable remote root login
  * Disable anonymous users
  * Remember `man -k mysql` and `mysql[TAB][TAB]`
13. Add a database user named 'webapp' identified by the password 'password' 
14. Grant webapp all privileges on all databases and tables from any host
15. Create a database named 'publications' containing the data in Table 3
--- 
16. Generate a GPG keys on the Ubuntu system for the user f.bastiat
  * Remember `man -k gpg` and `gpg[TAB][TAB]`
  * User f.bastiat@ubuntu.local for the email address
17. Generate an SSH identity key for the 'student' user on the Rocky system
18. Install student's SSH key for Ubuntu users f.bastiat and hd.thoreau
19. Secure the SSH service on the Ubuntu system to disable root login and password authentication
---
20. Write a BASH script that writes a log of all users currently logged in to the system
  * Use the Rocky system for this task
  * Save the script as /usr/local/bin/usercheck.sh with 0755 permissions 
  * The script should log to the file /tmp/usercheck.log every time it is run
21. Create a cron job on the Rocky system to run /usr/local/bin/usercheck.sh at 10:00 AM, 2:00 PM, and 4:00 PM every weekday
  * The cron job should run as the user student, not root
22. Ensure both the Ubuntu and Rocky systems synchronize their time to Microsoft's public NTP server at time.windows.com
---
23. Refer to the [Lab Answer Key](./CPMT-1076_Final_Key.md) to check your work



### Table 1
| Groups     | GIDs |
|------------|:----:|
|authors     |2001  |
|philosophers|2002  |
|economists  |2003  |

### Table 2
| Username | Full Name      | UID | GID | Supplementary Groups          | UMASK |
|----------|----------------|:---:|:---:|-------------------------------|:-----:|
|f.bastiat |Fred Bastiat    |1500 |1500 |authors,philosophers,economists|0022|
|js.mill   |John S. Mill    |1501 |1501 |authors,philosophers           |0002|
|h.hazlitt |Henry Hazlitt   |1502 |1502 |authors,economist              |0022|
|l.vonmises|Ludwig vonMises |1503 |1503 |authors,philosophers,economists|0022|
|l.spooner |Lysander Spooner|1504 |1504 |authors,philosophers           |0002|
|hd.thoreau|Henry D. Thoreau|1505 |1505 |authors,philosophers           |0002|

### Table 3
| id [int(4)] | author [varchar(48) | title [varchar(48)]              |
|-------------|---------------------|----------------------------------|
|1            |F. Bastiat           |The Law                           |
|2            |John Stuart Mill     |On Liberty                        |
|3            |Henry Hazlitt        |Economics in One Lesson           |
|4            |Ludwig von Mises     |Human Action                      |
|5            |Lysander Spooner     |The Unconstitutionality of Slavery|
|6            |Henry David Thoreau  |Civil Disobedience                |

### Table 4
| Private Groups | GIDs | Members |
|----------------|:----:|---------|
|f.bastiat       |1500  |f.bastiat| 
|js.mill         |1501  |js.mill|
|h.hazlitt       |1502  |h.hazlitt|
|l.vonmises      |1503  |l.vonmises|
|l.spooner       |1504  |l.spooner|
|h.thoreau       |1505  |h.thoreau|
