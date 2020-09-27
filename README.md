# MinecraftServer
Scripts for a Minecraft Server on Linux [Debian] using screen. 

Software:

In order for the Server to run we will need to install 2 Programms:

Java:
```
sudo apt install openjdk-14-jre-headless
```

Screen:
```
sudo apt install screen
```

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

Now you will need to download the server executable from Mojang and place it into your ${servername} directory. 

You can download it from: https://www.minecraft.net/en-us/download/server

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
Settings: 

If you would like to costumize your server further have a look at your server.properties file. 
```
nano server.properties
```
Important settings are:

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

The following scripts automate the start, stop, restart, backup and update procedure. 

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
```
./update.sh
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

I hope you learned something and that those Scripts I provide may help you and your Minecraft Server experience. 

Have Fun and enjoy the Game ;^)
