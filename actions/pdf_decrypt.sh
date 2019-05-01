#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

AAA=`zenity --entry --title="Снять защиту с PDF" --text="Введите для сохранения новое имя файла без защиты" --entry-text="${name%.*}_decrypt" --ok-label="Выполнить" --cancel-label="Отмена" --width=350`

if [ $? = 0 ]
	then
		qpdf --decrypt "$fullpathname" "$path/$AAA.pdf"
		notify-send -t 10000 -i "gtk-ok" "Завершено" "Снятие защиты с файла:\n$name\n\nСоздан файл:\n$path/$AAA.pdf"
fi