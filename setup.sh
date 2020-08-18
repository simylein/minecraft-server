#!/bin/bash
# Script for setting up 4 minecraft servers using papermc and screen

echo "Installing papermc and screen..."

	sudo apt install openjdk-11-jre-headless
	sudo apt install screen

echo "Setting up directorys with Scripts..."

mkdir server0
	cd server0
		wget -O paperclip.jar https://papermc.io/api/v1/paper/1.16.1/latest/download
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd
		

mkdir server1
	cd server1
		wget -O paperclip.jar https://papermc.io/api/v1/paper/1.16.1/latest/download
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd

mkdir server2
	cd server2
		wget -O paperclip.jar https://papermc.io/api/v1/paper/1.16.1/latest/download
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd
		
mkdir server3
	cd server3
		wget -O paperclip.jar https://papermc.io/api/v1/paper/1.16.1/latest/download
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget -O https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd

mkdir backup0

mkdir backup1

mkdir backup2

mkdir backup3


echo "done"
