#!/bin/bash

path=$1
path=${path%/*}

parameters=`yad --borders=20 --width=500 --title="Изменить гамму изображений" \
	--text-align=center --item-separator="|" --separator="!" --form \
	--field="Гамма:NUM"		--field=" :LBL"		--field="Каталог для сохранения:DIR"	--field="Добавить суфикс к имени файла:CHK" \
	"1.0|0.1..2.5|0.1|1"		""								"$path"									TRUE`

exit_status=$?

if [ $exit_status = 0 ]
	then
		gamma=$( echo $parameters | awk -F '!' '{print $1}')
		gamma=${gamma/","/"."}

		dir=$( echo $parameters | awk -F '!' '{print $3}')
		sufix=$( echo $parameters | awk -F '!' '{print $4}')

		kolfile=$#														# Количество выделенных файлов
		procent=$((100/$kolfile))										# Процентов на каждый файл

		(for file in "$@"
			do
				filename="${file##*/}"
				if [ $sufix == TRUE ]
					then file_out="$dir/${filename%.*}_$gamma.${file##*.}"
					else file_out="$dir/$filename"
				fi

				convert "$file" -gamma $gamma "$file_out"

				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
			done)|zenity --progress --title="Изменение гаммы изображений" --auto-close --auto-kill --width=350

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Изменение гаммы изображений"
fi
