# MinecraftServer
Scripts for a Minecraft Server on Linux using screen. 

First, you can download and execute the setup script.

donwloading setup script:
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

The Varo and Speedrun Scripts can be used if you wish for some Varo/Speedrun functionality. 

They can be executed with:

```
./speedrun.sh
```
```
./varo.sh
```

I hope you learned something and that those Scripts I provide may help you and your Minecraft Server experience. 

Have Fun and enjoy the Game ;^)
