#!/bin/bash
# Minecraft Server start script

. ./settings.sh

cd ${serverdirectory}

if screen -list | grep -q "${servername}";then
        echo "Server is already running!  Type screen -r ${servername} to open the console"
        exit 1
fi

NetworkChecks=0
while
	[ $NetworkChecks -lt 4 ]; do
		if ping -c 1 ${dnsserver} &> /dev/null
			then echo "Success: Nameserver is online"
			break
			else echo "Warning: Nameserver is offline"
		fi
	sleep 1s;
	NetworkChecks=$((NetworkChecks+1))
done

InterfaceChecks=0
while
	[ $InterfaceChecks -lt 4 ]; do
		 if ping -c 1 ${interface} &> /dev/null
				then echo "Success: Interface is online"
				break
				else echo "Warning: Interface is offline"
		 fi
	sleep 1s
	InterfaceChecks=$((InterfaceChecks+1))
done

echo "Starting Minecraft server.  To view window type screen -r ${servername}."
echo "To minimize the window and let the server run in the background, press Ctrl+A then Ctrl+D"

${screen} -dmSL ${servername} ${java} -server ${mems} ${memx} ${threadcount} -jar ${serverfile}

if ! screen -list | grep -q "${servername}"; then
        echo "Something went wrong - Server failed to start!"
        exit 1
fi

echo "Server startup successful - changing to Server Console..."

sleep 4s

screen -r ${servername}
