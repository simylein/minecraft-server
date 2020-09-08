#!/bin/sh
# Minecraft Server varo script

. ./settings.sh

echo "Initiating Varo Start Sequenze for Minecraft Varo Server..."

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 2 Minutes $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 2 Minutes"
sleep 60s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 1 Minute $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 1 Minute"
sleep 30s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 30 Seconds $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 30 Seconds"
sleep 10s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 20 Seconds $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 20 Seconds"
sleep 10s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 9 Seconds $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 9 Seconds"
sleep 1s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 8 Seconds $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 8 Seconds"
sleep 1s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 7 Seconds $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 7 Seconds"
sleep 1s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 6 Seconds $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 6 Seconds"
sleep 1s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 5 Seconds $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 5 Seconds"
sleep 1s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 4 Seconds $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 4 Seconds"
sleep 1s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 3 Seconds $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 3 Seconds"
sleep 1s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 2 Seconds $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 2 Seconds"
sleep 1s

screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in 1 Second $(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode 2 @a $(printf '\r')"
echo "Minecraft Varo is starting in 1 Second"
sleep 1s

screen -Rd ${servername} -X stuff "gamemode 0 @a $(printf '\r')"
screen -Rd ${servername} -X stuff "say Minecraft Varo has started $(printf '\r')"
screen -Rd ${servername} -X stuff "say Good Luck and Have fun to all Teams $(printf '\r')"

echo "script has finished"
