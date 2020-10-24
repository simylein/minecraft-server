#!/bin/bash
# minecraft server start script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# check if server is already running
if screen -list | grep -q "${servername}";then
        echo -e "${yellow}Server is already running!  Type screen -r ${servername} to open the console${nocolor}"
        exit 1
fi

# check if dnsserver is online
networkchecks="0"
while
	[ $networkchecks -lt 4 ]; do
		if ping -c 1 ${dnsserver} &> /dev/null
			then echo -e "${green}Success: Nameserver is online${nocolor}"
			break
			else echo -e "${red}Warning: Nameserver is offline${nocolor}"
		fi
	sleep 1s;
	networkchecks=$((networkchecks+1))
done

# check if interface is online
interfacechecks="0"
while
	[ $interfacechecks -lt 4 ]; do
		 if ping -c 1 ${interface} &> /dev/null
				then echo -e "${green}Success: Interface is online${nocolor}"
				break
				else echo -e "${red}Warning: Interface is offline${nocolor}"
		 fi
	sleep 1s
	interfacechecks=$((interfacechecks+1))
done

# user information
echo "Starting Minecraft server.  To view window type screen -r ${servername}."
echo "To minimize the window and let the server run in the background, press Ctrl+A then Ctrl+D"
echo "starting ${servername} server..."


# main start commmand
${screen} -dmSL ${servername} ${java} -server ${mems} ${memx} ${threadcount} -jar ${serverfile}
${screen} -r ${servername} -X colon "logfile flush 1^M"

sleep 4s

# check if screen is avaible
if ! screen -list | grep -q "${servername}"; then
        echo -e "${red}Something went wrong - Server failed to start!${nocolor}"
        exit 1
fi

# succesful startup
echo -e "${green}Server startup successful! - changing to Server Console...${nocolor}"

sleep 4s

# change to server console
screen -r ${servername}
