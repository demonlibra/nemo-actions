#!/bin/bash

fullpathname=$1
name=${fullpathname##*/}
path=${fullpathname%/*}
ext=${fullpathname##*.}

if [ $ext = "doc" ] || [ $ext = "docx" ] || [ $ext = "odt" ] || [ $ext = "rtf" ] || [ $ext = "txt" ]
	then
		#Конвертирование текстовых документов
		lowriter --convert-to pdf "$@" --outdir "$path"
	else
		#Конвертирование электронных таблиц
		localc --convert-to pdf "$@" --outdir "$path"
fi

notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование в PDF документа:\n\n$name"