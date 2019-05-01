#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

if [[ -n `echo $fullpathname | grep "//"` ]]
	then
		notify-send -t 10000 -i "error" "Остановлено" "Путь содержит некорректные символы. \nВозможно повреждение файлов!!!\n\nСкопируйте файлы на локальный носитель."
		notify-send -t 10000 -i "error" "Остановлено" "$fullpathname"
		exit
fi

AAA=`yad --borders=10 --width=300 --title="Сжатие изображений" --text="Процент сжатия" --scale --value=85 --max-value=100 --step=1 --inc-buttons`

if [ $? = 0 ]
	then
		kolfile=$#					#Количество выделенных файлов
		procent=$((100/$kolfile))	#Процентов на каждый файл

		(for file in "$@"
			do
				convert "$file" -quality $AAA "$file"
				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
			done)|zenity --progress --title="Сжатие изображений" --auto-close --auto-kill --width=250

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Сжатие изображений"
fi