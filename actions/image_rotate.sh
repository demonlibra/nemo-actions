#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

#Проверка установки пакета zenity
if [ -z "`dpkg -l | grep zenity`" ]
	then xfce4-terminal --hide-menubar --geometry=80x15 -T "Установка пакета zenity" -x bash -c "echo \"zenity не установлен\"; echo ; sudo apt install zenity; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`zenity --entry --title="Поворот изображений" --width=350 --text="Введите угол поворота (+ по ЧС, - против ЧС)"`

if [ $? = 0 ]
	then
		kolfile=$#					#Количество выделенных файлов
		procent=$((100/$kolfile))	#Процентов на каждый файл

	(for file in "$@"
		do
			convert "$file" -rotate $AAA "$file"
			counter=$(($counter+1))
			progress=$(($progress+$procent))
			echo $progress
			echo "# Обработано $counter из $kolfile"
		done)|zenity --progress --title="Поворот изображений" --auto-close --auto-kill --width=200

	notify-send -t 10000 -i "gtk-ok" "Завершено" "Поворот изображений на $AAA градусов"
fi