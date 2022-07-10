#!/bin/bash

path=$1
path=${path%/*}

parameters=`yad --borders=20 --width=500 --title="Конвертирование изображений" \
	--text-align=center --item-separator="|" --separator="," --form \
	--field="Формат:CB"				--field="Каталог для сохранения:DIR" \
	"^jpg|png|bmp|tiff|gif|pdf"					"$path"`

exit_status=$?

if [ $exit_status = 0 ]
	then

		format=$( echo $parameters | awk -F ',' '{print $1}')
		dir=$( echo $parameters | awk -F ',' '{print $2}')
		
		kolfile=$#														# Количество выделенных файлов
		procent=$((100/$kolfile))										# Процентов на каждый файл
		
		(for file in "$@"
			do
				mogrify -format $format -path "$dir" "$file"
				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
			done)|zenity --progress --title="Конвертирование изображений в формат $format" --auto-close --auto-kill --width=350

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Конвертирование изображений в формат $format"
fi
