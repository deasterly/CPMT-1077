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

