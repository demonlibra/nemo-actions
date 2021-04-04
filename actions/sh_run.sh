#!/bin/bash

#Проверка установки пакета yad
if [ -z "`dpkg -l | grep yad`" ]
	then x-terminal-emulator --hide-menubar --geometry=80x15 -t "Установка пакета yad" -e bash -c "echo \"yad не установлен\"; echo ; sudo apt install yad; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`yad --focus-field=4 --borders=10 --title="bash" --text="Выполнить скрипт" --text-align=center --form --field=:LBL --field="оставить открытым:CHK" --field="в терминале:CHK" --field="от имени root:CHK" "" FALSE TRUE FALSE`

if [ $? = 0 ]
	then
		root=$( echo $AAA | awk -F '|' '{print $4}')
		terminal=$( echo $AAA | awk -F '|' '{print $3}')
		noclose=$( echo $AAA | awk -F '|' '{print $2}')

		if [ $root = "TRUE" ]
			then rootterm="sudo"; root="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"; else root=""
		fi

		#if [ $noclose = "TRUE" ]
		#	then options="-H"
		#	else options=""
		#fi
		
		fullpathname="$@"
		path=${fullpathname%/*}
		name=${fullpathname##*/}
		cd $path

		if [ $terminal = "TRUE" ]
			then x-terminal-emulator --hide-menubar --working-directory="$path" -t "$name" $options -e "$rootterm bash \"$@\""
			else $root bash "$@"
		fi
fi