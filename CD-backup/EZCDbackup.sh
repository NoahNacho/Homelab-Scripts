#!/bin/bash
#ez backup of cd
#should be run as sudo

#variables for multiple ez runs
SRC="" #where cd is mounted to
DEST="" #where files will be copied to
DEVICE="" #what device to mount /dev/cdrom is usually a good choice

#variables for discord webhook notify
url="" #webhook url
message="$SRC successfully copied to $DEST"
#check for flags
while getopts n:dh flag
do
    case "${flag}" in
        n) FILENAME=${OPTARG};;
        d) DISCORD="TRUE";;
        h) HELP="TRUE";;
    esac
done

#check for flags set
if [ -n "$HELP" ]; then
    echo "Help command for cd.sh by @NoahNacho\n"
    echo -e "Options: \n-h Displays this message. \n-d if variable is set, send message to discord webhook when copy is complete \n-n Set name for directory created when copying."
    exit 1
fi
if [ -z "$FILENAME" ]; then
    echo "Dir name not specified, please specify a name to save as:"
    read FILENAME
fi
#actual fun stuff
mount "$DEVICE" "$SRC"
DIRPATH="$DEST/$FILENAME"
mkdir "$DIRPATH"
cp -r "$SRC" "$DIRPATH"
eject

if [ -n "$DISCORD" ]; then
    msg_content=\"$message\"
    curl -H "Content-Type: application/json" -X POST -d "{\"content\": $msg_content}" $url
else
    ls "$DIRPATH/media/"
fi
