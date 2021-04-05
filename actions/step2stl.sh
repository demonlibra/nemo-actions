#!/bin/bash

# Dowload and write correct path to file 'freecad_convert.py'
# https://github.com/faerietree/freecad_convert/blob/master/freecad_convert.py
path_converter="$HOME/app/freecad_convert/freecad_convert.py"

find "$@" -type f \( -iname "*.stp" -or -iname "*.step" \) -print0 | while read -d $'\0' file
	do
		python3 "$path_converter" "$file" "${file%.*}.stl"
done

#Вывод уведомления
notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование STEP в STL"
