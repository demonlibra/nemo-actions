#!/bin/bash

path=$1
path=${path%/*}

if [[ -n `echo $path | grep "//"` ]]
	then
		notify-send -t 10000 -i "error" "Остановлено" "Путь содержит некорректные символы. \nВозможно повреждение файлов!!!\n\nСкопируйте файлы на локальный носитель."
		notify-send -t 10000 -i "error" "Остановлено" "$path"
		exit
fi

parameters=`yad --borders=20 --width=350 --title="Поворот изображений" \
	--text-align=center --item-separator="|" --separator="!" --form \
	--field="Угол поворота (+ по часовой стрелке):NUM"	--field=" :LBL"		--field="Каталог для сохранения:DIR"	--field="Добавить суфикс к имени файла:CHK" \
						"90|-360..360|1|1"					""								"$path"									"TRUE"`

exit_status=$?

if [ $exit_status = 0 ]
	then
		angle=$( echo $parameters | awk -F '!' '{print $1}')
		angle=${angle/","/"."}

		dir=$( echo $parameters | awk -F '!' '{print $3}')
		sufix=$( echo $parameters | awk -F '!' '{print $4}')

		kolfile=$#														# Количество выделенных файлов
		procent=$((100/$kolfile))										# Процентов на каждый файл

		(for file in "$@"
			do
				filename="${file##*/}"
				if [ $sufix == TRUE ]
					then file_out="$dir/${filename%.*}_$angle.${file##*.}"
					else file_out="$dir/$filename"
				fi

				convert "$file" -rotate "$angle" "$file_out"

				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
			done)|zenity --progress --title="Поворот изображений" --auto-close --auto-kill --width=200

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Поворот изображений на $angle градусов"
fi
