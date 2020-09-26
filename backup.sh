#!/bin/bash
# Minecraft Server backup script

. ./settings.sh

echo "Starting Backup..."
echo "Backing up Server Files for Minecraft Server... (This may take a while)"
screen -Rd ${servername} -X stuff "Complete Server Database Backup has started...$(printf '\r')"

date +"%Y-%m-%d"
today=$(date +"%Y-%m-%d")

echo "Backup Location as follows ${backupdirectory}/${servername}${today}"

cp -r ${serverdirectory} ${backupdirectory}/${servername}-${today}

echo "Server Backups finished Succesfully"
screen -Rd ${servername} -X stuff "Complete Server Database Backup has successfully finished!$(printf '\r')"
