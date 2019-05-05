#!/bin/bash

#Проверка установки пакета tesseract
if [ -z "`dpkg -l | grep tesseract`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета tesseract" -- bash -c "echo \"tesseracr не установлен\"; echo ; sudo apt install tesseract-ocr tesseract-ocr-rus; echo ; echo ------------------ ; echo ; echo \"Установка завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

AAA=`zenity --list --checklist --title="Распознавание изображения tesseract" --text="Выберите язык" --column="Выбор" --column="Язык распознавания" --column="Описание" TRUE rus "Русский" FALSE eng "Английский" --ok-label="Распознать" --cancel-label="Отмена" --width=400 --height=170 --separator="+"`

if [ $? = 0 ]
	then
		tesseract "$fullpathname" "${fullpathname%.*}-OCR_tesseract" -l $AAA
		notify-send -t 10000 -i "gtk-ok" "tesseract" "Завершено распознавание текста в изображении:\n$name\n${fullpathname%.*}"
fi