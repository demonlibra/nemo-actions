#!/bin/bash

fullpathname="$@"
name=${fullpathname##*/}
path=${fullpathname%/*}

chmod +x "$fullpathname"

terminal=`zenity --question --title="bin" --width=150 --text="Запустить бинарник в терминале" --ok-label="Да" --cancel-label="Нет"`

if [ $? = 0 ]
	then
		gnome-terminal --title="$name" --hide-menubar --default-working-directory="$path" -e "./$name"
	else
		cd $path
		./$name
		
fi