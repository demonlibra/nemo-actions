#!/bin/bash

#Дополнительные параметры

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

text=`yad --borders=10 --title="Поиск строки в PDF" --entry-label="Введите строку для поиска" --text="" --text-align=center --entry`

if [ $? = 0 ]
	then
        
        for file in "$@"
            do
                #temp=`pdftotext "$file" - | grep --ignore-case --with-filename --label="$file" --color "$text"`
                #result=$result$temp"\n"
				result=`pdfgrep --ignore-case $text "$@"`
		done

		zenity --info --width=1000 --title="Результат поиска в PDF" --text="$result"

fi
