#!/bin/bash

FORM=`yad --borders=10 --width=300 --title="Распознавание изображения" --text-align=center --text="Укажите параметры" --form --item-separator="|" --separator="," --field=:LBL --field="Выберите программу распознавания:CB" --field="Выберите язык текста:CB" "" "cuneiform|^tesseract" "Русский|Английский|^Итальянский|Смешанный"`

if [ $? = 0 ]
	then
	
	ocr=$( echo $FORM | awk -F ',' '{print $2}')
	language=$( echo $FORM | awk -F ',' '{print $3}')

	(for file in "$@"
		do
			if [ $ocr = "cuneiform" ]
				then
					if [ "$language" = "Русский" ]; then lang="rus"
					elif [ "$language" = "Английский" ]; then lang="eng"
					elif [ "$language" = "Итальянский" ]; then lang="ita"
					else language="ruseng"
					fi

					cuneiform -f text -l $lang -o "${file%.*}-OCR_cuneiform_$lang.txt" "$file"

			elif [ $ocr = "tesseract" ]
				then
					if [ "$language" = "Русский" ]; then lang="rus"
					elif [ "$language" = "Английский" ]; then lang="eng"
					elif [ "$language" = "Итальянский" ]; then lang="ita"
					else language="rus+eng"
					fi

					tesseract "$file" "${file%.*}-OCR_tesseract_$lang" -l $lang
			fi
		done)|zenity --progress --title="Распознавание текста" --auto-close --auto-kill --width=250
	
	notify-send -t 10000 -i "gtk-ok" "$ocr" "Завершено распознавание текста в изображениях"
fi

