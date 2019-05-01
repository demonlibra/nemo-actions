#!/bin/bash

#Можно использовать для объединения программу convert, но при этом страницы PDF будут преобразованы в изображения.
#При этом херится оригинал, снижается качество и увиличивается размер конечного файла.
#Поэтому отдельно конвертируем изображения в PDF и скидываем все во временную папку.

#Указываем путь для временной папки. Сюда будут скопированы все выделенные файлы.
temppath="/tmp/pdfunite"
files=$@
fullpathname=$1
name=${fullpathname##*/}
path=${fullpathname%/*}

encrypted="FALSE"
use_temp_path="FALSE"

#Получаем список имен объединяемых файлов без путей
for file in "$@"
	do
		namewithext=${file##*/}
		namewithoutext=${namewithext%.*}
		oldnames=$oldnames$namewithoutext"|"
		
		#Проверяем были ли выделены изображения
		if [ ${file##*.} != "pdf" ] && [ ${file##*.} != "PDF" ]
			then use_temp_path="TRUE"
		fi

		#Проверяем присутствуют ли зашифрованные pdf
		if [ ${file##*.} = "pdf" ] || [ ${file##*.} = "PDF" ]
			then
				if [[ `pqdf --show-encryptin $file` != "File is not encrypted" ]]
					then
						encrypted="TRUE"
						use_temp_path="TRUE"
		fi
				fi
done

#Форма ввода нового имени файла
AAA=`yad --borders=10 --item-separator="|" --separator="," --title="Объединить файлы в PDF" --text="Введите имя конечного файла без расширения\nили выберите из списка" --text-align=center --width=350 --form --field=:LBL --field=":CBE" "" "$oldnames"`

if [ $? = 0 ]
	then
		newname=$( echo $AAA | awk -F ',' '{print $2}')".pdf"

		#Проверка существования файла с введенным именем
		if [ -f "$path/$newname" ]
			then newname="United_$newname"
		fi

		#Выполнить, если в выделенных файлах присутствуют изображения или pdf зашифрованы
		if [ $use_temp_path = "TRUE" ] || [ $encrypted = "TRUE" ]
			then
				#Подготовка временной папки
				rm -rf $temppath
				mkdir $temppath

				for file in "$@"
					do
						name=${file##*/}
						namenoext=${name%.*}
						ext=${file##*.}

						#Перенос файлов во временную папку
						if [ $ext = "pdf" ] || [ $ext = "PDF" ] && [ $encrypted = "TRUE" ]
								then
									qpdf --decrypt "$file" "$temppath/$name.pdf"
							elif [ $ext = "pdf" ] || [ $ext = "PDF" ]
								then
									cp "$file" "$temppath/$name"
							
								#Если файл является изображением выполняем конвертирование в PDF
							else convert "$file" "$temppath/$namenoext.pdf"
						fi
				done

				#Объединение всех файлов PDF во временной папке
				pdfunite $temppath/*.pdf "$path/$newname"
	
			#Выполнить, если в выделенных файлах присутствуют только нешифрованные pdf
			else pdfunite "$@" "$path/$newname"
			
		fi

		notify-send -t 10000 -i "gtk-ok" "Завершено бъединение файлов в PDF" "Результат объединения сохранен в файл:\n\n$newname"
fi