#!/bin/bash

#Дополнительные параметры
terminal="false"
#terminal="true"

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

if [ $terminal = "true" ]
	then
		#Запуск без терминала
		python3 "$fullpathname"
	else
		#Запуск через терминал
		x-terminal-emulator --hide-menubar --default-working-directory="$path" -e "python $fullpathname"
fi