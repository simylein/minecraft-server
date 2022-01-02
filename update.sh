#!/bin/bash
# minecraft server update script

# read server files
source server.settings
source server.functions

# parse arguments
ParseArgs "$@"
ArgHelp

# safety checks
RootSafety
ScriptSafety

# debug
Debug "executing $0 script"

# change to server directory
ChangeServerDirectory

# check for existance of executable
CheckExecutable

# look if server is running
CheckScreen

# prints countdown to screen
Countdown "updating"

# server stop
Stop

# awaits server stop
AwaitStop

# force quit server if not stopped
ForceQuit

# output confirmed stop
Log "ok" "server successfully stopped" "${screenLog}"
Print "ok" "server successfully stopped"

# create backup
CachedBackup "update"

# update from url
url="https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar"
version="1.18.1"

# Test internet connectivity and update on success
wget --spider --quiet "${url}"
if [ "$?" != 0 ]; then
	Log "warn" "unable to connect to mojang api skipping update..." "${screenLog}"
	Print "warn" "unable to connect to mojang api skipping update..."
else
	Log "info" "downloading newest server version..." "${screenLog}"
	Print "ok" "downloading newest server version..."
	# check if already on newest version
	if [[ "${executableServerFile}" = *"minecraft-server.${version}.jar" ]]; then
		Log "info" "you are running the newest server version - skipping update" "${screenLog}"
		Print "info" "you are running the newest server version - skipping update"
	else
		wget -q -O "minecraft-server.${version}.jar" "${url}"
		# update serverfile variable in server.settings
		newExecutableServerFile="${serverDirectory}/minecraft-server.${version}.jar"
		# if new serverfile exists remove oldserverfile
		if [ -s "${newExecutableServerFile}" ]; then
			Log "ok" "updating server.settings for startup with new server version ${version}" "${screenLog}"
			Print "ok" "updating server.settings for startup with new server version ${version}"
			sed -i "s|${executableServerFile}|${newExecutableServerFile}|g" "server.settings"
			# remove old serverfile if it exists
			if [ -s "${executableServerFile}" ]; then
				rm "${executableServerFile}"
			fi
		else
			Print "warn" "could not remove old server-file ${executableServerFile} because new server-file ${newExecutableServerFile} is missing"
			Print "info" "server will startup with old server-file ${executableServerFile}"
		fi
	fi
fi

# remove scripts from serverdirectory
RemoveScripts

# downloading scripts from github
DownloadScripts

# make selected scripts executable
ExecutableScripts

# restart the server
Print "action" "restarting server..."
./start.sh --force "$@"

# log to debug if true
Debug "executed $0 script"

# exit with code 0
exit 0
