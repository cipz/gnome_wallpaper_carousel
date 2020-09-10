#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
config_file=$DIR"/config.json"

# This needs to be edited
help () {
	echo "
	-d | --directory
		directory where the wallpaper image files are located
	-h | --help
		this help menu
	"
}

parse_args () {

	# echo "There are $# arguments"
	# echo "parse_args"
    
	# Add argument for changing the path of the config file
	while :; do
        case $1 in
			-h|--help) 
				help
				exit 0
			;;
			-d|--directory)
				shift
				directory="$1"
			;;
#			-i|--include)
#				shift
#				include="$1"
#			;;
#			-e|--exclude)
#				shift
#				include="$1"
			;;
			*) break
		esac
		shift
	done

}

update_config () {

  # If the directory argument is set (not empty) then change the variable in the config.json file
  if [ ! -z ${directory+x} ]
  then 
    old_directory=$(jq '.directory' ${config_file}) 
    jq --arg a "${directory}" '.directory = $a' ${config_file} > "tmp" && mv "tmp" ${config_file}
    # echo -e "Directory variable has been set from $old_directory to \"$directory\""; 
  fi

  # If the images argument is set then change the variable in the config.json file
  # if [ -z ${images+x} ]
  # then 
  # 	echo "Images is unchanged"; 
  # else
  # 	old_images=$(jq '.images' ${config_file}) 
  # 	jq --arg a "${images}" '.images = $a' ${config_file} > "tmp" && mv "tmp" ${config_file}
  #     echo -e "Images variable has been set from $old_images to \"$images\""; 
  # fi

}

update_wallpaper () {

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

  # Getting variables from configuration file
  directory=$(jq '.directory' ${config_file})
  directory=${directory//\"}

  old_wallpaper=$(jq '.current_wallpaper' ${config_file})
  old_wallpaper=${old_wallpaper//\"}

  # Use nullglob in case there are no matching files
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

  jq --arg a "${new_wallpaper}" '.current_wallpaper = $a' ${config_file} > "tmp" && mv "tmp" ${config_file}

  # echo "Changing wallpaper to $new_wallpaper"

  gsettings set org.gnome.desktop.background picture-uri "${new_wallpaper}"

}

if test $# -gt 0
then

	parse_args $@
  update_config

else

  update_wallpaper

fi
