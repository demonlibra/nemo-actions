#!/bin/bash

AAA=`yad --borders=10 --width=500 --title="Преобразовать PDF в изображения" --text="Введите параметры" --form --item-separator="|" --separator="," --field=":LBL" --field="Разрешение dPI:NUM" --field="Формат:CB" "" "150|50..2400|50" "^png|jpeg|tiff|svg"`

if [ $? = 0 ]
	then
		resolution=$( echo $AAA | awk -F ',' '{print $2}')
		format=$( echo $AAA | awk -F ',' '{print $3}')
		
		for file in "$@"
			do
				pdftocairo -$format -r $resolution "$file" "${file%.*}-$resolution"dpi
		
				#if [ $? = 0 ];	 then notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование страниц файла:\n$name"
				#elif [ $? = 1 ];  then notify-send -t 10000 -i "error" "Ошибка" "Не получилось открыть файл:\n$name"
				#elif [ $? = 2 ];  then notify-send -t 10000 -i "error" "Ошибка" "Не получилось записать в файл:\n$name"
				#elif [ $? = 3 ];  then notify-send -t 10000 -i "error" "Ошибка" "Ограничение доступа в файле:\n$name"
				#elif [ $? = 99 ]; then notify-send -t 10000 -i "error" "Ошибка" "Другая ошибка при обработке файла:\n$name"
				#fi
			done
		
		notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование pdf"
fi