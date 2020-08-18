#!/bin/sh

# Minecraft Server stop script

if ! screen -list | grep -q "minecraft"; then
        echo "Server is not currently running!"
        exit 1
fi

echo "Initiating Stopping Sequenze for Minecraft Server"

echo "Server is stopping in 30 seconds!"
screen -Rd minecraft -X stuff "say Server is stopping in 30 seconds! $(printf '\r')"
sleep 23s
echo "Server is stopping in 7 seconds!"
screen -Rd minecraft -X stuff "say Server is stopping in 7 seconds! $(printf '\r')"
sleep 1s
echo "Server is stopping in 6 seconds!"
screen -Rd minecraft -X stuff "say Server is stopping in 6 seconds! $(printf '\r')"
sleep 1s
echo "Server is stopping in 5 seconds!"
screen -Rd minecraft -X stuff "say Server is stopping in 5 seconds! $(printf '\r')"
sleep 1s
echo "Server is stopping in 4 seconds!"
screen -Rd minecraft -X stuff "say Server is stopping in 4 seconds! $(printf '\r')"
sleep 1s
echo "Server is stopping in 3 seconds!"
screen -Rd minecraft -X stuff "say Server is stopping in 3 seconds! $(printf '\r')"
sleep 1s
echo "Server is stopping in 2 seconds!"
screen -Rd minecraft -X stuff "say Server is stopping in 2 seconds! $(printf '\r')"
sleep 1s
echo "Server is stopping in 1 second!"
screen -Rd minecraft -X stuff "say Server is stopping in 1 second! $(printf '\r')"
sleep 1s
echo "Stopping server..."
screen -Rd minecraft -X stuff "say Stopping server...$(printf '\r')"
screen -Rd minecraft -X stuff "stop $(printf '\r')"

StopChecks=0
while [ $StopChecks -lt 30 ]; do
        if ! screen -list | grep -q "minecraft"; then
                break
        fi
        sleep 1;
        StopChecks=$((StopChecks+1))
done

if screen -list | grep -q "minecraft"; then
        echo "Minecraft server still hasn't closed after 30 seconds, closing screen manually"
        screen -S minecraft -X quit
fi

echo "Server Stopped"
