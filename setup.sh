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
noColor="$(tput sgr0)"

# prints all input to terminal at given log level
function Print {
	if [[ ${1} == "ok" ]]; then
		echo "$(date +"%H:%M:%S") ${green}ok${noColor}: ${2}"
	fi
	if [[ ${1} == "info" ]]; then
		echo "$(date +"%H:%M:%S") ${blue}info${noColor}: ${2}"
	fi
	if [[ ${1} == "warn" ]]; then
		echo "$(date +"%H:%M:%S") ${yellow}warn${noColor}: ${2}"
	fi
	if [[ ${1} == "error" ]]; then
		echo "$(date +"%H:%M:%S") ${red}error${noColor}: ${2}"
	fi
	if [[ ${1} == "fatal" ]]; then
		echo "$(date +"%H:%M:%S") ${red}fatal${noColor}: ${2}"
	fi
	if [[ ${1} == "action" ]]; then
		echo "$(date +"%H:%M:%S") ${cyan}action${noColor}: ${2}"
	fi
}

# function for parsing all arguments of script
function ParseArgs {
	nameArg=false
	proceedArg=false
	versionArg=false
	eulaArg=false
	portArg=false
	removeArg=false
	startArg=false
	help=false
	while [[ $# -gt 0 ]]; do
		case "${1}" in
		--name)
			nameArg=true
			shift
			nameVal="${1}"
			;;
		--proceed)
			proceedArg=true
			shift
			proceedVal="${1}"
			;;
		--version)
			versionArg=true
			shift
			versionVal="${1}"
			;;
		--eula)
			eulaArg=true
			shift
			eulaVal="${1}"
			;;
		--port)
			portArg=true
			shift
			portVal="${1}"
			;;
		--remove)
			removeArg=true
			shift
			removeVal="${1}"
			;;
		--start)
			startArg=true
			shift
			startVal="${1}"
			;;
		--help)
			help=true
			;;
		*)
			Print "warn" "bad argument: ${1}"
			Print "info" "for help use --help"
			;;
		esac
		shift
	done
}

# prints arguments help
function ArgHelp {
	if [[ ${help} == true ]]; then
		Print "info" "available arguments:"
		Print "info" "argument   example     type     explanation"
		Print "info" "--name     minecraft   string   (your server name)"
		Print "info" "--proceed  true        boolean  (proceed without user input)"
		Print "info" "--version  1.18.1      string   (minecraft server version)"
		Print "info" "--eula     true        boolean  (accept eula from mojang)"
		Print "info" "--port     25565       number   (server port to run on)"
		Print "info" "--remove   true        boolean  (remove script after execution)"
		Print "info" "--start    true        boolean  (start server after execution)"
		exit 0
	fi
}

# function for storing variables in server.settings
function StoreSettings {
	sed -i "s|${1}|${2}|g" server.settings
}

# function for storing settings in server.properties
function StoreProperties {
	sed -i "s|${1}|${2}|g" server.properties
}

# store to crontab function
function StoreCrontab {
	crontab -l | {
		cat
		echo "${1}"
	} | crontab -
}

# check for Linux
function CheckLinux {
	if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		# inform user about Linux
		Print "ok" "you are running Linux as your operating system - your server will likely run!"
		# get free memory on linux
		memory="$(free -b | tail -2 | head -1 | awk '{print $4}')"
		# check memory
		if ((${memory} < 2560000000)); then
			Print "warn" "your system has less than 2.56 GB of memory - this may impact server performance!"
		fi
		# get number of threads on Linux
		threads=$(nproc)
		# check threads
		if ((${threads} < 4)); then
			Print "warn" "your system has less than 4 threads - this may impact server performance!"
		fi
		supported=true
	else
		supported=false
	fi
}

# check for macOS
function CheckMacOS {
	if [ "$(uname)" == "Darwin" ]; then
		# inform user about macOS
		Print "warn" "you are running macOS as your operating system - your server may not run!"
		# get free memory on macOS
		memory=$(($(vm_stat | head -2 | tail -1 | awk '{print $3}' | sed 's/.$//') + $(vm_stat | head -4 | tail -1 | awk '{print $3}' | sed 's/.$//') * 4096))
		# check memory
		if ((${memory} < 2560000000)); then
			Print "warn" "your system has less than 2.56 GB of memory - this may impact server performance!"
		fi
		# get number of threads on macOS
		threads=$(nproc)
		# check threads
		if ((${threads} < 4)); then
			Print "warn" "your system has less than 4 threads - this may impact server performance!"
		fi
		supported=true
	else
		supported=false
	fi
}

# check for Windows
function CheckWindows {
	if [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
		# inform user about Windows
		Print "fatal" "you are running Windows as your operating system - your server will not run!"
		supported=false
		exit 1
	fi
}

# check for unsupported OS
function CheckUnsupported {
	if [ supported == false ]; then
		# inform user about unsupported operating system
		Print "fatal" "you are running an unsupported operating system - your server will not run!"
		exit 1
	fi
}

# function for downloading server file from mojang api with error checking
function FetchServerFile {
	Print "info" "downloading minecraft-server.${version}.jar..."
	wget -q -O "minecraft-server.${version}.jar" "https://launcher.mojang.com/v1/objects/${1}/server.jar"
	executableServerFile="${serverDirectory}/minecraft-server.${version}.jar"
	if [[ -s "minecraft-server.${version}.jar" ]]; then
		Print "ok" "download successful"
	else
		Print "fatal" "downloaded server-file minecraft-server.${version}.jar is empty or not available"
	fi
}

# root safety check
function RootSafety {
	if [ $(id -u) = 0 ]; then
		Print "fatal" "please do not run me as root :( - this is dangerous!"
		exit 1
	fi
}

# checks if a script is already running
function ScriptSafety {
	if [[ ${force} == false ]]; then
		if pidof -x "setup.sh" &>/dev/null; then
			Print "warn" "script setup.sh is already running"
			exit 1
		fi
	fi
}

# safety
RootSafety
ScriptSafety

# os detection
CheckLinux
CheckMacOS
CheckWindows
CheckUnsupported

# arguments
ParseArgs "$@"
ArgHelp

# user info about script
Print "action" "i will setup a minecraft server for you ;^)"

# initial question
if [[ ${nameArg} == false ]]; then
	read -re -i "minecraft" -p "$(date +"%H:%M:%S") prompt: how should I call your server? your name: " serverName
elif [[ ${nameArg} == true ]]; then
	serverName="${nameVal}"
fi
regex="^[a-zA-Z0-9]+$"
verify=false
while [[ ${verify} == false ]]; do
	if [[ ! "${serverName}" =~ ${regex} ]]; then
		read -p "$(date +"%H:%M:%S") prompt: please enter a name which only contains letters and numbers: " serverName
	else
		regexCheck=true
	fi
	if [ -d "${serverName}" ]; then
		read -p "$(date +"%H:%M:%S") prompt: directory ${serverName} already exists - please enter another directory: " serverName
	else
		existsCheck=true
	fi
	if [[ ${regexCheck} == true ]] && [[ ${existsCheck} == true ]]; then
		verify=true
	else
		verify=false
	fi
done

# user info
Print "info" "your server will be called ${green}${serverName}${noColor}"

# store homedirectory
homeDirectory=$(pwd)

# ask for permission to proceed
Print "info" "i will download start, stop, restart, backup and many more scripts from github"
if [[ ${proceedArg} == false ]]; then
	read -p "$(date +"%H:%M:%S") prompt: proceed? (y/n): " answer
elif [[ ${proceedArg} == true ]]; then
	if [[ ${proceedVal} == true ]]; then
		answer=y
	elif [[ ${proceedVal} == false ]]; then
		answer=n
	fi
fi
regex="^(Y|y|N|n)$"
while [[ ! ${answer} =~ ${regex} ]]; do
	read -p "$(date +"%H:%M:%S") prompt: please press y or n: " answer
done
if [[ $answer =~ ^[Yy]$ ]]; then
	Print "ok" "starting setup..."
else
	Print "error" "exiting..."
	exit 1
fi

# set up server directory
Print "info" "setting up a serverdirectory..."
mkdir "${serverName}"
cd "${serverName}"

# user info about download
Print "info" "downloading scripts from github..."

# downloading scripts from github
declare -a scriptsDownload=("server.settings" "server.properties" "server.functions" "start.sh" "restore.sh" "reset.sh" "restart.sh" "stop.sh" "backup.sh" "update.sh" "worker.sh" "vent.sh")
arrayLength=${#scriptsDownload[@]}
for ((i = 0; i < ${arrayLength}; i++)); do
	wget -q -O "${scriptsDownload[${i}]}" "https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/${scriptsDownload[${i}]}"
done

# user info about download
Print "ok" "download successful"

# make selected scripts executable
declare -a scriptsExecutable=("start.sh" "restore.sh" "reset.sh" "restart.sh" "stop.sh" "backup.sh" "update.sh" "worker.sh" "vent.sh")
arrayLength=${#scriptsExecutable[@]}
for ((i = 0; i < ${arrayLength}; i++)); do
	chmod +x "${scriptsExecutable[${i}]}"
done

# store serverdirectory
serverDirectory=$(pwd)

# download java executable from mojang
if [[ ${versionArg} == false ]]; then
	PS3="$(date +"%H:%M:%S") prompt: which server version would you like to install? "
	versions=("1.18.1" "1.17.1" "1.16.5")
	select version in "${versions[@]}"; do
		case ${version} in
		"1.18.1")
			FetchServerFile "125e5adf40c659fd3bce3e66e67a16bb49ecc1b9"
			break
			;;
		"1.17.1")
			FetchServerFile "a16d67e5807f57fc4e550299cf20226194497dc2"
			break
			;;
		"1.16.5")
			FetchServerFile "1b557e7b033b583cd9f66746b7a9ab1ec1673ced"
			break
			;;
		*)
			echo "please choose an option from the list: "
			;;
		esac
	done
elif [[ ${versionArg} == true ]]; then
	version="${versionVal}"
	case ${version} in
	"1.18.1")
		FetchServerFile "125e5adf40c659fd3bce3e66e67a16bb49ecc1b9"
		;;
	"1.17.1")
		FetchServerFile "a16d67e5807f57fc4e550299cf20226194497dc2"
		;;
	"1.16.5")
		FetchServerFile "1b557e7b033b583cd9f66746b7a9ab1ec1673ced"
		;;
	*)
		echo "please choose an option from the list: "
		;;
	esac
fi

# user information about execute at start
Print "info" "your server will execute ${executableServerFile} at start"

# set up backupdirectory with child directories
Print "info" "setting up a backupdirectory..."
mkdir world
mkdir backups
cd backups
declare -a backupChildren=("hourly" "daily" "weekly" "monthly" "cached")
arrayLength=${#backupChildren[@]}
for ((i = 0; i < ${arrayLength}; i++)); do
	mkdir "${backupChildren[${i}]}"
done
backupDirectory=$(pwd)
cd ${serverDirectory}

# eula question
Print "info" "would you like to accept the end user license agreement from mojang?"
if [[ ${eulaArg} == false ]]; then
	read -p "$(date +"%H:%M:%S") prompt: (y/n): " answer
elif [[ ${eulaArg} == true ]]; then
	if [[ ${eulaVal} == true ]]; then
		answer=y
	elif [[ ${eulaVal} == false ]]; then
		answer=n
	fi
fi
regex="^(Y|y|N|n)$"
while [[ ! ${answer} =~ ${regex} ]]; do
	read -p "$(date +"%H:%M:%S") prompt: please press y or n: " answer
done
if [[ ${answer} =~ ^[Yy]$ ]]; then
	Print "ok" "accepting eula..."
	echo "eula=true" >>eula.txt
else
	Print "error" "declining eula..."
	echo "eula=false" >>eula.txt
fi

# determine server port
if [[ ${portArg} == true ]]; then
	StoreProperties "server-port=25565" "server-port=${portVal}"
fi

# store to settings
Print "info" "storing variables in server.settings..."
StoreSettings "replaceBranch" "${branch}"
StoreSettings "replaceServerName" "${serverName}"
StoreSettings "replaceHomeDirectory" "${homeDirectory}"
StoreSettings "replaceServerDirectory" "${serverDirectory}"
StoreSettings "replaceBackupDirectory" "${backupDirectory}"
StoreSettings "replaceExecutableServerFile" "${executableServerFile}"

# store to properties
Print "info" "storing variables in server.properties..."
StoreProperties "white-list=false" "white-list=true"
StoreProperties "enforce-whitelist=false" "enforce-whitelist=true"
StoreProperties "op-permission-level=4" "op-permission-level=3"
StoreProperties "difficulty=easy" "difficulty=normal"
StoreProperties "max-players=20" "max-players=8"
StoreProperties "view-distance=10" "view-distance=16"
StoreProperties "simulation-distance=10" "simulation-distance=8"
StoreProperties "sync-chunk-writes=true" "sync-chunk-writes=false"
StoreProperties "motd=A Minecraft Server" "motd=Hello World, I am your new Minecraft Server ;^)"

# store to crontab
Print "info" "storing config to crontab..."
date=$(date +"%Y-%m-%d %H:%M:%S")
StoreCrontab "# minecraft ${serverName} server automatisation - executed setup.sh at $(date +"%Y-%m-%d %H:%M:%S")"
StoreCrontab ""
StoreCrontab "#MAILTO=youremail@example.com"
StoreCrontab "TERM=xterm"
StoreCrontab ""
StoreCrontab "# minecraft ${serverName} server backup hourly at **:00"
StoreCrontab "0 * * * * cd ${serverDirectory} && ./backup.sh --hourly --quiet"
StoreCrontab "# minecraft ${serverName} server backup daily at **:00"
StoreCrontab "0 0 * * * cd ${serverDirectory} && ./backup.sh --daily --quiet"
StoreCrontab "# minecraft ${serverName} server backup weekly at **:00"
StoreCrontab "0 0 * * 0 cd ${serverDirectory} && ./backup.sh --weekly --quiet"
StoreCrontab "# minecraft ${serverName} server backup monthly at **:00"
StoreCrontab "0 0 1 * * cd ${serverDirectory} && ./backup.sh --monthly --quiet"
StoreCrontab "# minecraft ${serverName} server startup at boot"
StoreCrontab "@reboot cd ${serverDirectory} && ./start.sh --quiet"
StoreCrontab ""
StoreCrontab ""

# finish message
Print "ok" "setup is complete!"

# ask user for removal of setup script
if [[ ${removeArg} == false ]]; then
	read -p "$(date +"%H:%M:%S") prompt: would you like to remove the setup script? (y/n): " answer
elif [[ ${removeArg} == true ]]; then
	if [[ ${removeVal} == true ]]; then
		answer=y
	elif [[ ${removeVal} == false ]]; then
		answer=n
	fi
fi
regex="^(Y|y|N|n)$"
while [[ ! ${answer} =~ ${regex} ]]; do
	read -p "$(date +"%H:%M:%S") prompt: please press y or n: " answer
done
if [[ ${answer} =~ ^[Yy]$ ]]; then
	cd "${homeDirectory}"
	rm setup.sh
	cd "${serverDirectory}"
fi

# ask user to start server now
if [[ ${startArg} == false ]]; then
	read -p "$(date +"%H:%M:%S") prompt: would you like to start your server now? (y/n): " answer
elif [[ ${startArg} == true ]]; then
	if [[ ${startVal} == true ]]; then
		answer=y
	elif [[ ${startVal} == false ]]; then
		answer=n
	fi
fi

regex="^(Y|y|N|n)$"
while [[ ! ${answer} =~ ${regex} ]]; do
	read -p "$(date +"%H:%M:%S") prompt: please press y or n: " answer
done
if [[ ${answer} =~ ^[Yy]$ ]]; then
	Print "action" "starting up server..."
	./start.sh
else
	Print "ok" "script has finished!"
fi

# exit with code 0
exit 0
