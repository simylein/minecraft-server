#!/bin/bash

# minecraft server worker script
# is meant to be executed detached with ./worker.sh & by start.sh

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

# write date to logfile
echo "${date} executing worker script" >> "${screenlog}"

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "server is not currently running!" >> "${screenlog}"
	echo "${yellow}server is not currently running!${nocolor}"
	exit 1
fi

# check every second if a player with permission request a task
# write a function that checks if backups are done regularly
# if any irregularities are detected notify via ingame or logfiles
# array with different welcome messages
welcome=( "Welcome on my server" "A warm welcome to" "Greetings" "Hello to" "Welcome aboard" "Make yourself at home" "Have a nice time" )
linebuffer=$(tail -1 "${screenlog}")
lastabsolutebackupsize="65536"
lastabsoluteworldsize="65536"
lastlinebuffer="${linebuffer}"
counter="0"
while true; do
	# welcome messages
	if [[ ${welcomemessage} == true ]]; then
		size=${#welcome[@]}
		index=$(($RANDOM % $size))
		timestamp=$(date +"%H:%M:%S")
		if tail -1 screen.log | grep -q "joined the game"; then
			welcomemsg=${welcome[$index]}
			player=$(tail -1 screen.log | grep -oP '.*?(?=joined the game)' | cut -d ' ' -f 4- | sed 's/.$//')
			screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"${welcomemsg} ${player}\",\"hoverEvent\":{\"action\":\"show_text\",\"value\":{\"text\":\"\",\"extra\":[{\"text\":\"player ${player} joined at ${timestamp}\"}]}}}]$(printf '\r')"
		fi
	fi
	# admin tasks
	if [[ ${enabletasks} == true ]]; then
		linebuffer=$(tail -1 "${screenlog}")
		if [[ ! ${linebuffer} == ${lastlinebuffer} ]]; then
			if [[ ${enablesafetybackupstring} == true ]]; then # check if safety backup is enabled
				CheckSafetyBackupString
			fi
			if [[ ${enableconfirmrestartstring} == true ]]; then # check if safety backup is enabled
				CheckConfirmRestartString
			fi
			if [[ ${enableconfirmupdatestring} == true ]]; then # check if safety backup is enabled
				CheckConfirmUpdateString
			fi
			if [[ ${enableconfirmresetstring} == true ]]; then # check if safety backup is enabled
				CheckConfirmResetString
			fi
		fi
		linebuffer=$(tail -1 "${screenlog}") # store last line of screen log into buffer
	fi
	# watchdog
	if [[ ${enablewatchdog} == true ]]; then
		if [[ ${counter} -eq 120 ]]; then
			. ./server.settings
			timestamp=$(date +"%H:%M:%S")
			lasttimestamp=$(date -d -"2 minute" +"%H:%M:%S")
			if [[ ${absoluteworldsize} < $((${lastabsoluteworldsize} - 65536)) ]]; then
				screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"info: your world-size is getting smaller - this may result in a corrupted world\",\"hoverEvent\":{\"action\":\"show_text\",\"value\":{\"text\":\"\",\"extra\":[{\"text\":\"world-size at ${lasttimestamp} was ${lastabsoluteworldsize} bytes, world-size at ${timestamp} is ${absoluteworldsize} bytes\"}]}}}]$(printf '\r')"
				echo "info: your world-size is getting smaller - this may result in a corrupted world" >> "${backuplog}"
				echo "info: world-size at ${timestamp} was ${lastabsoluteworldsize} bytes, world-size at ${lasttimestamp} is ${absoluteworldsize} bytes" >> "${backuplog}"
				echo "" >> ${backuplog}
			fi
			if [[ ${absolutebackupsize} < $((${lastabsolutebackupsize} - 65536)) ]]; then
				screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"info: your backup-size is getting smaller - this may result in corrupted backups\",\"hoverEvent\":{\"action\":\"show_text\",\"value\":{\"text\":\"\",\"extra\":[{\"text\":\"backup-size at ${lasttimestamp} was ${lastabsolutebackupsize} bytes, backup-size at ${timestamp} is ${absolutebackupsize} bytes\"}]}}}]$(printf '\r')"
				echo "info: your backup-size is getting smaller - this may result in corrupted backups" >> "${backuplog}"
				echo "info: backup-size at ${timestamp} was ${lastabsolutebackupsize} bytes, backup-size at ${lasttimestamp} is ${absolutebackupsize} bytes" >> "${backuplog}"
				echo "" >> ${backuplog}
			fi
			lastabsoluteworldsize="${absoluteworldsize}"
			lastabsolutebackupsize="${absolutebackupsize}"
			counter="0"
		fi
	fi
	# autostart on crash or exit
	if ! screen -list | grep -q "\.${servername}"; then
		if [[ ${enablestartoncrash} == true ]]; then
			./start.sh --quiet
		else
			exit 0
		fi
	fi
	# variables
	lastlinebuffer="${linebuffer}"
	counter=$((counter+1))
	sleep 1s
done
