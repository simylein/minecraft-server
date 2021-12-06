#!/bin/bash
# script for setting up a minecraft server on linux debian

# this script has been tested on debian and runs only if all packages are installed
# however you are welcome to try it on any other distribution you like ;^)

# set color enviroment
TERM="xterm"

# branch selection from for github
branch="dev"

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

# prints all input to terminal
function PrintToTerminal {
	if [[ $1 == "ok" ]]; then
		echo "${green}ok: ${2}${nocolor}"
	fi
	if [[ $1 == "info" ]]; then
		echo "${nocolor}info: ${2}${nocolor}"
	fi
	if [[ $1 == "warn" ]]; then
		echo "${yellow}warn: ${2}${nocolor}"
	fi
	if [[ $1 == "error" ]]; then
		echo "${red}error: ${2}${nocolor}"
	fi
	if [[ $1 == "fatal" ]]; then
		echo "${red}fatal: ${2}${nocolor}"
	fi
	if [[ $1 == "action" ]]; then
		echo "${cyan}action: ${2}${nocolor}"
	fi
}

# root safety check
if [ $(id -u) = 0 ]; then
	PrintToTerminal "fatal" "please do not run me as root :( - this is dangerous!"
	exit 1
fi

# check for Linux
function CheckForLinux {
	if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		# inform user about Linux
		PrintToTerminal "ok" "you are running Linux as your operating system - your server will likely run!"
		# get free memory on linux
		memory="$(free -b | tail -2 | head -1 | awk '{print $4}')"
		# check memory
		if (( ${memory} < 2560000000 )); then
			PrintToTerminal "warn" "your system has less than 2.56 GB of memory - this may impact server performance!"
		fi
		# get number of threads on Linux
		threads=$(nproc)
		# check threads
		if (( ${threads} < 4 )); then
			PrintToTerminal "warn" "your system has less than 4 threads - this may impact server performance!"
		fi
		supported=true
	else
		supported=false
	fi
}

# check for macOS
function CheckForMacOS {
	if [ "$(uname)" == "Darwin" ]; then
		# inform user about macOS
		PrintToTerminal "warn" "you are running macOS as your operating system - your server may not run!"
		# get free memory on macOS
		memory=$(($(vm_stat | head -2 | tail -1 | awk '{print $3}' | sed 's/.$//') + $(vm_stat | head -4 | tail -1 | awk '{print $3}' | sed 's/.$//') * 4096))
		# check memory
		if (( ${memory} < 2560000000 )); then
			PrintToTerminal "warn" "your system has less than 2.56 GB of memory - this may impact server performance!"
		fi
		# get number of threads on macOS
		threads=$(nproc)
		# check threads
		if (( ${threads} < 4 )); then
			PrintToTerminal "warn" "your system has less than 4 threads - this may impact server performance!"
		fi
		supported=true
	else
		supported=false
	fi
}

# check for Windows
function CheckForWindows {
	if [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
	# inform user about Windows
	PrintToTerminal "fatal" "you are running Windows as your operating system - your server will not run!"
	supported=false
	exit 1
	fi
}

# check for unsupported OS
function CheckForUnsupportedOS {
	if [ supported == false ]; then
		# inform user about unsupported operating system
		PrintToTerminal "fatal" "you are running an unsupported operating system - your server will not run!"
		exit 1
	fi
}

# run all checks
CheckForLinux
CheckForMacOS
CheckForWindows
CheckForUnsupportedOS

# check if every required package is installed
# declare all packages in an array
declare -a packages=( "apt" "java" "screen" "date" "tar" "echo" "ping" "grep" "wget" "man" "crontab" "nano" "less" "sed" "pv" "awk" )
# get length of package array
packageslength=${#packages[@]}
# use for loop to read all values and indexes
for (( i = 0; i < ${packageslength}; i ++ )); do
	if ! command -v ${packages[$i-1]} &> /dev/null; then
		PrintToTerminal "fatal" "the package ${packages[${i}]} is not installed on your system"
		exit 1
	fi
done

# user info about script
PrintToTerminal "action" "i will setup a minecraft server for you ;^)"

# initial question
read -re -i "minecraft" -p "how should I call your server? your name: " servername
regex="^[a-zA-Z0-9]+$"
verify="false"
while [[ ${verify} == "false" ]]; do
	if [[ ! "${servername}" =~ ${regex} ]]; then
		read -p "please enter a servername which only contains letters and numbers: " servername
	else
		regexcheck="true"
	fi
	if [ -d "${servername}" ]; then
		read -p "directory ${servername} already exists - please enter another directory: " servername
	else
		existscheck="true"
	fi
	if [[ ${regexcheck} == "true" ]] && [[ ${existscheck} == "true" ]]; then
		verify=true
	else
		verify="false"
	fi
done
PrintToTerminal "info" "your server will be called ${green}${servername}${nocolor}"

# store homedirectory
homedirectory=`pwd`

# ask for permission to proceed
PrintToTerminal "info" "i will download start, stop, restart, backup and many more scripts from github"
read -p "proceed? (y/n): "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "please press y or n: " REPLY
done
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo "${green}starting setup...${nocolor}"
	else echo "${red}exiting...${nocolor}"
		exit 1
fi

# set up server directory
PrintToTerminal "info" "setting up a serverdirectory..."
mkdir "${servername}"
cd "${servername}"

# function for fetching scripts from github with error checking
function FetchScriptFromGitHub {
	wget --spider --quiet "https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/${1}"
	if [ "$?" != 0 ]; then
		PrintToTerminal "fatal" "unable to connect to github api. script will exit! (maybe chose another branch?)"
		exit 1
	else
		wget -q -O "${1}" "https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/${1}"
	fi
}

# user info about download
PrintToTerminal "info" "downloading scripts from github..."

# downloading scripts from github
# declare all scripts in an array
declare -a scriptsdownload=( "LICENSE" "README.md" "server.settings" "server.properties" "server.functions" "start.sh" "restore.sh" "reset.sh" "restart.sh" "stop.sh" "backup.sh" "update.sh" "maintenance.sh" "prerender.sh" "worker.sh" "vent.sh" )
# get length of script array
scriptslength=${#scriptsdownload[@]}
# loop through all entries in the array
for (( i = 0; i < ${scriptslength}; i ++ )); do
	FetchScriptFromGitHub "${scriptsdownload[${i}]}"
done

# user info about download
PrintToTerminal "ok" "download successful"

# make selected scripts executable
# declare all scripts in an array
declare -a scriptsexecutable=( "start.sh" "restore.sh" "reset.sh" "restart.sh" "stop.sh" "backup.sh" "update.sh" "maintenance.sh" "prerender.sh" "watchdog.sh" "welcome.sh" "worker.sh" "vent.sh" )
# get length of script array
scriptslength=${#scriptsexecutable[@]}
# loop through all entries in the array
for (( i = 0; i < ${scriptslength}; i ++ )); do
	chmod +x "${scriptsexecutable[${i}]}"
done

# store serverdirectory
serverdirectory=`pwd`

# function for downloading serverfile from mojang api with error checking
function FetchServerFileFromMojang {
	PrintToTerminal "info" "downloading minecraft-server.${version}.jar..."
	wget -q -O "minecraft-server.${version}.jar" "https://launcher.mojang.com/v1/objects/${1}/server.jar"
	serverfile="${serverdirectory}/minecraft-server.${version}.jar"
	PrintToTerminal "ok" "download successful"
	if ! [[ -s "minecraft-server.${version}.jar" ]]; then
		PrintToTerminal "fatal" "downloaded server-file minecraft-server.${version}.jar is empty or not available"
	fi
}

# download java executable from mojang.com
PS3="which server version would you like to install? "
versions=("1.18.0" "1.17.1" "1.16.5")
select version in "${versions[@]}"; do
	case ${version} in
		"1.18.0")
			FetchServerFileFromMojang "3cf24a8694aca6267883b17d934efacc5e44440d"
			break
		;;
		"1.17.1")
			FetchServerFileFromMojang "a16d67e5807f57fc4e550299cf20226194497dc2"
			break
		;;
		"1.16.5")
			FetchServerFileFromMojang "1b557e7b033b583cd9f66746b7a9ab1ec1673ced"
			break
		;;
		*) echo "please choose an option from the list: ";;
	esac
done

# user information about execute at start
PrintToTerminal "info" "your server will execute ${serverfile} at start"

# set up backupdirectory with child directories
PrintToTerminal "info" "setting up a backupdirectory..."
mkdir world
mkdir backups
cd backups

# declare all backup children in an array
declare -a backupchildren=( "hourly" "daily" "weekly" "monthly" "cached")
# get length of backup children array
scriptslength=${#backupchildren[@]}
for (( i = 0; i < ${scriptslength}; i ++ )); do
	PrintToTerminal "info" "creating ${serverdirectory}/backups/${scriptslength[${i}-1]}"
	mkdir "${backupchildren[${i}]}"
done

backupdirectory=`pwd`
cd ${serverdirectory}

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

# eula question
PrintToTerminal "info" "would you like to accept the end user license agreement from mojang?"
PrintToTerminal "info" "if you say no your server will not be able to run"
PrintToTerminal "info" "if you say yes you must abide by their terms and conditions!"
read -p "(y/n): "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "please press y or n: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]
	then PrintToTerminal "ok" "accepting eula..."
	echo "eula=true" >> eula.txt
	else PrintToTerminal "error" "declining eula..."
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
PrintToTerminal "info" "storing variables in server.settings..."
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
StoreToSettings "replacebranch" "${branch}"

# store all the userinput
PrintToTerminal "info" "storing variables in server.properties..."
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

# create logfiles with welcome message
echo "Hello World, this ${servername}-server and log-file was created on ${date}" >> "${screenlog}"
echo "Hello World, this ${servername}-server and log-file was created on ${date}" >> "${backuplog}"
echo "" >> "${backuplog}"
echo "" >> "${backuplog}"

# store to crontab function
function StoreToCrontab {
	crontab -l | { cat; echo "${1}"; } | crontab -
}

# user info
PrintToTerminal "info" "storing config to crontab..."

# write servername and date into crontab
date=$(date +"%Y-%m-%d %H:%M:%S")
StoreToCrontab "# minecraft ${servername} server automatisation - executed setup.sh at ${date}"

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


# finish messages
PrintToTerminal "ok" "setup is complete!"
PrintToTerminal "info" "if you would like to start your server"
PrintToTerminal "info" "go into your ${green}${serverdirectory}${nocolor} directory"
PrintToTerminal "info" "and execute ${green}./start.sh${nocolor}"
PrintToTerminal "info" "god luck and have fun! ;^)"

# ask user for removal of setup script
read -p "would you like to remove the setup script? (y/n): "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "please press y or n: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
	cd "${homedirectory}"
	rm setup.sh
	cd "${serverdirectory}"
fi

# ask user to start server now
read -p "would you like to start your server now? (y/n): "
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "please press y or n: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
	PrintToTerminal "action" "starting up server..."
	./start.sh --verbose
else
	PrintToTerminal "ok" "script has finished!"
fi

# exit with code 0
exit 0
