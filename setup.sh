#!/bin/bash
# Script for setting up 4 minecraft servers using papermc and screen

echo "Installing papermc and screen..."

	sudo apt install openjdk-11-jre-headless
	sudo apt install screen

echo "Setting up directorys..."

mkdir server0
	cd server0
		wget -q -O paperclip.jar https://papermc.io/api/v1/paper/1.16.1/latest/download
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd
		

mkdir server1
	cd server1
		wget -q -O paperclip.jar https://papermc.io/api/v1/paper/1.16.1/latest/download
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd

mkdir server2
	cd server2
		wget -q -O paperclip.jar https://papermc.io/api/v1/paper/1.16.1/latest/download
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd
		
mkdir server3
	cd server3
		wget -q -O paperclip.jar https://papermc.io/api/v1/paper/1.16.1/latest/download
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd

mkdir backup0

mkdir backup1

mkdir backup2

mkdir backup3


echo "done"
