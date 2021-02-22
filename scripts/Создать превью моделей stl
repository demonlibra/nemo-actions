#!/bin/bash

#Проверка установки пакета yad
if [ -z "`dpkg -l | grep yad`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета yad" -- bash -c "echo \"yad не установлен\"; echo ; sudo apt install yad; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

#Проверка установки пакета openSCAD
if [ -z "`dpkg -l | grep openscad`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета openscad" -- bash -c "echo \"openscad не установлен\"; echo ; sudo apt install openscad; echo ; echo ------------------ ; echo ; echo \"Установка openscad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`yad --borders=10 --title="stl 2 png" --text="Создание изображения из stl" --text-align=center --form --item-separator="|" \
	--field=:LBL --field="Ширина изображения" --field="Высота изображения" --field="Цветовая схема:CB" 														--field="Проекция:CB" --field="Автоцентровка:CHK" --field="Вписать модель в размер:CHK" --field="Камера авто:CHK" --field="Камера ручн." 		--field="              transx,transy,transz,rotx,roty,rotz,distance:LBL" --field="Формат изображений:CB" \
		"" 					1080											1080				"^Cornfield|Sunset|Metallic|Starnight|BeforeDawn|Nature|Случайная"	"ortho|perspective" 						TRUE								TRUE												TRUE				"0,0,0,25,0,35,500"								""																						"png|gif|jpg"`

if [ $? = 0 ]
	then
		width=$( echo $AAA | awk -F '|' '{print $2}')
		height=$( echo $AAA | awk -F '|' '{print $3}')

		colorscheme[0]=Cornfield
		colorscheme[1]=Sunset
		colorscheme[2]=Metallic
		colorscheme[3]=Starnight
		colorscheme[4]=BeforeDawn
		colorscheme[5]=Nature
		colorscheme[6]=DeepOcean
		colorscheme[7]=$( echo $AAA | awk -F '|' '{print $4}')

		projection=$( echo $AAA | awk -F '|' '{print $5}')

		autocenter=$( echo $AAA | awk -F '|' '{print $6}')
		if [ $autocenter = "TRUE" ]; then autocenter='--autocenter'; else autocenter=''; fi

		viewall=$( echo $AAA | awk -F '|' '{print $7}')
		if [ $viewall = "TRUE" ]; then viewall='--viewall'; else viewall=''; fi

		camera_auto=$( echo $AAA | awk -F '|' '{print $8}')
		camera_man=$( echo $AAA | awk -F '|' '{print $9}')
		if [ "$camera_auto" != "TRUE" ]; then camera='--camera='${camera_man}; else camera=''; fi

		format=$( echo $AAA | awk -F '|' '{print $11}')
		
		number=`find "$@" -type f -iname "*.stl" -print | wc -l`	#Количество найденных файлов stl
		procent=$((100/$number))									#Процентов на каждый файл

		#Поиск файлов STL и формирование списка
		find "$@" -type f -iname "*.stl" -print0 | (while read -d $'\0' file
			do
				Start_Time=$(date +%s%N)	# Время начала обработки файлы STL

				# Случайный выбор цветовой схемы
				if [ "${colorscheme[7]}" = "Случайная" ]
					then
						color_number=`shuf -i 0-6 -n 1`
						color_scheme=${colorscheme[$color_number]}
					else
						color_scheme="${colorscheme[7]}"
				fi

				#Имя файла без пути
				filename="${file##*/}"

				#Создаём временный файл scad с командой импорта stl
				echo "import(\"${filename}\");" > "${file%.*}".scad

				#Экспорт в png при помощи openSCAD
				openscad -q -o "${file%.*}.png" --render --colorscheme=${color_scheme} $camera --projection=$projection $autocenter $viewall --imgsize=$width,$height "${file%.*}.scad" > /dev/null

				if [ $format != "png" ]
					then
						mogrify -format $format "${file%.*}.png" > /dev/null
						rm "${file%.*}.png"
					fi
					
				#Удаление временного файла
				rm "${file%.*}.scad"

				counter=$(($counter+1))
				progress=$(($progress+$procent))
				
				# Расчёт оставшегося времени исполнения сценария
				End_Time=$(date +%s%N)												# Время окончания обрабоки файла STL
				Sum_Time_ms=$(( $Sum_Time_ms + ($End_Time - $Start_Time)/1000000 ))	# Прошедшее время (мс) обработки файлов STL
				Everage_Time_ms=$(( $Sum_Time_ms / $counter ))						# Среднее время (мс) обработки каждого файла STL
				Second_to_End=$(( $Everage_Time_ms * ($number - $counter) / 1000 ))	# Осталось секунд до завершения обработки всех файлов
				Time_to_End=`date -d@${Second_to_End} -u +%Hч:%Mмин:%Sсек`
				
				echo $progress
				echo "# Обработано: ${counter} файлов из ${number}\n\nОсталось до завершения: ${Time_to_End}\nЗавершена обработка файла: ${filename}"
				
			done) | zenity --progress --title="Создание превью для моделей STL" --percentage=0 --auto-kill --width=500 --auto-close

		#Вывод уведомления
		notify-send -t 10000 -i "gtk-ok" "Завершено" "Создание превью для моделей STL"
fi
