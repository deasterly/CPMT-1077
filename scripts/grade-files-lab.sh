#!/bin/bash -i

### FUNCTIONS ###

cannot_be_root() {
	if [ $USER  == root ]; then
		echo "This script should be run as a regular user. The current user is $USER ."
		exit 1
	fi
}

must_be_root() {
	if [ $USER  != root ]; then
		echo "This script should be run as root. The current user is $USER ."
		exit 1
	fi
}

must_have_sudo(){
	cannot_be_root
	WHEEL="$(id $USER | grep 'wheel' | wc -l)"
	if [ $WHEEL = 0 ]; then
		echo "This script requires the use of 'sudo' and user $USER does not appear to be in the wheel group"
		exit 1
	fi
}

check_for_group(){
	DO_DEBUG="0"
	SCRIPT_DIR="/usr/local/bin"
	DATA_DIR="${SCRIPT_DIR}/DATA_FILES"
	GROUP_DATA="${DATA_DIR}/groups_data.txt"
	echo "This will check to make sure the groups in Table 1 were created with the correct names and GIDs."
	echo "NOTE:  This will not check to make sure the correct users are in these groups."

	#if [ "$DO_DEBUG" -eq "1" ]; then echo 'bridge|5001\nofficers|5002\ntactical|5003\nscience|5004\nengineering|5005\ncomms|5006\nmedical|5007\ntopsecret|7000' ; fi
	if [ "$DO_DEBUG" -eq "1" ]; then cat $GROUP_DATA ; fi

	echo 
	
	for GROUP_NAME in `cat $GROUP_DATA | cut -d'|' -f1 ` ; do
		unset GROUP_EXISTS
		unset THIS_GROUP
		unset GOOD_GID
		unset REAL_GID

		GROUP_GID=`grep $GROUP_NAME $GROUP_DATA | cut -d'|' -f2`
		if [ "$DO_DEBUG" -eq "1" ]; then echo "GROUP_NAME is $GROUP_NAME and GROUP_GID is $GROUP_GID " ; fi
		THIS_GROUP=`getent group $GROUP_NAME`
		if [ "$DO_DEBUG" -eq "1" ]; then echo "THIS_GROUP details: $THIS_GROUP" ; fi
		if [ `getent group $GROUP_NAME | wc -l` -eq "1" ] ; then
			GROUP_EXISTS="1"
			echo -n "Group $GROUP_NAME exists "
		else
			GROUP_EXISTS="0"
			echo -n "Group $GROUP_NAME doesn't appear to exist.  "
		fi
		
		GOOD_GID=$GROUP_GID
		REAL_GID=`getent group $GROUP_NAME | cut -d':' -f3`
		if [ "$DO_DEBUG" -eq "1" ]; then echo "GROUP_EXISTS is $GROUP_EXISTS, GOOD_GID is $GOOD_GID and REAL_GID is $REAL_GID" ; fi
		
		if [ "$REAL_GID" == "$GOOD_GID" ] && [ "$GROUP_EXISTS" -eq "1" ]; then
			echo "and $GROUP_NAME has a GID of $GOOD_GID. You have created this group correctly. Well done! "
		
		elif [ "$GROUP_EXISTS" -eq "0" ]; then
			echo "If you believe you have already created $GROUP_NAME, then check /etc/group to verify the spelling and case."
			echo "If you need to change the name or GID of a group, remember 'groupmod --help'."
		
		else 
			echo "but $GROUP_NAME has a GID of $REAL_GID rather than $GOOD_GID."
			# echo "Use 'groupmod --help' to change the GID of $GROUP_NAME."

			
		fi  
	echo "Done checking for group $GROUP_NAME."
	echo 
	done
}

check_for_user(){
	DO_DEBUG="0"
	SCRIPT_DIR="/usr/local/bin"
	DATA_DIR="${SCRIPT_DIR}/DATA_FILES"
	USER_DATA="${DATA_DIR}/users_data.txt"
	echo "This will check to make sure the users in Table 2 were created with the correct names, UIDs, group memberships, and umask permissions.."

		#if [ "$DO_DEBUG" -eq "1" ]; then echo -e 'jkirk|James T. Kirk|1500|1500|jkirk,wheel,bridge,officers,topsecret|0077|\nspock|Spock|1501|1501|spock,wheel,bridge,officers,science|0027|\nmscott|Montgomery Scott|1502|1502|mscott,officers,engineering,topsecret|0027|\npchekov|Pavel Chekov|1503|1503|pchekov,bridge,tactical,engineering|0022|\nnuhura|Nyota Uhura|1504|1504|nuhura,bridge,comms|0022|\nhsulu|Hikaru Sulu|1505|1505|hsulu,bridge,tactical,science|0022|\njrand|Janice Rand|1506|1506|jrand,bridge,comms|0022|\nlmccoy|Dr. Leonard McCoy|1507|1507|lmccoy,medical,science|0077|\ncchapel|Christine Chapel|1508|1508|cchapel,medical|0027|' ; fi
		if [ "$DO_DEBUG" -eq "1" ]; then cat $USER_DATA ; fi

	echo 
	
	for USER_NAME in `cat $USER_DATA | cut -d'|' -f1 ` ; do
		unset USER_EXISTS
		unset THIS_USER
		unset GOOD_UID
		unset REAL_UID
		UID_CORRECT="0"
		unset GOOD_PGID
		unset REAL_PGID
		PGID_CORRECT="0"
		unset GOOD_GECOS
		unset REAL_GECOS
		GECOS_CORRECT="0"
		unset GOOD_GROUPS
		unset REAL_GROUPS
		GROUPS_CORRECT="0"
		unset GOOD_UMASK
		unset REAL_UMASK
		UMASK_CORRECT="0"
		HAS_HOMEDIR="0"

		GOOD_UID=`grep $USER_NAME $USER_DATA | cut -d'|' -f3`
		GOOD_PGID=`grep $USER_NAME $USER_DATA | cut -d'|' -f4`
		GOOD_GECOS=`grep $USER_NAME $USER_DATA | cut -d'|' -f2`
		GOOD_GROUPS=`grep $USER_NAME $USER_DATA | cut -d'|' -f5 | tr ',' '\n' | sort`
		GOOD_UMASK=`grep $USER_NAME $USER_DATA | cut -d'|' -f6`

		if [ "$DO_DEBUG" -eq "1" ]; then echo "USER_NAME is $USER_NAME and USER_UID is $USER_UID " ; fi
		THIS_USER=`getent passwd $USER_NAME`
		if [ "$DO_DEBUG" -eq "1" ]; then echo "THIS_USER details: $THIS_USER" ; fi


		if [ `getent passwd $USER_NAME | wc -l` -eq "1" ] ; then
			USER_EXISTS="1"
			echo -n "User $USER_NAME exists "
		else
			USER_EXISTS="0"
			echo -n "User $USER_NAME doesn't appear to exist.  "
		fi
		
		REAL_UID=`getent passwd $USER_NAME | cut -d':' -f3`
		REAL_PGID=`getent passwd $USER_NAME | cut -d':' -f4`
		REAL_GECOS=`getent passwd $USER_NAME | cut -d':' -f5`
		REAL_GROUPS=`id -n -G $USER_NAME | tr ' ' '\n' | sort`
		REAL_UMASK=`su -lc 'umask' $USER_NAME`
		if [ "$DO_DEBUG" -eq "1" ]; then echo "USER_EXISTS is $USER_EXISTS, GOOD_UID is $GOOD_UID and REAL_UID is $REAL_UID. GOOD_PGID is $GOOD_PGID and REAL_PGID is $REAL_PGID. GOOD_GECOS is $GOOD_GECOS and REAL_GECOS is $REAL_GECOS. GOOD_GROUPS is $GOOD_GROUPS and REAL_GROUPS is $REAL_GROUPS. GOOD_UMASK is $GOOD_UMASK and REAL_UMASK is $REAL_UMASK." ; fi
		
		if [ "$REAL_UID" == "$GOOD_UID" ] && [ "$USER_EXISTS" -eq "1" ]; then
			echo "and $USER_NAME has a UID of $GOOD_UID."

			# Don't want to bother with all these tests if the user/UID aren't right...

			if [ "$REAL_PGID" == "$GOOD_PGID" ]; then
				PGID_CORRECT="1"
				echo "Primary GID of $REAL_PGID is correct."
			else
				echo "Primagy GID of $REAL_PGID should be $GOOD_PGID."
			fi

			if [ "$REAL_GECOS" == "$GOOD_GECOS" ]; then
				GECOS_CORRECT="1"
				echo "GECOS comment of $REAL_GECOS is correct."
			else
				echo "GECOS comment of $REAL_GECOS should be $GOOD_GECOS."
			fi

			if [ "$REAL_GROUPS" == "$GOOD_GROUPS" ]; then
				GROUPS_CORRECT="1"
				echo "Group memberships are correct."
			else
				echo -e "Group memberships are incorrect. \n"
			        echo -e "Current groups: \n$REAL_GROUPS\n"
			        echo -e	"Should be a member of: \n$GOOD_GROUPS"
			fi

			if [ "$REAL_UMASK" == "$GOOD_UMASK" ]; then
				UMASK_CORRECT="1"
				echo "Permissions umask of $REAL_UMASK is correct."
			else
				echo "Permissions umask of $REAL_UMASK should be $GOOD_UMASK."
			fi

			if [ -d /home/$USER_NAME ]; then
				HAS_HOMEDIR="1"
				echo "Home directory exists at /home/$USER_NAME."
			fi

			if [ "$PGID_CORRECT" -eq "1" ] && [ "$GECOS_CORRECT" -eq "1" ] && [ "$GROUPS_CORRECT" -eq "1" ] && [ "$UMASK_CORRECT" -eq "1" ] && [ "$HAS_HOMEDIR" -eq "1" ]; then 
				echo "You have created the $USER_NAME account perfectly!  Well done! "
			else
				echo "You still need to fix one or more things about the $USER_NAME account."
			fi

			#  End the stuff that only happens if the user exists with the right UID...



		elif [ "$USER_EXISTS" -eq "0" ]; then
			echo "If you believe you have already created $USER_NAME, then check /etc/passwd to verify the spelling and case."
			echo "If you need to change the name or UID of a user, remember 'usermod --help'."
		
		else 
			echo "but $USER_NAME has a UID of $REAL_UID rather than $GOOD_UID."
			# echo "Use 'usermod --help' to change the UID of $USER_NAME."
			
		fi  
		

	echo "Done checking for user $USER_NAME."
	echo 
	done
}



check_for_files(){
	DO_DEBUG="0"
	SCRIPT_DIR="/usr/local/bin"
	DATA_DIR="${SCRIPT_DIR}/DATA_FILES"
	FILE_DATA="${DATA_DIR}/files_data.txt"
	echo "This will check to make sure the files in Table 3 were created with the correct owner, group, and permissions."

		if [ "$DO_DEBUG" -eq "1" ]; then cat $FILE_DATA ; fi

	echo 
	
	for FILE_NAME in `cat $FILE_DATA | cut -d'|' -f1 ` ; do
		unset FILE_EXISTS
		unset THIS_FILE
		unset GOOD_UID
		unset REAL_UID
		UID_CORRECT="0"
		unset GOOD_GID
		unset REAL_GID
		GID_CORRECT="0"
		unset GOOD_PERMS
		unset REAL_PERMS
		PERMS_CORRECT="0"

		GOOD_UID=`grep -Ew $FILE_NAME $FILE_DATA | cut -d'|' -f2`
		GOOD_GID=`grep -Ew $FILE_NAME $FILE_DATA | cut -d'|' -f3`
		GOOD_PERMS=`grep -Ew $FILE_NAME $FILE_DATA | cut -d'|' -f4`
 
		if [ "$DO_DEBUG" -eq "1" ]; then echo "FILE_NAME is $FILE_NAME and GOOD_UID is $GOOD_UID " ; fi
		THIS_FILE=`ls -ld $FILE_NAME`
		if [ "$DO_DEBUG" -eq "1" ]; then echo "THIS_FILE details: $THIS_FILE" ; fi


		if [ -e $FILE_NAME ] ; then
			FILE_EXISTS="1"
			echo -n "File or directory $FILE_NAME exists "
		else
			FILE_EXISTS="0"
			echo -n "File or directory $FILE_NAME doesn't appear to exist.  "
		fi
		
		REAL_UID=`stat -c %U $FILE_NAME`
		REAL_GID=`stat -c %G $FILE_NAME`
		REAL_PERMS=`stat -c %A $FILE_NAME`
		if [ "$DO_DEBUG" -eq "1" ]; then echo "FILE_EXISTS is $FILE_EXISTS, GOOD_UID is $GOOD_UID and REAL_UID is $REAL_UID. GOOD_GID is $GOOD_GID and REAL_GID is $REAL_GID. GOOD_PERMS is $GOOD_PERMS and REAL_PERMS is $REAL_PERMS." ; fi
		
		if [ "$REAL_UID" == "$GOOD_UID" ] && [ "$FILE_EXISTS" -eq "1" ]; then 
			echo "and is owned by user $GOOD_UID."

			# Don't want to bother with all these tests if the files/UID aren't right...

			if [ "$REAL_GID" == "$GOOD_GID" ]; then
				GID_CORRECT="1"
				echo "Group owner of $REAL_GID is correct."
			else
				echo "Group owner of $REAL_GID should be $GOOD_GID."
			fi

			if [ "$REAL_PERMS" == "$GOOD_PERMS" ]; then
				PERMS_CORRECT="1"
				echo "Permissions of $REAL_PERMS are correct."
			else
				echo "Permissions of $REAL_PERMS should be $GOOD_PERMS."
			fi

			if [ "$GID_CORRECT" -eq "1" ] && [ "$PERMS_CORRECT" -eq "1" ]; then 
				echo "You have configured $FILE_NAME perfectly!  Well done! "
			else
				echo "You still need to fix one or more things about $FILE_NAME."
			fi

			#  End the stuff that only happens if the files exists with the right UID...



		elif [ "$FILE_EXISTS" -eq "0" ]; then
			echo "If you believe you have already created $FILE_NAME, then check the spelling and case."
			echo "If you need to change the owner, group, or permissions of a file/directory, remember 'chown --help' and 'chmod --help'."
		
		else 
			echo "but $FILE_NAME is owned by $REAL_UID rather than $GOOD_UID."
			# echo "Use 'chown --help' to change the owner of $FILE_NAME."
			
		fi  
		

	echo "Done checking for $FILE_NAME."
	echo 
	done
}



tidy_columns(){
	if [ $# != 2 ]; then 
		echo "ERROR: function tidy_columns called with $# arguments"
		exit 1
	fi
	# Call with ARG1=target directory to list and ARG2=output file (e.g. $LSFILE or $PERMFILE1)
	# Remove dates and eliminate uneven whitespace breaks between fields
	ls -lShRA --time-style=+ $1 | tr -s ' ' > $2
}

create_files() {
	for THISFILE in {$LSFILE1,$LSFILE2}; do
		if [ ! -f $THISFILE ]; then
			touch $THISFILE 
		fi ;
	done
	if [ $USER  != student ]; then
		REFFILE2="/tmp/.$(basename $REFFILE).${USER}"
		if [ ! -f $REFFILE2 ]; then
			touch $REFFILE2
			sed -e s/student/$USER/g $REFFILE > $REFFILE2
		fi
	else
		REFFILE2="$REFFILE"
	fi
	
	tidy_columns $FILEDIR $LSFILE1
}

verify_setup(){
	# Make sure the lab setup script was run first...
	if [ ! -d $FILEDIR ]; then
		echo "I cannot seem to find $FILEDIR."
		echo "Has $FILEDIR been renamed or deleted?"
		echo "You may need to run this lab's accompanying setup script again."
		exit 1
	fi
}

termwidth_warn(){
	if [ $COLUMNS -lt 100 ]; then
		echo "This script works best with terminal width >= 100 columns. Current width is $COLUMNS."
		echo "Please adjust your terminal or font settings if output is difficult to read."
	fi
}

check_files(){
	# Create a fixed-width side-by-side comparison and determine success or incompletion
	WIDTH=100
	SUFFIX=""
	VERB="is"
	ARTICLE="a "
	#echo "WIDTH = $WIDTH    REFFILE2 = $REFFILE2     LSFILE1 = $LSFILE1   LSFILE2 = $LSFILE2"
	echo "-----------------------------------------------------------------------------------------------"
	sdiff -s -w $WIDTH $REFFILE2 $LSFILE1 | tee $LSFILE2
	echo "-----------------------------------------------------------------------------------------------"
	(( FILESTOFIX= `cat $LSFILE2 |grep -v '^total' | wc -l` ))

	if [ $FILESTOFIX -ge 1 ]; then 
		if [ $FILESTOFIX -gt 1 ]; then 
			SUFFIX="s"
			VERB="are"
			ARTICLE=""
		fi
		echo "|---------------------------------------------------------------------------------------------|"
		echo "|     THESE THINGS MAY BE MISSING OR NEED     | SOME OF THESE FILES ARE IN THE WRONG PLACE(S) |"
		echo "|    TO BE COPIED IF THEY ARE FOLLOWED  BY    |  NOTE:   ALL CONTENTS OF DIRS W/ EXTRA FILES  |"
		echo "|      THE '<' CHARACTER. READ CAREFULLY!     |   MAY BE SHOWN! (NOT JUST EXTRANEOUS FILES)   |"
		echo "|---------------------------------------------------------------------------------------------|"
		echo "|    NOTE: FILES IN THE CORRECT LOCATION(S) ONLY ARE REMOVED FROM THE OUTPUT OF THIS SCRIPT   |"
		echo "|---------------------------------------------------------------------------------------------|"
		echo "There $VERB still ${ARTICLE}file${SUFFIX} in $FILEDIR that $VERB either missing or in the wrong location."
		echo "Run this script again after correcting the error$SUFFIX in $FILEDIR."
		echo "READ THE LAB GUIDE _CAREFULLY_ AND BE SURE TO UNDERSTAND THE TASKS. COPY VS MOVE MATTERS!"
		echo "This script uses 'sdiff' for comparison.  Please refer to the 'diffutils' documentation for "
		echo "more information about how to interpret the output."
	else
		echo "It appears you have successfully completed this lab exercise. You are AWESOME! "
	fi
}

backup_filedir(){
	NOW="$(date +%s)"
	echo "$FILEDIR already exists. Renaming to ${FILEDIR}.${NOW}"
	mv $FILEDIR ${FILEDIR}.${NOW}
}

create_filedir() {
	echo "Creating files in $FILEDIR..."
	# Just in case someone didn't mean to run this script twice...
	if [ -d $FILEDIR ]; then
		backup_filedir
	fi
	mkdir $FILEDIR
}

create_lab_files() {
	for i in {1..4}; 
		do echo "FILENAME: $FILEDIR/document$i.txt" > $FILEDIR/document$i.txt ; 
		# Just add some nonsense text so the files aren't empty...
		for h in {2..50}; 
			do echo "Line $h of document$i.txt..." >> $FILEDIR/document$i.txt ; 
		done ; 
	done

	for j in {1..4}; 
		# Create "random" junk data to take up space - larger every time!
		do dd if=/dev/urandom of=$FILEDIR/blob$j bs=1M count=$j &>/dev/null ; 
	done

	for k in {1..4}; 
		# More nonsense text just for padding...
		do for l in $(head -n 500 /usr/share/dict/words); 
			do echo "$k $l" >> $FILEDIR/.hidden$k.txt ; 
		done ;
		gzip $FILEDIR/.hidden$k.txt ;
	done
	# Make one hidden file bigger
	zcat $FILEDIR/.hidden{1..4}.txt.gz >> $FILEDIR/.hidden0.txt 
	gzip $FILEDIR/.hidden0.txt

	# Grab some irregularly named image files of varying sizes...
	cp /usr/share/backgrounds/gnome/*.jpg $FILEDIR

	echo "Files created in $FILEDIR" 
}

create_textfiles(){
	for i in {1..5}; 
	    	do echo "FILENAME: textfile$i.txt" > $FILEDIR/textfile$i.txt 
    		# Just add some nonsense text so the files aren't empty...
    		for h in {2..20}; 
    		    do echo "Line $h of textfile$i.txt..." >> $FILEDIR/textfile$i.txt  
    		done ;
    		sudo chown 2$i:2$i $FILEDIR/textfile$i.txt 
	done
}

create_datafiles(){
	for j in {1..5}; 
    		# Create "random" junk data to take up space - larger every time!
    		do dd if=/dev/urandom of=$FILEDIR/data$j bs=2M count=$j &>/dev/null 
    		chmod 5$j$j $FILEDIR/data$j 
    		sudo chown student:$j$j $FILEDIR/data$j
	done
}

create_gzipfiles(){
	for k in {1..7}; 
    		# More nonsense text just for padding...
    		do for l in $(head -n 5$k$k /usr/share/dict/words) 
        		do echo "$k $l" >> $FILEDIR/gzipped66$k.txt 
    		done; 
    		gzip $FILEDIR/gzipped66$k.txt 
    		sudo chown 1$k:550$k $FILEDIR/gzipped66$k.txt.gz
	done
}

show_lab_files(){
	echo "The following files have been created in $FILEDIR:"
	for m in {1..80}; do echo -n "#" ; done 
	echo ""
	echo "$(ls -lSh -T12 $FILEDIR)"
	ls -lSh --time-style=+ $FILEDIR  2>/dev/null | tr -s ' ' | tail -n +2 > $PERMFILE1
	for m in {1..80}; do echo -n "#" ; done
}

check_perms(){
	WIDTH=100
	VERB="is"
	SUFFIX=""
	ARTICLE=""
	#echo "WIDTH = $WIDTH    REFFILE = $REFFILE     PERMFILE1 = $PERMFILE1   PERMFILE2 = $PERMFILE2"
	# Remove the $FILEDIR from line 1 of $PERMFILE1
	BKUPFILE=/tmp/.temp.$USER
	cp $PERMFILE1 $BKUPFILE
	tail -n +2 $BKUPFILE > $PERMFILE1
	rm -f $BKUPFILE
	# Create a fixed-width side-by-side comparison and determine success or incompletion
	sdiff -s -w $WIDTH $REFFILE $PERMFILE1 | tee $PERMFILE2
	(( PERMSTOFIX= `cat $PERMFILE2 |grep -v '^total' | wc -l` ))
	if [ $PERMSTOFIX -ge 1 ]; then 
		echo "-----------------------------------------------------------------------------------------------"
		echo "|  CHANGE THE PERMISSIONS TO LOOK LIKE THIS   |   THE CURRENT PERMISSIONS AND OWNERSHIP ARE   |"
		echo "|  COLUMN AND RUN THIS SCRIPT AGAIN TO TEST   | DISPLAYED IN THIS COLUMN. FILES WITH CORRECT  |"
		echo "|        YOUR RESULTS. READ CAREFULLY!        |  OWNERSHIP/PERMISSIONS ARE NOT LISTED HERE.   |"
		echo "-----------------------------------------------------------------------------------------------"
		if [ $PERMSTOFIX -gt 1  ]; then 
			VERB="are" 
			SUFFIX="s" 
		fi 
		echo "This script uses \"sdiff\" for comparison.  Please refer to \"pinfo sdiff\" for more information."
		echo "There $VERB $PERMSTOFIX file$SUFFIX in $FILEDIR with incorrent ownership or permissions."
		echo "Run this script again after correcting the previous error$SUFFIX in $FILEDIR."
	else
		echo "It appears you have successfully completed this lab exercise. WAY TO GO!" 
	fi
}


### MAIN ###

must_be_root

check_for_files



