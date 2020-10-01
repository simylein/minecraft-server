#!/bin/bash
# script for setting up a minecraft server on linux debian

# command line colours 
red="\033[0;31m"
yellow="\033[1;33m"
green="\033[0;32m"
blue="\033[0;34m"
purple="\033[0;35m"
nocolor="\033[0m"

# initial questions
echo -e "${blue}I will setup a minecraft server for you${nocolor}"
echo "How should I call your server?"
echo -e "Please enter a servername: Example:${yellow}minecraft${nocolor}"
read -p "Your name:" servername
echo -e "Your Server will be called ${green}${servername}${nocolor}"

# store homedirectory
homedirectory=`pwd`

# ask for permission to proceed
echo "I will download the following scripts:"
echo "start, stop, restart, backup, update, maintenance, speedrun and varo."
read -p "Continue? [Y/N]:"
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}starting setup...${nocolor}"
	else echo -e "${red}exiting...${nocolor}"
		exit 1
fi

# set up directorys
echo "I will now setup a server and backup directory. "

# set up server directory
echo "setting up a serverdirectory..."
mkdir ${servername}

# donwload all the github scripts
echo "downloading scripts from GitHub..."
	cd ${servername}
		wget -q -O settings.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/settings.sh
		wget -q -O start.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/start.sh
		wget -q -O reset.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/reset.sh
		wget -q -O restart.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/restart.sh
		wget -q -O stop.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/stop.sh
		wget -q -O backup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/backup.sh
		wget -q -O update.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/update.sh
		wget -q -O maintenance.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/maintenance.sh
		wget -q -O speedrun.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/speedrun.sh
		wget -q -O varo.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/varo.sh
		wget -q -O prerender.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/prerender.sh

# making the core scripts executable 
echo "making Scripts executable..."
		chmod +x start.sh
		chmod +x restart.sh
		chmod +x stop.sh
		chmod +x backup.sh

# download java executable from mojang.com
echo "downloading server.jar..."
		wget -q -O minecraft_server.1.16.3.jar https://launcher.mojang.com/v1/objects/f02f4473dbf152c23d7d484952121db0b36698cb/server.jar

# store serverdirectory
    serverdirectory=`pwd`
	cd ${homedirectory}
	
# set up backupdirectory
echo "setting up a Backupdirectory..."		
mkdir ${servername}-backups
  cd ${servername}-backups
    backupdirectory=`pwd`
  cd ${homedirectory}

# ask all the importatnt user input
echo "Please tell me which DNS server you would like to use"
echo -e "Example from Cloudflare:${yellow}1.1.1.1${nocolor}"
read -p "Your dnsserver:" dnsserver
echo -e "Your server will use ${green}${dnsserver}${nocolor} as a name server"

echo "Please tell me the address of your interface (router)"
echo -e "Usally it is something like this Example:${yellow}192.168.1.1${nocolor}"
read -p "Your interface:" interface
echo -e "Your server will use ${green}${interface}${nocolor} as an interface"

echo "Tell me where your java binary is located"
echo -e "Usally it is Example:${yellow}/usr/bin/java${nocolor}"
read -p "Your location of the java binary:" java
echo -e "Your server will access${green}${java}${nocolor} as java binary"

echo "Tell me where your screen binary is located"
echo -e "Usally it is Example:${yellow}/usr/bin/screen${nocolor}"
read -p "Your location of the screen binary:" screen
echo -e "Your server will access${green}${screen}${nocolor} as screen binary"

echo "How much minimum memory would you like to grant your Server?"
echo -e "Please enter like this: Example:${yellow}-Xms256M${nocolor}"
read -p "Your amount:" mems
echo -e "Your Server will will have ${green}${mems}${nocolor} of minimum memory allocated"

echo "How much maximum memory would you like to grant your Server?"
echo -e "Please enter like this: Example:${yellow}-Xmx2048M${nocolor}"
read -p "Your amount:" memx
echo -e "Your Server will will have ${green}${memx}${nocolor} of maximum memory allocated"

echo "How many threads would you like your Server to use?"
echo -e "Please enter like this. Example:${yellow}-XX:ParallelGCThreads=2${nocolor}"
read -p "Your amount:" threadcount
echo -e "Your Server will will have ${green}${threadcount}${nocolor} of threads to work with"

echo "Please enter the location of your serverfile (executable)."
echo -e "Please enter like this. Example:${yellow}${serverdirectory}/minecraft_server.1.16.3.jar${nocolor}"
read -p "Your location:" serverfile
echo -e "Your Server will execute ${green}${serverfile}${nocolor} at start"

# store all the userinput
echo "storing variables..."
  cd ${servername}
    for var in dnsserver; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in interface; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in java; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in screen; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in mems; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in memx; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in threadcount; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in serverfile; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in servername; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in homedirectory; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in serverdirectory; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done
    for var in backupdirectory; do
      declare -p $var | cut -d ' ' -f 3- >> settings.sh
    done

# finish messages
echo -e "${blue}setup is complete!${nocolor}"
echo "If you would like to start your Server:"
echo -e "go into your ${green}${serverdirectory}${nocolor} directory and execute ${green}start.sh${nocolor}"
echo -e "execute like this: ${green}./start.sh${nocolor}"
echo -e "God Luck and Have Fun! ${blue};^)${nocolor}"
