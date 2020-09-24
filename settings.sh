#!/bin/bash
# Minecraft Server settings

# All variables for the server
# If you know what you are doing, feel free to tinker with them ;^)

screen='/usr/bin/screen'
java='/usr/bin/java'
dnsserver='1.1.1.1'
interface='192.168.1.1'
threadcount='-XX:ParallelGCThreads=2'
mems='-Xms256M'
memx='-Xmx2048M'
serverfile='/home/simylein/minecraft/minecraft_server.1.16.3.jar'
