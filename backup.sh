#!/bin/bash
# Minecraft Server Backup

echo "Initiated Backup Sequenze for Minecraft Servers"

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

cp -r /server0/ /backups/server0-${today}
cp -r /server1/ /backups/server1-${today}
cp -r /server2/ /backups/server2-${today}
cp -r /server3/ /backups/server3-${today}

echo "Server Backups finished Succesfully"
