#!/bin/bash

# Minecraft Server backup script

echo "Initiated Backup Sequenze for Minecraft Server"

echo "Changing Directory..." 
cd

echo "Starting Backup..."

echo "Backing up Server Files for Minecraft Server... (this may take a while)"

date +"%FORMAT_STRING"
date +"%m_%d_%Y"
date +"%Y-%m-%d"

var=$(date +"%FORMAT_STRING")
now=$(date +"%m_%d_%Y")
printf "%s\n" $now
today=$(date +"%Y-%m-%d")

printf "Backup Location as follows '%s'\n" "/backups/${today}"

cp -r /minecraft/ /backups/minecraft-${today}

echo "Server Backups finished Succesfully"
