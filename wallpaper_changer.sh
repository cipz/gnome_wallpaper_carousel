#!/bin/bash

current_working_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

config_file=$current_working_directory"/config.json"

wp_folder_path=$(jq '.directory' ${config_file})
wp_folder_path=${wp_folder_path//\"}

if [[ ! -d "${wp_folder_path}/old" ]] ; then
    mkdir -p "${wp_folder_path}/old"
fi

wp_folder_arr=($(ls ${wp_folder_path}/*.{png,jpg,jpeg,PNG,JPG,JPEG} 2> /dev/null))
wp_folder_elements=${#wp_folder_arr[@]}

if [[ $wp_folder_elements -eq 0 ]] ; then
    mv ${wp_folder_path}/old/*.{png,jpg,jpeg,PNG,JPG,JPEG} ${wp_folder_path} 2> /dev/null
    wp_folder_arr=(${wp_folder_path}/*.{png,jpg,jpeg,PNG,JPG,JPEG})
    wp_folder_elements=${#wp_folder_arr[@]}
fi

new_wp_index=$(($RANDOM % $wp_folder_elements))
new_wp_path=${wp_folder_arr[$new_wp_index]}

new_wp_file=$(basename $new_wp_path)

mv "$new_wp_path" "$wp_folder_path/old/$new_wp_file"

gsettings set org.gnome.desktop.background picture-uri-dark "file://$wp_folder_path/old/$new_wp_file"