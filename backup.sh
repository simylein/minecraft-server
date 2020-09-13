#!/bin/bash
# Minecraft Server backup script

. ./settings.sh

echo "Starting Backup..."
echo "Backing up Server Files for Minecraft Server... (This may take a while)"
screen -Rd ${servername} -X stuff "Complete Server Database Backup has started...$(printf '\r')"

date +"%Y-%m-%d"
today=$(date +"%Y-%m-%d")

echo "Backup Location as follows "${directory}${servername}/${servername}${today}"

cp -r ${serverdirectory} ${serverdirectory}${servername}-${today}

echo "Server Backups finished Succesfully"
screen -Rd ${servername} -X stuff "Complete Server Database Backup has successful finished!$(printf '\r')"
