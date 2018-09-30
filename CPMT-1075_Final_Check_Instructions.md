# How to check your work
Try this:
<pre>
openSUSE:~ # getent passwd | grep 150[0-9]
prof_x:x:1500:1500:Charles Xavier:/home/prof_x:/bin/bash
beast:x:1501:1501:Hank McCoy:/home/beast:/bin/bash
jgrey:x:1502:1502:Jean Grey:/home/jgrey:/bin/bash
summers:x:1503:1503:Scott Summers:/home/summers:/bin/bash
storm:x:1504:1504:Ororo Munroe:/home/storm:/bin/bash
iceman:x:1505:1505:Bobby Drake:/home/iceman:/bin/bash
kpryde:x:1506:1506:Kitty Pryde:/home/kpryde:/bin/bash
nightcrawler:x:1507:1507:Kurt Wagner:/home/nightcrawler:/bin/bash
logan:x:1508:1508:Logan:/home/logan:/bin/bash
student@openSUSE:~/CPMT-1077> getent group | grep -E '150[1-8]|[57]00[0-7]'
x-men:x:5001:prof_x,beast,jgrey,summers,storm,iceman,kpryde,nightcrawler,logan
teachers:x:5002:prof_x,beast,jgrey
squad1:x:5003:beast,jgrey,summers,storm
squad2:x:5004:iceman,kpryde,nightcrawler,logan
blackbird:x:5005:summers,logan
dangerroom:x:5006:storm,kpryde
cerebro:x:5007:prof_x,beast,jgrey
topsecret:x:7000:prof_x,beast
beast:!:1501:
jgrey:!:1502:
summers:!:1503:
storm:!:1504:
iceman:!:1505:
kpryde:!:1506:
nightcrawler:!:1507:
logan:!:1508:
openSUSE:~ # ls -ld /home/* /bl* /sq* /te* /ce*
drwxrws---  4 summers      blackbird     4096 Sep 30 12:12 /blackbird
drwxrws--T  2 prof_x       cerebro       4096 Sep 30 12:18 /cerebro
drwxr-xr-x  7 beast        beast         4096 Sep 30 11:33 /home/beast
drwxr-xr-x  7 iceman       iceman        4096 Sep 30 11:37 /home/iceman
drwxr-xr-x  7 jgrey        jgrey         4096 Sep 30 11:34 /home/jgrey
drwxr-xr-x  7 kpryde       kpryde        4096 Sep 30 11:37 /home/kpryde
drwxr-xr-x  7 logan        logan         4096 Sep 30 11:38 /home/logan
drwx------  2 root         root         16384 Feb  4  2015 /home/lost+found
drwxr-xr-x  7 nightcrawler nightcrawler  4096 Sep 30 11:38 /home/nightcrawler
drwxr-xr-x  7 prof_x       prof_x        4096 Sep 30 11:32 /home/prof_x
drwxr-xr-x  7 storm        storm         4096 Sep 30 11:36 /home/storm
drwxr-xr-x 20 student      users         4096 Sep 30 12:54 /home/student
drwxr-xr-x  7 summers      summers       4096 Sep 30 11:34 /home/summers
drwx------  3 beast        squad1        4096 Sep 30 11:04 /squad1
drwx------  3 logan        squad2        4096 Sep 30 11:08 /squad2
drwxrws---  2 jgrey        teachers      4096 Sep 30 12:23 /teachers
openSUSE:~ # ls -lR /blackbird/ /cerebro/ /teachers/
/blackbird/:
total 20
drwx--S--- 2 logan   blackbird  4096 Sep 30 12:12 logan
drwx------ 2 root    root      16384 Sep 30 10:55 lost+found
-rw-r----- 1 summers blackbird     0 Sep 30 12:12 summers.log

/blackbird/logan:
total 0

/blackbird/lost+found:
total 0

/cerebro/:
total 0
-rw------- 1 prof_x prof_x 0 Sep 30 12:18 prof_x.log

/teachers/:
total 0
-rw-r----- 1 jgrey teachers 0 Sep 30 12:23 jgrey.log

openSUSE:~ # for XMAN in prof_x beast jgrey summers storm iceman kpryde nightcrawler logan ; do su -l -c 'echo "For XMAN `whoami` the UMASK is `umask` " ; echo "XMAN `whoami` UID, GID, and group memberships: " ; id $XMAN ; echo '  $XMAN  ; done
For XMAN prof_x the UMASK is 0077 
XMAN prof_x UID, GID, and group memberships: 
uid=1500(prof_x) gid=1500(prof_x) groups=1500(prof_x),5001(x-men),5002(teachers),5007(cerebro),7000(topsecret)

For XMAN beast the UMASK is 0077 
XMAN beast UID, GID, and group memberships: 
uid=1501(beast) gid=1501(beast) groups=1501(beast),5001(x-men),5002(teachers),5003(squad1),5007(cerebro),7000(topsecret)

For XMAN jgrey the UMASK is 0027 
XMAN jgrey UID, GID, and group memberships: 
uid=1502(jgrey) gid=1502(jgrey) groups=1502(jgrey),5001(x-men),5002(teachers),5003(squad1),5007(cerebro)

For XMAN summers the UMASK is 0027 
XMAN summers UID, GID, and group memberships: 
uid=1503(summers) gid=1503(summers) groups=1503(summers),5001(x-men),5003(squad1),5005(blackbird)

For XMAN storm the UMASK is 0077 
XMAN storm UID, GID, and group memberships: 
uid=1504(storm) gid=1504(storm) groups=1504(storm),5001(x-men),5003(squad1),5006(dangerroom)

For XMAN iceman the UMASK is 0022 
XMAN iceman UID, GID, and group memberships: 
uid=1505(iceman) gid=1505(iceman) groups=1505(iceman),5001(x-men),5004(squad2)

For XMAN kpryde the UMASK is 0002 
XMAN kpryde UID, GID, and group memberships: 
uid=1506(kpryde) gid=1506(kpryde) groups=1506(kpryde),5001(x-men),5004(squad2),5006(dangerroom)

For XMAN nightcrawler the UMASK is 0022 
XMAN nightcrawler UID, GID, and group memberships: 
uid=1507(nightcrawler) gid=1507(nightcrawler) groups=1507(nightcrawler),5001(x-men),5004(squad2)

For XMAN logan the UMASK is 0077 
XMAN logan UID, GID, and group memberships: 
uid=1508(logan) gid=1508(logan) groups=1508(logan),5001(x-men),5004(squad2),5005(blackbird)
</pre>

