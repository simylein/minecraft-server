MinecraftServer
===============
Scripts for a Minecraft Server on Linux Debian using screen.

This tutorial contains important steps if you would like to host a minecraft server from the command line. 
## software
In order for the Server to run we will need to install some packages: (please note: some of them could be installed already) <br>
This command installs all packages you will need to run your server.
```
sudo apt install openjdk-11-jre-headless iputils-ping mailutils coreutils dnsutils sendmail screen grep nano wget less cron sed pv
```
## setup
Then, you can download and execute the setup script. <br>
This command downloads, makes exectable and executes the setup script. 
```
wget -O setup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/setup.sh && chmod +x setup.sh && ./setup.sh
```
The Script will ask you some Questions. Please answer them in order for the Server to work. If you do not know what you like right now you can edit all answers later in the server.* files and going with the prefilled answer works for most people. Now you got yourself a server directory. It is called ${servername} (it's the name you have chosen for your server) and inside ${servername} a directory is called backups. Like you can imagine ${servername} holds your live server and backups stores your backups. 
## serverstart
Start your Server for the first time: `./start.sh`

## screen
Screen is an amzing comand line tool that creates a "virtual" terminal inside your terminal.

You can view all your active screens by typing: `screen -list`
<br>
If you want to resume a certain screen session just type: `screen -r ${servername}`

If you would like to scroll inside a screen session press Ctrl+A and Esc (enter copy mode). <br>
For returning back to normal press Esc.

To exit the screen terminal press Ctrl+A and Ctrl+D
## server commands
Your minecraft server can understand certain commands. <br>
I will explain some of them to you.

`whitelist add ${playername}` adding someone to your whitelist so he/she can join your server. <br>
`whitelist remove ${playername}` remove someone to your whitelist so he/she can no longer join your server. <br>
`op ${playername}` make someone admin on. your server so he/she can execute commands. <br>
`deop ${playername}` remove admin permissions for a player so he/she can no longer execute commands. <br>
`ban ${playername}` ban someone from your server so he/she can no longer join your server. <br>
`pardon ${playername}` pardon someone from your server so he/she can join your server. <br>
`tp ${playername} ${x} ${y} ${z}` teleporting a player to cords. <br>
`tp ${playername} ${playername}` teleporting a player to another player.

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
...
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

enable-command-block=   (enables command blocks to tinker with) [true/false]
```
## scripts
There are lots of script in your ${serverdirectory}. Normally, the executable ones are green and can be executed with: <br>
```
./NameOfScript.sh
```

## crontab
If you would like to automate some of those task on your server you can create a crontab.
```
crontab -e
```
A new file will open (If you got one already the existing one will open) <br>
Side note: the setup script will already put these lines in your crontab if you chose to do so. <br>
In this file, you can automate things as follows: <br>

First star: Minutes [0 - 59] <br>
Secound star: Hours [0 - 23] <br>
Third star: Day of Month [0 - 31] <br>
Forth star: Month [0 - 12] <br>
Fifth star: Day of Week [0 - 6]

Generic Example: (In order to work, please replace the variables with your own ones)
```
# minecraft ${servername} your description of command here
* * * * * cd ${serverdirectory} && ${serverdirectory}/NameOfScript.sh
```
Close and save your crontab. (Press Ctrl X and Y)
## logfiles
Your server will write two growing logfiles (located in your ${serverdirectory}) <br>
screen.log and backup.log <br>
screen.log contains everything that get's written inside your screen terminal while backup.log logs all action of the backup script. 

to view them:
```
less screen.log
less backup.log
```
## ending
I hope you learned something and that those scripts I provide may help you and your minecraft server experience. <br>
Have fun and enjoy the Game ;^)

Best regards, <br>
Simylein
