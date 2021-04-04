#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}
ext=${fullpathname##*.}

AAA=`yad --borders=10 --title="Раскадровка видео" --text="Введите параметры" --form --item-separator="|" --separator="," --field=":LBL" --field="Формат изображений:CB" --field='Начало (пример 75 или 1:15 или 00:01:15):A' --field="Длительность, секунд (по умолчанию всё)" --field="Через сколько кадров (по умолчанию все)" --field="Создать каталог:CHK" "" "bmp|^jpg|png|tiff" "00:00:00" "" "0" TRUE`

if [ $? = 0 ]
	then
		format=$( echo $AAA | awk -F ',' '{print $2}')
		start=$( echo $AAA | awk -F ',' '{print $3}')
		duration=$( echo $AAA | awk -F ',' '{print $4}')
		skip=$( echo $AAA | awk -F ',' '{print $5}')
		folder=$( echo $AAA | awk -F ',' '{print $6}')
		
		if [ "$duration" != "" ]
			then option1="-t $duration"
		fi
		
		if [ "$skip" != "" ]
			then option2="-vf \"select=not(mod(n\,$skip))\" -vsync vfr"
		fi
		
		if [ "$folder" = TRUE ]
			then
				new_path="${fullpathname%.*}"
				mkdir "$new_path"
			else
				new_path="$path"
		fi
		
		x-terminal-emulator --wait --geometry 100x20 --hide-menubar -t "Раскадровка файла $name" -e "ffmpeg -hide_banner -ss $start $option1 -i \"$fullpathname\" $option2 \"$new_path/${name%.*}-%3d.$format\""
		
		notify-send -t 10000 -i "gtk-ok" "Завершено" "Раскадровка завершена:\n$name"
fi