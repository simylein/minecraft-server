#!/bin/bash
# Minecraft Server backup script

. ./settings.sh

new=$(date +"%Y-%m-%d")
old=$(date -d "-24 days" +"%Y-%m-%d")

# adding new backup
echo "creating new backup..."
screen -Rd ${servername} -X stuff "say creating new backup...$(printf '\r')"
sleep 2s

cp -r ${serverdirectory} ${backupdirectory}/${servername}-${new}

echo "file available under ${backupdirectory}/${servername}-${new}"
screen -Rd ${servername} -X stuff "say file available under ${backupdirectory}/${servername}-${new}$(printf '\r')"
sleep 2s

# deleting old backup
echo "deleting old backup..."
screen -Rd ${servername} -X stuff "say deleting old backup..."
sleep 2s

rm -r ${backupdirectory}/${servername}-${old}

echo "deleted ${backupdirectory}/${servername}-${old}$(printf '\r')"
screen -Rd ${servername} -X stuff "say deleted ${backupdirectory}/${servername}-${old}$(printf '\r')"
sleep 2s

echo "script is done"
