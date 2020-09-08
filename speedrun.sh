#!/bin/sh
# Minecraft Server speedrun script

. ./settings.sh

echo "Initiating Timer Sequenze for Minecraft Speedrun Server..."

echo "applying effects..."
screen -Rd ${servername} -X stuff "effect give @a minecraft:blindness 100 2 $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode adventure @a $(printf '\r')"
screen -Rd ${servername} -X stuff "effect give @a minecraft:slowness 100 2 $(printf '\r')"
screen -Rd ${servername} -X stuff "time set night $(printf '\r')"
screen -Rd ${servername} -X stuff "weather thunder $(printf '\r')"
screen -Rd ${servername} -X stuff "difficulty peaceful $(printf '\r')"

echo "welcome"
screen -Rd ${servername} -X stuff "say Welcome to Minecraft Speedrun Server $(printf '\r')"
echo "starting countdown..."
echo "Speedrun Challange is starting in 60 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 60 secounds $(printf '\r')"
sleep 40s
echo "Speedrun Challange is starting in 20 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 20 secounds $(printf '\r')"
sleep 5s
echo "Speedrun Challange is starting in 15 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 15 secounds $(printf '\r')"
sleep 5s
echo "Speedrun Challange is starting in 10 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 10 secounds $(printf '\r')"
sleep 5s
echo "Speedrun Challange is starting in 5 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 5 secounds $(printf '\r')"
sleep 1s
echo "Speedrun Challange is starting in 4 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 4 secounds $(printf '\r')"
sleep 1s
echo "Speedrun Challange is starting in 3 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 3 secounds $(printf '\r')"
sleep 1s
echo "Speedrun Challange is starting in 2 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 2 secounds $(printf '\r')"
sleep 1s
echo "Speedrun Challange is starting in 1 secounds"
screen -Rd ${servername} -X stuff "say Speedrun Challange is starting in 1 secound $(printf '\r')"
sleep 1s

echo "removing effects..."
screen -Rd ${servername} -X stuff "effect clear @a $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode survival @a $(printf '\r')"
screen -Rd ${servername} -X stuff "effect give @a minecraft:saturation  $(printf '\r')"
screen -Rd ${servername} -X stuff "time set day $(printf '\r')"
screen -Rd ${servername} -X stuff "weather clear $(printf '\r')"
screen -Rd ${servername} -X stuff "difficulty hard $(printf '\r')"

echo "Speedrun Challange has started"
screen -Rd ${servername} -X stuff "say Speedrun Challange has startet  $(printf '\r')"
screen -Rd ${servername} -X stuff "say God Luck and Have Fun :PogChamp:,:ZickZackSmiley: $(printf '\r')"

echo "Time elapsed: 00:00:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:00:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:05:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:05:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:10:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:10:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:15:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:15:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:20:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:20:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:25:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:25:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:30:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:30:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:35:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:35:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:40:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:40:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:45:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:45:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:50:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:50:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 00:55:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 00:55:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:00:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:00:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:05:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:05:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:10:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:10:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:15:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:15:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:20:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:20:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:25:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:25:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:30:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:30:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:35:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:35:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:40:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:40:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:45:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:45:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:50:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:50:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 01:55:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 01:55:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 02:00:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 02:00:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 02:05:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 02:05:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 02:10:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 02:10:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 02:15:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 02:15:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 02:20:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 02:20:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 02:25:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 02:25:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 02:30:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 02:30:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 02:35:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 02:35:00 $(printf '\r')"
sleep 300s
echo "Time elapsed: 02:40:00"
screen -Rd ${servername} -X stuff "say Time elapsed: 02:40:00 $(printf '\r')"

echo "script has finished"
