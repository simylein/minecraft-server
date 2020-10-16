# MinecraftServer
Scripts for a Minecraft Server on Linux Debian using screen. 

This tutorial contains important steps if you would like to host a minecarft server from the command line. 
# software
In order for the Server to run we will need to install 2 Programms:
```
sudo apt install openjdk-14-jre-headless
```
```
sudo apt install screen
```
# setup
Then, you can download and execute the setup script.

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

The Script will ask you some Questions. Please answer them in order for the Server to work. 

Now you got two directorys. 

One is called ${servername} (it's the name you have chosen for your server) and one is called ${servername}-backups. 

Like you can imagine ${servername} holds your live Server and ${servername}-backups stores your backups. 
# server.settings
This is your file that holds the variables you have chosen with the setup script.

If you know what your are doing feel free to edit it to suit your needs.
```
nano server.settings
```
It looks like this: (the empty variables are filled with the content your provided in setup.sh)
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
# server variables
new=$(date +"%Y-%m-%d")
old=$(date -d "-24 days" +"%Y-%m-%d")
screen=
java=
dnsserver=
interface=
servername=
homedirectory=
serverdirectory=
backupdirectory=
mems=
memx=
threadcount=
serverfile=
```
# serverstart
Start your Server for the first time:
```
./start.sh
```

The first time the server will fail to start - this is normal.

You need to accept the eula (End User License Agreement):
```
nano eula.txt
```
replace eula=false with eula=true

By doing this, of course you will have to follow their terms and conditions. 

Now start your server a secound time - this time it should work.
```
./start.sh
```
# server.properties
If you would like to costumize your server further have a look at your server.properties file. 
```
nano server.properties
```
Important settings are:

```
max-players=            (limuts the maximumg amount of players on the server at the same time[Warning large numbers may impact performance])
difficulty=             (defines ingame difficulty [peaceful, easy, normal, hard])
view-distance=          (defines number of ingame chnuks to be rendered [Warning large numbers may impact performance])
enforce-whitelist=      (enforces the whitelist[I would strongely recomment to set this to true])
white-list=             (turns on the whitelist[I would strongely recomment to set this to true])
online-mode=            (runs server in online mode with Mojang authentication [I would strongely recomment to set this to true])
motd=                   (this will be displayed in the menu below your server - chose what you like)
server-port=            (default by 25565. Only importent if you are dealing with multiple server)
max-tick-time=          (default by 60000. Time in millisecound until the server considers itself as crashed)
gamemode=               (default survival. Defines your game mode. For creative server replace with creative)
sync-chunk-writes=      (stores your changes [I would strongely recomment to set this to true])
```
# scripts
The following scripts automate the start, stop, restart and backup procedure. 

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
```
./backup.sh
```
The varo and speedrun scripts can be used if you wish for some varo and speedrun functionality. 

They can be executed with:
```
./speedrun.sh
```
```
./varo.sh
```
The prerender script is for pregenerating your world if you so desire. 

It will require at least one player on the server. 
```
./prerender.sh
```

The maintenance script is there to let people know you take their server offline while you perform maintenance. 
```
./maintenance.sh
```
The update script will updaet your server to the newest java version avaible. 
```
./update.sh
```
There is also a reset script. Warning it will reset your world and log files. 
```
./reset.sh
```
# crontab
If you would like to automate some of those task on your server you can create a crontab.
```
crontab -e
```
A new file will open (If you got one already the existing one will open)

In this file, you can automate things as follows:

Suggestion:

Example: (In order to work, please replace the variable with your own ones)
```
# minecraft ${servername} server restart at 02:00
00 02 * * * ${serverdirectory}/restart.sh

# minecraft ${servername} server backup at 04:00
00 04 * * * ${serverdirectory}/backup.sh
```
You may also do it differently:

Example: (In order to work, please replace the variable with your own ones)
```
# minecraft ${servername} server stop at 02:00
00 02 * * * ${serverdirectory}/stop.sh

# minecraft ${servername} server backup at 02:01
01 02 * * * ${serverdirectory}/backup.sh

# minecraft ${servername} server start at 02:05
05 02 * * * ${serverdirectory}/start.sh
```
Also, if you want your server to be online from a certain time to time:

Example: (In order to work, please replace the variable with your own ones)
```
# minecraft ${servername} server start at 16:00
00 16 * * * ${serverdirectory}/start.sh

# minecraft ${servername} server stop at 22:00
00 22 * * * ${serverdirectory}/stop.sh

# minecraft ${servername} server backup at 04:00
00 04 * * * ${serverdirectory}/backup.sh
```

If you want to start up your minecraft server at boot of your Linux server:

Example: (In order to work, please replace the variable with your own ones)
```
# minecraft ${servername} server start at boot
@reboot ${serverdirectory}/start.sh
```
Close and save your crontab. 
# ending
I hope you learned something and that those scripts I provide may help you and your minecraft server experience. 

Have fun and enjoy the Game ;^)

Best regards,

Simylein
