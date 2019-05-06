#!/bin/bash

Type_Hash=`zenity --list --title="Вычисление хеш-сумм" --text="Что вычислить?" \
	--radiolist --column "" --column "Функция" \
	TRUE "md5" \
	FALSE "sha256" \
	FALSE "sha1" \
	FALSE "sha224" \
	FALSE "sha384" \
	FALSE "sha512" \
	 --height=270 \
	 --width=220`

if [ $? = 0 ]
    then
    	for file in "$@"
        	do
				hash=$($Type_Hash"sum" "$file" | awk '{print $1}')
				name=${file##*/}
				
            	output=$output$hash"\t\t""$name""\n"
		done

    zenity --width=600 --info --title="$Type_Hash" --text="$output"
fi
