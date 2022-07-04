#!/bin/bash

path=$1
path=${path%/*}

if [[ -n `echo $path | grep "//"` ]]
	then
		notify-send -t 10000 -i "error" "Остановлено" "Путь содержит некорректные символы. \nВозможно повреждение файлов!!!\n\nСкопируйте файлы на локальный носитель."
		notify-send -t 10000 -i "error" "Остановлено" "$path"
		exit
fi

parameters=`yad --borders=20 --width=850 --title="Изменение разрешения изображений" \
	--text-align=left --item-separator="|" --separator="," --form \
	--field="800 - Сжатие до 800 пикс. по ширине, с пропорциональным сжатием высоты:LBL" \
	--field="x600 - Сжатие до 600 пикс. по высоте, с пропорциональным сжатием ширины:LBL" \
	--field="800x600 - Изменяем размер изображения в пикселях, с сохранением соотношения сторон:LBL" \
	--field="100×50! - Изменяем размер изображения в пикселях, без сохранения соотношения сторон:LBL" \
	--field=" :LBL"	--field="Разрешение"	--field=" :LBL"	--field="Каталог для сохранения:DIR"	--field="Добавить суфикс к имени файла:CHK" \
		"" "" "" "" ""		"1368"					""						"$path"											"TRUE"`

exit_status=$?

if [ $exit_status = 0 ]
	then
		resolution=$( echo $parameters | awk -F ',' '{print $6}')
		dir=$( echo $parameters | awk -F ',' '{print $8}')
		sufix=$( echo $parameters | awk -F ',' '{print $9}')

		kolfile=$#														# Количество выделенных файлов
		procent=$((100/$kolfile))										# Процентов на каждый файл

		(for file in "$@"
			do
				filename="${file##*/}"
				if [ $sufix == TRUE ]
					then file_out="$dir/${filename%.*}_$resolution.${file##*.}"
					else file_out="$dir/$filename"
				fi

				convert "$file" -resize $resolution "$file_out"

				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
			done)|zenity --progress --title="Изменение разрешения изображений" --auto-close --auto-kill --width=350

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Изменение разрешения изображений"
fi
