#!/bin/bash

# Скачайте appimageupdatetool-x86_64.AppImage from https://github.com/AppImage/AppImageUpdate/releases
# или выполните команду: wget https://github.com/AppImage/AppImageUpdate/releases/download/continuous/appimageupdatetool-x86_64.AppImage
# Укажите путь к файлу appimageupdatetool-x86_64.AppImage

path_update_tool="/home/demonlibra/app/appimageupdatetool-x86_64.AppImage"

if ! [ -f "$path_update_tool" ]
	then
		notify-send -t 10000 -i "error" "Ошибка" "Отсутствует файл appimageupdatetool"
		exit
fi

fullpathname=$1
name=${fullpathname##*/}
path=${fullpathname%/*}

gnome-terminal --hide-menubar --working-directory="$path" --title "$name" $options -- bash -c \
	"${path_update_tool} \"$name\"; echo ; echo ------------------ ; echo \"завершено\"; echo; read -p \"Нажмите ENTER чтобы закрыть окно\""
