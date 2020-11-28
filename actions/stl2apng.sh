#!/bin/bash

#Проверка установки пакета yad
if [ -z "`dpkg -l | grep yad`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета yad" -- bash -c "echo \"yad не установлен\"; echo ; sudo apt install yad; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

#Проверка установки пакета openSCAD
if [ -z "`dpkg -l | grep openscad`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета openscad" -- bash -c "echo \"openscad не установлен\"; echo ; sudo apt install openscad; echo ; echo ------------------ ; echo ; echo \"Установка openscad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

#Проверка установки пакета apngasm
if [ -z "`dpkg -l | grep apngasm`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета apngasm" -- bash -c "echo \"apngasm не установлен\"; echo ; sudo apt install apngasm; echo ; echo ------------------ ; echo ; echo \"Установка apngasm завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`yad --borders=10 --title="stl 2 apng" --text="Создание анимации из stl" --text-align=center --form --item-separator="|" --field=:LBL --field="Ширина изображения" --field="Высота изображения" --field="Проекция:CB" --field="Автоцентровка:CHK" --field="Вписать модель в размер:CHK" --field="Камера ручн." --field="              transx,transy,transz,rotx,roty,rotz,distance:LBL" --field="Угол поворота за шаг" --field="Задержка (1/5 сек)" --field="Начальный угол" "" 1080 1080  "ortho|perspective" TRUE TRUE "0,0,0,25,0,35,500" "" 10 "1 5" 40`

if [ $? = 0 ]
	then
		width=$( echo $AAA | awk -F '|' '{print $2}')
		height=$( echo $AAA | awk -F '|' '{print $3}')

                projection=$( echo $AAA | awk -F '|' '{print $4}')

		autocenter=$( echo $AAA | awk -F '|' '{print $5}')
		if [ $autocenter = "TRUE" ]; then autocenter='--autocenter'; else autocenter=''; fi
		
		viewall=$( echo $AAA | awk -F '|' '{print $6}')
		if [ $viewall = "TRUE" ]; then viewall='--viewall'; else viewall=''; fi


                #camera_start=$( echo $AAA | awk -F '|' '{print $7}')
                #if [ "$camera_auto" != "TRUE" ]; then camera='--camera='${camera_man}; else camera=''; fi

                degree_step=$( echo $AAA | awk -F '|' '{print $9}')
                delay=$( echo $AAA | awk -F '|' '{print $10}')
                degree_start=$( echo $AAA | awk -F '|' '{print $11}')
		for file in "$@"
			do
				#Создание временного файла scad с командой импорта stl
				echo "import(\"${file}\");" > "${file%.*}.scad"

				# Экспорт кадров в png при помощи openSCAD
				num=0
                                for ((deg=degree_start; deg<degree_start+360; deg=deg+degree_step))
                                    do
                                      num=$((num+1))
                                      name="${file%/*}/frame"`printf "%02d" $num`".png"
                                      openscad -o "$name" --camera=0,0,0,40,0,$deg,500 --projection=$projection $autocenter $viewall --imgsize=$width,$height "${file%.*}.scad"
                                    done
                                apngasm "${file%.*}.png" "${file%/*}/frame"*".png" $delay

                                # Удаление кадров
				rm "${file%/*}/frame"*".png"

				# Удаление временного файла scad
				rm "${file%.*}.scad"
			done
fi