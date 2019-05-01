#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

#Проверка установки пакета zenity
if [ -z "`dpkg -l | grep zenity`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета zenity" -- bash -c "echo \"zenity не установлен\"; echo ; sudo apt install zenity; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`zenity --list --radiolist --title="Сжатие PDF" --text="Выберите качество изображений" --column="Выбор" --column="Качество" --column="Описание" FALSE screen "для просмотра на экране, 72 dpi" TRUE ebook "низкое качество, 150 dpi" FALSE printer "высокое качество, 300 dpi images" FALSE prepress "высокое качество, сохранение цвета, 300 dpi" FALSE default "почти как на экране" --ok-label="Обработать" --cancel-label="Отмена" --width=440 --height=211`

if [ $? = 0 ]
	then
		gs -dNOPAUSE  -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/$AAA -sOutputFile="${fullpathname%.*}-$AAA.pdf" "$fullpathname"
		notify-send -t 10000 -i "gtk-ok" "Завершено" "Сжатие PDF:\n$name\n\nРезультат сохранен в файл:\n${fullpathname%.*}-$AAA.pdf"
fi