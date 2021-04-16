#!/bin/bash
# minecraft server start script

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
		CheckVerbose "${green}Success: Interface is online${nocolor}"
		echo "Success: Interface is online" >> ${screenlog}
		break
	else
		echo "${red}Warning: Interface is offline${nocolor}"
		echo "Warning: Interface is offline" >> ${screenlog}
	fi
	if [ ${interfacechecks} -eq 7 ]; then
		echo "${red}Fatal: Interface timed out${nocolor}"
		echo "Fatal: Interface timed out" >> ${screenlog}
	fi
	sleep 1s
	interfacechecks=$((interfacechecks+1))
done

# check if dnsserver is online
networkchecks="0"
while [ ${networkchecks} -lt 8 ]; do
	if ping -c 1 ${dnsserver} &> /dev/null
	then
		CheckVerbose "${green}Success: Nameserver is online${nocolor}"
		echo "Success: Nameserver is online" >> ${screenlog}
		break
	else
		echo "${red}Warning: Nameserver is offline${nocolor}"
		echo "Warning: Nameserver is offline" >> ${screenlog}
	fi
	if [ ${networkchecks} -eq 7 ]; then
		echo "${red}Fatal: Nameserver timed out${nocolor}"
		echo "Fatal: Nameserver timed out" >> ${screenlog}
	fi
	sleep 1s
	networkchecks=$((networkchecks+1))
done

# user information
CheckQuiet "Starting Minecraft server.  To view window type screen -r ${servername}."
CheckQuiet "To minimise the window and let the server run in the background, press Ctrl+A then Ctrl+D"
echo "starting ${servername} server..." >> ${screenlog}
CheckVerbose "starting ${servername} server..."	

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
	echo "something went wrong - server failed to start!" >> ${screenlog}
	echo "${red}something went wrong - server failed to start!${nocolor}"
	exit 1
fi

# succesful start sequence
echo "server is on startup..." >> ${screenlog}
CheckQuiet "${green}server is on startup...${nocolor}"

# check if screenlog contains start comfirmation
count="0"
counter="0"
startupchecks="0"
while [ ${startupchecks} -lt 120 ]; do
	if tail ${screenlog} | grep -q "Query running on"; then
		echo "server startup successful - query up and running" >> ${screenlog}
		CheckQuiet "${green}server startup successful - query up and running${nocolor}"
		break
	fi
	if tail -20 ${screenlog} | grep -q "FAILED TO BIND TO PORT"; then
		echo "server port is already in use - please change to another port" >> ${screenlog}
		echo "${red}server port is already in use - please change to another port${nocolor}"
		exit 1
	fi
	if ! screen -list | grep -q "${servername}"; then
		echo "Fatal: something went wrong - server appears to have crashed!" >> ${screenlog}
		echo "${red}Fatal: something went wrong - server appears to have crashed!${nocolor}"
		echo "crash dump - last 10 lines of ${screenlog}"
		tail -10 ${screenlog}
		exit 1
	fi
	if tail ${screenlog} | grep -q "Preparing spawn area"; then
		counter=$((counter+1))
	fi
	if tail ${screenlog} | grep -q "Environment"; then
		if [ ${count} -eq 0 ]; then
			CheckVerbose "server is loading the environment..."
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
		CheckVerbose "server is preparing spawn area..."
		counter="0"
	fi
	if [ ${count} -eq 0 ] && [ ${startupchecks} -eq 20 ]; then
		echo "Warning: the server could be crashed" >> ${screenlog}
		echo "${yellow}Warning: the server could be crashed${nocolor}"
		exit 1
	fi
	startupchecks=$((startupchecks+1))
	sleep 1s
done

# check if screenlog does not contain startup confirmation
if ! tail ${screenlog} | grep -q "Query running on"; then
	echo "server startup unsuccessful - perhaps query is disabled" >> ${screenlog}
	echo "${yellow}server startup unsuccessful - perhaps query is disabled${nocolor}"
fi

# enables the watchdog script for backup integrity
if [ ${enablewatchdog} = true ]; then
	CheckVerbose "activating watchdog..."
	./watchdog.sh &
fi

# check if user wants to send welcome messages
if [ ${welcomemessage} = true ]; then
	CheckVerbose "activating welcome messages..."
	./welcome.sh &
fi

# if set to true change automatically to server console
if [ ${changetoconsole} = true ]; then
	CheckVerbose "changing to server console..."
	screen -r ${servername}
	exit 1
fi

# user information
CheckQuiet "If you would like to change to server console - type screen -r ${servername}"
