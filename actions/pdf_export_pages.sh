#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

#Проверка установки пакета zenity
if [ -z "`dpkg -l | grep zenity`" ]
	then x-terminal-emulator --hide-menubar --geometry=80x15 -t "Установка пакета zenity" -e bash -c "echo \"zenity не установлен\"; echo ; sudo apt install zenity; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`zenity --entry --title="Извлечь страницы из PDF" --width=350 --text="Введите номера страниц (пример 1: 1-3,5,6) (пример 2: 5-z)" --entry-text="1"`

if [ $? = 0 ]
	then
		qpdf --pages "$fullpathname" $AAA -- "$fullpathname" "${fullpathname%.*}_pages_$AAA.pdf"
		notify-send -t 10000 -i "gtk-ok" "Завершено" "Извлечение страниц из документа:\n$name"
fi