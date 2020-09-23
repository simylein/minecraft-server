#!/bin/sh
# Minecraft Server maintenance script

. ./settings.sh

cd ${serverdirectory}

if ! screen -list | grep -q "${servername}"; then
        echo "Server is not currently running!"
        exit 1
fi

echo "Initiating Updating Sequenze for Minecraft Server"

echo "Server is going into maintenance in 30 seconds!"
screen -Rd ${servername} -X stuff "say Server is updating in 30 seconds!$(printf '\r')"
sleep 23s
echo "Server is going into maintenance in 7 seconds!"
screen -Rd ${servername} -X stuff "say Server is updating in 7 seconds!$(printf '\r')"
sleep 1s
echo "Server is going into maintenance in 6 seconds!"
screen -Rd ${servername} -X stuff "say Server is updating in 6 seconds!$(printf '\r')"
sleep 1s
echo "Server is going into maintenance in 5 seconds!"
screen -Rd ${servername} -X stuff "say Server is updating in 5 seconds!$(printf '\r')"
sleep 1s
echo "Server is going into maintenance in 4 seconds!"
screen -Rd ${servername} -X stuff "say Server is updating in 4 seconds!$(printf '\r')"
sleep 1s
echo "Server is going into maintenance in 3 seconds!"
screen -Rd ${servername} -X stuff "say Server is updating in 3 seconds!$(printf '\r')"
sleep 1s
echo "Server is going into maintenance in 2 seconds!"
screen -Rd ${servername} -X stuff "say Server is updating in 2 seconds!$(printf '\r')"
sleep 1s
echo "Server is going into maintenance in 1 second!"
screen -Rd ${servername} -X stuff "say Server is updating in 1 second!$(printf '\r')"
sleep 1s
echo "Closing server..."
screen -Rd ${servername} -X stuff "say Closing server...$(printf '\r')"
screen -Rd ${servername} -X stuff "stop$(printf '\r')"

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
