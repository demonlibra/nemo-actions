#!/bin/bash

file="$1"
name_without_ext=${file%.*}
ext="png"

path=${file%/*}

parameters=`yad --borders=20 --width=500 --title="Объединить png в анимированный apng" \
	--text-align=center --item-separator="|" --separator="!" --form \
	--field="Файл для сохранения"		--field=" :LBL"		--field="Каталог для сохранения:DIR" --field="Задержка (1/10 секунды)" \
				"out.apng"						""								"$path"						"1 10"`

exit_status=$?

if [ $exit_status = 0 ]
	then
		new_name=$(echo $parameters | awk -F '!' '{print $1}')
		dir=$(echo $parameters | awk -F '!' '{print $3}')
		delay=$(echo $parameters | awk -F '!' '{print $4}')

		path_to_save="$dir/$new_name"
		pattern=`echo "${name_without_ext}" | sed 's/[0-9]\+$//'`"*.png"

		gnome-terminal --wait --title="youtube-dl" --geometry=90x20 --hide-menubar \
			-e "apngasm \"$path_to_save\" \"$pattern\" $delay"
		#apngasm "$path_to_save" "$pattern" $delay
fi
