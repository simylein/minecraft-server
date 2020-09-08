#!/bin/bash
# Minecraft Server settings

# All variables for the server

# Directory path of the screen binary
screen='/usr/bin/screen'

# Directory path of the java binary
java='/usr/bin/java'

# Directory path of the server.jar
serverfile='/minecraft_server.1.16.2.jar'

# Name of Server
servername='minecraft'

# Homedirectory
directory='/home/simylein/'

# Minimum ammount of Memory granted
mems='-Xms256M'

# Maximum ammount of Memory granted
memx='-Xmx2048M'

# Number of Threads allowed
threadcount='-XX:ParallelGCThreads=2'
