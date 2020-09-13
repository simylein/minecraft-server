#!/bin/bash
# Script for setting up a Minecraft Server

# Feel free to change those variables to somthing you like
servername='minecraft'
homedirectory='/home/simylein/'

echo "Setting up a Serverdirectory..."
mkdir ${servername}

echo "Downloading Scripts from GitHub..."
	cd ${servername}
		wget -O settings.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/settings.sh
		wget -O start.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/start.sh
		wget -O restart.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/restart.sh
		wget -O stop.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/stop.sh
		wget -O backup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/backup.sh
		wget -O update.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/update.sh
		wget -O speedrun.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/speedrun.sh
		wget -O varo.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/varo.sh

echo "Making Scripts executable..."
		chmod +x start.sh
		chmod +x restart.sh
		chmod +x stop.sh
		chmod +x backup.sh
		chmod +x update.sh
		chmod +x speedrun.sh
		chmod +x varo.sh
	cd ${homedirectory}
	
echo "Setting up a Backupdirectory..."		
mkdir ${servername}-backups

echo "Setup is complete"
