#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}
ext=${fullpathname##*.}

#Проверка установки пакета yad
if [ -z "`dpkg -l | grep yad`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета yad" -- bash -c "echo \"yad не установлен\"; echo ; sudo apt install yad; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`yad --title="Преобразование ps" --width=350 --borders=10 --form --separator="," --form --field=:LBL --field="Конвертировать в PDF:CHK" --field="Конвертировать в PNG:CHK" --field="Разрешение файла PNG:NUM" "" "TRUE" "FALSE" "600"`

if [ $? = 0 ]
	then
		pdf=$( echo $AAA | awk -F ',' '{print $2}')
		if [ $pdf = "TRUE" ]
			then 
				ps2pdf "$fullpathname" "${fullpathname%.*}.pdf"
				notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование в pdf файла:\n$name"
		fi

		png=$( echo $AAA | awk -F ',' '{print $3}')
		resolution=$( echo $AAA | awk -F ',' '{print $4}')
		echo "res $resolution"
		if [ $png = "TRUE" ]
			then
				gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -dGraphicsAlphaBits=4 -r$resolution -sOutputFile="${fullpathname%.*}_$resolution".png "$fullpathname"
				notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование в png файла:\n$name"
		fi
fi