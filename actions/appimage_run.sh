#!/bin/bash

fullpathname="$@"
name=${fullpathname##*/}
path=${fullpathname%/*}

appimage_dir="$HOME/app"									#Общий каталог для пакетов AppImage

if ! [ -d $appimage_dir ]
	then mkdir "$appimage_dir"								#Создаем каталог для пакетов AppImage
	
fi


#if ! [ -f "$appimage_dir/$name" ]							#Проверяем отсутствие этого пакета в общем каталоге для пакетов AppImage
if ! [[ `echo $fullpathname | grep "$appimage_dir"` ]]		#Проверяем находится ли пакет в общем каталоге для пакетов AppImage
	then
		cp "$fullpathname" "$appimage_dir"					#Копируем пакет в общий каталог, если отсутсует 
		cd "$appimage_dir"									#Переходим в каталог с пакетами AppImage
		chmod +x "$name"									#Разрешаем исполнение
		terminal=`zenity --question --title="AppImage" --width=150 --text="Запустить пакет в терминале" --ok-label="Да" --cancel-label="Нет"`
		if [ $? = 0 ]
			then
				#Запуск через терминал
				x-terminal-emulator --title="$name" --hide-menubar --default-working-directory="$appimage_dir" -e "./$name"	
			else
				./$name										#Запуск без терминала
		fi
	else
		terminal=`zenity --question --title="AppImage" --width=150 --text="Запустить пакет в терминале" --ok-label="Да" --cancel-label="Нет"`
		if [ $? = 0 ]
			then
				chmod +x "$fullpathname"					#Разрешаем исполнение
				#Запуск через терминал
				gnome-terminal --title="$name" --hide-menubar --default-working-directory="$path" -e "./$name"
			else
				cd "$path"									#Переходим в каталог с пакетами AppImage
				chmod +x "$name"							#Разрешаем исполнение
				./$name										#Запуск без терминала
		fi

fi
