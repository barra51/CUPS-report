#!/bin/bash

# Created by Miguel Angel H. <miguel51atlas@gmail.com>
# Support any version of CUPS. Optimized to work with Redhat based distros.

PRINTER_APP_NAME=`lpq -a | grep -v "(s)" | awk '{ print $4" "}'`
OS_USER=`lpq -a | grep -v "(s)" | awk '{ print $2 }'`
DISK_USAGE=`lpq -a | grep -v "(s)" | awk '{ print $5 / 1000"Kb"}'`
TEMP_NOT_C=$(mktemp /tmp/TEMP_NOT_C.XXXXXX)
TEMP_C=$(mktemp /tmp/TEMP_C.XXXXXX)
COUNTER=`lpstat -o | wc -l`

not-completed() {
#Processing only NOT completed jobs. They are still in the queue.


echo "          *******************************************************************"
echo "                          Not completed jobs                                *"
echo "          *******************************************************************"



echo "Total pending count is:"  $COUNTER

PRINTER_NAME=`lpstat -o -W "not-completed" | awk -F "-" '{ print $1" "}'`
PRINTER_DATE=`lpstat -o -W "not-completed" | awk -F " " '{ print $4"/"$5"/"$6"/"$7"-"$8 $9"-"$10}'`
ID_N_C=`lpstat -o -W "not-completed" | awk '{ print $1 }' | awk -F'-' '{ print $2 }'`
FIN_N_C=`paste <(echo "$PRINTER_NAME") <(echo "$PRINTER_APP_NAME") <(echo "$ID_N_C") <(echo "$OS_USER") <(echo "$DISK_USAGE") <(echo "$PRINTER_DATE") > "$TEMP_NOT_C"`
sed -i '1iPRINTER OS_JOB ID(OS) LINUXUSER USAGE DATE' $TEMP_NOT_C
cat $TEMP_NOT_C | column -t
rm -f $TEMP_NOT_C
}

completed() {
#Processing only COMPLETED jobs. They were processed and sent to optio/local socket.

echo "          *******************************************************************"
echo "                                       Completed jobs.                      *"
echo "          *******************************************************************"


PRINTER_NAME=`lpstat -o -W "completed" | awk -F "-" '{ print $1" "}'`
PRINTER_DATE=`lpstat -o -W "completed" | awk -F " " '{ print $4"/"$5"/"$6"/"$7"-"$8 $9"-"$10}'`
ID_C=`lpstat -o -W "completed" | awk '{ print $1 }' | awk -F'-' '{ print $2 }'`
FIN_C=`paste <(echo "$PRINTER_NAME") <(echo "$PRINTER_APP_NAME") <(echo "$ID_C") <(echo "$OS_USER") <(echo "$DISK_USAGE") <(echo "$PRINTER_DATE") > "$TEMP_C"`
sed -i '1iPRINTER OS_JOB ID(OS) LINUXUSER USAGE DATE' $TEMP_C
cat $TEMP_C | column -t
rm -f $TEMP_C
}

not-completed
completed
