#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

#Проверка установки пакета zenity
if [ -z "`dpkg -l | grep zenity`" ]
	then xfce4-terminal --hide-menubar --geometry=80x15 -T "Установка пакета zenity" -x bash -c "echo \"zenity не установлен\"; echo ; sudo apt install zenity; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

FORM=`yad --borders=10 --width=300 --title="Обрезать изображения" --text-align=center --form --item-separator="|" --separator="," \
	 --field="Позиция отсчёта:CB" 												--field="Ширина и высота (WxH) или (xH) или (Wx)" 	--field="Смещение (+X+Y)"	--field="Расширить, если исходный размер меньше:CHK"	--field="Цвет фона при расширении:CLR"	--field="Перезаписать файл:CHK" \
	"None|NorthWest|North|NorthEast|West|^Center|East|SouthWest|South|SouthEast"			"800x600"						"+0+0"						FALSE															white								FALSE`

if [ $? = 0 ]
	then
		gravity=$( echo $FORM | awk -F ',' '{print $1}')
		size=$( echo $FORM | awk -F ',' '{print $2}')
		offset=$( echo $FORM | awk -F ',' '{print $3}')
		extent=$( echo $FORM | awk -F ',' '{print $4}')
		color=$( echo $FORM | awk -F ',' '{print $5}')
		rewrite=$( echo $FORM | awk -F ',' '{print $6}')

		kolfile=$#							# Количество выделенных файлов
		procent=$((100/$kolfile))			# Процентов на каждый файл

		(for file in "$@"
			do
				if [[ `echo ${size:0:1}` == "x" ]] || [[ `echo ${size:0:1}` == "X" ]]
					then
						width=`identify -ping -format '%w' $1`
						size="$width$size"
				elif [[ `echo ${size: -1}` == "x" ]] || [[ `echo ${size: -1}` == "X" ]]
					then				
						height=`identify -ping -format '%h' $1`
						size="$size$height"
				fi

				if [ $extent == "TRUE" ]
					then extent="-background $color -extent $size"
					else extent=""
				fi

				if [ "$rewrite" == "TRUE" ]
					then convert "$file" -gravity $gravity -crop $size$offset $extent "$file"
					else convert "$file" -gravity $gravity -crop $size$offset $extent "${file%.*}_crop.${file##*.}"
				fi

				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
			done)|zenity --progress --title="Обрезка изображений" --auto-close --auto-kill --width=200

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Обрезка изображений"
fi

