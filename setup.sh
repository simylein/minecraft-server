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

if [ -d "$backup0" ]; then
	echo "Directory backups already exists! exiting..."
	exit 1
fi

if [ -d "$backup1" ]; then
	echo "Directory backups already exists! exiting..."
	exit 1
fi

if [ -d "$backup2" ]; then
	echo "Directory backups already exists! exiting..."
	exit 1
fi

if [ -d "$backup3" ]; then
	echo "Directory backups already exists! exiting..."
	exit 1
fi

echo "Setting up directorys..."

mkdir server0
	cd server0
		wget -0 https://papermc.io/api/v1/paper/1.16.1/latest/download paperclip.jar
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd
		

mkdir server1
	cd server1
		wget -0 https://papermc.io/api/v1/paper/1.16.1/latest/download paperclip.jar
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd

mkdir server2
	cd server2
		wget -0 https://papermc.io/api/v1/paper/1.16.1/latest/download paperclip.jar
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/start.sh start.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/restart.sh restart.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/stop.sh stop.sh
		wget https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/backup.sh backup.sh
	cd
		
mkdir server3
	cd server3
		wget -0 https://papermc.io/api/v1/paper/1.16.1/latest/download paperclip.jar
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
