#!/bin/bash
# minecraft server start script

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

# check for executable
if ! ls ${serverfile}* 1> /dev/null 2>&1; then
	echo "${red}fatal: no executable found!${nocolor}"
	echo "fatal: no executable found!" >> ${screenlog}
	echo "$(date) fatal: no executable found!" >> fatalerror.log
	exit 1
fi

# parsing script arguments
ParseScriptArguments "$@"

# padd logfile for visibility
echo "" >> ${screenlog}
echo "" >> ${screenlog}

# write date to logfile
echo "${date} executing start script" >> ${screenlog}

# check if server is already running
if screen -list | grep -q "\.${servername}"; then
	echo "Server is already running!  Type screen -r ${servername} to open the console" >> ${screenlog}
	echo "${yellow}Server is already running!  Type screen -r ${servername} to open the console${nocolor}"
	exit 1
fi

# check if interface is online
interfacechecks="0"
while [ ${interfacechecks} -lt 8 ]; do
	if ping -c 1 ${interface} &> /dev/null
	then
		CheckVerbose "${green}ok: interface is online${nocolor}"
		echo "ok: interface is online" >> ${screenlog}
		break
	else
		echo "${yellow}warning: interface is offline${nocolor}"
		echo "warning: interface is offline" >> ${screenlog}
	fi
	if [ ${interfacechecks} -eq 7 ]; then
		echo "${red}fatal: interface timed out${nocolor}"
		echo "fatal: interface timed out" >> ${screenlog}
	fi
	sleep 1s
	interfacechecks=$((interfacechecks+1))
done

# check if dnsserver is online
networkchecks="0"
while [ ${networkchecks} -lt 8 ]; do
	if ping -c 1 ${dnsserver} &> /dev/null
	then
		CheckVerbose "${green}ok: nameserver is online${nocolor}"
		echo "ok: nameserver is online" >> ${screenlog}
		break
	else
		echo "${yellow}warning: nameserver is offline${nocolor}"
		echo "warning: nameserver is offline" >> ${screenlog}
	fi
	if [ ${networkchecks} -eq 7 ]; then
		echo "${red}fatal: nameserver timed out${nocolor}"
		echo "fatal: nameserver timed out" >> ${screenlog}
	fi
	sleep 1s
	networkchecks=$((networkchecks+1))
done

# user information
CheckQuiet "Starting Minecraft server. To view window type screen -r ${servername}."
CheckQuiet "To minimise the window and let the server run in the background, press Ctrl+A then Ctrl+D"
echo "action: starting ${servername} server..." >> ${screenlog}
CheckVerbose "${cyan}action: starting ${servername} server...${nocolor}"

# main start commmand
${screen} -dmSL ${servername} -Logfile ${screenlog} ${java} -server ${mems} ${memx} ${threadcount} -jar ${serverfile} -nogui
${screen} -r ${servername} -X colon "logfile flush 1^M"

# check if screen is avaible
counter="0"
startchecks="0"
while [ ${startchecks} -lt 10 ]; do
	if screen -list | grep -q "\.${servername}"; then
		counter=$((counter+1))
	fi
	if [ ${counter} -eq 2 ]; then
		break
	fi
	startchecks=$((startchecks+1))
	sleep 1s
done

# if no screen output error
if ! screen -list | grep -q "${servername}"; then
	echo "fatal: something went wrong - server failed to start!" >> ${screenlog}
	echo "${red}fatal: something went wrong - server failed to start!${nocolor}"
	exit 1
fi

# succesful start sequence
echo "ok: server is on startup..." >> ${screenlog}
CheckQuiet "${green}ok: server is on startup...${nocolor}"

# check if screenlog contains start comfirmation
count="0"
counter="0"
startupchecks="0"
while [ ${startupchecks} -lt 120 ]; do
	if tail ${screenlog} | grep -q "Query running on"; then
		echo "ok: server startup successful - query up and running" >> ${screenlog}
		CheckQuiet "${green}ok: server startup successful - query up and running${nocolor}"
		break
	fi
	if tail -20 ${screenlog} | grep -q "FAILED TO BIND TO PORT"; then
		echo "fatal: server port is already in use - please change to another port" >> ${screenlog}
		echo "${red}fatal: server port is already in use - please change to another port${nocolor}"
		exit 1
	fi
	if ! screen -list | grep -q "${servername}"; then
		echo "fatal: something went wrong - server appears to have crashed!" >> ${screenlog}
		echo "${red}fatal: something went wrong - server appears to have crashed!${nocolor}"
		echo "info: crash dump - last 10 lines of ${screenlog}"
		tail -10 ${screenlog}
		exit 1
	fi
	if tail ${screenlog} | grep -q "Preparing spawn area"; then
		counter=$((counter+1))
	fi
	if tail ${screenlog} | grep -q "Environment"; then
		if [ ${count} -eq 0 ]; then
			CheckVerbose "info: server is loading the environment..."
		fi
		count=$((count+1))
	fi
	if tail ${screenlog} | grep -q "Reloading ResourceManager"; then
		count=$((count+1))
	fi
	if tail ${screenlog} | grep -q "Starting minecraft server"; then
		count=$((count+1))
	fi
	if [ ${counter} -ge 10 ]; then
		CheckVerbose "info: server is preparing spawn area..."
		counter="0"
	fi
	if [ ${count} -eq 0 ] && [ ${startupchecks} -eq 20 ]; then
		echo "warning: the server could be crashed" >> ${screenlog}
		echo "${yellow}warning: the server could be crashed${nocolor}"
		exit 1
	fi
	startupchecks=$((startupchecks+1))
	sleep 1s
done

# check if screenlog does not contain startup confirmation
if ! tail ${screenlog} | grep -q "Query running on"; then
	echo "warning: server startup unsuccessful - perhaps query is disabled" >> ${screenlog}
	echo "${yellow}warning: server startup unsuccessful - perhaps query is disabled${nocolor}"
fi

# enables the watchdog script for backup integrity
if [[ ${enablewatchdog} == true ]]; then
	CheckVerbose "info: activating watchdog..."
	./watchdog.sh &
fi

# check if user wants to send welcome messages
if [[ ${welcomemessage} == true ]]; then
	CheckVerbose "info: activating welcome messages..."
	./welcome.sh &
fi

# check if user wants to enable task execution
if [[ ${enabletasks} == true ]]; then
	CheckVerbose "info: activating task execution..."
	./worker.sh &
fi

# if set to true change automatically to server console
if [[ ${changetoconsole} == true ]]; then
	CheckVerbose "info: changing to server console..."
	screen -r ${servername}
fi

# user information
CheckQuiet "If you would like to change to server console - type ${green}screen -r ${servername}${nocolor}"

# exit with code 0
exit 0
