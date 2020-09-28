#!/bin/bash
# Minecraft Server start script

. ./settings.sh

cd ${serverdirectory}

if screen -list | grep -q "${servername}";then
        echo -e "${yellow}Server is already running!  Type screen -r ${servername} to open the console${nocolor}"
        exit 1
fi

NetworkChecks=0
while
	[ $NetworkChecks -lt 4 ]; do
		if ping -c 1 ${dnsserver} &> /dev/null
			then echo -e "${green}Success: Nameserver is online${nocolor}"
			break
			else echo -e "${red}Warning: Nameserver is offline${nocolor}"
		fi
	sleep 1s;
	NetworkChecks=$((NetworkChecks+1))
done

InterfaceChecks=0
while
	[ $InterfaceChecks -lt 4 ]; do
		 if ping -c 1 ${interface} &> /dev/null
				then echo -e "${green}Success: Interface is online${nocolor}"
				break
				else echo -e "${red}Warning: Interface is offline${nocolor}"
		 fi
	sleep 1s
	InterfaceChecks=$((InterfaceChecks+1))
done

echo "starting ${servername} server..."
echo "Starting Minecraft server.  To view window type screen -r ${servername}."
echo "To minimize the window and let the server run in the background, press Ctrl+A then Ctrl+D"

${screen} -dmSL ${servername} ${java} -server ${mems} ${memx} ${threadcount} -jar ${serverfile}

sleep 4s

if ! screen -list | grep -q "${servername}"; then
        echo -e "${red}Something went wrong - Server failed to start!${nocolor}"
        exit 1
fi

echo -e "${green}Server startup successful! - changing to Server Console...${nocolor}"

sleep 4s

screen -r ${servername}
