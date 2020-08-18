#!/bin/bash
# Minecraft Server startup script using screen
if screen -list | grep -q "minecraft";then
        echo "Server is already running!  Type screen -r minecraft to open the console"
        exit 1
fi
NetworkChecks=0
DefaultRoute=$(route -n | awk '$4 == "UG" {print $2}')
while [ -z "$DefaultRoute" ]; do
        echo "Network interface not up, will try again in 1 second";
        sleep 1;
        DefaultRoute=$(route -n | awk '$4 == "UG" {print $2}')
        NetworkChecks=$((NetworkChecks+1))
        if [ $NetworkChecks -gt 20 ]; then
                echo "Waiting for network interface to come up timed out - starting server without network connection ..."
                break
        fi
done
echo "Initiated Starting Sequenze for Minecraft Server"
echo "Starting Minecraft server.  To view window type screen -r minecraft."
echo "To minimize the window and let the server run in the background, press Ctrl+A then Ctrl+D"
cd /home/simylein/minecraft/
/usr/bin/screen -dmS minecraft /usr/bin/java -jar -Xms2048 -Xmx8192M /minecraft/paperclip.jar
echo "Server is Starting..."
sleep 4s
cd /home/simylein/
screen -r minecraft
