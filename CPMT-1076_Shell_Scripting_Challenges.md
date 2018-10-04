#CPMT-1076 Shell Scripting Challenges

Writing shell scripts will be an essential skill for any experienced Linux admin.  To prepare not only for the LPIC-1/Linux+ certifications, but a career supporting and/or administering Linux, you need to learn at least the basics of BASH scripting.  For a complete tutorial on BASH scripting, look online for the "Advanced BASH Scripting Guide" or "ABS Guide" at https://tldp.org.

##Challenge 1
Write a Bash shell script that meets the following requirements:
1. The script must verify it is being run as root and exit with an exit code of 3 if run as a non-root user.
2. The script must ask the user "What permissions do you want to search for?"
3. The script must use `find / -perm $PERMS` to generate a report of files matching the requested permissions both to the screen and in the file /tmp/perms-$PERMS.txt where $PERMS equals the octal permissions provided by the user.
4. All errors from the find command should be discarded and NOT displayed.

##Challenge 2
For extra "awesomeness points," add the following to your script:
1. Validate the permissions entered by the user are valid octal permissions. If not, exit with an exit code of 2.

##Challenge 3
1. Add logic to report "No matching files found." if there are no matches, then exit with an exit code of 1.

##Challenge 4
1. Make verifying the root user into a function.
2. Make the reading of the permissions from the user into a function.
3. Make the process of finding and reporting the files into a function.

##Challenge 5
1. Add an additional question and logic to find only files matching the requested permissions AND owned by a particular user.
