#!/bin/bash

#Проверка установки пакета secure-delete
if [ -z "`dpkg -l | grep secure-delete`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета secure-delete" -- bash -c "echo \"secure-delete не установлен\"; echo ; sudo apt install secure-delete; echo ; echo ------------------ ; echo ; echo \"Установка завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

#Проверка установки пакета yad
if [ -z "`dpkg -l | grep yad`" ]
	then gnome-terminal --hide-menubar --geometry=80x15 -t "Установка пакета yad" -- bash -c "echo \"yad не установлен\"; echo ; sudo apt install yad; echo ; echo ------------------ ; echo ; echo \"Установка yad завершена\"; echo ; read -p \"Нажмите ENTER чтобы закрыть окно\""
fi

AAA=`yad --borders=10 --title="secure-delete" --text="Безопасное удаление файлов" --text-align=center --form --separator="," --item-separator="|" --field=:LBL --field="Быстро (no /dev/urandom, no synchronize mode):CHK" --field="Меньше проходов (2 прохода 0xff/random):CHK" --field="Ещё меньше проходов (1 проход random):CHK" --field="От имени root:CHK" "" TRUE TRUE TRUE FALSE`

if [ $? = 0 ]
	then
		fast=$( echo $AAA | awk -F ',' '{print $2}')
		if [ $fast = "TRUE" ]
			then options="f"
		fi

		lessens=$( echo $AAA | awk -F ',' '{print $3}')

		if [ $lessens = "TRUE" ]
			then options=$options"l"
		fi

		lessens=$( echo $AAA | awk -F ',' '{print $4}')
		if [ $lessens = "TRUE" ]
			then options=$options"l"
		fi

		root=$( echo $AAA | awk -F ',' '{print $5}')
		if [ $root = "TRUE" ]
			then gnome-terminal --geometry 90x20 --hide-menubar -t "Secure delete" -e "sudo srm -rv$options $@"
			else gnome-terminal --geometry 90x20 --hide-menubar -t "Secure delete" -e "srm -rv$options $@"
		fi

		notify-send -t 10000 -i "gtk-ok" "Secure delete" "Операция завершена"
fi