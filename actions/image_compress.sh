#!/bin/bash

path=${1%/*}
ext=${1##*.}

if [[ -n `echo $path | grep "//"` ]]
	then
		notify-send -t 10000 -i "error" "Остановлено" "Путь содержит некорректные символы. \nВозможно повреждение файлов!!!\n\nСкопируйте файлы на локальный носитель."
		notify-send -t 10000 -i "error" "Остановлено" "$path"
		exit
fi

if [ "$ext" == "png" ] || [ "$ext" == "PNG" ]
	then
		parameters=`yad --borders=20 --width=500 --title="Сжатие изображений PNG" \
			--text-align=center --item-separator="|" --separator="," --form \
			--field="Процент сжатия:SCL"	--field=" :LBL"		--field="Каталог для сохранения:DIR"	--field="Преобразовать в png8:CHK"	--field="Добавить суфикс к имени файла:CHK" \
						"85"						""						"$path"										FALSE							"FALSE"`
	else
		parameters=`yad --borders=20 --width=500 --title="Сжатие изображений" \
			--text-align=center --item-separator="|" --separator="," --form \
			--field="Процент сжатия:SCL"	--field=" :LBL"		--field="Каталог для сохранения:DIR"				--field=" :LBL"				--field="Добавить суфикс к имени файла:CHK" \
						"85"						""						"$path"																		"FALSE"`
fi

exit_status=$?

if [ $exit_status = 0 ]
	then
		quality=$( echo $parameters | awk -F ',' '{print $1}')
		dir=$( echo $parameters | awk -F ',' '{print $3}')

		png8=$( echo $parameters | awk -F ',' '{print $4}')
		if [ $png8 == TRUE ]
			then png8="png8:"
			else png8=""
		fi

		sufix=$( echo $parameters | awk -F ',' '{print $5}')

		kolfile=$#														# Количество выделенных файлов
		procent=$((100/$kolfile))										# Процентов на каждый файл

		(for file in "$@"
			do
				filename="${file##*/}"
				if [ $sufix == TRUE ]
					then file_out="$dir/${filename%.*}_$quality.${file##*.}"
					else file_out="$dir/$filename"
				fi

				convert "$file" -quality $quality "$png8$file_out"

				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
			done)|zenity --progress --title="Сжатие изображений" --auto-close --auto-kill --width=250

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Сжатие изображений"
fi
