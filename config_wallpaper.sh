#!/bin/bash

config_file="/home/cip/Desktop/AutomaticWallpaperChanger/config.json"

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
			#-i|--images)
			#	shift
			#	images="$1"
			#;;
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

# If the directory argument is set then change the variable in the config.json file
if [ ! -z ${directory+x} ]
then 
#	echo "directory is unchanged"; 
#else
	old_directory=$(jq '.directory' ${config_file}) 
	jq --arg a "${directory}" '.directory = $a' ${config_file} > "tmp" && mv "tmp" ${config_file}
    # echo -e "directory variable has been set from $old_directory to \"$directory\""; 
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

