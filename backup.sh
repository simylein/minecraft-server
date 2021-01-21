#!/bin/bash
# minecraft server backup script

# this script is meant to be executed every hour by crontab

# read the server.settings and server.functions
. ./server.settings
. ./server.functions

# change to server directory
cd ${serverdirectory}

# performs backup hourly every hour
PerformHourlyBackup

# performs backup daily if it is 22:??
hours=$(date +"%H")
if [[ ${hours} -eq 22 ]]; then
PerformDailyBackup
fi

# performs backup weekly if it is 22:?? and Sunday
hours=$(date +"%H")
weekday=$(date +"%u")
if [[ ${hours} -eq 22 && ${weekday} -eq 7 ]]; then
PerformWeeklyBackup
fi

# performs backup monthly if it is 22:?? and the first day of a month
hours=$(date +"%H")
dayofmonth=$(date +"%d")
if [[ ${hours} -eq 22 && ${dayofmonth} -eq 1 ]]; then
PerformMonthlyBackup
fi
