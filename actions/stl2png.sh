#!/bin/bash

#Проверка установки пакета yad
if [ -z "`dpkg -l | grep yad`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета yad" -- bash -c "echo \"yad не установлен\"; echo ; sudo apt install yad; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

#Проверка установки пакета openSCAD
if [ -z "`dpkg -l | grep openscad`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета openscad" -- bash -c "echo \"openscad не установлен\"; echo ; sudo apt install openscad; echo ; echo ------------------ ; echo ; echo \"Установка openscad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`yad --borders=10 --title="stl 2 png" --text="Конвертация stl в png" --text-align=center --form --item-separator="|" --field=:LBL --field="Ширина изображения" --field="Высота изображения" --field="Автоцентровка:CHK" --field="Вписать модель в размер:CHK" --field="Проекция:CB" --field="Камера авто:CHK" --field="Камера ручн." "" 1080 1080 TRUE TRUE "ortho|perspective" TRUE "0,0,0,25,0,35,500"`

if [ $? = 0 ]
	then
		width=$( echo $AAA | awk -F '|' '{print $2}')
		height=$( echo $AAA | awk -F '|' '{print $3}')
		
		autocenter=$( echo $AAA | awk -F '|' '{print $4}')
		if [ $autocenter = "TRUE" ]; then autocenter='--autocenter'; else autocenter=''; fi
		
		viewall=$( echo $AAA | awk -F '|' '{print $5}')
		if [ $viewall = "TRUE" ]; then viewall='--viewall'; else viewall=''; fi

                projection=$( echo $AAA | awk -F '|' '{print $6}')

                camera_auto=$( echo $AAA | awk -F '|' '{print $7}')
                camera_man=$( echo $AAA | awk -F '|' '{print $8}')
                if [ "$camera_auto" != "TRUE" ]; then camera='--camera='${camera_man}; else camera=''; fi

		for file in "$@"
			do
				#Создание временного файла scad с командой импорта stl
				echo "import(\"${file}\");" > "${file%.*}.scad"

				# Экспорт в png при помощи openSCAD
				openscad -o "${file%.*}.png" $camera --projection=$projection $autocenter $viewall --imgsize=$width,$height "${file%.*}.scad"

				# Удаление временного файла
				rm "${file%.*}.scad"
			done
fi