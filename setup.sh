#!/bin/bash
# script for setting up a minecraft server on linux debian

# command line colours 
red="\033[0;31m"
yellow="\033[1;33m"
green="\033[0;32m"
blue="\033[0;34m"
purple="\033[0;35m"
nocolor="\033[0m"

# initial question
echo -e "${purple}I will setup a minecraft server for you${nocolor} ${nocolor} ${blue};^)${nocolor}"
echo "How should I call your server?"
echo -e "Please enter a servername: Example:${yellow}minecraft${nocolor}"
read -re -i "minecraft" -p "Your name: " servername
echo -e "Your Server will be called ${green}${servername}${nocolor}"

# store homedirectory
homedirectory=`pwd`

# ask for permission to proceed
echo "I will download the following:"
echo "start, stop, restart, backup and many more scripts from GitHub."
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
		wget -q -O LICENSE https://raw.githubusercontent.com/Simylein/MinecraftServer/master/LICENSE
		wget -q -O README.md https://raw.githubusercontent.com/Simylein/MinecraftServer/master/README.md
		wget -q -O server.settings https://raw.githubusercontent.com/Simylein/MinecraftServer/master/server.settings
		wget -q -O server.properties https://raw.githubusercontent.com/Simylein/MinecraftServer/master/server.properties
		wget -q -O start.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/start.sh
		wget -q -O restore.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/restore.sh
		wget -q -O reset.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/reset.sh
		wget -q -O restart.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/restart.sh
		wget -q -O stop.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/stop.sh
		wget -q -O backuphourly.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/backuphourly.sh
		wget -q -O backupdaily.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/backupdaily.sh
		wget -q -O update.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/update.sh
		wget -q -O maintenance.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/maintenance.sh

# making the core scripts executable 
echo "making Scripts executable..."
		chmod +x start.sh
		chmod +x restart.sh
		chmod +x restore.sh
		chmod +x stop.sh
		chmod +x update.sh
		chmod +x maintenance.sh
		chmod +x backuphourly.sh
		chmod +x backupdaily.sh

# store serverdirectory
serverdirectory=`pwd`

# download java executable from mojang.com
PS3='Which server version would you like to install? '
versions=("1.16.4" "1.15.2" "1.14.4" "1.13.2" "1.12.2" "1.11.2" "1.10.2" "1.9.4" "1.8.9" "1.7.10")
select version in "${versions[@]}"; do
	case $version in
		"1.16.4")
			echo "downloading minecraft-server.1.16.4.jar..."
				wget -q -O minecraft-server.1.16.4.jar https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.16.4.jar"
			break
			;;
		"1.15.2")
			echo "downloading minecraft-server.1.15.2.jar..."
				wget -q -O minecraft-server.1.15.2.jar https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.15.2.jar"
			break
			;;
		"1.14.4")
			echo "downloading minecraft-server.1.14.4.jar..."
				wget -q -O minecraft-server.1.14.4.jar https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.14.4.jar"
			break
			;;
		"1.13.2")
			echo "downloading minecraft-server.1.13.2.jar..."
				wget -q -O minecraft-server.1.13.2.jar https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.13.2.jar"
			break
			;;
		"1.12.2")
			echo "downloading minecraft-server.1.12.2.jar..."
				wget -q -O minecraft-server.1.12.2.jar https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.12.2.jar"
			break
			;;
		"1.11.2")
			echo "downloading minecraft-server.1.11.2.jar..."
				wget -q -O minecraft-server.1.11.2.jar https://launcher.mojang.com/v1/objects/f00c294a1576e03fddcac777c3cf4c7d404c4ba4/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.11.2.jar"
			break
			;;
		"1.10.2")
			echo "downloading minecraft-server.1.10.2.jar..."
				wget -q -O minecraft-server.1.10.2.jar https://launcher.mojang.com/v1/objects/3d501b23df53c548254f5e3f66492d178a48db63/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.10.2.jar"
			break
			;;
		"1.9.4")
			echo "downloading minecraft-server.1.9.4.jar..."
				wget -q -O minecraft-server.1.9.4.jar https://launcher.mojang.com/v1/objects/edbb7b1758af33d365bf835eb9d13de005b1e274/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.9.4.jar"
			break
			;;
		"1.8.9")
			echo "downloading minecraft-server.1.8.9.jar..."
				wget -q -O minecraft-server.1.8.9.jar https://launcher.mojang.com/v1/objects/b58b2ceb36e01bcd8dbf49c8fb66c55a9f0676cd/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.8.9.jar"
			break
			;;
		"1.7.10")
			echo "downloading minecraft-server.1.7.10.jar..."
				wget -q -O minecraft-server.1.7.10.jar https://launcher.mojang.com/v1/objects/952438ac4e01b4d115c5fc38f891710c4941df29/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.7.10.jar"
			break
			;;
		*) echo "Please choose an option from the list 1 - 10 ";;
	esac
done

# user information
echo -e "Your Server will execute ${green}${serverfile}${nocolor} at start"

# return to homedirectory
	cd ${homedirectory}
	
# set up backupdirectory
echo "setting up a backupdirectory..."
mkdir ${servername}-backups
	cd ${servername}-backups
		mkdir hourly
		mkdir daily
		backupdirectory=`pwd`
	cd ${homedirectory}

# ask all the importatnt user input
echo "How much minimum memory would you like to grant your Server?"
echo -e "Please enter like this: Example:${yellow}256${nocolor}"
read -re -i "256" -p "Your amount: " mems
mems="-Xms${mems}M"
echo -e "Your Server will will have ${green}${mems}${nocolor} of minimum memory allocated"

echo "How much maximum memory would you like to grant your Server?"
echo -e "Please enter like this: Example:${yellow}2048${nocolor}"
read -re -i "2048" -p "Your amount: " memx
memx="-Xms${memx}M"
echo -e "Your Server will will have ${green}${memx}${nocolor} of maximum memory allocated"

echo "How many threads would you like your Server to use?"
echo -e "Please enter like this. Example:${yellow}2${nocolor}"
read -re -i "2" -p "Your amount: " threadcount
threadcount="-XX:ParallelGCThreads=${threadcount}"
echo -e "Your Server will will have ${green}${threadcount}${nocolor} of threads to work with"

echo "Please specify your desired view-distance"
echo -e "Please enter like this. Example:${yellow}16${nocolor}"
read -re -i "16" -p "Your view-distance: " viewdistance
viewdistance="view-distance=${viewdistance}"
echo -e "Your Server will have ${green}${viewdistance}${nocolor}"

echo "Please specify your desired spawn-protection"
echo -e "Please enter like this. Example:${yellow}16${nocolor}"
read -re -i "16" -p "Your spawn-protection: " spawnprotection
spawnprotection="spawn-protection=${spawnprotection}"
echo -e "Your Server will have ${green}${spawnprotection}${nocolor}"

echo "Please tell me the max-players amount"
echo -e "Please enter like this. Example:${yellow}8${nocolor}"
read -re -i "8" -p "Your spawn-protection: " maxplayers
maxplayers="max-players=${maxplayers}"
echo -e "Your Server will have ${green}${maxplayers}${nocolor}"

echo "Please specify your desired server-port"
echo -e "Please enter like this. Example:${yellow}25565${nocolor}"
read -re -i "25565" -p "Your server-port: " serverport
serverport="server-port=${serverport}"
echo -e "Your Server will be on ${green}${serverport}${nocolor}"

echo "Please specify your desired query-port"
echo -e "Please enter like this. Example:${yellow}25565${nocolor}"
read -re -i "25565" -p "Your query-port: " queryport
queryport="query.port=${queryport}"
echo -e "Your Server will be on ${green}${queryport}${nocolor}"

echo "Which gamemode would you like to play?"
echo -e "Please enter like this. Example:${yellow}survival${nocolor}"
read -re -i "survival" -p "Your gamemode: " gamemode
gamemode="gamemode=${gamemode}"
echo -e "Your Server will be on ${green}${gamemode}${nocolor}"

echo "Which difficulty would you like to have?"
echo -e "Please enter like this. Example:${yellow}normal${nocolor}"
read -re -i "normal" -p "Your difficulty: " difficulty
difficulty="difficulty=${difficulty}"
echo -e "Your Server will be on ${green}${difficulty}${nocolor}"

echo "Would you like to turn on pvp?"
echo -e "Please enter like this. Example:${yellow}true${nocolor}"
read -re -i "true" -p "Your choice: " pvp
pvp="pvp=${pvp}"
echo -e "Your Server will be on ${green}${pvp}${nocolor}"

echo "Would you like to turn on command-blocks??"
echo -e "Please enter like this. Example:${yellow}true${nocolor}"
read -re -i "true" -p "Your choice: " cmdblock
cmdblock="enable-command-block=${cmdblock}"
echo -e "Your Server will be on ${green}${cmdblock}${nocolor}"

echo "Please chose your server message"
echo -e "Please enter like this. Example:${yellow}Hello World${nocolor}"
read -re -i "Hello World" -p "Your message: " motd
motd="motd=${motd}"
echo -e "Your server message will be ${green}${motd}${nocolor}"

# eula question
cd ${servername}
echo "Would you like to accept the End User License Agreement from Mojang?"
read -p "If you say yes you must abide by their terms and conditions! [Y/N]:"
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}accepting eula...${nocolor}"
	echo "eula=true" >> eula.txt
	else echo -e "${red}declining eula...${nocolor}"
	echo "eula=false" >> eula.txt
fi

# store all the userinput
echo "storing variables in server.settings..."
echo "" >> server.settings
echo "# memory and threads" >> server.settings
	for var in mems; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done
	for var in memx; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done
	for var in threadcount; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done
echo "" >> server.settings
echo "# files and directorys" >> server.settings
	for var in servername; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done
	for var in homedirectory; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done
	for var in serverdirectory; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done
	for var in backupdirectory; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done
	for var in serverfile; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done

echo "storing variables in server.properties..."
	echo "${viewdistance}" >> server.properties
	echo "${spawnprotection}" >> server.properties
	echo "${maxplayers}" >> server.properties
	echo "${serverport}" >> server.properties
	echo "${queryport}" >> server.properties
	echo "${gamemode}" >> server.properties
	echo "${difficulty}" >> server.properties
	echo "${pvp}" >> server.properties
	echo "${cmdblock}" >> server.properties
	echo "${motd}" >> server.properties
	
# write servername and date into crontab
date=$(date +"%Y-%m-%d %H:%M:%S")
crontab -l | { cat; echo "# Minecraft ${servername} server automatisation - executed setup.sh at ${date}"; } | crontab -
crontab -l | { cat; echo ""; } | crontab -

# crontab automatization backups
read -p "Would you like to automate backups? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}automating backups...${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server backup hourly at **:00"; } | crontab -
		crontab -l | { cat; echo "00 * * * * cd ${serverdirectory} && ${serverdirectory}/backuphourly.sh"; } | crontab -
		crontab -l | { cat; echo ""; } | crontab -
		crontab -l | { cat; echo "# minecraft ${servername} server backup daily at 22:00"; } | crontab -
		crontab -l | { cat; echo "00 22 * * * cd ${serverdirectory} && ${serverdirectory}/backupdaily.sh"; } | crontab -
		crontab -l | { cat; echo ""; } | crontab -
	else echo -e "${yellow}no automated backups${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server backup hourly at **:00"; } | crontab -
		crontab -l | { cat; echo "#00 * * * * cd ${serverdirectory} && ${serverdirectory}/backuphourly.sh"; } | crontab -
		crontab -l | { cat; echo ""; } | crontab -
		crontab -l | { cat; echo "# minecraft ${servername} server backup daily at 22:00"; } | crontab -
		crontab -l | { cat; echo "#00 22 * * * cd ${serverdirectory} && ${serverdirectory}/backupdaily.sh"; } | crontab -
		crontab -l | { cat; echo ""; } | crontab -
fi

# crontab automated start and stop
read -p "Would you like to start and stop your server at a certain time? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}automating start and stop...${nocolor}"
		read -p "Your start time: " starttime
		read -p "Your stop time: " stoptime
	else echo -e "${yellow}no automated  start and stop${nocolor}"
		
fi

# crontab automatization restart
read -p "Would you like to restart your server at 02:00? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}atomatic restarts at 02:00${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server restart at 02:00"; } | crontab -
		crontab -l | { cat; echo "00 02 * * * cd ${serverdirectory} && ${serverdirectory}/restart.sh"; } | crontab -
		crontab -l | { cat; echo ""; } | crontab -
	else echo -e "${yellow}no restarts${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server restart at 02:00"; } | crontab -
		crontab -l | { cat; echo "#00 02 * * * cd ${serverdirectory} && ${serverdirectory}/restart.sh"; } | crontab -
		crontab -l | { cat; echo ""; } | crontab -
fi

# crontab automatization startup
read -p "Would you like to start your server at boot? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}automatic startup at boot...${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server startup at boot"; } | crontab -
		crontab -l | { cat; echo "@reboot cd ${serverdirectory} && ${serverdirectory}/start.sh"; } | crontab -
		crontab -l | { cat; echo ""; } | crontab -
	else echo -e "${yellow}no startup at boot${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server startup at boot"; } | crontab -
		crontab -l | { cat; echo "#@reboot cd ${serverdirectory} && ${serverdirectory}/start.sh"; } | crontab -
		crontab -l | { cat; echo ""; } | crontab -
fi

# finish messages
echo -e "${green}setup is complete!${nocolor}"
echo "If you would like to start your Server:"
echo -e "go into your ${green}${serverdirectory}${nocolor} directory and execute ${green}start.sh${nocolor}"
echo -e "execute like this: ${green}./start.sh${nocolor}"
echo -e "${purple}God Luck and Have Fun!${nocolor} ${blue};^)${nocolor}"

# ask user to start server now
read -p "Would you like to start your server now?? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo -e "${green}starting server...${nocolor}"
		./start.sh
fi
