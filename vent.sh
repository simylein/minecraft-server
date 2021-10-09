#!/bin/bash
# minecraft server selft-destruct script

# WARNING do not execute unless you want to delete your server

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
	cd "${serverdirectory}"
else
	echo "$(date) fatal: serverdirectory is missing" >> "fatalerror.log"
	echo "${red}fatal: serverdirectory is missing${nocolor}"
	exit 1
fi

# log to debug if true
CheckDebug "executing vent script"

# parsing script arguments
ParseScriptArguments "$@"

# user safety function for confirmation
PrintToTerminal "warn" "are you sure you want to vent your server?"
read -p "if so, please type ${red}confirm venting${nocolor} "
if [[ ${REPLY} == "confirm venting" ]]; then
	PrintToTerminal "info" "user confirmed venting - server will self-destruct now"
else
	PrintToTerminal "error" "wrong token - please try again"
	exit 1
fi

# write date to logfile
PrintToLog "action" "${date} executing self-destruct script" "${screenlog}"

# warning
PrintToTerminal "action" "self-destructing server"
PrintToScreen "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"self-destructing server\",\"color\":\"red\"}]"

# sleep for 2 seconds
sleep 2s

# check if now is specified
if ! [[ ${now} == true ]]; then
	# countdown
	counter="120"
	while [ ${counter} -gt 0 ]; do
		if [[ "${counter}" =~ ^(120|60|40|20|10|9|8|7|6|5|4|3|2|1)$ ]]; then
			CheckQuiet "${blue}[Script]${nocolor} ${red}server is self-destructing in ${counter} seconds${nocolor}"
			PrintToScreen "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"server is self-destructing in ${counter} seconds\",\"color\":\"red\"}]"
		fi
		counter=$((counter-1))
		sleep 1s
	done
fi

# game over
echo "${blue}[Script]${nocolor} ${red}GAME OVER${nocolor}"
PrintToScreen "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"GAME OVER\",\"color\":\"red\"}]"

# sleep 2 seconds
sleep 2s

# check if server is running
if screen -list | grep -q "\.${servername}"; then

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

# sleep 2 seconds
sleep 2s

cd "${homedirectory}"
# remove crontab
crontab -r
# remove serverdirectory
echo "deleting server..."
rm -r "${servername}"
# check if vent was successful
if ! [ -d "${serverdirectory}" ]; then
	# game over terminal screen
	PrintGameOver
	exit 0
else
	# error if serverdirectory still exists
	PrintToTerminal "error" "venting failed!"
	exit 1
fi

# exit with code 0
exit 0
