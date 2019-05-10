#!/bin/bash

#Дополнительные параметры

temp_index="/tmp"				#Каталог для временного индекса. Хранится только до перезагрузки ПК.
home_index="$HOME/.recoll"		#Каталог для постоянного индекса

FORM=`yad --borders=10 --title="Поиск строк в докуметах - recoll" --form --item-separator="|" --separator="," --field=":LBL" --field="Введите строку для поиска" --field="Вывод результата:CB" --field="Сохранить индекс после перезагрузки ПК:CB" "" "" "zenity|^recoll" "^Да|Нет"`

if [ $? = 0 ]
	then
		text=$( echo $FORM | awk -F ',' '{print $2}')
		out=$( echo $FORM | awk -F ',' '{print $3}')
		save_index=$( echo $FORM | awk -F ',' '{print $4}')
		
		if [[ "$save_index" = "Да" ]]
			then PathIndex=$home_index
			else PathIndex=$temp_index
		fi
		
		find "$@" -type f \( -iname "*.pdf" -or -iname "*.doc" -or -iname "*.docx" -or -iname "*.xls" -or -iname "*.xlsx" -or -iname "*.txt" -or -iname "*.rtf" -or -iname "*.odt" \) -print | recollindex -c $PathIndex -i -e -f
				
		if [ $out = "zenity" ]
			then 
				result=`recoll -c $PathIndex -t -b -q "$text"`
				zenity --info --width=1000 --title="Результат поиска в PDF" --text="$result"
		
		elif [ $out = "recoll" ]
			then 
				result=`recoll -c $PathIndex -q "$text"`
		fi
fi
