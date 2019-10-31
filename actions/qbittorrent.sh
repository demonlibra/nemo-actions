#!/bin/bash

FORM=`yad --borders=10 --title="qbittorent" --text="" --text-align=center --form --separator="," --item-separator="|" --field=:LBL --field="Путь для загрузки:DIR" --field="Пропустить диалоговые окна:CHK" --field="Загружать последовательно:CHK" --field="Загружать с первой и последней части:CHK" --field="Добавить остановленными:CHK" "" "" TRUE FALSE FALSE FALSE`

if [ $? = 0 ]
	then
		options=""
		
		path=$( echo $FORM | awk -F ',' '{print $2}')
		
		skip_dialog=$( echo $FORM | awk -F ',' '{print $3}')
		if [ "$skip_dialog" = "TRUE" ]; then options=$options" --skip-dialog"; fi		#Пропустить диалоговые окна
		
		sequential=$( echo $FORM | awk -F ',' '{print $4}')
		if [ "$sequential" = "TRUE" ]; then options=$options" --sequential"; fi			#Загружать последовательно
		
		first_and_last=$( echo $FORM | awk -F ',' '{print $5}')
		if [ "$first_and_last" = "TRUE" ]; then options=$options" --first-and-last"; fi	#Загружать с первой и последней части
		
		pause=$( echo $FORM | awk -F ',' '{print $6}')
		if [ "$pause" = "TRUE" ]; then options=$options" --add-paused=TRUE"; fi			#Добавить остановленными
		
		qbittorrent --save-path="$path" $options "$@"
fi