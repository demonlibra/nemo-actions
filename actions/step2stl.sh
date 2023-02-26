#!/bin/bash

'''
Dowload and write full path to prusa-slicer
PrusaSlicer must be 2.5 or newer
https://github.com/prusa3d/PrusaSlicer
'''

path_ps="/home/demonlibra/app/PrusaSlicer/bin/prusa-slicer"

#Проверка доступа к PrusaSlicer
if ! [ -f "$path_ps" ]
	then
		notify-send -t 10000 -i "gtk-ok" "prusa-slicer" "Файл отсутствует или путь указан не верно"
		exit 0
fi

find "$@" -type f \( -iname "*.stp" -or -iname "*.step" \) -print0 | while read -d $'\0' file
	do
		"$path_ps" --export-stl "$file"
done

#Вывод уведомления
notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование STEP в STL"
