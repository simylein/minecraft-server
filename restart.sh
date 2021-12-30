#!/bin/bash
# minecraft server restart script

# read server files
source server.settings
source server.functions

# safety checks
RootSafety
ScriptSafety

# parse arguments
ParseArgs "$@"

# debug
Debug "executing $0 script"

# change to server directory
ChangeServerDirectory

# check for existance of executable
CheckExecutable

# look if server is running
CheckScreen

# prints countdown to screen
Countdown "restarting"

# server stop
Stop

# awaits server stop
AwaitStop

# force quit server if not stopped
ForceQuit

# output confirmed stop
Log "ok" "server successfully stopped" "${screenLog}"
Print "ok" "server successfully stopped"

# restart the server
Print "action" "restarting server..."
./start.sh "$@"

# log to debug if true
Debug "executed $0 script"

# exit with code 0
exit 0
