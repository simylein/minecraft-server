#!/bin/bash
# minecraft server update script

# root safety check
if [ $(id -u) = 0 ]; then
	echo "$(tput bold)$(tput setaf 1)please do not run me as root :( - this is dangerous!$(tput sgr0)"
	exit 1
fi

# read server.functions file with error checking
if [[ -s "server.functions" ]]; then
	. ./server.functions
else
	echo "$(date) fatal: server.functions is missing" >> "fatalerror.log"
	echo "$(tput setaf 1)fatal: server.functions is missing$(tput sgr0)"
	exit 1
fi

# read server.properties file with error checking
if ! [[ -s "server.properties" ]]; then
	echo "$(date) fatal: server.properties is missing" >> "fatalerror.log"
	echo "$(tput setaf 1)fatal: server.properties is missing$(tput sgr0)"
	exit 1
fi

# read server.settings file with error checking
if [[ -s "server.settings" ]]; then
	. ./server.settings
else
	echo "$(date) fatal: server.settings is missing" >> "fatalerror.log"
	echo "$(tput setaf 1)fatal: server.settings is missing$(tput sgr0)"
	exit 1
fi

# change to server directory with error checking
if [ -d "${serverdirectory}" ]; then
	cd ${serverdirectory}
else
	echo "$(date) fatal: serverdirectory is missing" >> "fatalerror.log"
	echo "${red}fatal: serverdirectory is missing${nocolor}"
	exit 1
fi

# log to debug if true
CheckDebug "executing update script"

# parsing script arguments
ParseScriptArguments "$@"

# write date to logfile
PrintToLog "action" "${date} executing update script" "${screenlog}"

# check if server is running
if screen -list | grep -q "\.${servername}"; then

	# prints countdown to screen
	PerformCountdown "updating"
	
	# server stop
	PerformServerStop
	
	# awaits server stop
	AwaitServerStop
	
	# force quit server if not stopped
	ConditionalForceQuit
	
	# output confirmed stop
	PrintToLog "ok" "server successfully stopped!" "${screenlog}"
	CheckQuiet "ok" "server successfully stopped!"
fi

# create backup
CreateCachedBackup "update"

# Test internet connectivity and update on success
wget --spider --quiet "https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar"
if [ "$?" != 0 ]; then
	PrintToTerminal "warn" "unable to connect to mojang api skipping update..."
	PrintToLog "warn" "unable to connect to mojang api skipping update..." "${screenlog}"
else
	CheckQuiet "ok" "downloading newest server version..."
	PrintToLog "info" "downloading newest server version..." "${screenlog}"
	# check if already on newest version
	if [[ "${serverfile}" = *"minecraft-server.1.18.1.jar" ]]; then
		CheckVerbose "info" "you are running the newest server version - skipping update"
		PrintToLog "info" "you are running the newest server version - skipping update" "${screenlog}"
	else
		wget -q -O "minecraft-server.1.18.1.jar" "https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar"
		# update serverfile variable in server.settings
		newserverfile="${serverdirectory}/minecraft-server.1.18.0.jar"
		# if new serverfile exists remove oldserverfile
		if [ -f "${newserverfile}" ]; then
			CheckVerbose "ok" "updating server.settings for startup with new server version 1.18.1"
			sed -i "s|${serverfile}|${newserverfile}|g" "server.settings"
			# remove old serverfile if it exists
			if [ -f "${serverfile}" ]; then
				rm ${serverfile}
			fi
		else
			PrintToTerminal "warn" "could not remove old server-file ${serverfile} because new server-file ${newserverfile} is missing"
			CheckQuiet "info" "server will startup with old server-file ${serverfile}"
		fi
	fi
fi

# remove scripts from serverdirectory
RemoveScriptsFromServerDirectory

# downloading scripts from github
DownloadScriptsFromGitHub

# make selected scripts executable
MakeScriptsExecutable

# restart the server
CheckQuiet "action" "restarting server..."
./start.sh "$@"

# log to debug if true
CheckDebug "executed update script"

# exit with code 0
exit 0
