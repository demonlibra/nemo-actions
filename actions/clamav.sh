#!/bin/bash

#Проверка установки пакета clamav
if [ -z "`dpkg -l | grep clamav`" ]
	then x-terminal-emulator --hide-menubar --geometry=80x15 -t "Установка пакета clamav" -e bash -c "echo \"clamav не установлен\"; echo ; sudo apt install clamav; sudo freshclam; sudo systemctl stop clamav-freshclam; sudo systemctl disable clamav-freshclam; echo ; echo ------------------ ; echo ; echo \"Установка clamav завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

fullpathname=$@
name=${fullpathname##*/}
path=${fullpathname%/*}

AAA=`yad --borders=10 --title="clamav" --text="Поиск вирусов в $path" --text-align=center --item-separator="|" --separator="," --form --field=:LBL  --field="Показывать только зараженные файлы:CHK" --field="Удалять зараженные файлы:CHK" --field="Проверять вложенные каталоги:CHK" --field="Обновить базу сигнатур:CHK" "" FALSE FALSE TRUE FALSE`

if [ $? = 0 ]
	then
		infected=$( echo $AAA | awk -F ',' '{print $2}')
		if [ "$infected" = "TRUE" ]
			then options="-i"
		fi

		remove=$( echo $AAA | awk -F ',' '{print $3}')
		if [ "$remove" = "TRUE" ]
			then options=$options" --remove=yes"
		fi

		recursive=$( echo $AAA | awk -F ',' '{print $4}')
		if [ "$recursive" = "TRUE" ]
			then options=$options" -r"
		fi
		
		update=$( echo $AAA | awk -F ',' '{print $5}')
		if [ "$update" = "TRUE" ]
			then
				update_command="echo \"Обновить базу сигнатур\"; echo; echo ------------------ ; sudo freshclam;"
		fi		
				
		x-terminal-emulator --hide-menubar --geometry 110x30 -t "clamav $@" -e bash -c "$update_command clamscan $options \"$@\"; echo ; echo ------------------ ; echo ; echo \"Проверка завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi