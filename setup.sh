#!/bin/bash
# script for setting up a minecraft server on linux debian

# this script has been tested on debian and runs only if all packages are installed
# however you are welcome to try it on any other distribution you like ;^)

# root safety check
if [ $(id -u) = 0 ]; then
	echo "$(tput bold)$(tput setaf 1)please do not run me as root :( - this is dangerous!$(tput sgr0)"
	exit 1
fi

# check for operating system and for free memory
if [ "$(uname)" == "Darwin" ]; then
	echo "$(tput bold)$(tput setaf 3)you are running macOS as your operating system - your server may not run!$(tput sgr0)"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	memory="$(free | tail -2 | head -1 | awk '{print $4}')"
	if (( ${memory} < 2560000 )); then
		echo "$(tput bold)$(tput setaf 3)your system has less than 2.56 GB of memory - your server may not run!$(tput sgr0)"
	fi
fi

# command line colours
black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"
nocolor="$(tput sgr0)"

# iuser info about script
echo "${magenta}I will setup a minecraft server for you${nocolor} ${blue};^)${nocolor}"

# initial question
echo "How should I call your server?"
echo "Please enter a servername: Example: ${yellow}minecraft${nocolor}"
read -re -i "minecraft" -p "Your name: " servername
regex="^[a-zA-Z0-9]+$"
verify="false"
while [[ ${verify} == "false" ]]; do
	if [[ ! ${servername} =~ ${regex} ]]; then
		read -p "Please enter a servername which only contains letters and numbers: " servername
	else
		check1="true"
	fi
	if [ -d ${servername} ]; then
		read -p "Directory ${servername} already exists - please enter another directory: " servername
	else
		check2="true"
	fi
	if [[ ${check1} == "true" ]] && [[ ${check2} == "true" ]]; then
		verify=true
	else
		verify="false"
	fi
done
echo "Your Server will be called ${green}${servername}${nocolor}"

# store homedirectory
homedirectory=`pwd`

# ask for permission to proceed
echo "I will download the following:"
echo "start, stop, restart, backup and many more scripts from GitHub."
read -p "Continue? [Y/N]:"
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo "${green}starting setup...${nocolor}"
	else echo "${red}exiting...${nocolor}"
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
	case ${version} in
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

# user information about execute at start
echo "Your Server will execute ${green}${serverfile}${nocolor} at start"

# set up backupdirectory with child directories
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
echo "nerdy setup means you are able to customise everything - you are able to change these settings later"
echo "auto setup means you are asked fewer questions but there will not be as much customisation for you"
PS3="How would you like to setup your server? "
serversetup=("nerdy" "auto")
select setup in ${serversetup[@]}; do
	case ${setup} in
		"nerdy")

			# ask for a valid dnsserver
			echo "Please tell me which dnsserver you would like to use. Example: ${yellow}1.1.1.1${nocolor}"
			read -re -i "1.1.1.1" -p "Your dnsserver: " dnsserver
			regex="^(0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))\.){3}"
			while [[ ! ${dnsserver} =~ ${regex} ]]; do
				read -p "Please enter a valid ip address: " dnsserver
			done
			echo "Your server will ping ${green}${dnsserver}${nocolor} at start."

			# ask for a valid interface
			echo "Please tell me which interface you would like to use. Example: ${yellow}192.168.1.1${nocolor}"
			read -re -i "192.168.1.1" -p "Your interface: " interface
			regex="^(0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))\.){3}"
			while [[ ! ${interface} =~ ${regex} ]]; do
				read -p "Please enter a valid ip address: " interface
			done
			echo "Your server will ping ${green}${interface}${nocolor} at start."

			# ask for minimum memory
			echo "How much minimum memory would you like to grant your Server? Example: ${yellow}256${nocolor}"
			read -re -i "256" -p "Your amount: " mems
			regex="^([2-9][5-9][6-9]|[1-4][0-9][0-9][0-9])$"
			while [[ ! ${mems} =~ ${regex} ]]; do
				read -p "Please enter a number between 256 and 4096: " mems
			done
			echo "Your Server will will have ${green}${mems}${nocolor} MB of minimum memory allocated."
			mems="-Xms${mems}M"

			# ask for maximum memory
			echo "How much maximum memory would you like to grant your Server? Example: ${yellow}2048${nocolor}"
			read -re -i "2048" -p "Your amount: " memx
			regex="^([2-9][0-9][4-9][8-9]|[0-3][0-2][0-7][0-6][0-8])$"
			while [[ ! ${memx} =~ ${regex} ]]; do
				read -p "Please enter a number between 2048 and 32768: " memx
			done
			echo "Your Server will will have ${green}${memx}${nocolor} MB of maximum memory allocated."
			memx="-Xms${memx}M"

			# ask for amount of threads
			echo "How many threads would you like your Server to use? Example: ${yellow}2${nocolor}"
			read -re -i "2" -p "Your amount: " threadcount
			regex="^(0?[1-9]|[1-2][0-9]|3[0-2])$"
			while [[ ! ${threadcount} =~ ${regex} ]]; do
				read -p "Please enter a number between 1 and 32: " threadcount
			done
			echo "Your Server will will have ${green}${threadcount}${nocolor} threads to work with."
			threadcount="-XX:ParallelGCThreads=${threadcount}"

			# ask for view distance
			echo "Please specify your desired view-distance. Example: ${yellow}16${nocolor}"
			read -re -i "16" -p "Your view-distance: " viewdistance
			regex="^([2-9]|[1-5][0-9]|6[0-4])$"
			while [[ ! ${viewdistance} =~ ${regex} ]]; do
				read -p "Please enter a number between 2 and 64: " viewdistance
			done
			echo "Your Server will have ${green}${viewdistance}${nocolor} chunks view-distance."
			viewdistance="view-distance=${viewdistance}"

			# ask for spawn protection
			echo "Please specify your desired spawn-protection. Example: ${yellow}16${nocolor}"
			read -re -i "16" -p "Your spawn-protection: " spawnprotection
			regex="^([2-9]|[1-5][0-9]|6[0-4])$"
			while [[ ! ${spawnprotection} =~ ${regex} ]]; do
				read -p "Please enter a number between 2 and 64: " spawnprotection
			done
			echo "Your Server will have ${green}${spawnprotection}${nocolor} blocks spawn-protection."
			spawnprotection="spawn-protection=${spawnprotection}"

			# ask for max player count
			echo "Please tell me the max-players amount. Example: ${yellow}8${nocolor}"
			read -re -i "8" -p "Your max-players: " maxplayers
			regex="^([2-9]|[0-9][0-9]|1[0-9][0-9]|200)$"
			while [[ ! ${maxplayers} =~ ${regex} ]]; do
				read -p "Please enter a number between 2 and 200: " maxplayers
			done
			echo "Your Server will have ${green}${maxplayers}${nocolor} max-players."
			maxplayers="max-players=${maxplayers}"

			# ask for server port
			echo "Please specify your desired server-port. Example: ${yellow}25565${nocolor}"
			read -re -i "25565" -p "Your server-port: " serverport
			regex="^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$"
			while [[ ! ${serverport} =~ ${regex} ]]; do
				read -p "Please enter a valid port between 0 and 65535: " serverport
			done
			echo "Your Server will be on ${green}${serverport}${nocolor}"
			serverport="server-port=${serverport}"

			# ask for query port
			echo "Please specify your desired query-port. Example: ${yellow}25565${nocolor}"
			read -re -i "25565" -p "Your query-port: " queryport
			regex="^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$"
			while [[ ! ${queryport} =~ ^${regex} ]]; do
				read -p "Please enter a valid port between 0 and 65535: " queryport
			done
			echo "Your Server will be on ${green}${queryport}${nocolor}"
			queryport="query.port=${queryport}"

			# ask for gamemode
			echo "Which gamemode would you like to play? Example: ${yellow}survival${nocolor}"
			read -re -i "survival" -p "Your gamemode: " gamemode
			regex="^(survival|creative|adventure|spectator)$"
			while [[ ! ${gamemode} =~ ${regex} ]]; do
				read -p "Please enter a valid gamemode: " gamemode
			done
			echo "Your Server will be on ${green}${gamemode}${nocolor}"
			gamemode="gamemode=${gamemode}"

			# ask for forced gamemode
			echo "Would like like to force the gamemode on your server? ${yellow}false${nocolor}"
			read -re -i "false" -p "Your choice: " forcegamemode
			regex="^(true|false)$"
			while [[ ! ${forcegamemode} =~ ${regex} ]]; do
				read -p "Please enter true or false: " forcegamemode
			done
			echo "Your Server will be on ${green}${forcegamemode}${nocolor}"
			forcegamemode="force-gamemode=${forcegamemode}"

			# ask for difficulty
			echo "Which difficulty would you like to have? Example: ${yellow}normal${nocolor}"
			read -re -i "normal" -p "Your difficulty: " difficulty
			regex="^(peaceful|easy|normal|hard)$"
			while [[ ! ${difficulty} =~ ${regex} ]]; do
				read -p "Please enter a valid difficulty: " difficulty
			done
			echo "Your Server will be on ${green}${difficulty}${nocolor}"
			difficulty="difficulty=${difficulty}"

			# ask for hardcore mode
			echo "Would you like to turn on hardcore mode? Example: ${yellow}false${nocolor}"
			read -re -i "false" -p "Your choice: " hardcore
			regex="^(true|false)$"
			while [[ ! ${hardcore} =~ ${regex} ]]; do
				read -p "Please enter true or false: " hardcore
			done
			echo "Your Server will be on ${green}${hardcore}${nocolor}"
			hardcore="hardcore=${hardcore}"

			# ask for monsters
			echo "Would you like your server to spawn monsters? Example: ${yellow}true${nocolor}"
			read -re -i "true" -p "Your choice: " monsters
			regex="^(true|false)$"
			while [[ ! ${monsters} =~ ${regex} ]]; do
				read -p "Please enter true or false: " monsters
			done
			echo "Your Server will be on monsters ${green}${monsters}${nocolor}"
			monsters="spawn-monsters=${monsters}"

			# ask for whitelist
			echo "Would you like to turn on the whitelist? Example: ${yellow}true${nocolor}"
			read -re -i "true" -p "Your choice: " whitelist
			regex="^(true|false)$"
			while [[ ! ${whitelist} =~ ${regex} ]]; do
				read -p "Please enter true or false: " whitelist
			done
			echo "Your Server will be on whitelist ${green}${whitelist}${nocolor}"
			whitelist="white-list=${whitelist}"

			# ask for enforced whitelist
			echo "Would you like to enforce the whitelist on your server? Example: ${yellow}true${nocolor}"
			read -re -i "true" -p "Your choice: " enforcewhitelist
			regex="^(true|false)$"
			while [[ ! ${enforcewhitelist} =~ ${regex} ]]; do
				read -p "Please enter true or false: " enforcewhitelist
			done
			echo "Your Server will be on enforcewhitelist ${green}${enforcewhitelist}${nocolor}"
			enforcewhitelist="enforce-whitelist=${enforcewhitelist}"

			# ask for online mode
			echo "Would you like to run your server in online mode? Example: ${yellow}true${nocolor}"
			read -re -i "true" -p "Your choice: " onlinemode
			regex="^(true|false)$"
			while [[ ! ${onlinemode} =~ ${regex} ]]; do
				read -p "Please enter true or false: " onlinemode
			done
			echo "Your Server will be on onlinemode ${green}${onlinemode}${nocolor}"
			onlinemode="online-mode=${onlinemode}"

			# ask for pvp
			echo "Would you like to turn on pvp? Example: ${yellow}true${nocolor}"
			read -re -i "true" -p "Your choice: " pvp
			regex="^(true|false)$"
			while [[ ! ${pvp} =~ ${regex} ]]; do
				read -p "Please enter true or false: " pvp
			done
			echo "Your Server will be on pvp ${green}${pvp}${nocolor}"
			pvp="pvp=${pvp}"

			# ask for animals
			echo "Would you like to spawn animals on your server? Example: ${yellow}true${nocolor}"
			read -re -i "true" -p "Your choice: " animals
			regex="^(true|false)$"
			while [[ ! ${animals} =~ ${regex} ]]; do
				read -p "Please enter true or false: " animals
			done
			echo "Your Server will be on animals ${green}${animals}${nocolor}"
			animals="spawn-animals=${animals}"

			# ask for nether
			echo "Would you like to activate the nether on your server? Example: ${yellow}true${nocolor}"
			read -re -i "true" -p "Your choice: " nether
			regex="^(true|false)$"
			while [[ ! ${nether} =~ ${regex} ]]; do
				read -p "Please enter true or false: " nether
			done
			echo "Your Server will be on nether ${green}${nether}${nocolor}"
			nether="allow-nether=${nether}"

			# ask for npcs
			echo "Would you like to spawn npcs on your server? Example: ${yellow}true${nocolor}"
			read -re -i "true" -p "Your choice: " npcs
			regex="^(true|false)$"
			while [[ ! ${npcs} =~ ${regex} ]]; do
				read -p "Please enter true or false: " npcs
			done
			echo "Your Server will be on npcs ${green}${npcs}${nocolor}"
			npcs="spawn-npcs=${npcs}"

			# ask for structures
			echo "Would you like your server to generate structures? Example: ${yellow}true${nocolor}"
			read -re -i "true" -p "Your choice: " structures
			regex="^(true|false)$"
			while [[ ! ${structures} =~ ${regex} ]]; do
				read -p "Please enter true or false: " structures
			done
			echo "Your Server will be on structures ${green}${structures}${nocolor}"
			structures="generate-structures=${structures}"

			# ask for command blocks
			echo "Would you like to turn on command-blocks? Example: ${yellow}true${nocolor}"
			read -re -i "true" -p "Your choice: " cmdblock
			regex="^(true|false)$"
			while [[ ! ${cmdblock} =~ ${regex} ]]; do
				read -p "Please enter true or false: " cmdblock
			done
			echo "Your Server will be on ${green}${cmdblock}${nocolor}"
			cmdblock="enable-command-block=${cmdblock}"

			# ask for entity broadcast range
			echo "How far would you like to be able to see entities? Example: ${yellow}250${nocolor}"
			read -re -i "250" -p "Your range: " entitybroadcast
			regex="^([1-4][0-9][0-9]|500)$"
			while [[ ! ${entitybroadcast} =~ ${regex} ]]; do
				read -p "Please enter a number between 100 and 500: " entitybroadcast
			done
			echo "Your Server will broadcast entities ${green}${entitybroadcast}${nocolor}"
			entitybroadcast="entity-broadcast-range-percentage=${entitybroadcast}"

			# ask for server console
			echo "Would you like to change to server console after successful startup? Example: ${yellow}false${nocolor}"
			read -re -i "false" -p "Your choice: " changetoconsole
			regex="^(true|false)$"
			while [[ ! ${changetoconsole} =~ ${regex} ]]; do
				read -p "Please enter true or false: " changetoconsole
			done
			echo "Your Server will be on change-to-console ${green}${changetoconsole}${nocolor}"

			# ask for server message
			echo "Please chose your server message. Example: ${yellow}Hello World, I am your new Minecraft Server ;^)${nocolor}"
			read -re -i "Hello World, I am your new Minecraft Server ;^)" -p "Your message: " motd
			echo "Your server message will be: ${green}${motd}${nocolor}"
			motd="motd=${motd}"

			break

			;;

		"auto")

			dnsserver="1.1.1.1"
			interface="192.168.1.1"
			mems="-Xms256M"
			memx="-Xms2048M"
			threadcount="-XX:ParallelGCThreads=2"
			viewdistance="view-distance=16"
			spawnprotection="spawn-protection=16"
			maxplayers="max-players=8"
			serverport="server-port=25565"
			queryport="query.port=25565"
			gamemode="gamemode=survival"
			forcegamemode="force-gamemode=false"
			difficulty="difficulty=normal"
			hardcore="hardcore=false"
			monsters="spawn-monsters=true"
			whitelist="white-list=true"
			enforcewhitelist="enforce-whitelist=true"
			onlinemode="online-mode=true"
			pvp="pvp=true"
			animals="spawn-animals=true"
			nether="allow-nether=true"
			npcs="spawn-npcs=true"
			structures="generate-structures=true"
			cmdblock="enable-command-block=true"
			entitybroadcast="entity-broadcast-range-percentage=250"
			changetoconsole="false"
			motd="motd=Hello World, I am your new Minecraft Server ;^)"

			break

			;;

		*) echo "Please chose an option from the list: "
			;;
	esac
done

# eula question
echo "Would you like to accept the End User License Agreement from Mojang?"
read -p "If you say yes you must abide by their terms and conditions! [Y/N]:"
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]
	then echo "${green}accepting eula...${nocolor}"
	echo "eula=true" >> eula.txt
	else echo "${red}declining eula...${nocolor}"
	echo "eula=false" >> eula.txt
fi

# store all the userinput
echo "# change to server console after startup"
	for var in changetoconsole; do
		declare -p $var | cut -d ' ' -f 3- >> server.settings
	done
echo ""
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
	echo "${whitelist}" >> server.properties
	echo "${enforcewhitelist}" >> server.properties
	echo "${animals}" >> server.properties
	echo "${monsters}" >> server.properties
	echo "${structures}" >> server.properties
	echo "${npcs}" >> server.properties
	echo "${nether}" >> server.properties
	echo "${pvp}" >> server.properties
	echo "${cmdblock}" >> server.properties
	echo "${gamemode}" >> server.properties
	echo "${forcegamemode}" >> server.properties
	echo "${difficulty}" >> server.properties
	echo "${hardcore}" >> server.properties
	echo "${maxplayers}" >> server.properties
	echo "${viewdistance}" >> server.properties
	echo "${entitybroadcast}" >> server.properties
	echo "${spawnprotection}" >> server.properties
	echo "${serverport}" >> server.properties
	echo "${queryport}" >> server.properties
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
read -p "Would you like to receive emails from your crontab? [Y/N]: "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ ${REPLY} =~ [Yy]$ ]]
	then read -p "Please enter your email address: " emailaddress
		crontab -l | { cat; echo "MAILTO=${emailaddress}"; } | crontab -
		emailchoice=true
	else echo "${yellow}no emails${nocolor}"
		crontab -l | { cat; echo "#MAILTO=youremail@example.com"; } | crontab -
		emailchoice=false
fi

# define colors for tput
crontab -l | { cat; echo "TERM=xterm"; } | crontab -
crontab -l | { cat; echo ""; } | crontab -

# crontab automatization backups
read -p "Would you like to automate backups? [Y/N]: "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]
	then echo "${green}automating backups...${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server backup hourly at **:00"; } | crontab -
		crontab -l | { cat; echo "0 * * * * cd ${serverdirectory} && ${serverdirectory}/backup.sh"; } | crontab -
		backupchoice=true
	else echo "${yellow}no automated backups${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server backup hourly at **:00"; } | crontab -
		crontab -l | { cat; echo "#0 * * * * cd ${serverdirectory} && ${serverdirectory}/backup.sh"; } | crontab -
		backupchoice=false
fi

# crontab automated start and stop
read -p "Would you like to start and stop your server at a certain time? [Y/N]: "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]
	then echo "${green}automating start and stop...${nocolor}"
		read -p "Your start time [0 - 23]: " starttime
		read -p "Your stop time [0 - 23]: " stoptime
		crontab -l | { cat; echo "# minecraft ${servername} server start at ${starttime}"; } | crontab -
		crontab -l | { cat; echo "0 ${starttime} * * * cd ${serverdirectory} && ${serverdirectory}/start.sh"; } | crontab -
		crontab -l | { cat; echo "# minecraft ${servername} server stop at ${stoptime}"; } | crontab -
		crontab -l | { cat; echo "0 ${stoptime} * * * cd ${serverdirectory} && ${serverdirectory}/stop.sh"; } | crontab -
		startstopchoice=true
	else echo "${yellow}no automated  start and stop${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server start at 06:00"; } | crontab -
		crontab -l | { cat; echo "#0 6 * * * cd ${serverdirectory} && ${serverdirectory}/start.sh"; } | crontab -
		crontab -l | { cat; echo "# minecraft ${servername} server stop at 23:00"; } | crontab -
		crontab -l | { cat; echo "#0 23 * * * cd ${serverdirectory} && ${serverdirectory}/stop.sh"; } | crontab -
		startstopchoice=false
fi

# crontab automatization restart
read -p "Would you like to restart your server at 12:00? [Y/N]: "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]
	then echo "${green}automatic restarts at 02:00${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server restart at 02:00"; } | crontab -
		crontab -l | { cat; echo "0 12 * * 0 cd ${serverdirectory} && ${serverdirectory}/restart.sh"; } | crontab -
		restartchoice=true
	else echo "${yellow}no restarts${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server restart at 02:00"; } | crontab -
		crontab -l | { cat; echo "#0 12 * * 0 cd ${serverdirectory} && ${serverdirectory}/restart.sh"; } | crontab -
		restartchoice=false
fi

# crontab automatization updates
read -p "Would you like to update your server every Sunday at 18:00? [Y/N]: "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]
	then echo "${green}automatic update at Sunday${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server update at Sunday"; } | crontab -
		crontab -l | { cat; echo "0 18 * * 0 cd ${serverdirectory} && ${serverdirectory}/update.sh"; } | crontab -
		updatechoice=true
	else echo "${yellow}no updates${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server update at Sunday"; } | crontab -
		crontab -l | { cat; echo "#0 18 * * 0 cd ${serverdirectory} && ${serverdirectory}/update.sh"; } | crontab -
		updatechoice=false
fi

# crontab automatization startup
read -p "Would you like to start your server at boot? [Y/N]: "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]
	then echo "${green}automatic startup at boot...${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server startup at boot"; } | crontab -
		crontab -l | { cat; echo "@reboot cd ${serverdirectory} && ${serverdirectory}/start.sh"; } | crontab -
		startatbootchoice=true
	else echo "${yellow}no startup at boot${nocolor}"
		crontab -l | { cat; echo "# minecraft ${servername} server startup at boot"; } | crontab -
		crontab -l | { cat; echo "#@reboot cd ${serverdirectory} && ${serverdirectory}/start.sh"; } | crontab -
		startatbootchoice=false
fi

# padd crontab with two empty lines
crontab -l | { cat; echo ""; } | crontab -
crontab -l | { cat; echo ""; } | crontab -

# inform user of automated crontab choices
echo "You have chosen the following configuration of your server:"
if [[ ${emailchoice} == true ]];
	then echo "crontab email output = ${blue}true${nocolor}"
	else echo "crontab email output = ${red}false${nocolor}"
fi
if [[ ${backupchoice} == true ]];
	then echo "automated backups = ${blue}true${nocolor}"
	else echo "automated backups = ${red}false${nocolor}"
fi
if [[ ${startstopchoice} == true ]];
	then echo "automated start and stop = ${blue}true${nocolor}"
	else echo "automated start and stop = ${red}false${nocolor}"
fi
if [[ ${restartchoice} == true ]];
	then echo "automated restart = ${blue}true${nocolor}"
	else echo "automated restart = ${red}false${nocolor}"
fi
if [[ ${updatechoice} == true ]];
	then echo "automated update = ${blue}true${nocolor}"
	else echo "automated update = ${red}false${nocolor}"
fi
if [[ ${startatbootchoice} == true ]];
	then echo "automated start at boot = ${blue}true${nocolor}"
	else echo "automated start at boot = ${red}false${nocolor}"
fi

# finish messages
echo "${green}setup is complete!${nocolor}"
echo "If you would like to start your Server:"
echo "go into your ${green}${serverdirectory}${nocolor} directory and execute ${green}start.sh${nocolor}"
echo "execute like this: ${green}./start.sh${nocolor}"
echo "${magenta}God Luck and Have Fun!${nocolor} ${blue};^)${nocolor}"

# ask user to start server now
read -p "Would you like to start your server now? [Y/N]: "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
	echo "${green}starting up server...${nocolor}"
	./start.sh
else
	echo "${magenta}script has finished!${nocolor}"
fi
