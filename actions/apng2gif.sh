#!/bin/bash

path=$1
path=${path%/*}

parameters=`yad --borders=20 --width=500 --title="apng2gif" \
	--text-align=center --item-separator="|" --separator="!" --form \
	--field="Фон:CLR"	--field="Прозрачность:NUM"	--field="Каталог для сохранения:DIR" \
			"#FFFFFF"			"128|0..155|1|0"				"$path"`

exit_status=$?

if [ $exit_status = 0 ]
	then

		color=$( echo $parameters | awk -F '|' '{print $1}')
		transparency=$( echo $parameters | awk -F '|' '{print $2}')
		dir=$( echo $parameters | awk -F '|' '{print $3}')
		
		kolfile=$#					#Количество выделенных файлов
		procent=$((100/$kolfile))	#Процентов на каждый файл
		
		(for file in "$@"
			do
				apng2gif "$file" "${file%.*}.gif" "/b #$color" "/t $transparency"

				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
			done)|zenity --progress --title="apng2gif" --auto-close --auto-kill --width=350

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Конвертирование apng2gif"
fi
