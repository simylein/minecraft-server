#!/bin/bash
# Minecraft Server settings

# All variables for the server
screen=$/usr/bin/screen
java=$/usr/bin/java
serverfile=$/minecraft_server.1.16.2.jar
servername=$minecraft
directory=$/home/simylein/
mems=$-Xms256M
memx=$-Xmx2048M
threadcount=$-XX:ParallelGCThreads=2
