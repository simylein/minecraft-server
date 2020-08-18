#!/bin/bash
# Script for setting up 4 minecraft servers using papermc and screen

test 

mkdir server0
	cd server0
		wget -O paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download
		wget -0 start.sh https://github.com/simylein/Minecraft_Server/blob/master/start.sh
		wget -0 restart.sh https://github.com/simylein/Minecraft_Server/blob/master/restart.sh
		wget -0 stop.sh https://github.com/simylein/Minecraft_Server/blob/master/stop.sh		
	cd
		

mkdir server1
	cd server1
		wget -O paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download
		wget -0 start.sh https://github.com/simylein/Minecraft_Server/blob/master/start.sh
		wget -0 restart.sh https://github.com/simylein/Minecraft_Server/blob/master/restart.sh
		wget -0 stop.sh https://github.com/simylein/Minecraft_Server/blob/master/stop.sh		
	cd

mkdir server2
	cd server2
		wget -O paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download
		wget -0 start.sh https://github.com/simylein/Minecraft_Server/blob/master/start.sh
		wget -0 restart.sh https://github.com/simylein/Minecraft_Server/blob/master/restart.sh
		wget -0 stop.sh https://github.com/simylein/Minecraft_Server/blob/master/stop.sh
	cd
		
mkdir server3
	cd server3
		wget -O paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download
		wget -0 start.sh https://github.com/simylein/Minecraft_Server/blob/master/start.sh
		wget -0 restart.sh https://github.com/simylein/Minecraft_Server/blob/master/restart.sh
		wget -0 stop.sh https://github.com/simylein/Minecraft_Server/blob/master/stop.sh
	cd

mkdir backups

