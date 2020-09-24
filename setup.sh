#!/bin/bash
# Script for setting up a Minecraft Server

echo "How should I call your Server?"
read -p "Please enter a servername: " servername
echo "Your Server will be called $servername"

homedirectory=`pwd`

echo "I will now setup a server and backup directory. "
echo "I will also download the following scripts:"
echo "start, stop, restart, backup, update, maintenance, speedrun and varo."
echo "Continue?"
read -p "[Y/N]:"
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo "starting setup..."
	else echo "exiting..."
		exit 1
fi

echo "setting up a Serverdirectory..."
mkdir ${servername}

echo "downloading Scripts from GitHub..."
	cd ${servername}
		wget -q -O settings.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/settings.sh
		wget -q -O start.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/start.sh
		wget -q -O restart.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/restart.sh
		wget -q -O stop.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/stop.sh
		wget -q -O backup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/backup.sh
		wget -q -O update.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/update.sh
		wget -q -O maintenance.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/maintenance.sh
		wget -q -O speedrun.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/speedrun.sh
		wget -q -O varo.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/varo.sh

echo "making Scripts executable..."
		chmod +x start.sh
		chmod +x restart.sh
		chmod +x stop.sh
		chmod +x backup.sh
		chmod +x update.sh
		chmod +x maintenance.sh
		chmod +x speedrun.sh
		chmod +x varo.sh
    serverdirectory=`pwd`
	cd ${homedirectory}
	
echo "setting up a Backupdirectory..."		
mkdir ${servername}-backups
  cd ${servername}-backups
    backupdirectory=`pwd`
  cd ${homedirectory}

echo "storing variables..."
  cd ${servername}
    for var in servername; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in homedirectory; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in serverdirectory; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done

echo "setup is complete"
