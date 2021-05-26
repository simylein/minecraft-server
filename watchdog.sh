#!/bin/bash

# minecraft server watchdog script
# can be executed detached with ./watchdog.sh &

# root safety check
if [ $(id -u) = 0 ]; then
	echo "$(tput bold)$(tput setaf 1)please do not run me as root :( - this is dangerous!$(tput sgr0)"
	exit 1
fi

# read server.functions file with error checking
if [[ -s "server.functions" ]]; then
	. ./server.functions
else
	echo "$(date) fatal: server.functions is missing" >> fatalerror.log
	echo "$(tput setaf 1)fatal: server.functions is missing$(tput sgr0)"
	exit 1
fi

# read server.properties file with error checking
if ! [[ -s "server.properties" ]]; then
	echo "$(date) fatal: server.properties is missing" >> fatalerror.log
	echo "$(tput setaf 1)fatal: server.properties is missing$(tput sgr0)"
	exit 1
fi

# read server.settings file with error checking
if [[ -s "server.settings" ]]; then
	. ./server.settings
else
	echo "$(date) fatal: server.settings is missing" >> fatalerror.log
	echo "$(tput setaf 1)fatal: server.settings is missing$(tput sgr0)"
	exit 1
fi

# change to server directory with error checking
if [ -d "${serverdirectory}" ]; then
	cd ${serverdirectory}
else
	echo "$(date) fatal: serverdirectory is missing" >> fatalerror.log
	echo "${red}fatal: serverdirectory is missing${nocolor}"
	exit 1
fi

# write date to logfile
echo "${date} executing watchdog script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "server is not currently running!" >> ${screenlog}
	echo "${yellow}server is not currently running!${nocolor}"
	exit 1
fi

# write a function that checks if backups are done regularly
# if any irregularities are detected notify via ingame or logfiles
lastabsoluteworldsize="65536"
lastabsolutebackupsize="65536"
counter="0"
while true; do
	if [[ ${counter} -eq 120 ]]; then
		. ./server.settings
		timestamp=$(date +"%H:%M:%S")
		lasttimestamp=$(date -d -"2 minute" +"%H:%M:%S")
		if [[ ${absoluteworldsize} < $((${lastabsoluteworldsize} - 65536)) ]]; then
			screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"info: your world-size is getting smaller - this may result in a corrupted world\",\"hoverEvent\":{\"action\":\"show_text\",\"value\":{\"text\":\"\",\"extra\":[{\"text\":\"world-size at ${lasttimestamp} was ${lastabsoluteworldsize} bytes, world-size at ${timestamp} is ${absoluteworldsize} bytes\"}]}}}]$(printf '\r')"
			echo "info: your world-size is getting smaller - this may result in a corrupted world" >> ${backuplog}
			echo "info: world-size at ${timestamp} was ${lastabsoluteworldsize} bytes, world-size at ${lasttimestamp} is ${absoluteworldsize} bytes" >> ${backuplog}
			echo "" >> ${backuplog}
		fi
		if [[ ${absolutebackupsize} < $((${lastabsolutebackupsize} - 65536)) ]]; then
			screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"info: your backup-size is getting smaller - this may result in corrupted backups\",\"hoverEvent\":{\"action\":\"show_text\",\"value\":{\"text\":\"\",\"extra\":[{\"text\":\"backup-size at ${lasttimestamp} was ${lastabsolutebackupsize} bytes, backup-size at ${timestamp} is ${absolutebackupsize} bytes\"}]}}}]$(printf '\r')"
			echo "info: your backup-size is getting smaller - this may result in corrupted backups" >> ${backuplog}
			echo "info: backup-size at ${timestamp} was ${lastabsolutebackupsize} bytes, backup-size at ${lasttimestamp} is ${absolutebackupsize} bytes" >> ${backuplog}
			echo "" >> ${backuplog}
		fi
		lastabsoluteworldsize="${absoluteworldsize}"
		lastabsolutebackupsize="${absolutebackupsize}"
		counter="0"
	fi
	if ! screen -list | grep -q "\.${servername}"; then
		exit 0
	fi
	counter=$((counter+1))
	sleep 1s
done
