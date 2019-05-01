#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

AAA=`zenity --list --radiolist --title="Конвертирование изображений" --text="Выберите формат" --column="Выбор" --column="Формат" TRUE jpg FALSE png FALSE bmp FALSE tiff FALSE gif FALSE pdf --ok-label="Конвертировать" --cancel-label="Отмена" --width=300 --height=240`

if [ $? = 0 ]
	then
		kolfile=$#					#Количество выделенных файлов
		procent=$((100/$kolfile))	#Процентов на каждый файл
		
		(for file in "$@"
			do
				mogrify -format $AAA "$file"
				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
			done)|zenity --progress --title="Конвертирование изображений в формат $AAA" --auto-close --auto-kill --width=350

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Конвертирование изображений в формат $AAA"
fi