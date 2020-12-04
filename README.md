MinecraftServer
===============
Scripts for a Minecraft Server on Linux Debian using screen.

This tutorial contains important steps if you would like to host a minecraft server from the command line. 
## software
In order for the Server to run we will need to install some packages: (please note: some of them could be installed already)
```
sudo apt install openjdk-11-jre-headless iputils-ping coreutils dnsutils screen grep nano wget less sed cron
```
## setup
Then, you can download and execute the setup script. <br>
downloading setup script:
```
wget -O setup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/setup.sh
```
making setup script executable:
```
chmod +x setup.sh
```
executing setup script:
```
./setup.sh
```
The Script will ask you some Questions. Please answer them in order for the Server to work. Now you got two directorys. One is called ${servername} (it's the name you have chosen for your server) and one is called ${servername}-backups. Like you can imagine ${servername} holds your live server and ${servername}-backups stores your backups. 
## serverstart
Start your Server for the first time:
```
./start.sh
```
## screen
Screen is an amzing comand line tool that creates a "virtual" terminal inside your terminal. <br>
You can view all your active screens by typing
```
screen -list
```
If you want to resume a certain screen session just type
```
screen -r ${servername}
```
If you would like to scroll inside a screen session press Ctrl+A and Esc (enter copy mode). <br>
For returning back to normal press Esc.

To exit the screen terminal press Ctrl+A and Ctrl+D
## server commands
Your minecraft server can understand certain commands. <br>
I will explain some of them to you. <br>
adding someone to your whitelist so he/she can join your server. 
```
whitelist add ${playername}
```
remove someone to your whitelist so he/she can no longer join your server. 
```
whitelist remove ${playername}
```
ban someone from your server so he/she can no longer join your server. 
```
ban ${playername}
```
pardon someone from your server so he/she can join your server. 
```
pardon ${playername}
```
teleporting a player to cords.
```
tp ${playername} ${x} ${y} ${z}
```
teleporting a player to another player
```
tp ${playername} ${playername}
```
Important: If you do these commands ingame you will need to put a / before each command. <br>
In the screen terminal you don't need a / before your command. 
## server.settings
This is your file that holds the variables you have chosen with the setup script. <br>
If you know what your are doing feel free to edit it to suit your needs.
```
nano server.settings
```
It looks like this: (there will be alot of variables after setup.sh)
```
#!/bin/bash
# minecraft server settings

# This file stores all the variables for the server. 
# If you know what you are doing, feel free to tinker with them ;^)

# command line colors
red="\033[0;31m"
yellow="\033[1;33m"
green="\033[0;32m"
blue="\033[0;34m"
purple="\033[0;35m"
nocolor="\033[0m"

# backup stuff
newhourly=$(date +"%H"-00)
oldhourly=$(date -d "-23 hours" +"%H"-00)
newdaily=$(date +"%Y-%m-%d")
olddaily=$(date -d "-24 days" +"%Y-%m-%d")
```
## server.properties
If you would like to costumize your server further have a look at your server.properties file. 
```
nano server.properties
```
Important settings are:
```
max-players=            (limuts the maximumg amount of players on the server at the same time)
                        [Warning large numbers may impact performance]
                        
difficulty=             (defines ingame difficulty) [peaceful, easy, normal, hard]

view-distance=          (defines number of ingame chnuks to be rendered)
                        [Warning large numbers may impact performance]
                        
white-list=             (turns on the whitelist) [I would strongely recomment to set this to true]

motd=                   (this will be displayed in the menu below your server - chose what you like)

server-port=            (default by 25565. Only importent if you are dealing with multiple server)
                        [if you run multiple servers each server wants to have its own port]
                        
gamemode=               (default survival. Defines your game mode. For creative server replace with creative)
                        [survival/creative/adventure/spectator]
                        
spawn-protection=       (the number of block at the worldspawn only operators can touch)

pvp=                    (ability for player to do damage to oneanother) [true/false]

enable-command-block    (enables command blocks to tinker with) [true/false]
```
## scripts
The following scripts automate the start, stop and restart procedure. <br>
each one can be executed with:
```
./start.sh
```
```
./stop.sh
```
```
./restart.sh
```
The maintenance script is there to let people know you take their server offline while you perform maintenance. 
```
./maintenance.sh
```
The restore script is for restoring a backup (daily - last 24 days) (hourly - last 24 hours)
```
./restore.sh
```
The update script will update your server to the newest java version avaible.
```
./update.sh
```
There is also a reset script. Warning it will reset your world! (it will performe a backup before doing so)
```
./reset.sh
```
## crontab
If you would like to automate some of those task on your server you can create a crontab.
```
crontab -e
```
A new file will open (If you got one already the existing one will open) <br>
Side note: the setup script will already put these lines in your crontab if you chose to do so <br>
In this file, you can automate things as follows: <br>

Backup Example: (In order to work, please replace the variables with your own ones)
```
# minecraft ${servername} server hourly backup at **:00
00 * * * * cd ${serverdirectory} && ${serverdirectory}/backuphourly.sh

# minecraft ${servername} server daily backup at 22:00
00 22 * * * cd ${serverdirectory} && ${serverdirectory}/backupdaily.sh
```
Stop and Start Example: (In order to work, please replace the variables with your own ones)
```
# minecraft ${servername} server stop at 22:30
30 22 * * * cd ${serverdirectory} && ${serverdirectory}/stop.sh

# minecraft ${servername} server start at 06:30
30 06 * * * cd ${serverdirectory} && ${serverdirectory}/start.sh
```
If you  like to restart your minecraft server: <br>
Restart Example: (In order to work, please replace the variables with your own ones)
```
# minecraft ${servername} server restart at 23:00
00 23 * * * cd ${serverdirectory} && ${serverdirectory}/restart.sh
```
If you want to start up your minecraft server at boot of your Linux server: <br>
Start at Boot Example: (In order to work, please replace the variables with your own ones)
```
# minecraft ${servername} server start at boot
@reboot cd ${serverdirectory} && ${serverdirectory}/start.sh
```
Close and save your crontab. 
## logfiles
Your server will write two growing logfiles (located in your ${serverdirectory}) <br>

screen.log and backup.log <br>

to view them:
```
less screen.log
```
```
less backup.log
```
to edit them:
```
nano screen.log
```
```
nano backup.log
```
## ending
I hope you learned something and that those scripts I provide may help you and your minecraft server experience. <br>
Have fun and enjoy the Game ;^)

Best regards, <br>
Simylein
