# Created by Miguel Angel <miguel51atlas@gmail.com>
# Send report trough mail.

#!/bin/bash

TEMP_FILE=$(mktemp /tmp/PRINTER.XXXXXX) #TEMP FILES, WILL BE DELETED
TEMP_TABLE=$(mktemp /tmp/TABLE.XXXXXX)
RECEIPENT="some.mail.com"

#PRINTER_NAME = Get the printer name in order to compare with the pending jobs.
#PRINTER_DATE = Print the date of each job.
#PRINT_APP_NAME = Print the job name which is easily to find by Oracle teams. Using grep to avoid some output that is not necessary to print.

PRINTER_NAME=`lpstat -o -W "not-completed" | awk -F "-" '{ print $1" "}'`
PRINTER_DATE=`lpstat -o -W "not-completed" | awk -F " " '{ print $4"/"$5"/"$6"/"$7"-"$8 $9"-"$10}'`
PRINTER_APP_NAME=`lpq -a | grep -v "(s)" | awk '{ print $4" "}'`

#Paste each variable.
FINAL_OUTPUT=`paste <(echo "$PRINTER_NAME") <(echo "$PRINTER_APP_NAME") <(echo "$PRINTER_DATE") > $TEMP_FILE`

#Head names for the table.
sed -i '1iPRINTER_NAME JOB_NAME DATE_JOB' $TEMP_FILE

#set -x

##### TABLE SECTION #########
if [ -f "${TEMP_FILE}" ]
        then
                printf "<table border=\"1\">"
                sed "s/ /<\/td><td>/g" $TEMP_FILE | while read line
                        do
                                printf "<tr><td>${line}</td></tr>"
                done
                printf "</table>"
                echo

fi > $TEMP_TABLE

#set +x

#### PRINTING TO CONSOLE BEFORE DELETE ######
cat "$TEMP_FILE" | column -t
rm -f $TEMP_FILE

#mutt for send mail with the table.
mutt -e "my_hdr Content-Type: text/html" $RECEIPENT -s "Pending Jobs - ALERT" < $TEMP_TABLE

rm -f $TEMP_TABLE
