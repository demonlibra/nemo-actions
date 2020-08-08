#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

#Проверка установки пакета zenity
if [ -z "`dpkg -l | grep zenity`" ]
	then xfce4-terminal --hide-menubar --geometry=80x15 -T "Установка пакета zenity" -x bash -c "echo \"zenity не установлен\"; echo ; sudo apt install zenity; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

FORM=`yad --borders=10 --width=300 --title="Обрезать изображения" --text-align=center --text="Укажите параметры" --form --item-separator="|" --separator="," --field=:LBL --field="Считать от центра:CHK" --field="Перезаписать файл:CHK" --field="Введите ширину и высоту (ШxВ+X+Y)" "" TRUE FALSE "800x600+0+0"`

center=$( echo $FORM | awk -F ',' '{print $2}')
rewrite=$( echo $FORM | awk -F ',' '{print $3}')
size=$( echo $FORM | awk -F ',' '{print $4}')

if [ $? = 0 ]
	then
		kolfile=$#			#Количество выделенных файлов
		procent=$((100/$kolfile))	#Процентов на каждый файл

	(for file in "$@"
		do
			if [[ $center = "TRUE" ]]
				then
					if [[ $rewrite = "TRUE" ]]
						then convert "$file" -gravity center -crop $size +repage "$file"
						else convert "$file" -gravity center -crop $size +repage "${file%.*}_crop.${file##*.}"
					fi
			fi
			
			if [[ $center = "FALSE" ]]
				then
					if [[ $rewrite = "TRUE" ]]
						then convert "$file" -crop $size +repage "$file"
						else convert "$file" -crop $size +repage "${file%.*}_crop.${file##*.}"
					fi					
			fi
			
			counter=$(($counter+1))
			progress=$(($progress+$procent))
			echo $progress
			echo "# Обработано $counter из $kolfile"
		done)|zenity --progress --title="Обрезка изображений" --auto-close --auto-kill --width=200

	notify-send -t 10000 -i "gtk-ok" "Завершено" "Обрезка изображений"
fi

