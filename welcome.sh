#!/bin/bash

# minecraft server welcome script
# can be executed detached with ./welcome.sh &

# root safety check
if [ $(id -u) = 0 ]; then
	echo "$(tput bold)$(tput setaf 1)please do not run me as root :( - this is dangerous!$(tput sgr0)"
	exit 1
fi

# read server.functions file with error checking
if [[ -f "server.functions" ]]; then
	. ./server.functions
else
	echo "$(date) fatal: server.functions is missing" >> fatalerror.log
	echo "fatal: server.functions is missing"
	exit 1
fi

# read server.properties file with error checking
if ! [[ -f "server.properties" ]]; then
	echo "$(date) fatal: server.properties is missing" >> fatalerror.log
	echo "fatal: server.properties is missing"
	exit 1
fi

# read server.settings file with error checking
if [[ -f "server.settings" ]]; then
	. ./server.settings
else
	echo "$(date) fatal: server.settings is missing" >> fatalerror.log
	echo "fatal: server.settings is missing"
	exit 1
fi

# change to server directory with error checking
if [ -d "${serverdirectory}" ]; then
	cd ${serverdirectory}
else
	echo "$(date) fatal: serverdirectory is missing" >> fatalerror.log
	echo "fatal: serverdirectory is missing"
	exit 1
fi

# write date to logfile
echo "${date} executing welcome script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "server is not currently running!" >> ${screenlog}
	echo "${yellow}server is not currently running!${nocolor}"
	exit 1
fi

# array with different welcome messages
welcome=( "Welcome on my server" "A warm welcome to" "Greetings" "Hello to" "Welcome aboard" "Make yourself at home" "Have a nice time" )

# check every second if a player joins and welcome them by name with a random welcome message
while true; do
	size=${#welcome[@]}
	index=$(($RANDOM % $size))
	if tail -1 screen.log | grep -q "joined the game"; then
		welcomemsg=${welcome[$index]}
		player=$(tail -1 screen.log | grep -oP '.*?(?=joined the game)' | cut -d ' ' -f 4-)
		screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"${welcomemsg} ${player}\"}]$(printf '\r')"
	fi
	if ! screen -list | grep -q "\.${servername}"; then
		exit 1
	fi
	sleep 1s
done
