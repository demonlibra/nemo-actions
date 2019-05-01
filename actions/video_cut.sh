#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}
ext=${fullpathname##*.}

duration=`mediainfo --Inform="Video;%Duration/String3%" $fullpathname`
duration=${duration%.*}

AAA=`yad --borders=10 --title="Вырезать фрагмент мультимедиа b" --text="Введите параметры" --form --item-separator="|" --separator="," --field=":LBL" --field="Начало" --field="Конец" --field=":LBL" --field="Формат ввода значений: 75 или 1:15 или 01:15 или 00:01:15:LBL" "" "00:00:00" "$duration" ""`

if [ $? = 0 ]
	then
		start=$(echo $AAA | awk -F ',' '{print $2}')
		finish=$(echo $AAA | awk -F ',' '{print $3}')
		options="-ss $start -to $finish"

		ffmpeg -i "$fullpathname" -y -vcodec copy -acodec copy $options -strict -2 "${fullpathname%.*}_${start/:/-}_${finish/:/-}.$ext"

		notify-send -t 10000 -i "gtk-ok" "Завершено" "Вырезан фрагмент из файла:\n$name"
fi