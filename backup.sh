#!/bin/bash
# minecraft server backup script

# read the settings
. ./settings.sh

# change to server directory
cd ${serverdirectory}

# adding new backup
echo "creating new backup..."
screen -Rd ${servername} -X stuff "say creating new backup...$(printf '\r')"

cp -r ${serverdirectory} ${backupdirectory}/${servername}-${new}

# output file location of new backup
echo "file available under ${backupdirectory}/${servername}-${new}"
screen -Rd ${servername} -X stuff "say file available under ${backupdirectory}/${servername}-${new}$(printf '\r')"

# deleting old backup
echo "deleting old backup..."
screen -Rd ${servername} -X stuff "say deleting old backup...$(printf '\r')"

rm -r ${backupdirectory}/${servername}-${old}

# output deleted backup location
echo "deleted ${backupdirectory}/${servername}-${old}"
screen -Rd ${servername} -X stuff "say deleted ${backupdirectory}/${servername}-${old}$(printf '\r')"
