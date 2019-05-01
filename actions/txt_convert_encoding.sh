#!/bin/bash

encoding1=`enca -i "$1"`
identical="TRUE"
encoding_default="^UTF-8|CP1251"
text="Выделенные файлы имеют следующую кодировку:\n\n"

for file in "$@"									#Перебор всех файлов и определение кодировки
	do
		name=${file##*/}							#Имя файла без пути
		encoding=`enca -i "$file"`					#Кодировка файла
		
		if [[ "$encoding1" != $encoding ]]			#Одинаковые ли кодировки?
			then identical="FALSE"
		fi

		text="$text$encoding\t\t$name\n"			#Текст для формы, если кодировки разные
done

if [[ "$identical" = "TRUE" ]]						#Параметры для формы, если кодировки одинаковые
	then
		text="У всех файлов кодировка:\t$encoding1"
		
		if [[ "$encoding1" = "UTF-8" ]]				#Назначение кодировки по умолчанию 
			then encoding_default="UTF-8|^CP1251"
			else encoding_default="^UTF-8|CP1251"
		fi
fi

FORM=`yad --borders=10 --width=400 --title="Изменить кодировку текстовых файлов" --text="$text" --text-align=left --form --separator="," --item-separator="|" --form --field=:LBL --field="Преобразовать в:CB" "" "$encoding_default"`

if [ $? = 0 ]
	then
		encoding=$( echo $FORM | awk -F ',' '{print $2}')
		
		enconv -x $encoding "$@"
fi