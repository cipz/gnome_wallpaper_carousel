#!/bin/bash

# - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- 

# This code allows the script to run with cron
# gsettings needs to know the process and the display
user=$(whoami)

fl=$(find /proc -maxdepth 2 -user $user -name environ -print -quit)
while [ -z $(grep -z DBUS_SESSION_BUS_ADDRESS "$fl" | cut -d= -f2- | tr -d '\000' ) ]
do
  fl=$(find /proc -maxdepth 2 -user $user -name environ -newer "$fl" -print -quit)
done

export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS "$fl" | cut -d= -f2-)

# - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- - -- 

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
config_file=$DIR"/config.json"

# Getting variables from configuration file
directory=$(jq '.directory' ${config_file})
directory=${directory//\"}

old_wallpaper=$(jq '.current_wallpaper' ${config_file})
old_wallpaper=${old_wallpaper//\"}

# use nullglob in case there are no matching files
shopt -s nullglob

arr=(${directory}/*)
size=${#arr[@]}

# echo $size
index=$(($RANDOM % $size))
new_wallpaper=${arr[$index]}

if (( size > 1 ))
then
    while [ $new_wallpaper == $old_wallpaper ]
    do
        index=$(($RANDOM % $size))
        new_wallpaper=${arr[$index]}
    done
fi

# Or I could take it out of the array
#arr=("${arr[@]/$old_wallpaper}")
#let size--

jq --arg a "${new_wallpaper}" '.current_wallpaper = $a' ${config_file} > "tmp" && mv "tmp" ${config_file}

#echo "Changing wallpaper to $new_wallpaper"

gsettings set org.gnome.desktop.background picture-uri "${new_wallpaper}"
gsettings set org.gnome.desktop.background picture-options 'wallpaper'