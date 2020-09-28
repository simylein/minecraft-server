#!/bin/bash
# Minecraft Server backup script

. ./settings.sh

new=$(date +"%Y-%m-%d")
old=$(date -d "-24 days" +"%Y-%m-%d")

# adding new backup
echo "creating new backup..."
screen -Rd ${servername} -X stuff "say creating new backup...$(printf '\r')"

cp -r ${serverdirectory} ${backupdirectory}/${servername}-${new}

echo "file available under ${backupdirectory}/${servername}-${new}"
screen -Rd ${servername} -X stuff "say file available under ${backupdirectory}/${servername}-${new}$(printf '\r')"

# deleting old backup
echo "deleting old backup..."
screen -Rd ${sevrername} -X stuff "say deleting old backup..."

rm -r ${serverdirectory}/${servername}-${old}

echo "deleted ${serverdirectory}/${servername}-${old}$(printf '\r')"
screen -Rd ${sevrername} -X stuff "say deleted ${serverdirectory}/${servername}-${old}$(printf '\r')"

