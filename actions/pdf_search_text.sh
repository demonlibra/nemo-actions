#!/bin/bash

text=`yad --borders=10 --title="Поиск строки в PDF - pdfgrep" --entry-label="Введите строку для поиска" --text="" --text-align=center --entry`

if [ $? = 0 ]
	then
        
        #result=`pdfgrep -H -n --ignore-case $text "$@"`
		result=`find "$@" -type f -iname "*.pdf" -print0 | xargs -0 pdfgrep -H -n --ignore-case "$text"`
		
		zenity --info --width=1000 --title="Результат поиска в PDF" --text="$result" 

fi
