#!/bin/bash

#Проверка установки пакета cuneiform
if [ -z "`dpkg -l | grep cuneiform`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета cuneiform" -- bash -c "echo \"cuneiform не установлен\"; echo ; sudo apt install cuneiform; echo ; echo ------------------ ; echo ; echo \"Установка завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

AAA=`zenity --list --radiolist --title="Распознавание изображения cuneiform" --text="Выберите язык" --column="Выбор" --column="Язык распознавания" --column="Описание" TRUE rus "Русский" FALSE eng "Английский" FALSE ruseng "Русский и Английский" --ok-label="Распознать" --cancel-label="Отмена" --width=400 --height=195`

if [ $? = 0 ]
	then
		cuneiform -f text -l $AAA -o "${fullpathname%.*}-OCR_cuneiform.txt" "$fullpathname"
		notify-send -t 10000 -i "gtk-ok" "cuneiform" "Завершено распознавание текста в изображении:\n%n"
fi