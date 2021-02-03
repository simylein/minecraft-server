#!/bin/bash
# script for setting up a minecraft server on linux debian

# this script has been tested on debian and runs only if all packages are installed
# however you are welcome to try it on any other distribution you like ;^)

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
echo "I will now setup a server and backup directory."

# set up server directory
echo "setting up a serverdirectory..."
mkdir ${servername}

# donwload all the github scripts and make them exectuable
echo "downloading scripts from GitHub..."
	cd ${servername}
		wget -q -O LICENSE https://raw.githubusercontent.com/Simylein/MinecraftServer/master/LICENSE
		wget -q -O README.md https://raw.githubusercontent.com/Simylein/MinecraftServer/master/README.md
		wget -q -O server.settings https://raw.githubusercontent.com/Simylein/MinecraftServer/master/server.settings
		wget -q -O server.properties https://raw.githubusercontent.com/Simylein/MinecraftServer/master/server.properties
		wget -q -O server.functions https://raw.githubusercontent.com/Simylein/MinecraftServer/master/server.functions
		wget -q -O start.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/start.sh && chmod +x start.sh
		wget -q -O restore.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/restore.sh && chmod +x restore.sh
		wget -q -O reset.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/reset.sh && chmod +x reset.sh
		wget -q -O restart.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/restart.sh && chmod +x restart.sh
		wget -q -O stop.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/stop.sh && chmod +x stop.sh
		wget -q -O backup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/backup.sh && chmod +x backup.sh
		wget -q -O update.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/update.sh && chmod +x update.sh
		wget -q -O maintenance.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/maintenance.sh && chmod +x maintenance.sh
		wget -q -O prerender.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/prerender.sh && chmod +x prerender.sh
		wget -q -O vent.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/vent.sh

# store serverdirectory
serverdirectory=`pwd`

# download java executable from mojang.com
PS3="Which server version would you like to install? "
versions=("1.16.5" "1.15.2" "1.14.4" "1.13.2" "1.12.2" "1.11.2" "1.10.2" "1.9.4" "1.8.9" "1.7.10")
select version in "${versions[@]}"; do
	case $version in
		"1.16.5")
			echo "downloading minecraft-server.1.16.5.jar..."
				wget -q -O minecraft-server.1.16.5.jar https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar
				serverfile="${serverdirectory}/minecraft-server.1.16.5.jar"
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
		*) echo "Please choose an option from the list: ";;
	esac
done

# user information
echo -e "Your Server will execute ${green}${serverfile}${nocolor} at start"

# set up backupdirectory
echo "setting up a backupdirectory..."
mkdir world
mkdir backups
	cd backups
		mkdir hourly
		mkdir daily
		mkdir weekly
		mkdir monthly
		mkdir cached
		backupdirectory=`pwd`
	cd ../

# ask all the importatnt user input
echo "Please tell me which dnsserver you would like to use"
echo -e "Please enter like this: Example:${yellow}1.1.1.1${nocolor}"
read -re -i "1.1.1.1" -p "Your dnsserver: " dnsserver
echo -e "Your server will ping ${green}${dnsserver}${nocolor} at start"

echo "Please tell me which interface you would like to use"
echo -e "Please enter like this: Example:${yellow}192.168.1.1${nocolor}"
read -re -i "192.168.1.1" -p "Your interface: " interface
echo -e "Your server will ping ${green}${dnsserver}${nocolor} at start"

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

echo "Would you like to turn on command-blocks?"
echo -e "Please enter like this. Example:${yellow}true${nocolor}"
read -re -i "true" -p "Your choice: " cmdblock
cmdblock="enable-command-block=${cmdblock}"
echo -e "Your Server will be on ${green}${cmdblock}${nocolor}"

echo "Please chose your server message"
echo -e "Please enter like this. Example:${yellow}Hello World, I am your new Minecraft Server ;^)${nocolor}"
read -re -i "Hello World, I am your new Minecraft Server ;^)" -p "Your message: " motd
motd="motd=${motd}"
echo -e "Your server message will be ${green}${motd}${nocolor}"

# eula question
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
echo "# network stuff" >> server.settings
	for var in dnsserver; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done
	for var in interface; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done
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
echo "# files and directories" >> server.settings
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

# create logfiles with Welcome message
. ./server.settings
. ./server.functions
echo "Hello World, this server was created on ${date}" >> ${screenlog}
echo "Hello World, this server was created on ${date}" >> ${backuplog}
echo "" >> ${backuplog}
echo "" >> ${backuplog}

# write servername and date into crontab
date=$(date +"%Y-%m-%d %H:%M:%S")
	crontab -l | { cat; echo "# Minecraft ${servername} server automatisation - executed setup.sh at ${date}"; } | crontab -

# crontab e-mail config
read -re -i "N" -p "Would you like to receive emails from your crontab? [Y/N]: "
if [[  $REPLY =~ [Yy]$ ]]
	then read -p "Please enter your email address: " emailaddress
		crontab -l | { cat; echo "MAILTO=${emailaddress}"; } | crontab -
		crontab -l | { cat; echo ""; } | crontab -
		emailchoice=true
	else echo -e "${yellow}no emails${nocolor}"
		crontab -l | { cat; echo "#MAILTO=youremail@example.com"; } | crontab -
		crontab -l | { cat; echo ""; } | crontab -
		emailchoice=false
fi

# crontab automatization backups
read -re -i "Y" -p "Would you like to automate backups? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}automating backups...${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server backup hourly at **:00"; } | crontab -
		crontab -l | { cat; echo "0 * * * * cd ${serverdirectory} && ${serverdirectory}/backup.sh"; } | crontab -
		backupchoice=true
	else echo -e "${yellow}no automated backups${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server backup hourly at **:00"; } | crontab -
		crontab -l | { cat; echo "#0 * * * * cd ${serverdirectory} && ${serverdirectory}/backup.sh"; } | crontab -
		backupchoice=false
fi

# crontab automated start and stop
read -re -i "N" -p "Would you like to start and stop your server at a certain time? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}automating start and stop...${nocolor}"
		read -p "Your start time [0 - 23]: " starttime
		read -p "Your stop time [0 - 23]: " stoptime
		crontab -l | { cat; echo "# minecraft ${servername} server start at ${starttime}"; } | crontab -
		crontab -l | { cat; echo "0 ${starttime} * * * cd ${serverdirectory} && ${serverdirectory}/start.sh"; } | crontab -
		crontab -l | { cat; echo "# minecraft ${servername} server stop at ${stoptime}"; } | crontab -
		crontab -l | { cat; echo "0 ${stoptime} * * * cd ${serverdirectory} && ${serverdirectory}/stop.sh"; } | crontab -
		startstopchoice=true
	else echo -e "${yellow}no automated  start and stop${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server start at 06:00"; } | crontab -
		crontab -l | { cat; echo "#0 6 * * * cd ${serverdirectory} && ${serverdirectory}/start.sh"; } | crontab -
		crontab -l | { cat; echo "# minecraft ${servername} server stop at 23:00"; } | crontab -
		crontab -l | { cat; echo "#0 23 * * * cd ${serverdirectory} && ${serverdirectory}/stop.sh"; } | crontab -
		startstopchoice=false
fi

# crontab automatization restart
read -re -i "Y" -p "Would you like to restart your server at 12:00? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}automatic restarts at 02:00${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server restart at 02:00"; } | crontab -
		crontab -l | { cat; echo "0 12 * * 0 cd ${serverdirectory} && ${serverdirectory}/restart.sh"; } | crontab -
		restartchoice=true
	else echo -e "${yellow}no restarts${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server restart at 02:00"; } | crontab -
		crontab -l | { cat; echo "#0 12 * * 0 cd ${serverdirectory} && ${serverdirectory}/restart.sh"; } | crontab -
		restartchoice=false
fi

# crontab automatization updates
read -re -i "Y" -p "Would you like to update your server every Sunday at 18:00? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}automatic update at Sunday${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server update at Sunday"; } | crontab -
		crontab -l | { cat; echo "0 18 * * 0 cd ${serverdirectory} && ${serverdirectory}/update.sh"; } | crontab -
		updatechoice=true
	else echo -e "${yellow}no updates${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server update at Sunday"; } | crontab -
		crontab -l | { cat; echo "#0 18 * * 0 cd ${serverdirectory} && ${serverdirectory}/update.sh"; } | crontab -
		updatechoice=false
fi

# crontab automatization startup
read -re -i "Y" -p "Would you like to start your server at boot? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}automatic startup at boot...${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server startup at boot"; } | crontab -
		crontab -l | { cat; echo "@reboot cd ${serverdirectory} && ${serverdirectory}/start.sh"; } | crontab -
		startatbootchoice=true
	else echo -e "${yellow}no startup at boot${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server startup at boot"; } | crontab -
		crontab -l | { cat; echo "#@reboot cd ${serverdirectory} && ${serverdirectory}/start.sh"; } | crontab -
		startatbootchoice=false
fi

# padd crontab with two empty lines
crontab -l | { cat; echo ""; } | crontab -
crontab -l | { cat; echo ""; } | crontab -

# inform user of automated crontab choices
echo "You have chosen the following configuration of your server:"
if [[ $emailchoice == true ]];
	then echo -e "crontab email output = ${blue}true${nocolor}"
	else echo -e "crontab email output = ${red}false${nocolor}"
fi
if [[ $backupchoice == true ]];
	then echo -e "automated backups = ${blue}true${nocolor}"
	else echo -e "automated backups = ${red}false${nocolor}"
fi
if [[ $startstopchoice == true ]];
	then echo -e "automated start and stop = ${blue}true${nocolor}"
	else echo -e "automated start and stop = ${red}false${nocolor}"
fi
if [[ $restartchoice == true ]];
	then echo -e "automated restart = ${blue}true${nocolor}"
	else echo -e "automated restart = ${red}false${nocolor}"
fi
if [[ $updatechoice == true ]];
	then echo -e "automated update = ${blue}true${nocolor}"
	else echo -e "automated update = ${red}false${nocolor}"
fi
if [[ $startatbootchoice == true ]];
	then echo -e "automated start at boot = ${blue}true${nocolor}"
	else echo -e "automated start at boot = ${red}false${nocolor}"
fi

# finish messages
echo -e "${green}setup is complete!${nocolor}"
echo "If you would like to start your Server:"
echo -e "go into your ${green}${serverdirectory}${nocolor} directory and execute ${green}start.sh${nocolor}"
echo -e "execute like this: ${green}./start.sh${nocolor}"
echo -e "${purple}God Luck and Have Fun!${nocolor} ${blue};^)${nocolor}"

# ask user to start server now
read -p "Would you like to start your server now? [Y/N]: "
if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo -e "${green}starting server...${nocolor}"
		./start.sh
fi
