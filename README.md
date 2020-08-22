# Minecraft_Server
Scripts for a Minecraft Server on Linux using papermc and screen. 

Feel free to change the installations paths to something you like. 

donwloading setup script:
```
  wget -O setup.sh https://raw.githubusercontent.com/Simylein/Minecraft_Server/master/setup.sh
```

making setup script executable:
```
chmod +x setup.sh
```

executing setup script:
```
./setup.sh
```

done

Now you dot a minecraft directory with different Scripts. 

Those automate the start, stop, restart, update and backup procedure. 

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

If you wish you can configure a crontab to automatically execute these. 
Here an Example with daily Restarts and Backups:

```
# Minecraft Server restart at 02:00
0 2 * * * /home/simylein/minecraft/restart.sh
# Minecraft Server backup at 04:00
0 4 * * * /home/simylein/minecraft/backup.sh
```

If you wish you can also execute start.sh at boot:
```
# Minecraft Server start at boot
@reboot /home/simylein/minecraft/start.sh
```

