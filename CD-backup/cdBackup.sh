#!/bin/bash
#ez backup of cd
#should be run as sudo

#variables for multiple ez runs
SRC="" #where your drive will be mounted to
DEST="" #full path you want files copied to
DEVICE="" #/dev/cdrom is usually best

#check for flags
# -n dirname
while getopts n: flag
do
    case "${flag}" in
        n) FILENAME=${OPTARG};;
    esac
done

#check if -n for name was used
if test -z "$FILENAME"
then
    echo "Please run with -n 'name of cd'"
    exit 1
fi

#actual fun stuff
mount "$DEVICE" "$SRC"
DIRPATH="$DEST/$FILENAME"
mkdir "$DIRPATH"
cp -r "$SRC" "$DIRPATH"
eject
