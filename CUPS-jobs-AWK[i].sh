#!/bin/bash

# Created by Miguel Angel. <miguel51atlas@gmail.com>
# Based on CUPS-jobs.sh script. This moddification process the data and gives you a nice table and added another column based in the timezone that you are located.

TEMP_FILE=$(mktemp /tmp/PRINTER.XXXXXX) #TEMP FILES, WILL BE DELETED
TEMP_TABLE=$(mktemp /tmp/TABLE.XXXXXX)

#PRINTER_NAME = Get the printer name in order to compare with the pending jobs.
#PRINTER_DATE = Print the date of each job.
#PRINT_APP_NAME = Print the job name which is easily to find by Oracle teams. Using grep to avoid some output that is not necessary to print.
PRINTER_NAME=`lpstat -o -W "not-completed" | awk -F "-" '{ print $1" "}'`
PRINTER_DATE=`lpstat -o -W "not-completed" | awk -F " " '{ print $4"/"$5"/"$6"/"$7"-"$8 $9"-"$10}'`
PRINTER_APP_NAME=`lpq -a | grep -v "(s)" | awk '{ print $4" "}'`
SUM_GREECE=`lpstat -o -W "not-completed" | awk -F " " '{ print $4"/"$5"/"$6"/"$7"-"$8 $9"-"$10}' | awk -F'-' '{ split ($2,a,":"); { print a[1]+2":" a[2]":" a[3] a[4]"-EET" } }'`
PRE_GREECE_TIME=`lpstat -o -W "not-completed" | awk -F " " '{ print $4"/"$5"/"$6"/"$7"-"$8 $9"-"$10}' | awk -F'-' '{ print $1 }'`
FINAL_GREECE_TIME=`paste <(echo "$PRE_GREECE_TIME") <(echo "$SUM_GREECE")`
#Paste each variable.
FINAL_OUTPUT=`paste <(echo "$PRINTER_NAME") <(echo "$PRINTER_APP_NAME") <(echo "$PRINTER_DATE") <(echo "$FINAL_GREECE_TIME")| sort > $TEMP_FILE`

#Head names for the table.
sed -i '1iPRINTER_NAME JOB_NAME DATE_JOB GREECE_TIME' $TEMP_FILE

#fi > $TEMP_TABLE
#### PRINTING TO CONSOLE BEFORE DELETE ######
cat "$TEMP_FILE" | column -t | grep "$$$"

cat "$TEMP_FILE" | column -t | grep "$$$" > /home/$USER/taxspooler.txt
