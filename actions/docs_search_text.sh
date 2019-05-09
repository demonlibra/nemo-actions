#!/bin/bash

#Дополнительные параметры

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

PathIndex="/tmp"
FORM=`yad --borders=10 --title="Поиск строк в докуметах - recoll" --form --item-separator="|" --separator="," --field=":LBL" --field="Введите строку для поиска" --field="Вывод:CB" "" "" "zenity|^recoll"`

if [ $? = 0 ]
	then
		text=$( echo $FORM | awk -F ',' '{print $2}')
		out=$( echo $FORM | awk -F ',' '{print $3}')
		
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
