#!/bin/bash

fullpathname=$@				#Получаем полный путь к файлу
name=${fullpathname##*/}	#Получаем часть от самого правого слеша до конца строки (получаем имя файла и расширение)
name=${name//" "/"_"}		#Заменяем пробелы нижними подчеркиваниями

#Загрузка файла на Transfer.sh
link=`curl --upload-file "$fullpathname" "https://transfer.sh/$name"`
status=$?

if [ $status = 0 ]
	then 
		#Копирование ссылки в буфер обмена
		echo -n "$link" | xclip -i -selection clipboard

		notify-send -t 10000 -i "gtk-ok" "Загрузка завершена" "Ссылка скопирована в буфер обмена:\n$link"
	else
		notify-send -t 10000 -i "error" "Transfer.sh" "При загрузке возникла ошибка: $status"
fi