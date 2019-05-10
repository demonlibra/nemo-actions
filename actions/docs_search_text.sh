#!/bin/bash

#Дополнительные параметры

temp_index_recoll="/tmp"				#Каталог для временного индекса. Хранится только до перезагрузки ПК.
home_index_recoll="$HOME/.recoll"		#Каталог для постоянного индекса

FORM=`yad --borders=10 --title="Поиск строк в докуметах" --form --item-separator="|" --separator="," --field=":LBL" --field="Введите строку для поиска" --field="Программа для поиска:CB" --field="Вывод результата:CB" --field="Сохранить индекс recoll после перезагрузки ПК:CB" "" "" "^recoll|pdfgrep" "zenity|^recoll" "^Да|Нет"`

if [ $? = 0 ]
	then
		text=$( echo $FORM | awk -F ',' '{print $2}')
		tool=$( echo $FORM | awk -F ',' '{print $3}')
		out=$( echo $FORM | awk -F ',' '{print $4}')
		save_index_recoll=$( echo $FORM | awk -F ',' '{print $5}')
		
		if [[ "$save_index_recoll" = "Да" ]]
			then path_index_recoll=$home_index_recoll
			else path_index_recoll=$temp_index_recoll
		fi
		
		if [ "$tool" = "recoll" ]
			then
				find "$@" -type f \( -iname "*.pdf" -or -iname "*.doc" -or -iname "*.docx" -or -iname "*.xls" -or -iname "*.xlsx" -or -iname "*.txt" -or -iname "*.rtf" -or -iname "*.odt" \) -print | recollindex -c $path_index_recoll -i -e -f
				
				if [ $out = "zenity" ]
					then 
						result=`recoll -c $path_index_recoll -t -b -q "$text"`
						zenity --info --width=1000 --title="Результат поиска в PDF - recoll" --text="$result"
		
					else result=`recoll -c $path_index_recoll -q "$text"`
				fi
			
		else
			result=`find "$@" -type f -iname "*.pdf" -print0 | xargs -0 pdfgrep -H -n --ignore-case "$text"`
			zenity --info --width=1000 --title="Результат поиска в PDF - pdfgrep" --text="$result"
		fi
		
fi
