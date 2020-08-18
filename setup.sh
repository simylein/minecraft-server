#!/bin/bash

# Script for setting up a Minecraft Server using papermc and screen

echo "Installing openjdk and screen..."

	sudo apt install openjdk-11-jre-headless
	sudo apt install screen

echo "Setting up directorys with Scripts..."

mkdir minecraft
	cd minecraft
		wget -O paperclip.jar https://papermc.io/api/v1/paper/1.16.1/latest/download
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/update.sh update.sh
	cd
		
mkdir backups

echo "done"
