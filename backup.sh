#!/bin/bash
# Minecraft Server backup script

../settings.sh

echo "Starting Backup..."
echo "Backing up Server Files for Minecraft Server... (this may take a while)"

date +"%Y-%m-%d"
today=$(date +"%Y-%m-%d")

echo "Backup Location as follows "${directory}${servername}/${servername}${today}"

cp -r ${directory}${servername} ${directory}${servername}/${servername}-${today}

echo "Server Backups finished Succesfully"
