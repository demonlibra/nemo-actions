#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

AAA=`yad --borders=10 --width=500 --title="Преобразовать PDF в изображения" --text="Введите параметры" --form --item-separator="|" --separator="," --field=":LBL" --field="Номер первой страницы:NUM" --field="Номер последней страницы:NUM" --field="Количество страниц:NUM" --field="Все страницы:CHK" --field="Разрешение dPI:NUM" --field="Формат:CB" "" "1" "1" "1" FALSE "150|50..2400|50" "^png|jpeg|tiff|svg"`

if [ $? = 0 ]
	then
		firstpage=$( echo $AAA | awk -F ',' '{print $2}')
		lastpage=$( echo $AAA | awk -F ',' '{print $3}')
		quantity=$( echo $AAA | awk -F ',' '{print $4}')
		all=$( echo $AAA | awk -F ',' '{print $5}')
		resolution=$( echo $AAA | awk -F ',' '{print $6}')
		format=$( echo $AAA | awk -F ',' '{print $7}')
		
		if [ $all = "TRUE" ]
			then
				pages=""
		
		elif (( $quantity > "1" )) || [ $quantity = "1" ] && [ $lastpage = "1" ]
			then
				pages="-f $firstpage -l $(($firstpage+$quantity-1))"
		
		elif (( "$lastpage" > "$firstpage" ))
			then
				pages="-f $firstpage -l $lastpage"
			
		else
			pages="-f $firstpage -l $firstpage"
		fi
		
		pdftocairo -$format -r $resolution $pages "$fullpathname" "${fullpathname%.*}-$resolution"dpi
		
		if [ $? = 0 ];	  then notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование страниц файла:\n$name"
		elif [ $? = 1 ];  then notify-send -t 10000 -i "error" "Ошибка" "Не получилось открыть файл:\n$name"
		elif [ $? = 2 ];  then notify-send -t 10000 -i "error" "Ошибка" "Не получилось записать в файл:\n$name"
		elif [ $? = 3 ];  then notify-send -t 10000 -i "error" "Ошибка" "Ограничение доступа в файле:\n$name"
		elif [ $? = 99 ]; then notify-send -t 10000 -i "error" "Ошибка" "Другая ошибка при обработке файла:\n$name"
		fi

fi