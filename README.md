# minecraft-server

Scripts for a Minecraft Server on Linux Debian using screen.

This tutorial contains important steps if you would like to host a minecraft server from the command line.

## software

In order for the Server to run we will need to install some packages: (please note: some of them could be installed already) <br>
This command installs all packages you will need to run your server.

```
sudo apt install openjdk-17-jre-headless iputils-ping net-tools mailutils coreutils dnsutils sendmail screen grep nano wget less cron man sed pv
```

## setup

Then, you can download and execute the setup script. <br>

Download and make Executable

```
wget -O setup.sh https://raw.githubusercontent.com/simylein/minecraft-server/main/setup.sh && chmod +x setup.sh
```

This will start the script in interactive mode and you must answer questions

```
./setup.sh
```

If you like a straight one-liner which is non-interactive you may use the setup arguments like this

```
./setup.sh --name minecraft --proceed true --version 1.19 --port 25565 --eula true --remove true --start true
```

## serverstart

Start your Server for the first time: `./start.sh`

## screen

Screen is an amazing command line tool that creates a "virtual" terminal inside your terminal.

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
`op ${playername}` make someone admin on your server so he/she can execute commands. <br>
`deop ${playername}` remove admin permissions for a player so he/she can no longer execute commands. <br>
`ban ${playername}` ban someone from your server so he/she can no longer join your server. <br>
`pardon ${playername}` pardon someone from your server so he/she can join your server. <br>
`tp ${playername} ${x} ${y} ${z}` teleporting a player to cords. <br>
`tp ${playername} ${playername}` teleporting a player to another player.

Important: If you do these commands ingame you will need to put a `/` before each command. <br>
In the screen terminal you don't need a `/` before your command.

## server.settings

This is your file that holds the variables you have chosen with the setup script. <br>
If you know what your are doing feel free to edit it to suit your needs.

```
nano server.settings
```

Important settings are:

`public=` (ip of a wan server which will be pinged to ensure network availability) <br>
`private=` (ip of a lan server which will be pinged to ensure network availability) <br>

`doHourly=` (enables hourly backups) <br>
`doDaily=` (enables daily backups) <br>
`doWeekly=` (enables weekly backups) <br>
`doMonthly=` (enables monthly backups) <br>

`diskSpaceError=` (value in bytes for free disk space at which the backup script stops working) <br>
`diskSpaceWarning=` (value in bytes for free disk space at which the backup script throws warnings) <br>

## server.properties

If you would like to customize your server further have a look at your server.properties file.

```
nano server.properties
```

Important settings are:

`max-players=` (limits the maximum amount of players on the server at the same time) <br>
[Warning large numbers may impact performance] <br>

`difficulty=` (defines ingame difficulty) [peaceful, easy, normal, hard] <br>
`gamemode=` (default survival. Defines your game mode. For creative server replace with creative) <br>
[survival/creative/adventure/spectator] <br>

`view-distance=` (defines number of ingame chunks to be rendered) <br>
[Warning large numbers may impact performance] <br>
`simulation-distance=` (defines number of ingame chunks in which entities are computed) <br>
[Warning large numbers may impact performance] <br>

`motd=` (this will be displayed in the menu below your server - chose what you like) <br>
`pvp=` (ability for player to do damage to each another) [true/false] <br>

`server-port=` (default by 25565. Only important if you are dealing with multiple server) <br>
[if you run multiple servers each server wants to have its own port] <br>

`white-list=` (turns on the whitelist) [I would strongly recommend to set this to true] <br>
`spawn-protection=` (the number of block at the worldspawn only operators can touch) <br>

`enable-command-block=` (enables command blocks to tinker with) [true/false] <br>

## scripts

There are lots of script in your ${serverdirectory}. Normally, the executable ones are green and can be executed with:

```
./${scriptname}.sh ${arguments}
```

Example: `./start.sh --quiet` <br>
Example: `./stop.sh --now`

Arguments: `-h --help, -f --force, -n --now -q --quiet -v --verbose`

The script name stands for the action the script will do. <br>

start.sh (starts your server) <br>
stop.sh (stops your server) <br>
restart.sh (restarts your server) <br>
update.sh (updates your server version) <br>
restore.sh (restores the backup of your choice) <br>
reset.sh (resets server world) <br>
vent.sh (self-destructs your server along its backups) <br>

## crontab

If you would like to automate some of those task on your server you can create a crontab.

```
crontab -e
```

A new file will open (If you got one already the existing one will open) <br>
Side note: the setup script will already put these lines in your crontab if you chose to do so. <br>
In this file, you can automate things as follows: <br>

First star: Minutes [0 - 59] <br>
Second star: Hours [0 - 23] <br>
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

Your server will write two growing logfiles [screen.log and backup.log] (located in your ${serverdirectory}) <br>
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
