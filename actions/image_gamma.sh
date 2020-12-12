#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

#AAA=`zenity --entry --title="Изменить гамму изображений" --width=350 --text="Введите гамму (<1.0 темнее; >1.0 светлее)" --entry-text="0.5"`
AAA=`yad --borders=10 --width=400 --title="Изменить гамму изображений" --text="Введите гамму (темнее - 1.0 + светлее)" --entry --entry-text=1.0 --numeric 0 2 0.1 1`

if [ $? = 0 ]
	then
		AAA=${AAA//","/"."}
		
		kolfile=$#					#Количество выделенных файлов
		procent=$((100/$kolfile))	#Процентов на каждый файл
		
	(for file in "$@"
		do
			convert "$file" -gamma $AAA "$file"
			counter=$(($counter+1))
			progress=$(($progress+$procent))
			echo $progress
			echo "# Обработано $counter из $kolfile"
		done)|zenity --progress --title="Изменение гаммы изображений" --auto-close --auto-kill --width=350
		
		notify-send -t 10000 -i "gtk-ok" "Завершено" "Изменение гаммы изображений на $AAA"
fi