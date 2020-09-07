#!/bin/bash
# Script for setting up a Minecraft Server

../settings.sh

echo "Setting up Serverdirectory..."
mkdir ${servername}

echo "Downloading Scripts from GitHub..."
	cd ${servername}
		wget -O update.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/settings.sh
		wget -O start.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/start.sh
		wget -O restart.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/restart.sh
		wget -O stop.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/stop.sh
		wget -O backup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/backup.sh
		wget -O update.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/update.sh

echo "Making Scripts executable..."
		chmod +x start.sh
		chmod +x restart.sh
		chmod +x stop.sh
		chmod +x backup.sh
		chmod +x update.sh
	cd ${directory}
	
echo "Setting up Backupdirectory..."		
mkdir ${servername}-backups

echo "Script is done"
