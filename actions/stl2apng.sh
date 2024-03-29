#!/bin/bash

#tmp="/tmp/stl_preview"					# Временный каталог для кадров превью
tmp=`mktemp --directory --tmpdir="/tmp" "stl2apng_XXXXX"`	# Генерировать уникальный временный каталог

if [ -d "$tmp" ]
	then rm --force --recursive "$tmp"	# Удалить временный каталог, если существует
fi
mkdir "$tmp"							# Создать временный каталог, если не существует

#Проверка установки пакета yad
if [ -z "`dpkg -l | grep yad`" ]
	then x-terminal-emulator --hide-menubar --geometry=80x15 -t "Установка пакета yad" -e bash -c "echo \"yad не установлен\"; echo ; sudo apt install yad; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

#Проверка установки пакета openSCAD
if [ -z "`dpkg -l | grep openscad`" ]
	then x-terminal-emulator --hide-menubar --geometry=80x15 -t "Установка пакета openscad" -e bash -c "echo \"openscad не установлен\"; echo ; sudo apt install openscad; echo ; echo ------------------ ; echo ; echo \"Установка openscad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

#Проверка установки пакета apngasm
if [ -z "`dpkg -l | grep apngasm`" ]
	then x-terminal-emulator --hide-menubar --geometry=80x15 -t "Установка пакета apngasm" -e bash -c "echo \"apngasm не установлен\"; echo ; sudo apt install apngasm; echo ; echo ------------------ ; echo ; echo \"Установка apngasm завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

#Проверка установки пакета apng2gif
if [ -z "`dpkg -l | grep apng2gif`" ]
	then x-terminal-emulator --hide-menubar --geometry=80x15 -t "Установка пакета apng2gif" -e bash -c "echo \"apng2gif не установлен\"; echo ; sudo apt install apng2gif; echo ; echo ------------------ ; echo ; echo \"Установка apng2gif завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`yad --borders=10 --title="stl 2 apng" --text="Создание анимации из stl" --text-align=center --form --item-separator="|" \
--field=:LBL --field="Ширина изображения" --field="Высота изображения" 	--field="Цветовая схема:CB" 								--field="Проекция:CB" --field="Смещение вдоль осей" --field="Автоцентровка:CHK" --field="Отдаление от модели" --field="Вписать модель в размер:CHK" --field="Начальный угол оси X" --field="Начальный угол оси Y" --field="Начальный угол оси Z" --field="Вращать вокруг оси:CB" --field="Угол поворота оси за шаг" --field="Задержка анимации(1/5 сек)" --field="Сохранить в PNG:CHK" --field="Сохранить в GIF:CHK" \
		"" 					600							600		"^Cornfield|Sunset|Metallic|Starnight|BeforeDawn|Nature|Случайная"	"ortho|perspective" 			"0,0,0" 						TRUE 							"500"							TRUE							25							25								0										"X|^Y|Z"						10							"1 4"								FALSE							TRUE`

if [ $? = 0 ]
	then
		width=$( echo $AAA | awk -F '|' '{print $2}')
		height=$( echo $AAA | awk -F '|' '{print $3}')

		colorscheme[0]=Cornfield
		colorscheme[1]=Sunset
		colorscheme[2]=Metallic
		colorscheme[3]=Starnight
		colorscheme[4]=BeforeDawn
		colorscheme[5]=Nature
		colorscheme[6]=DeepOcean
		colorscheme[7]=$( echo $AAA | awk -F '|' '{print $4}')
		
		projection=$( echo $AAA | awk -F '|' '{print $5}')

		trans=$( echo $AAA | awk -F '|' '{print $6}')
		autocenter=$( echo $AAA | awk -F '|' '{print $7}')
		if [ $autocenter = "TRUE" ]; then autocenter='--autocenter'; else autocenter=''; fi

		distance=$( echo $AAA | awk -F '|' '{print $8}')
		viewall=$( echo $AAA | awk -F '|' '{print $9}')
		if [ $viewall = "TRUE" ]; then viewall='--viewall'; else viewall=''; fi

		x_degree=$( echo $AAA | awk -F '|' '{print $10}')
		y_degree=$( echo $AAA | awk -F '|' '{print $11}')
		z_degree=$( echo $AAA | awk -F '|' '{print $12}')
		rotate_axis=$( echo $AAA | awk -F '|' '{print $13}')
		degree_step=$( echo $AAA | awk -F '|' '{print $14}')
		delay=$( echo $AAA | awk -F '|' '{print $15}')

		out_png=$( echo $AAA | awk -F '|' '{print $16}')
		out_gif=$( echo $AAA | awk -F '|' '{print $17}')
		
		# Количество файлов stl
		number=`find "$@" -type f -iname "*.stl" -print | wc -l`
		
		# Процентов на каждый файл
		procent=$((100/$number))

		#Поиск файлов STL и формирование списка
		find "$@" -type f -iname "*.stl" -print0 | (while read -d $'\0' file
			do
				# Случайный выбор цветовой схемы
				if [ "${colorscheme[7]}" = "Случайная" ]
					then
						color_number=`shuf -i 0-6 -n 1`
						color_scheme=${colorscheme[$color_number]}
					else
						color_scheme="${colorscheme[7]}"
				fi

				# Время начала обработки файлы STL
				Start_Time=$(date +%s)
				
				# Имя файла без пути
				filename="${file##*/}"

				# Создание временного файла scad с командой импорта stl
				echo "import(\"${filename}\");" > "${file%.*}.scad"

				# Экспорт кадров в png при помощи openSCAD
				num=0
				steps=$((360/$degree_step))
				for ((step=1; step<=steps; step=step+1))
					do
						if [ "$rotate_axis" == "X" ]
							then x_degree=$(($x_degree+$degree_step))
						elif [ "$rotate_axis" == "Y" ]
							then y_degree=$(($y_degree+$degree_step))
						elif [ "$rotate_axis" == "Z" ]
							then z_degree=$(($z_degree+$degree_step))
						fi
						name="$tmp/frame"`printf "%03d" $step`".png"
						openscad -o "$name" --render --colorscheme=${color_scheme} --camera=$trans,${x_degree},${y_degree},${z_degree},$distance --projection=$projection $autocenter $viewall --imgsize=$width,$height "${file%.*}.scad" > /dev/null
					done

				# Объединение кадров в apng
				apngasm "$tmp/${filename%.*}.png" "$tmp/frame"*".png" $delay > /dev/null

				# Создание файла в формате gif
				if [ $out_gif = "TRUE" ]
					then
						apng2gif "$tmp/${filename%.*}.png" "$tmp/${filename%.*}.gif" > /dev/null
						mv "$tmp/${filename%.*}.gif" "${file%.*}.gif" > /dev/null
				fi

				# Перенос файла в формате apng
				if [ $out_png = "TRUE" ]
					then mv "$tmp/${filename%.*}.png" "${file%.*}.png" > /dev/null
					else rm "$tmp/${filename%.*}.png" > /dev/null
				fi

				# Удаление кадров
				rm "$tmp/frame"*".png"

				# Удаление временного файла scad
				rm "${file%.*}.scad"
				
				counter=$(($counter+1))													# Счётчик обработанных файлов STL
				progress=$(($progress+$procent))										# Расчёт процентов для шкалы выполнения

				# Расчёт оставшегося времени исполнения сценария
				End_Time=$(date +%s)														# Время окончания обрабоки файла STL
				Sum_Time=$(( $Sum_Time + $End_Time - $Start_Time ))			# Прошедшее время обработки файлов STL 
				Everage_Time=$(( $Sum_Time / $counter ))							# Среднее время обработки каждого файла STL
				Second_to_End=$(( $Everage_Time * ($number - $counter) ))	# Осталось секунд до завершения обработки всех файлов
				Time_to_End=`date -d@${Second_to_End} -u +%Hч:%Mмин:%Sсек`
				
				echo $progress
				echo "# Обработано: ${counter} файлов из ${number}\n\nОсталось до завершения: ${Time_to_End}\nЗавершена обработка файла: ${filename}"

			done) | zenity --progress --title="Создание анимации из STL" --percentage=0 --auto-kill --width=500 --auto-close

		#Вывод уведомления
		notify-send -t 10000 -i "gtk-ok" "Завершено" "Создание файлов предварительного просмотра для моделей STL"
fi
