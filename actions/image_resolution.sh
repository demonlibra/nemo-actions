#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

#Проверка установки пакета zenity
if [ -z "`dpkg -l | grep zenity`" ]
	then xfce4-terminal --hide-menubar --geometry=80x15 -T "Установка пакета zenity" -x bash -c "echo \"zenity не установлен\"; echo ; sudo apt install zenity; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`zenity --entry --title="Изменение разрешения изображений" --text="Введите новое значения разрешения. Смотрите примеры ниже.\n\n800 - Сжатие до 800 пикс. по ширине, с пропорциональным сжатием высоты\nx600 - Сжатие до 600 пикс. по высоте, с пропорциональным сжатием ширины\n\n800x600 - Изменяем размер изображения в пикселях, с сохранением соотношения сторон\n100×50! - Изменяем размер изображения в пикселях, без сохранения соотношения сторон" --entry-text="1368"`

if [ $? = 0 ]
	then
		kolfile=$#					#Количество выделенных файлов
		procent=$((100/$kolfile))	#Процентов на каждый файл
		
	(for file in "$@"
		do
			convert "$file" -resize $AAA "${file%.*}_$AAA.${file##*.}"
			counter=$(($counter+1))
			progress=$(($progress+$procent))
			echo $progress
			echo "# Обработано $counter из $kolfile"
		done)|zenity --progress --title="Изменение разрешения изображений" --auto-close --auto-kill --width=350; notify-send -t 10000 -i "gtk-ok" "Завершено" "Изменение разрешения изображений на $AAA"
fi
