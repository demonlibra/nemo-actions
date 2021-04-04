#!/bin/bash

#Дополнительные параметры
pathtoqcad="$HOME/app/qcad" #Путь к папке, содержащей скрипты dwg2bmp, dwg2svg и dwg2pdf

#Проверка наличия программы QCAD
if ! [ -f "$pathtoqcad/dwg2bmp" ] && ! [ -f "$pathtoqcad/dwg2svg" ] && ! [ -f "$pathtoqcad/dwg2pdf" ]
	then
		notify-send -t 10000 --icon=error "Ошибка" "Пакет QCAD отсутствует по указанному пути:\n$pathtoqcad"
		exit 1
fi

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}
ext=${fullpathname##*.}

AAA=`yad --borders=10 --width=300 --title="QCAD" --text="Преобразовать $name в изображение" --text-align=center --form --item-separator="|" --separator="," \
--field=":LBL" --field="Введите ширину:NUM" --field="Введите высоту:NUM" 	  	    --field="Формат:CB"				 --field="Стиль:CB" \
     ""							"2000"			  				   "1000"				  "bmp|jpg|^png|pdf|ppm|svg|tiff"	 "|grayscale|monochrome"`

if [ $? = 0 ] 
	then
		width=$( echo $AAA | awk -F ',' '{print $2}')
		height=$( echo $AAA | awk -F ',' '{print $3}')
		format=$( echo $AAA | awk -F ',' '{print $4}')
		
		style=$( echo $AAA | awk -F ',' '{print $5}')
		if [ $style = "grayscale" ]
			then style_option="-k"
		elif [ $style = "monochrome" ]
			then style_option="-n"
			else style_option=""
		fi
		
		if [ $format = "svg" ]
			then #x-terminal-emulator -t "dwg2svg \"$name\"" -e "sh $pathtoqcad/dwg2svg -f \"$fullpathname\""
					bash "$pathtoqcad/dwg2svg" -f -o "$fullpathname"

			elif [ $format = "pdf" ]
				then #x-terminal-emulator -t "dwg2pdf \"$name\"" -e "sh $pathtoqcad/dwg2pdf -f -a -p \"$width\"x\"$height\" \"$fullpathname\""
						bash "$pathtoqcad/dwg2pdf" -f -a $style_option -p "$width"x"$height" -o "${fullpathname%.*}_$style.pdf" "$fullpathname"

			else #x-terminal-emulator -t "dwg2bmp \"$name\"" -e "sh $pathtoqcad/dwg2bmp -f -b white -x $width -y $height -o \"${fullpathname%.*}.$format\" \"$fullpathname\""
					bash "$pathtoqcad/dwg2bmp" -f -b white $style_option -x $width -y $height -o "${fullpathname%.*}_$style.$format" "$fullpathname"
		fi

	notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование файла $name в формат $format"
fi