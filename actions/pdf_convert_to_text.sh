#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

#Проверка установки пакета yad
if [ -z "`dpkg -l | grep yad`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета yad" -- bash -c "echo \"yad не установлен\"; echo ; sudo apt install yad; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`yad --borders=10 --title="pdftotext" --text="Преобразовать PDF в текст" --text-align=center --form --separator="," --item-separator="|" --field=:LBL --field="Номер первой страницы" --field="Номер последней страницы (по умолчанию одна)" "1" ""`

if [ $? = 0 ]
	then
		firstpage=$( echo $AAA | awk -F ',' '{print $2}')
		pages=" -f "$firstpage
		lastpage=$( echo $AAA | awk -F ',' '{print $3}')

		if [ -n "$lastpage" ]
			then pages=$pages" -l "$lastpage
			else pages=$pages" -l "$firstpage
		fi

		pdftotext $pages "$fullpathname" "${fullpathname%.*}.txt"
		notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование страниц $firstpage-$lastpage файла:\n$name"
fi