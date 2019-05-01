#!/bin/bash

first_element=$1														#Первый элементы переданный сценарию
path=${first_element%/*}												#Путь к элементам
timestamp=`date +%Y-%m-%d_%H-%M`										#Имя будущего архива по умолчанию


if [[ -d $first_element ]]												#Если выделен каталог (wetransfer не поддерживает загрузку каталогов)
	then archive_list="^zip|tgz|7z"
	else archive_list="^нет|zip|tgz|7z"
fi

FORM=`yad --borders=10 --width=300 --title="Загрузка на Wetransfer" --text-align=center --text="Укажите параметры" --form --item-separator="|" --separator="," --field=:LBL --field="Упаковать?:CB" --field="Имя архива:" --field="Пароль (только zip и 7z):" "" "$archive_list" "$timestamp"`

if [ $? = 0 ]
	then
		packing=$( echo $FORM | awk -F ',' '{print $2}')
		name_archive=$( echo $FORM | awk -F ',' '{print $3}')
		full_name_archive=/tmp/$name_archive
		password=$( echo $FORM | awk -F ',' '{print $4}')
		
		if [[ "$packing" != "нет" ]]
			then	
				cd "$path"																						#Переходим в каталог с элементами (чтобы не сохранять полные пути)
				
				if [[ "$packing" = "zip" ]]
					then
						if [[ "$password" != "" ]]
							then archive=`zip -r -P "$password" "$full_name_archive".zip "${@##*/}"`			#Создаем архив zip с шифрованием
							else archive=`zip -r "$full_name_archive".zip "${@##*/}"`							#Создаем архив zip без шифрования
						fi
				fi
				
				if [[ "$packing" = "tgz" ]]; then archive=`tar cfvz "$full_name_archive".tgz "${@##*/}"`;fi		#Создаем архив tgz
				
				if [[ "$packing" = "7z" ]] 
					then
						if [[ "$password" != "" ]]											
							then archive=`7z a -mhe=on -p"$password" "$full_name_archive".7z "${@##*/}"`		#Создаем архив 7z с шифрованием
							else archive=`7z a "$full_name_archive".7z "${@##*/}"`								#Создаем архив 7z без шифрования
						fi
				fi
				#notify-send -t 10000 -i "error" "Ошибка загрузки" "$archive"									#Отладка. Вывод результатов архивирования
				
				result=`wtclient upload $full_name_archive.*`
			else 
				result=`wtclient upload "$@"`
		fi
		
		link=`echo $result | awk '{print $5}' `

		if [[ `echo $link | grep "https://we.tl"` ]]															#Проверка удачной загрузки
			then
				echo -n "$link" | xclip -i -selection clipboard													#Запись ссылки в буфер обмена
				notify-send -t 10000 -i "gtk-ok" "Загрузка завершена" "Ссылка скопирована в буфер обмена:\n$link"
			else
				notify-send -t 10000 -i "error" "Ошибка загрузки" "$result"										#Вывод ошибки загрузки
		fi
fi