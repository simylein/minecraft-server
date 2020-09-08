# Minecraft_Server
Scripts for a Minecraft Server on Linux using screen. 

First, you can download and execute the setup script.

donwloading setup script:
```
  wget -O setup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/setup.sh
```

You will need to edit the file and change "servername=$minecraft" and "directory=$/home/simylein/" to something that suits you. 

making setup script executable:
```
chmod +x setup.sh
```

executing setup script:
```
./setup.sh
```

Now you got two directorys. 

One is called "minecraft" and has all the scripts in it and the otherone is called "minecraft-backups"

The "minecraft" is your Live-Server so to Speak and the "minecraft-backups" stores your backups as an archiv or restore option. 

The following Scripts automate the start, stop, restart, update and backup procedure. 

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
./update.sh
```
```
./backup.sh
```
The file settings.sh can be edited and confiured to suit your needs. 

The Speedrun and Varo Scripts can be downloaded if you wish for some Varo/Speedrun functionality. 

They can be executed with:

```
./speedrun.sh
```
```
./varo.sh
```

I hope you learned something and that those Scripts I provide may help you and your Minecraft Server Experience. 

Have Fun and enjoy the Game ;^)
