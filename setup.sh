#!/bin/bash
# Script for setting up 4 minecraft servers using papermc and screen

echo "Installing papermc and screen..."

	sudo apt install openjdk-11-jre-headless
	sudo apt install screen


echo "Scanning for already existing directorys..."

if [ -d "$server0" ]; then
	echo "Directory server0 already exists! exiting..."
	exit 1
fi

if [ -d "$server1" ]; then
	echo "Directory server1 already exists! exiting..."
	exit 1
fi

if [ -d "$server2" ]; then
	echo "Directory server2 already exists! exiting..."
	exit 1
fi

if [ -d "$server3" ]; then
	echo "Directory server3 already exists! exiting..."
	exit 1
fi

if [ -d "$backups" ]; then
	echo "Directory backups already exists! exiting..."
	exit 1
fi

echo "Setting up directorys..."

mkdir server0
	cd server0
		wget -0 paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download
		wget -0 start.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh
		wget -0 restart.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh
		wget -0 stop.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh
	cd
		

mkdir server1
	cd server1
		wget -0 paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download
		wget -0 start.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh
		wget -0 restart.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh
		wget -0 stop.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh
	cd

mkdir server2
	cd server2
		wget -0 paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download
		wget -0 start.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh
		wget restart.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh
		wget stop.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh
	cd
		
mkdir server3
	cd server3
		wget -0 paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download
		wget -0 start.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh
		wget -0 restart.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh
		wget -0 stop.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh
	cd

mkdir backups
	cd backups
		wget -0 backup.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh
	cd

echo "done"
