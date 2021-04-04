#!/bin/bash

#Дополнительные параметры
temppath="/tmp/pdfunite"	#Путь для временной папки. Сюда будут скопированы все выделенные файлы.

fullpathname=$1
name=${fullpathname##*/}
path=${fullpathname%/*}

#Проверка установки пакета yad
if [ -z "`dpkg -l | grep yad`" ]
	then x-terminal-emulator --hide-menubar --geometry=80x15 -t "Установка пакета yad" -e bash -c "echo \"yad не установлен\"; echo ; sudo apt install yad; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

#Получаем список имен объединяемых файлов без путей
for file in "$@"
	do	oldnames=$oldnames"${file##*/}|"
done

#Форма ввода нового имени файла
AAA=`yad --borders=10 --item-separator="|" --separator="," --title="Объединить файлы в PDF" --text="Введите имя конечного файла с расширением\nили выберите из списка" --text-align=center --width=350 --form --field=:LBL --field=":CBE" "" "$oldnames"`

#Проверка существования введенного имени
newname=$( echo $AAA | awk -F ',' '{print $2}')
if [ -f $path/$newname ]
	then newname="United_$newname"
fi

if [ $? = 0 ]
	then
		cd "$path"
		pdfunite "$@" "$newname"
		notify-send -t 10000 -i "gtk-ok" "Завершено объединение файлов PDF" "Результат объединения сохранен в файл:\n\n$newname"
fi