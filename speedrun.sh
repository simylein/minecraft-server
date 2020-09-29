#!/bin/sh
# Minecraft Server speedrun script

# read the settings
. ./settings.sh

if ! screen -list | grep -q "${servername}"; then
        echo -e "${yellow}Server is not currently running!${nocolor}"
        exit 1
fi

echo "creating scoreboard..."
screen -Rd ${servername} -X stuff "scoreboard objectives add health health$(printf '\r')"
screen -Rd ${servername} -X stuff "scoreboard objectives setdisplay list health$(printf '\r')"

echo "applying effects..."
screen -Rd ${servername} -X stuff "effect give @a minecraft:blindness 100 2$(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode adventure @a$(printf '\r')"
screen -Rd ${servername} -X stuff "effect give @a minecraft:slowness 100 2$(printf '\r')"
screen -Rd ${servername} -X stuff "time set night$(printf '\r')"
screen -Rd ${servername} -X stuff "weather thunder$(printf '\r')"
screen -Rd ${servername} -X stuff "difficulty peaceful$(printf '\r')"

echo "welcome"
screen -Rd ${servername} -X stuff "say Welcome to Minecraft Speedrun Server$(printf '\r')"
echo "starting countdown..."
echo "Speedrun Challange is starting in 60 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 60 secounds$(printf '\r')"
sleep 40s
echo "Speedrun Challange is starting in 20 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 20 secounds$(printf '\r')"
sleep 5s
echo "Speedrun Challange is starting in 15 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 15 secounds$(printf '\r')"
sleep 5s
echo "Speedrun Challange is starting in 10 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 10 secounds$(printf '\r')"
sleep 5s
echo "Speedrun Challange is starting in 5 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 5 secounds$(printf '\r')"
sleep 1s
echo "Speedrun Challange is starting in 4 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 4 secounds$(printf '\r')"
sleep 1s
echo "Speedrun Challange is starting in 3 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 3 secounds$(printf '\r')"
sleep 1s
echo "Speedrun Challange is starting in 2 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 2 secounds$(printf '\r')"
sleep 1s
echo "Speedrun Challange is starting in 1 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 1 secound$(printf '\r')"
sleep 1s

echo "removing effects..."
screen -Rd ${servername} -X stuff "effect clear @a$(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode survival @a$(printf '\r')"
screen -Rd ${servername} -X stuff "effect give @a minecraft:saturation$(printf '\r')"
screen -Rd ${servername} -X stuff "time set day$(printf '\r')"
screen -Rd ${servername} -X stuff "weather clear$(printf '\r')"
screen -Rd ${servername} -X stuff "difficulty hard$(printf '\r')"

echo "Speedrun Challange has started"
screen -Rd ${servername} -X stuff "say Speedrun Challange has startet$(printf '\r')"
screen -Rd ${servername} -X stuff "say God Luck and Have Fun :PogChamp:,:ZickZackSmiley:$(printf '\r')"

#!/bin/bash
# Timer sequence

counter=0
while [ $counter -lt 12000 ]; do
    if [ $((counter%300)) -eq 0 ];
      then 
        echo "Time elapsed: ${counter} seconds"
        screen -Rd ${servername} -X stuff "say Time elapsed: ${counter} seconds$(printf '\r)"
    fi
  sleep 1s;
  counter=$((counter+1))
done

screen -Rd ${servername} -X stuff "say script has finished$(printf '\r')"
echo -e "${green}script has finished${nocolor}"
