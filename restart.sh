#!/bin/bash
# minecraft server restart script

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

# write date to logfile
echo "${date} executing restart script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "${yellow}server is not currently running!${nocolor}"
	echo "${yellow}server not running - starting server now!${nocolor}"
	echo "server not running - starting server now!" >> ${screenlog}
	./start.sh
	exit 1
fi

# check if immediatly is specified
if ! [[ ${immediatly} == true ]]; then
	# countdown
	counter="60"
	while [ ${counter} -gt 0 ]; do
		if [[ "${counter}" =~ ^(60|40|20|10|5|4|3|2|1)$ ]];then
			CheckQuiet "${blue}[Script]${nocolor} server is restarting in ${counter} seconds"
			screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"server is restarting in ${counter} seconds\"}]$(printf '\r')"
		fi
		counter=$((counter-1))
		sleep 1s
	done
fi

# server stop
CheckQuiet "stopping server..."
PrintToScreen "say stopping server..."
PrintToScreen "stop"

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

# restart the server
CheckQuiet "${cyan}restarting server...${nocolor}"
./start.sh "$@"

# exit with code 0
exit 0
