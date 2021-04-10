#!/bin/bash

# Dowload and write correct path to file 'freecad_convert.py'
# https://github.com/faerietree/freecad_convert/blob/master/freecad_convert.py
path_converter="$HOME/app/freecad_convert/freecad_convert.py"

#Проверка установки пакета freecad
if [ -z "`dpkg -l | grep freecad`" ]
	then x-terminal-emulator --hide-menubar --geometry=80x15 -t "Установка пакета freecad" -e bash -c "echo \"freecad не установлен\"; echo ; sudo apt install freecad; echo ; echo ------------------ ; echo ; echo \"Установка freecad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

if ! [ -f "$path_converter" ]
	then
		notify-send -t 10000 -i "gtk-ok" "freecad_convert.py" "Путь к файлу указан не верно"
		exit 0
fi

find "$@" -type f \( -iname "*.stp" -or -iname "*.step" \) -print0 | while read -d $'\0' file
	do
		python3 "$path_converter" "$file" "${file%.*}.stl"
done

#Вывод уведомления
notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование STEP в STL"
