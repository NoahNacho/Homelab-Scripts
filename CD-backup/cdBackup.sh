#!/bin/bash
#ez backup of cd
#should be run as sudo

#variables for multiple ez runs
SRC="" #where cd is mounted to
DEST="" #where files will be copied to
DEVICE="" #what device to mount /dev/cdrom is usually a good choice
#check for flags
# -n dirname
while getopts n: flag
do
    case "${flag}" in
        n) FILENAME=${OPTARG};;
    esac
done

#check if -n was sent
if test -z "$FILENAME"
then
    echo "Dir name not specified, please specify a name to save as:"
    read FILENAME
    echo "$FILENAME"
fi

#actual fun stuff
mount "$DEVICE" "$SRC"
DIRPATH="$DEST/$FILENAME"
mkdir "$DIRPATH"
cp -r "$SRC" "$DIRPATH"
eject
ls "$DIRPATH/media/"
