#!/bin/bash

#Проверка установки пакета yad
if [ -z "`dpkg -l | grep yad`" ]
	then x-terminal-emulator --hide-menubar --geometry=80x15 -t "Установка пакета yad" -e bash -c "echo \"yad не установлен\"; echo ; sudo apt install yad; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`yad --focus-field=4 --borders=10 --title="bash" --text="Выполнить скрипт" --text-align=center --form \
	--field=:LBL --field="в терминале:CHK" --field="от имени root:CHK" \
			""						TRUE								FALSE`

if [ $? = 0 ]
	then
		terminal=$( echo $AAA | awk -F '|' '{print $2}')
		root=$( echo $AAA | awk -F '|' '{print $3}')

		if [ $root == "TRUE" ]
			then
				rootterm="sudo"
				root="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"
			else
				root=""
		fi
		
		fullpathname="$@"
		path=${fullpathname%/*}
		name=${fullpathname##*/}
		cd $path

		if [ $terminal == "TRUE" ]
			then
				gnome-terminal --hide-menubar --working-directory="$path" --title "$name" $options -- bash -c \
					"$rootterm bash \"$name\"; echo ; echo ------------------ ; echo \"завершено\"; echo; read -p \"Нажмите ENTER чтобы закрыть окно\""
			else
				$root bash "$@"
		fi
fi
