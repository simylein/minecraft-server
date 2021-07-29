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

# parsing script arguments
ParseScriptArguments "$@"

# user safety function for confirmation
echo "${yellow}Are you sure you want to vent your server?${nocolor}"
read -p "If so, please type ${red}CONFIRM VENTING${nocolor} "
if [[ ${REPLY} == "CONFIRM VENTING" ]]; then
	echo "User confirmed venting - I will self-destruct now"
else
	echo "wrong token - please try again"
	exit 1
fi

# write date to logfile
echo "${date} executing self-destruct script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "server is not currently running!" >> ${screenlog}
	echo "${yellow}server is not currently running!${nocolor}"
	counter="10"
	# check if immediately is specified
	if ! [[ ${immediately} == true ]]; then
		while [ ${counter} -gt 0 ]; do
			if [[ "${counter}" =~ ^(10|9|8|7|6|5|4|3|2|1)$ ]]; then
				CheckQuiet "${blue}[Script]${nocolor} ${red}server is self-destructing in ${counter} seconds${nocolor}"
			fi
			counter=$((counter-1))
			sleep 1s
		done
	fi
	cd ${homedirectory}
	# remove crontab
	crontab -r
	# remove serverdirectory
	echo "deleting server..."
	rm -r ${servername}
	# check if vent was successful
	if ! [ -d "${serverdirectory}" ]; then
		# game over terminal screen
		PrintGameOver
		exit 0
	else
		# error if serverdirectory still exists
		echo "${red}venting failed!${nocolor}"
		exit 1
	fi
fi

# warning
echo "${blue}[Script]${nocolor} ${red}WARNING: venting startet!${nocolor}"
screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"WARNING: venting startet!\",\"color\":\"red\"}]$(printf '\r')"

# sleep for 2 seconds
sleep 2s

# check if immediately is specified
if ! [[ ${immediately} == true ]]; then
	# countdown
	counter="120"
	while [ ${counter} -gt 0 ]; do
		if [[ "${counter}" =~ ^(120|60|40|20|10|9|8|7|6|5|4|3|2|1)$ ]]; then
			CheckQuiet "${blue}[Script]${nocolor} ${red}server is self-destructing in ${counter} seconds${nocolor}"
			screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"server is self-destructing in ${counter} seconds\",\"color\":\"red\"}]$(printf '\r')"
		fi
		counter=$((counter-1))
		sleep 1s
	done
fi

# game over
echo "${blue}[Script]${nocolor} ${red}GAME OVER${nocolor}"
screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"GAME OVER\",\"color\":\"red\"}]$(printf '\r')"

# sleep 2 seconds
sleep 2s

# stop command
echo "stopping server..."
screen -Rd ${servername} -X stuff "say deleting server...$(printf '\r')"
screen -Rd ${servername} -X stuff "stop$(printf '\r')"

# check if server stopped
stopchecks="0"
while [ $stopchecks -lt 30 ]; do
	if ! screen -list | grep -q "\.${servername}"; then
		break
	fi
	stopchecks=$((stopchecks+1))
	sleep 1;
done

# force quit server if not stopped
if screen -list | grep -q "${servername}"; then
	echo "${yellow}minecraft server still hasn't closed after 30 seconds, closing screen manually${nocolor}"
	screen -S ${servername} -X quit
fi

# sleep 2 seconds
sleep 2s

cd ${homedirectory}
# remove crontab
crontab -r
# remove serverdirectory
echo "deleting server..."
rm -r ${servername}
# check if vent was successful
if ! [ -d "${serverdirectory}" ]; then
	# game over terminal screen
	PrintGameOver
	exit 0
else
	# error if serverdirectory still exists
	echo "${red}venting failed!${nocolor}"
	exit 1
fi

# exit with code 0
exit 0
