#!/bin/bash

#Работу данного сценария обеспечивает утилита ffsend
#https://github.com/timvisee/ffsend

#Скачать утилиту ffsend можно перейдя по следующей ссылке: https://github.com/timvisee/ffsend/releases/latest
#После скачивания необходимо открыть терминал, перейти в папку со скаченным файлов и выполнить:
#cp ffsend* ffsend; chmod +x ffsend; sudo mv ffsend /usr/bin/

first_element=$1														#Первый элементы переданный сценарию
path=${first_element%/*}												#Путь к элементам
timestamp=`date +%Y-%m-%d_%H-%M`										#Имя будущего архива по умолчанию

numberelements=$#														#Количество элементов (путей к файлам и каталогам)
if [[ -d $first_element ]] || [[ $numberelements > 1 ]]					#Если элементов много или выделен каталог(и)
	then archive_list="^zip|tgz|7z"
	else archive_list="^нет|zip|tgz|7z"
fi

FORM=`yad --borders=10 --width=300 --title="Загрузка на Firefox Send" --text-align=center --text="Укажите параметры" --form --item-separator="|" --separator="," --field=:LBL --field="Упаковать?:CB" --field="Имя архива:" --field="Пароль (только zip и 7z):" "" "$archive_list" "$timestamp"`

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

				link=`ffsend -q upload $full_name_archive.*`
			else
				link=`ffsend -q upload "$first_element"`
		fi
		
		if [[ `echo $link | grep "https://send.firefox.com"` ]]													#Проверка удачной загрузки
			then
				echo -n "$link" | xclip -i -selection clipboard
				notify-send -t 10000 -i "gtk-ok" "Загрузка на Firefox Send завершена" "Ссылка скопирована в буфер обмена"
			else
				notify-send -t 10000 -i "error" "Ошибка загрузки на Firefox Send" "$link"
		fi
fi