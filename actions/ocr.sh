#!/bin/bash

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

FORM=`yad --borders=10 --width=300 --title="Распознавание изображения" --text-align=center --text="Укажите параметры" --form --item-separator="|" --separator="," --field=:LBL --field="Выберите программу распознавания:CB" --field="Выберите язык текста:CB" "" "cuneiform|^tesseract" "Русский|Английский|Итальянский|Смешанный"`

if [ $? = 0 ]
	then
	
	ocr=$( echo $FORM | awk -F ',' '{print $2}')
	lang=$( echo $FORM | awk -F ',' '{print $3}')
	
	if [ $ocr = "cuneiform" ]
		then
			if [ "$lang" = "Русский" ]; then lang="rus"
			elif [ "$lang" = "Английский" ]; then lang="eng"
			else lang="ruseng"
			fi
			
			cuneiform -f text -l $lang -o "${fullpathname%.*}-OCR_cuneiform_$lang.txt" "$fullpathname"
			
	elif [ $ocr = "tesseract" ]
		then
			if [ "$lang" = "Русский" ]; then lang="rus"
			elif [ "$lang" = "Английский" ]; then lang="eng"
			elif [ "$lang" = "Итальянский" ]; then lang="ita"
			else lang="rus+eng"
			fi
			
			tesseract "$fullpathname" "${fullpathname%.*}-OCR_tesseract_$lang" -l $lang
	fi
	notify-send -t 10000 -i "gtk-ok" "$ocr" "Завершено распознавание текста в изображении $name"
fi

