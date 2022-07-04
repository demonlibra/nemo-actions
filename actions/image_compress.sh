#!/bin/bash

path=$1
path=${path%/*}

if [[ -n `echo $path | grep "//"` ]]
	then
		notify-send -t 10000 -i "error" "Остановлено" "Путь содержит некорректные символы. \nВозможно повреждение файлов!!!\n\nСкопируйте файлы на локальный носитель."
		notify-send -t 10000 -i "error" "Остановлено" "$path"
		exit
fi

parameters=`yad --borders=20 --width=500 --title="Сжатие изображений" \
	--text-align=center --item-separator="|" --form \
	--field="Процент сжатия:SCL"	--field=" :LBL"		--field="Каталог для сохранения:DIR"	--field="Добавить суфикс к имени файла:CHK"\
				"85"						""						"$path"									"FALSE"			`
exit_status=$?

if [ $exit_status = 0 ]
	then
		quality=$( echo $parameters | awk -F '|' '{print $1}')
		dir=$( echo $parameters | awk -F '|' '{print $3}')
		sufix=$( echo $parameters | awk -F '|' '{print $4}')

		kolfile=$#														#Количество выделенных файлов
		procent=$((100/$kolfile))										#Процентов на каждый файл

		(for file in "$@"
			do
				filename="${file##*/}"
				if [ $sufix == TRUE ]
					then file_out="$dir/${filename%.*}_$quality.${file##*.}"
					else file_out="$dir/$filename"
				fi

				convert "$file" -quality $quality "$file_out"

				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
			done)|zenity --progress --title="Сжатие изображений" --auto-close --auto-kill --width=250

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Сжатие изображений"
fi
