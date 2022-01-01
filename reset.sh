#!/bin/bash
# minecraft server reset script

# read server files
source server.settings
source server.functions

# parse arguments
ParseArgs "$@"

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
Countdown "stopping"

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
CachedBackup "reset"

# remove log and world
Print "info" "removing world directory..."
nice -n 19 rm -r world
mkdir world

# restart the server
echo "action" "restarting server..."
./start.sh --force "$@"

# log to debug if true
Debug "executed $0 script"

# exit with code 0
exit 0
