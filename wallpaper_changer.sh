#!/bin/bash

# Getting variables from configuration file
directory=$(jq '.directory' config.json)
directory=${directory//\"}

old_wallpaper=$(jq '.current_wallpaper' config.json)
old_wallpaper=${old_wallpaper//\"}

# use nullglob in case there are no matching files
shopt -s nullglob

# create an array with all the filer/dir inside ~/myDir
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

jq --arg a "${new_wallpaper}" '.current_wallpaper = $a' config.json > "tmp" && mv "tmp" config.json

# echo "Changing wallpaper to $new_wallpaper"

gsettings set org.gnome.desktop.background picture-uri "${new_wallpaper}"