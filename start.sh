#!/bin/bash
# minecraft server start script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# write date to logfile
echo "executing start script at" >> ${screenlog} && date >> ${screenlog}

# check if server is already running
if screen -list | grep -q "${servername}";then
	echo "Server is already running!  Type screen -r ${servername} to open the console" >> ${screenlog}
	echo -e "${yellow}Server is already running!  Type screen -r ${servername} to open the console${nocolor}"
	exit 1
fi

# check if interface is online
interfacechecks="0"
while
	[ $interfacechecks -lt 8 ]; do
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
while
	[ $networkchecks -lt 8 ]; do
		if ping -c 1 ${dnsserver} &> /dev/null
			then echo -e "${green}Success: Nameserver is online${nocolor}" && echo "Success: Nameserver is online" >> ${screenlog}
			break
			else echo -e "${red}Warning: Nameserver is offline${nocolor}" && echo "Warning: Nameserver is offline" >> ${screenlog}
		fi
	sleep 1s;
	networkchecks=$((networkchecks+1))
done

# user information
echo "Starting Minecraft server.  To view window type screen -r ${servername}."
echo "To minimize the window and let the server run in the background, press Ctrl+A then Ctrl+D"
echo "starting ${servername} server..." && echo "starting ${servername} server..." >> ${screenlog}


# main start commmand
${screen} -dmSL ${servername} -Logfile ${screenlog} ${java} -server ${mems} ${memx} ${threadcount} -jar ${serverfile}
${screen} -r ${servername} -X colon "logfile flush 1^M"

sleep 4s

# check if screen is avaible
if ! screen -list | grep -q "${servername}"; then
	echo "something went wrong - server failed to start!" >> ${screenlog}
	echo -e "${red}something went wrong - server failed to start!${nocolor}"
	exit 1
fi

# succesful startup
echo "server startup successfull!" >> ${screenlog}
echo -e "${green}server startup successfull! - changing to server console...${nocolor}"

sleep 4s

# change to server console
screen -r ${servername}
