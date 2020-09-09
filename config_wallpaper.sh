#!/bin/bash

parse_args () {

	echo "There are $# arguments"
	echo "parse_args"
    
	while :; do
        case $1 in
			-h|--help) 
				help
				exit 0
			;;
			-f|--folder) 
				shift
				folder="$1"
			;;
			*) break
		esac
		shift
	done

}

if test $# -gt 0
then
	parse_args $@
#else
#	echo "No arguments have been passed."
fi

# If the folder argument is set then change the variable in the config.json file
if [ -z ${folder+x} ]
then 
	echo "Folder is unchanged"; 
else
	old_folder=$(jq '.folder' config.json) 
	jq --arg a "${folder}" '.folder = $a' config.json > "tmp" && mv "tmp" config.json
    echo -e "Folder variable has been set from $old_folder to \"$folder\""; 
fi

#gsettings set org.gnome.desktop.background picture-uri "/home/cip/Pictures/wallpaper/IMG-8917.jpg"
