#!/bin/bash

fullpathname="$1"
name=${fullpathname##*/}
path=${fullpathname%/*}

namenoext=${name%.*}
ext=${name##*.}

if [ $ext = "png" ] || [ $ext = "PNG" ]
	then
		extext="^png|jpg|tiff|bmp"
	else
		extext="^jpg|png|tiff|bmp"
fi

AAA=`yad --borders=10 --width=600 --title="Объединить изображений" --text="Введите параметры" --form --item-separator="|" --separator="," --field=":LBL" --field="Направление:CB" --field="Отступ" --field="Имя файла" --field="Формат:CB" "" "^вертикально|горизонтально" "0" " $namenoext"_montage "$extext"`

if [ $? = 0 ]
	then
		direction=$(echo $AAA | awk -F ',' '{print $2}')
		space=$(echo $AAA | awk -F ',' '{print $3}')
		newname=$(echo $AAA | awk -F ',' '{print $4}')
		ext=$(echo $AAA | awk -F ',' '{print $5}')

		kolfile=$#					#Количество выделенных файлов
		
		if [ $direction = "вертикально" ]
			then montage -geometry +0+$space -tile 1x$kolfile "$@" "$path/$newname.$ext"
		fi
		
		if [ $direction = "горизонтально" ]
			then montage -geometry +$space+0 -tile "$kolfile"x1 "$@" "$path/$newname.$ext"
		fi
fi
