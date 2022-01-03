#!/bin/bash

ip="192.168.3.36"

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

kolfile=$#														#Количество выделенных файлов
procent=$((100/$kolfile))										#Процентов на каждый файл

if [[ "$kolfile" -gt 1 ]]
	then
		AAA=`yad --borders=10 --width=300 --title="DUET" --text="Отправка файлов на SD-карту" --text-align=center --form --item-separator="|" \
			--field=:LBL --field="IP адрес" "" "$ip"`
	else
		AAA=`yad --borders=10 --width=300 --title="DUET" --text="Отправка файлов на SD-карту" --text-align=center --form --item-separator="|" \
			--field=:LBL --field="IP адрес" --field="Выполнить после загрузки:CHK" "" "$ip" TRUE`
fi

if [ $? = 0 ]
	then
		ip=$( echo $AAA | awk -F '|' '{print $2}')
		print=$( echo $AAA | awk -F '|' '{print $3}')

		(for file in "$@"
			do
				name=${file##*/}										#Убираем путь
				name=${name// /%20}										#Заменяем пробелы кодом %20
				
				curl --data-binary @"$file" "http://$ip/rr_upload?name=gcodes/$name"
				
				counter=$(($counter+1))
				progress=$(($progress+$procent))
				echo $progress
				echo "# Обработано $counter из $kolfile"
				
				if [ "$print" == "TRUE" ]
					then curl "http://$ip/rr_gcode?gcode=M32$name"
				fi
			done)|zenity --progress --title="DUET" --auto-close --auto-kill --width=250



		notify-send -t 10000 -i "gtk-ok" "Завершено" "Отправка файлов в DUET"
fi
