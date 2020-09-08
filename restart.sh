#!/bin/sh
# Minecraft Server restart script

. ./settings.sh

cd ${directory}${servername}

if ! screen -list | grep -q "${servername}"; then
        echo "Server is not currently running!"
        exit 1
fi

echo "Initiating Restarting Sequenze for Minecraft Server"

echo "Server is restarting in 30 seconds!"
screen -Rd ${servername} -X stuff "say Server is restarting in 30 seconds! $(printf '\r')"
sleep 23s
echo "Server is restarting in 7 seconds!"
screen -Rd ${servername} -X stuff "say Server is restarting in 7 seconds! $(printf '\r')"
sleep 1s
echo "Server is restarting in 6 seconds!"
screen -Rd ${servername} -X stuff "say Server is restarting in 6 seconds! $(printf '\r')"
sleep 1s
echo "Server is restarting in 5 seconds!"
screen -Rd ${servername} -X stuff "say Server is restarting in 5 seconds! $(printf '\r')"
sleep 1s
echo "Server is restarting in 4 seconds!"
screen -Rd ${servername} -X stuff "say Server is restarting in 4 seconds! $(printf '\r')"
sleep 1s
echo "Server is restarting in 3 seconds!"
screen -Rd ${servername} -X stuff "say Server is restarting in 3 seconds! $(printf '\r')"
sleep 1s
echo "Server is restarting in 2 seconds!"
screen -Rd ${servername} -X stuff "say Server is restarting in 2 seconds! $(printf '\r')"
sleep 1s
echo "Server is restarting in 1 second!"
screen -Rd ${servername} -X stuff "say Server is restarting in 1 second! $(printf '\r')"
sleep 1s
echo "Closing server..."
screen -Rd ${servername} -X stuff "say Closing server...$(printf '\r')"
screen -Rd ${servername} -X stuff "stop $(printf '\r')"

StopChecks=0
while [ $StopChecks -lt 30 ]; do
        if ! screen -list | grep -q "${servername}"; then
                break
        fi
        sleep 1;
        StopChecks=$((StopChecks+1))
done

if screen -list | grep -q "${servername}"; then
        echo "Minecraft server still hasn't closed after 30 seconds, closing screen manually"
        screen -S ${servername} -X quit
fi

echo "Restarting Server..."
./start.sh
