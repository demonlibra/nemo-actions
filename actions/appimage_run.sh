#!/bin/bash

fullpathname="$@"
name=${fullpathname##*/}
path=${fullpathname%/*}

app_dir="$HOME/App"						#Общий каталог для пакетов AppImage

if ! [ -d $app_dir ]
	then mkdir "$app_dir"				#Создаем каталог для пакетов AppImage
	
fi

if ! [ -f "$app_dir/$name" ]			#Проверяем отсутствие этого пакета в общем каталоге
	then
		cp "$fullpathname" "$app_dir"	#Копируем пакет в общий каталог, если отсутсует 
fi

cd "$app_dir"							#Переходим в каталог с пакетами AppImage
chmod +x "$name"						#Разрешаем исполнение

terminal=`zenity --question --title="AppImage" --width=150 --text="Запустить пакет в терминале" --ok-label="Да" --cancel-label="Нет"`

if [ $? = 0 ]
	then
		gnome-terminal --title="$name" --hide-menubar --default-working-directory="$app_dir" -e "./$name"		#Запуск через терминал
	else
		./$name																									#Запуск без терминала
fi