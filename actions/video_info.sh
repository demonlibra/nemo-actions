#!/bin/bash

#Проверка установки пакета mediainfo
if [ -z "`dpkg -l | grep mediainfo`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета mediainfo" -- bash -c "echo \"mediainfo не установлен\"; echo ; sudo apt install mediainfo; echo ; echo ------------------ ; echo ; echo \"Установка завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

fullpathname="$@"
name=${fullpathname##*/}
path=${fullpathname%/*}

gnome-terminal --hide-menubar --geometry 80x50 -t "mediainfo $name" -- bash -c "mediainfo \"$fullpathname\"; echo ; echo ------------------ ; echo; read -p \"Нажмите ENTER чтобы закрыть окно\""