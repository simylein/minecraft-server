#!/bin/bash
# script for setting up a minecraft server on linux debian

# this script has been tested on debian and runs only if all packages are installed
# however you are welcome to try it on any other distribution you like ;^)

# set color enviroment
TERM="xterm"

# branch selection from for github
branch="main"

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

# parse script arguments
immediatly=false
quiet=false
verbose=false
while [[ $# -gt 0 ]]; do
	case "$1" in
		-i)
			immediatly=true
		;;
		-q)
			quiet=true
		;;
		-v)
			verbose=true
		;;
		--immediatly)
			immediatly=true
		;;
		--quiet)
			quiet=true
		;;
		--verbose)
			verbose=true
		;;
		*)
			echo "bad argument: $1"
			exit 1
		;;
	esac
	shift
done

# root safety check
if [ $(id -u) = 0 ]; then
	echo "$(tput bold)$(tput setaf 1)please do not run me as root :( - this is dangerous!$(tput sgr0)"
	exit 1
fi

# check for operating system compatibility and for free memory
if [ "$(uname)" == "Darwin" ]; then
	# inform user about macOS
	echo "$(tput bold)$(tput setaf 3)warning: you are running macOS as your operating system - your server may not run!$(tput sgr0)"
	# get free memory on macOS
	memory=$(($(vm_stat | head -2 | tail -1 | awk '{print $3}' | sed 's/.$//') + $(vm_stat | head -4 | tail -1 | awk '{print $3}' | sed 's/.$//') * 4096))
	# check memory
	if (( ${memory} < 2560000000 )); then
		echo "$(tput bold)$(tput setaf 3)warning: your system has less than 2.56 GB of memory - this may impact server performance!$(tput sgr0)"
	fi
	# get number of threads on macOS
	threads=$(nproc)
	# check threads
	if (( ${threads} < 4 )); then
		echo "$(tput bold)$(tput setaf 3)warning: your system has less than 4 threads - this may impact server performance!$(tput sgr0)"
	fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	# get free memory on linux
	memory="$(free -b | tail -2 | head -1 | awk '{print $4}')"
	# check memory
	if (( ${memory} < 2560000000 )); then
		echo "$(tput bold)$(tput setaf 3)warning: your system has less than 2.56 GB of memory - this may impact server performance!$(tput sgr0)"
	fi
	# get number of threads on Linux
	threads=$(nproc)
	# check threads
	if (( ${threads} < 4 )); then
		echo "$(tput bold)$(tput setaf 3)warning: your system has less than 4 threads - this may impact server performance!$(tput sgr0)"
	fi
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
	# inform user about Windows
	echo "$(tput bold)$(tput setaf 1)fatal: you are running Windows as your operating system - your server will not run!$(tput sgr0)"
	exit 1
else
	# inform user about unsupported operating system
	echo "$(tput bold)$(tput setaf 1)fatal: you are running an unsupported operating system - your server will not run!$(tput sgr0)"
	exit 1
fi

# check if every required package is installed
# declare all packages in an array
declare -a packages=( "apt" "java" "screen" "date" "tar" "echo" "ping" "ifconfig" "grep" "wget" "cron" "nano" "less" "sed" "pv" "awk" )
# get length of package array
packageslength=${#packages[@]}
# use for loop to read all values and indexes
for (( i = 1; i < ${packageslength} + 1; i ++ )); do
	if ! man ${packages[$i-1]} &> /dev/null; then
		echo "${red}fatal: the package ${packages[${i}-1]} is not installed on your system"
		exit 1
	fi
done

# user info about script
echo "${cyan}I will setup a minecraft server for you${nocolor} ${blue};^)${nocolor}"

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
read -p "Continue? [Y/N]: "
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
echo -n "setting up a serverdirectory... "
mkdir ${servername}
cd ${servername}
echo "done"

# check if verbose mode is on
function CheckVerbose {
	if [[ ${verbose} == true ]]; then
		echo "${1}"
	fi
}

# check if quiet mode is on
function CheckQuiet {
	if ! [[ ${quiet} == true ]]; then
		echo "${1}"
	fi
}

# function for fetching scripts from github with error checking
function FetchScriptFromGitHub {
	wget --spider --quiet https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/${1}
	if [ "$?" != 0 ]; then
		echo "${red}Fatal: Unable to connect to GitHub API. Script will exit! (maybe chose another branch?)${nocolor}"
		exit 1
	else
		CheckVerbose "Fetching file: ${1} from branch ${branch} on GitHub..."
		wget -q -O ${1} https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/${1}
	fi
}

# user info about download
echo "downloading scripts from GitHub... "

# downloading scripts from github
# declare all scripts in an array
declare -a scripts1=( "LICENSE" "README.md" "server.settings" "server.properties" "server.functions" "start.sh" "restore.sh" "reset.sh" "restart.sh" "stop.sh" "backup.sh" "update.sh" "maintenance.sh" "prerender.sh" "watchdog.sh" "welcome.sh" "worker.sh" "vent.sh" )
# get length of script array
scriptslength=${#scripts1[@]}
# loop through all entries in the array
for (( i = 1; i < ${scriptslength} + 1; i ++ )); do
	FetchScriptFromGitHub "${scripts1[${i}-1]}"
done

# make selected scripts executable
# declare all scripts in an array
declare -a scripts2=( "start.sh" "restore.sh" "reset.sh" "restart.sh" "stop.sh" "backup.sh" "update.sh" "maintenance.sh" "prerender.sh" "watchdog.sh" "welcome.sh" "worker.sh" "vent.sh" )
# get length of script array
scriptslength=${#scripts2[@]}
# loop through all entries in the array
for (( i = 1; i < ${scriptslength} + 1; i ++ )); do
	CheckVerbose "Setting script ${scripts2[${i}-1]} executable"
	chmod +x ${scripts2[${i}-1]}
done

# store serverdirectory
serverdirectory=`pwd`

echo "download successful"

# function for downloading serverfile from mojang api with error checking
function FetchServerFileFromMojan {
	echo -n "downloading minecraft-server.${version}.jar... "
	wget -q -O minecraft-server.${version}.jar https://launcher.mojang.com/v1/objects/${1}/server.jar
	serverfile="${serverdirectory}/minecraft-server.${version}.jar"
	echo "done"
	if ! [[ -s "minecraft-server.${version}.jar" ]]; then
		echo "download error: downloaded server-file minecraft-server.${version}.jar is empty or not available"
	fi
}

# download java executable from mojang.com
PS3="Which server version would you like to install? "
versions=("1.16.5" "1.16.4" "1.16.3" "1.16.2" "1.16.1")
select version in "${versions[@]}"; do
	case ${version} in
		"1.16.5")
			FetchServerFileFromMojan "1b557e7b033b583cd9f66746b7a9ab1ec1673ced"
			break
			;;
		"1.16.4")
			FetchServerFileFromMojan "35139deedbd5182953cf1caa23835da59ca3d7cd"
			break
		;;
		"1.16.3")
			FetchServerFileFromMojan "f02f4473dbf152c23d7d484952121db0b36698cb"
			break
		;;
		"1.16.2")
			FetchServerFileFromMojan "c5f6fb23c3876461d46ec380421e42b289789530"
			break
		;;
		"1.16.1")
			FetchServerFileFromMojan "a412fd69db1f81db3f511c1463fd304675244077"
			break
		;;
		*) echo "Please choose an option from the list: ";;
	esac
done

# user information about execute at start
echo "Your Server will execute ${green}${serverfile}${nocolor} at start"

# set up backupdirectory with child directories
echo -n "setting up a backupdirectory... "
mkdir world
mkdir backups
	cd backups
		CheckVerbose "creating ${serverdirectory}/backups/hourly"
		mkdir hourly
		CheckVerbose "creating ${serverdirectory}/backups/daily"
		mkdir daily
		CheckVerbose "creating ${serverdirectory}/backups/weekly"
		mkdir weekly
		CheckVerbose "creating ${serverdirectory}/backups/monthly"
		mkdir monthly
		CheckVerbose "creating ${serverdirectory}/backups/cached"
		mkdir cached
		backupdirectory=`pwd`
	cd ${serverdirectory}
echo "done"

# ask all the importatnt user input
echo "${cyan}auto setup means you are asked fewer questions but there will not be as much customisation for you${nocolor}"
echo "${cyan}nerdy setup means you are able to customise everything - you are able to change these settings later${nocolor}"
PS3="How would you like to setup your server? "
serversetup=("auto" "nerdy")
select setup in ${serversetup[@]}; do
	case ${setup} in
		"auto")
			# set nerdysetup to false
			nerdysetup=false
			break
		;;
		"nerdy")
			# set nerdysetup to true
			nerdysetup=true
			break
		;;
		*)
			echo "Please chose an option from the list: "
		;;
	esac
done

# check if nerdysetup is true
if [[ ${nerdysetup} == true ]]; then

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

	# ask for query
	echo "Would you like your server have a query? Example: ${yellow}true${nocolor}"
	read -re -i "true" -p "Your choice: " enablequery
	regex="^(true|false)$"
	while [[ ! ${enablequery} =~ ${regex} ]]; do
	read -p "Please enter true or false: " enablequery
	done
	echo "Your Server will be on ${green}${enablequery}${nocolor}"
	enablequery="enably-query=${enablequery}"

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
	echo "How far would you like to be able to see entities? Example: ${yellow}100${nocolor}"
	read -re -i "100" -p "Your range: " entitybroadcast
	regex="^([1-4][0-9][0-9]|500)$"
	while [[ ! ${entitybroadcast} =~ ${regex} ]]; do
	read -p "Please enter a number between 100 and 500: " entitybroadcast
	done
	echo "Your Server will broadcast entities ${green}${entitybroadcast}${nocolor}"
	entitybroadcast="entity-broadcast-range-percentage=${entitybroadcast}"

	# ask for enable watchdog
	echo "Would you like to check the integrity of your backups? Example: ${yellow}true${nocolor}"
	read -re -i "true" -p "Your choice: " enablewatchdog
	regex="^(true|false)$"
	while [[ ! ${enablewatchdog} =~ ${regex} ]]; do
	read -p "Please enter true or false: " enablewatchdog
	done
	echo "Your Server will be on enable-watchdog ${green}${enablewatchdog}${nocolor}"

	# ask for welcome message
	echo "Would you like to print welcome messages if a player joins after successful startup? Example: ${yellow}true${nocolor}"
	read -re -i "true" -p "Your choice: " welcomemessage
	regex="^(true|false)$"
	while [[ ! ${welcomemessage} =~ ${regex} ]]; do
	read -p "Please enter true or false: " welcomemessage
	done
	echo "Your Server will be on welcome-message ${green}${welcomemessage}${nocolor}"

	# ask for server console
	echo "Would you like to change to server console after successful startup? Example: ${yellow}false${nocolor}"
	read -re -i "false" -p "Your choice: " changetoconsole
	regex="^(true|false)$"
	while [[ ! ${changetoconsole} =~ ${regex} ]]; do
	read -p "Please enter true or false: " changetoconsole
	done
	echo "Your Server will be on change-to-console ${green}${changetoconsole}${nocolor}"

	# ask for admin task execution
	echo "Would you like to enable admin tasks for the in game chat? Example: ${yellow}false${nocolor}"
	read -re -i "false" -p "Your choice: " enabletasks
	regex="^(true|false)$"
	while [[ ! ${enabletasks} =~ ${regex} ]]; do
	read -p "Please enter true or false: " enabletasks
	done
	echo "Your Server will be on admin-tasks ${green}${enabletasks}${nocolor}"

	# ask for server message
	echo "Please chose your server message. Example: ${yellow}Hello World, I am your new Minecraft Server ;^)${nocolor}"
	read -re -i "Hello World, I am your new Minecraft Server ;^)" -p "Your message: " motd
	echo "Your server message will be: ${green}${motd}${nocolor}"
	motd="motd=${motd}"

fi

# check if nerdysetup is false
if [[ ${nerdysetup} == false ]]; then

	# declare standart values
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
	enablequery="enable-query=true"
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
	entitybroadcast="entity-broadcast-range-percentage=100"
	enablewatchdog="true"
	enabletasks="false"
	welcomemessage="true"
	changetoconsole="false"
	motd="motd=Hello World, I am your new Minecraft Server ;^)"

fi

# eula question
echo "Would you like to accept the End User License Agreement from Mojang?"
echo "If you say no your server will not be able to run"
echo "${orange}If you say yes you must abide by their terms and conditions!${nocolor}"
read -p "[Y/N]: "
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

# function for storing variables in server.settings
function StoreToSettings {
	sed -i "s|${1}|${2}|g" server.settings
}

# function for storing settings in server.properties
function StoreToProperties {
	sed -i "s|${1}|${2}|g" server.properties
}

# store all the userinput
echo -n "storing variables in server.settings... "
	StoreToSettings "replacechangetoconsole" "${changetoconsole}"
	StoreToSettings "replaceenablewatchdog" "${enablewatchdog}"
	StoreToSettings "replacewelcomemessage" "${welcomemessage}"
	StoreToSettings "replaceenabletasksmessage" "${enabletasks}"
	StoreToSettings "replacednsserver" "${dnsserver}"
	StoreToSettings "replaceinterface" "${interface}"
	StoreToSettings "replacemems" "${mems}"
	StoreToSettings "replacememx" "${memx}"
	StoreToSettings "replacethreadcount" "${threadcount}"
	StoreToSettings "replaceservername" "${servername}"
	StoreToSettings "replacehomedirectory" "${homedirectory}"
	StoreToSettings "replaceserverdirectory" "${serverdirectory}"
	StoreToSettings "replacebackupdirectory" "${backupdirectory}"
	StoreToSettings "replaceserverfile" "${serverfile}"
echo "done"

# store all the userinput
echo -n "storing variables in server.properties... "
	StoreToProperties "white-list=false" "${whitelist}"
	StoreToProperties "enforce-whitelist=false" "${enforcewhitelist}"
	StoreToProperties "spawn-animals=true" "${animals}"
	StoreToProperties "spawn-monsters=true" "${monsters}"
	StoreToProperties "generate-structures=true" "${structures}"
	StoreToProperties "spawn-npcs=true" "${npcs}"
	StoreToProperties "allow-nether=true" "${nether}"
	StoreToProperties "pvp=true" "${pvp}"
	StoreToProperties "enable-command-block=false" "${cmdblock}"
	StoreToProperties "gamemode=survival" "${gamemode}"
	StoreToProperties "force-gamemode=false" "${forcegamemode}"
	StoreToProperties "difficulty=easy" "${difficulty}"
	StoreToProperties "hardcore=false" "${hardcore}"
	StoreToProperties "max-players=20" "${maxplayers}"
	StoreToProperties "view-distance=10" "${viewdistance}"
	StoreToProperties "entity-broadcast-range-percentage=100" "${entitybroadcast}"
	StoreToProperties "spawn-protection=16" "${spawnprotection}"
	StoreToProperties "server-port=25565" "${serverport}"
	StoreToProperties "query.port=25565" "${queryport}"
	StoreToProperties "enable-query=false" "${enablequery}"
	StoreToProperties "motd=A Minecraft Server" "${motd}"
echo "done"

# create logfiles with welcome message
. ./server.settings
. ./server.functions
echo "Hello World, this ${servername}-server and log-file was created on ${date}" >> ${screenlog}
echo "Hello World, this ${servername}-server and log-file was created on ${date}" >> ${backuplog}
echo "" >> ${backuplog}
echo "" >> ${backuplog}

# store to crontab function
function StoreToCrontab {
	crontab -l | { cat; echo "${1}"; } | crontab -
}

# check if nerdysetup is true
if [[ ${nerdysetup} == true ]]; then

	# write servername and date into crontab
	date=$(date +"%Y-%m-%d %H:%M:%S")
		StoreToCrontab "# Minecraft ${servername} server automatisation - executed setup.sh at ${date}"

	# crontab e-mail config
	read -p "Would you like to receive emails from your crontab? [Y/N]: "
	regex="^(Y|y|N|n)$"
	while [[ ! ${REPLY} =~ ${regex} ]]; do
		read -p "Please press Y or N: " REPLY
	done
	if [[ ${REPLY} =~ [Yy]$ ]]
		then read -p "Please enter your email address: " emailaddress
			StoreToCrontab "MAILTO=${emailaddress}"
			emailchoice=true
		else echo "${yellow}no emails${nocolor}"
			StoreToCrontab "#MAILTO=youremail@example.com"
			emailchoice=false
	fi

	# define colors for tput
	StoreToCrontab "TERM=xterm"
	StoreToCrontab ""

	# crontab automatization backups
	read -p "Would you like to automate backups? [Y/N]: "
	regex="^(Y|y|N|n)$"
	while [[ ! ${REPLY} =~ ${regex} ]]; do
		read -p "Please press Y or N: " REPLY
	done
	if [[ ${REPLY} =~ ^[Yy]$ ]]
		then echo "${green}automating backups...${nocolor}"
			StoreToCrontab "# minecraft ${servername} server backup hourly at **:00"
			StoreToCrontab "0 * * * * cd ${serverdirectory} && ./backup.sh --quiet"
			backupchoice=true
		else echo "${yellow}no automated backups${nocolor}"
			StoreToCrontab "# minecraft ${servername} server backup hourly at **:00"
			StoreToCrontab "#0 * * * * cd ${serverdirectory} && ./backup.sh --quiet"
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
			StoreToCrontab "# minecraft ${servername} server start at ${starttime}"
			StoreToCrontab "0 ${starttime} * * * cd ${serverdirectory} && ./start.sh --quiet"
			StoreToCrontab "# minecraft ${servername} server stop at ${stoptime}"
			StoreToCrontab "0 ${stoptime} * * * cd ${serverdirectory} && ./stop.sh --quiet"
			startstopchoice=true
		else echo "${yellow}no automated  start and stop${nocolor}"
			StoreToCrontab "# minecraft ${servername} server start at 06:00"
			StoreToCrontab "#0 6 * * * cd ${serverdirectory} && ./start.sh --quiet"
			StoreToCrontab "# minecraft ${servername} server stop at 23:00"
			StoreToCrontab "#0 23 * * * cd ${serverdirectory} && ./stop.sh --quiet"
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
			StoreToCrontab "# minecraft ${servername} server restart at 02:00 on Sundays"
			StoreToCrontab "0 12 * * 0 cd ${serverdirectory} && ./restart.sh --quiet"
			restartchoice=true
		else echo "${yellow}no restarts${nocolor}"
			StoreToCrontab "# minecraft ${servername} server restart at 02:00 on Sundays"
			StoreToCrontab "#0 12 * * 0 cd ${serverdirectory} && ./restart.sh --quiet"
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
			StoreToCrontab "# minecraft ${servername} server update at 18:00 on Sundays"
			StoreToCrontab "0 18 * * 0 cd ${serverdirectory} && ./update.sh --quiet"
			updatechoice=true
		else echo "${yellow}no updates${nocolor}"
			StoreToCrontab "# minecraft ${servername} server update at 18:00 on Sundays"
			StoreToCrontab "#0 18 * * 0 cd ${serverdirectory} && ./update.sh --quiet"
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
			StoreToCrontab "# minecraft ${servername} server startup at boot"
			StoreToCrontab "@reboot cd ${serverdirectory} && ./start.sh --quiet"
			startatbootchoice=true
		else echo "${yellow}no startup at boot${nocolor}"
			StoreToCrontab "# minecraft ${servername} server startup at boot"
			StoreToCrontab "#@reboot cd ${serverdirectory} && ./start.sh --quiet"
			startatbootchoice=false
	fi

	# padd crontab with two empty lines
	StoreToCrontab ""
	StoreToCrontab ""

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

fi

# check if nerdysetup is false
if [[ ${nerdysetup} == false ]]; then

	# write servername and date into crontab
	date=$(date +"%Y-%m-%d %H:%M:%S")
	StoreToCrontab "# Minecraft ${servername} server automatisation - executed setup.sh at ${date}"

	# crontab e-mail config
	StoreToCrontab "#MAILTO=youremail@example.com"

	# define colors for tput
	StoreToCrontab "TERM=xterm"
	StoreToCrontab ""

	# crontab automatization backups
	StoreToCrontab "# minecraft ${servername} server backup hourly at **:00"
	StoreToCrontab "0 * * * * cd ${serverdirectory} && ./backup.sh --quiet"

	# crontab automated start and stop
	StoreToCrontab "# minecraft ${servername} server start at 06:00"
	StoreToCrontab "#0 6 * * * cd ${serverdirectory} && ./start.sh --quiet"
	StoreToCrontab "# minecraft ${servername} server stop at 23:00"
	StoreToCrontab "#0 23 * * * cd ${serverdirectory} && ./stop.sh --quiet"

	# crontab automatization restart
	StoreToCrontab "# minecraft ${servername} server restart at 02:00 on Sundays"
	StoreToCrontab "#0 12 * * 0 cd ${serverdirectory} && ./restart.sh --quiet"

	# crontab automatization updates
	StoreToCrontab "# minecraft ${servername} server update at 18:00 on Sundays"
	StoreToCrontab "#0 18 * * 0 cd ${serverdirectory} && ./update.sh --quiet"

	# crontab automatization startup
	StoreToCrontab "# minecraft ${servername} server startup at boot"
	StoreToCrontab "@reboot cd ${serverdirectory} && ./start.sh --quiet"

	# padd crontab with two empty lines
	StoreToCrontab ""
	StoreToCrontab ""

fi

# finish messages
echo "${green}setup is complete!${nocolor}"
echo "If you would like to start your Server:"
echo "go into your ${green}${serverdirectory}${nocolor} directory and execute ${green}start.sh${nocolor}"
echo "execute like this: ${green}./start.sh${nocolor}"
echo "${magenta}God Luck and Have Fun!${nocolor} ${blue};^)${nocolor}"

# ask user for removal of setup script
read -p "Would you like to remove the setup script? [Y/N]: "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
	cd ${homedirectory}
	rm setup.sh
	cd ${serverdirectory}
fi

# ask user to start server now
read -p "Would you like to start your server now? [Y/N]: "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "Please press Y or N: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
	echo "${cyan}starting up server...${nocolor}"
	./start.sh --verbose
else
	echo "${cyan}script has finished!${nocolor}"
fi

# exit with code 0
exit 0
