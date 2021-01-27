#!/bin/bash
# minecraft server start script

# read server.functions file with error checking
if [[ -f "server.functions" ]]; then
	. ./server.functions
else
	echo "fatal: server.functions is missing" >> fatalerror.log
	echo "fatal: server.functions is missing"
	exit 1
fi

# read server.properties file with error checking
if ! [[ -f "server.properties" ]]; then
	echo "fatal: server.properties is missing" >> fatalerror.log
	echo "fatal: server.properties is missing"
	exit 1
fi

# read server.settings file with error checking
if [[ -f "server.settings" ]]; then
	. ./server.settings
else
	echo "fatal: server.settings is missing" >> fatalerror.log
	echo "fatal: server.settings is missing"
	exit 1
fi

# change to server directory with error checking
if [ -d "${serverdirectory}" ]; then
	cd ${serverdirectory}
else
	echo "fatal: serverdirectory is missing" >> fatalerror.log
	echo "fatal: serverdirectory is missing"
	exit 1
fi

# check for executable
if ! ls ${serverfile}* 1> /dev/null 2>&1; then
	echo -e "${red}Warning: no executable found!${nocolor}"
	echo "Warning: no executable found!" >> ${screenlog}
	exit 1
fi

# padd logfile for visibility
echo "" >> ${screenlog}
echo "" >> ${screenlog}

# write date to logfile
echo "${date} executing start script" >> ${screenlog}

# check if server is already running
if screen -list | grep -q "${servername}"; then
	echo "Server is already running!  Type screen -r ${servername} to open the console" >> ${screenlog}
	echo -e "${yellow}Server is already running!  Type screen -r ${servername} to open the console${nocolor}"
	exit 1
fi

# check if interface is online
interfacechecks="0"
while [ $interfacechecks -lt 8 ]; do
	if ping -c 1 ${interface} &> /dev/null
	then echo -e "${green}Success: Interface is online${nocolor}" && echo "Success: Interface is online" >> ${screenlog}
		break
	else echo -e "${red}Warning: Interface is offline${nocolor}" && echo "Warning: Interface is offline" >> ${screenlog}
	fi
	sleep 1s
	interfacechecks=$((interfacechecks+1))
done

# check if dnsserver is online
networkchecks="0"
while [ $networkchecks -lt 8 ]; do
	if ping -c 1 ${dnsserver} &> /dev/null
	then echo -e "${green}Success: Nameserver is online${nocolor}" && echo "Success: Nameserver is online" >> ${screenlog}
		break
	else echo -e "${red}Warning: Nameserver is offline${nocolor}" && echo "Warning: Nameserver is offline" >> ${screenlog}
	fi
	sleep 1s
	networkchecks=$((networkchecks+1))
done

# user information
echo "Starting Minecraft server.  To view window type screen -r ${servername}."
echo "To minimise the window and let the server run in the background, press Ctrl+A then Ctrl+D"
echo "starting ${servername} server..." >> ${screenlog}
echo "starting ${servername} server..."	

# main start commmand
${screen} -dmSL ${servername} -Logfile ${screenlog} ${java} -server ${mems} ${memx} ${threadcount} -jar ${serverfile}
${screen} -r ${servername} -X colon "logfile flush 1^M"

# check if screen is avaible
counter="0"
startchecks="0"
while [ ${startchecks} -lt 10 ]; do
	if screen -list | grep -q "${servername}"; then
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
	echo -e "${red}something went wrong - server failed to start!${nocolor}"
	exit 1
fi

# succesful start sequence
echo "server is on startup..." >> ${screenlog}
echo -e "${green}server is on startup...${nocolor}"

# check if screenlog contains start comfirmation
counter="0"
startupchecks="0"
while [ ${startupchecks} -lt 60 ]; do
	if tail ${screenlog} | grep -q "Query running on"; then
		echo "server startup successful - query up and running" >> ${screenlog}
		echo -e "${green}server startup successful - query up and running${nocolor}"
		break
	fi
	if tail ${screenlog} | grep -q "Preparing spawn area"; then
		counter=$((counter+1))
	fi
	if [ ${counter} -ge 10 ]; then
		echo -e "server is preparing spawn area..."
		counter="0"
	fi
	startupchecks=$((startupchecks+1))
	sleep 1s
done

# check if screenlog does not contain startup confirmation
if ! tail ${screenlog} | grep -q "Query running on"; then
	echo "server startup unsuccessful - perhaps query is disabled" >> ${screenlog}
	echo -e "${yellow}server startup unsuccessful - perhaps query is disabled${nocolor}"
fi

# user information
echo "If you would like to change to server console - type screen -r ${servername}"
