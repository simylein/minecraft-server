#!/bin/sh
# Minecraft Server stop script

# read the settings
. ./settings.sh

# change to server directory
cd ${serverdirectory}

# check if server is running
if ! screen -list | grep -q "${servername}"; then
        echo -e "${yellow}Server is not currently running!${nocolor}"
        exit 1
fi

# countdown
counter="60"
while [ ${counter} -gt 0 ]; do
        if [[ "${counter}" =~ ^(60|40|20|10|5|4|3|2|1)$ ]];then
                echo "server is stopping in ${counter} seconds!"
                screen -Rd ${servername} -X stuff "say server is stopping in ${counter} seconds!$(printf '\r')"
        fi
counter=$((counter-1))
sleep 1s
done

# server stop
echo "Stopping server..."
screen -Rd ${servername} -X stuff "say Stopping server...$(printf '\r')"
screen -Rd ${servername} -X stuff "stop$(printf '\r')"

# check if server stopped
StopChecks=0
while [ $StopChecks -lt 30 ]; do
        if ! screen -list | grep -q "${servername}"; then
                break
        fi
        sleep 1;
        StopChecks=$((StopChecks+1))
done

# force quit server if not stopped
if screen -list | grep -q "${servername}"; then
        echo -e "${yellow}Minecraft server still hasn't closed after 30 seconds, closing screen manually${nocolor}"
        screen -S ${servername} -X quit
fi

# output confirmed stop
echo -e "${green}server successfully stopped!{nocolor}"
