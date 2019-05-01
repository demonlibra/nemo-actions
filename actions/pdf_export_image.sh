#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

#AAA=`zenity --entry --title="Извлечь изображения из pdf" --width=350 --text="Введите номер страницы" --entry-text="1"`
AAA=`yad --borders=10 --width=500 --title="Извлечь изображения из pdf" --text="Введите параметры" --form --item-separator="|" --separator="," --field=":LBL" --field="Номер первой страницы:NUM" --field="Номер последней страницы:NUM" --field="Количество страниц:NUM" --field="Все страницы:CHK" --field=":LBL" --field="Будет создан каталог::LBL" --field="$path/${name%.*}:LBL" "" "1" "1" "1" FALSE`

if [ $? = 0 ]
	then
		firstpage=$(echo $AAA | awk -F ',' '{print $2}')
		lastpage=$(echo $AAA | awk -F ',' '{print $3}')
		quantity=$(echo $AAA | awk -F ',' '{print $4}')
		all=$(echo $AAA | awk -F ',' '{print $5}')
		
		mkdir "$path/${name%.*}"
		
		if [ $all = "TRUE" ]
			then pdfimages -all -p "$fullpathname" "$path/${name%.*}/export"
		elif [ $quantity != "1" ]
			then pdfimages -all -p -f $firstpage -l $(($firstpage+$quantity-1)) "$fullpathname" "$path/${name%.*}/export"
		elif [ $quantity = "1" ] && [ $lastpage = "1" ]
		    then pdfimages -all -p -f $firstpage -l $firstpage "$fullpathname" "$path/${name%.*}/export"
		elif [ $quantity = "1" ] && [ $lastpage != "1" ]
		    then pdfimages -all -p -f $firstpage -l $lastpage "$fullpathname" "$path/${name%.*}/export"	
		fi
		
		notify-send -t 10000 -i "gtk-ok" "Завершено" "Извлечение изображений из документа:\n$name"
fi
