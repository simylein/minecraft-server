# Minecraft_Server
Scripts for a Minecraft Server on Linux using screen. 

First, you can download and execute the setup script.

donwloading setup script:
```
  wget -O setup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/setup.sh
```

You will need to edit the file and change "servername=$minecraft" and "directory=$/home/simylein/" to something that suits you. 
```
nano setup.sh
```

After you are done you can go ahead and execute it.

making setup script executable:
```
chmod +x setup.sh
```

executing setup script:
```
./setup.sh
```

Now you got two directorys. 

By default, one is called "minecraft" and has all the scripts in it and the other one is called "minecraft-backups" (if you chose another name it will replace "minecraft" with your name)

The "minecraft" is your Live-Server so to Speak and the "minecraft-backups" stores your backups as an archiv or restore option. 

There is also a Script which is called settings.sh

This stores all the variables for your Minecraft Server.

Again you should edit it and change it as you like. 

you can edit it like this:
```
nano settings.sh
```

The following Scripts automate the start, stop, restart, backup and update procedure. 

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

The Varo and Speedrun Scripts can be downloaded if you wish for some Varo/Speedrun functionality. 

They can be executed with:

```
./speedrun.sh
```
```
./varo.sh
```

I hope you learned something and that those Scripts I provide may help you and your Minecraft Server Experience. 

Have Fun and enjoy the Game ;^)
