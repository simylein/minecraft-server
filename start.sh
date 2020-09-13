#!/bin/bash
# Minecraft Server start script

. ./settings.sh

cd ${directory}${servername}

if screen -list | grep -q "${servername}";then
        echo "Server is already running!  Type screen -r ${servername} to open the console"
        exit 1
fi

if ping -w 4 -c2 1.1.1.1 &> /dev/null
        then echo "1.1.1.1 DNS Server reachable - you are online - starting server with network connection..."
        else echo "1.1.1.1 DNS Server unreachable - you are offline - starting server without network connection..."
fi

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
