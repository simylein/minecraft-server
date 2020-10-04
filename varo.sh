#!/bin/sh
# Minecraft Server varo script

# read the settings
. ./settings.sh

# check if server is running
if ! screen -list | grep -q "${servername}"; then
        echo -e "${yellow}Server is not currently running!{nocolor}"
        exit 1
fi

# welcome message
screen -Rd ${servername} -X stuff "say Welcome to Minecraft Varo$(printf '\r')"
echo "Welcome to Minecraft Varo"
sleep 5s

# countdown to varo
counter="240"
while [ ${counter} -gt 0 ]; do
        if [[ "${counter}" =~ ^(240|180|120|60|40|20|10|5|4|3|2|1)$ ]];then
                echo "Minecraft Varo is starting in ${counter} seconds!"
                screen -Rd ${servername} -X stuff "gamemode 2 @a$(printf '\r')"
                screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in ${counter} seconds!$(printf '\r')"
        fi
counter=$((counter-1))
sleep 1s
done

# start of varo
screen -Rd ${servername} -X stuff "gamemode 0 @a$(printf '\r')"
screen -Rd ${servername} -X stuff "say Minecraft Varo has started$(printf '\r')"
screen -Rd ${servername} -X stuff "say Good Luck and have fun to all Teams$(printf '\r')"
