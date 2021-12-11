#!/bin/bash

fullpathname=$1
name=${fullpathname##*/}
path=${fullpathname%/*}

width=`ffprobe -i "$fullpathname" -show_entries stream=width -of default=noprint_wrappers=1:nokey=1`
height=`ffprobe -i "$fullpathname" -show_entries stream=height -of default=noprint_wrappers=1:nokey=1`
wh="$width"x"$height"
scale=`echo "scale=2;$width/$height" |bc`

#AAA=`yad --borders=10 --width=600 --title="Обработка видео" --text="Текущее разрешение файла $name: $wh, соотношение сторон: $scale" --form --item-separator="|" --separator="," --field=:LBL --field="Формат:CB" --field="Bitrate (kbit)" --field="Разрешение (пример 800x452, только четное, по умолчанию оригинал)" --field="Кодек видео:CB" --field="Кодек аудио:CB" --field="Тест (5 сек с 5-й сек):CHK" --field="Без звука:CHK" "" "оригинал|^mkv|mov|mp4|avi" "2000" "" "^оригинал|^h264|hevc|mpeg4|mpeg2video" "оригинал|^mp3|aac" FALSE FALSE`

AAA=`yad --borders=10 --width=600 --title="Обработка видео" --text="Текущее разрешение файла $name: $wh, соотношение сторон: $scale" --form --item-separator="|" --separator="," --field=:LBL --field="Формат:CB" --field="Bitrate (kbit):NUM" --field="Разрешение (пример 800x452, только четное, по умолчанию оригинал)" --field="Обрезать W:H:X:Y (Ширина : Высота : X левого угла : Y левого угла):" --field="Кодек видео:CB" --field="Кодек аудио:CB" --field="Поворот:CB" --field="Тест (5 сек с 5-й сек):CHK" --field="Без звука:CHK" --field="Количество кадров" "" "оригинал|^mkv|mov|mp4|avi|gif" "4000|0..10000|500" "" "" "^оригинал|^h264|hevc|mpeg4|mpeg2video" "оригинал|^mp3|aac" "^Нет|По часовой|Против часовой" FALSE FALSE`

if [ $? = 0 ]
	then
		format=$( echo $AAA | awk -F ',' '{print $2}')
		if [ $format != "оригинал" ]
			then ext=$format
		fi

		bitrate=$( echo $AAA | awk -F ',' '{print $3}')

		size=$( echo $AAA | awk -F ',' '{print $4}')
		if [ "$size" != "" ]
			then
				optionsize="-s $size"
				sizeprefix="_$size"
			fi
		
		crop=$( echo $AAA | awk -F ',' '{print $5}')
		if [ "$crop" != "" ]
			then cropprefix="-filter:v crop=$crop"
		fi

		videocodec=$( echo $AAA | awk -F ',' '{print $6}')
		if [[ "$videocodec" != "оригинал" ]] && [[ "$format" != "gif" ]]
			then optionvideocodec="-vcodec $videocodec"
		fi

		audiocodec=$( echo $AAA | awk -F ',' '{print $7}')
		if [ $audiocodec != "оригинал" ]
			then optionaudiocodec="-acodec $audiocodec"
		fi
		
		rotate=$( echo $AAA | awk -F ',' '{print $8}')
		if [[ "$rotate" = "По часовой" ]]
			then
				option_rotate="-vf transpose=1"
				prefix="_CW"
		elif [ "$rotate" = "Против часовой" ]
			then
				option_rotate="-vf transpose=2"
				prefix="_CCW"
		fi

		test=$( echo $AAA | awk -F ',' '{print $9}')
		if [ "$test" = "TRUE" ]
			then
				testcode="-ss 00:00:05 -to 00:00:10"
				prefix=$prefix"_5sec"
		fi

		nosound=$( echo $AAA | awk -F ',' '{print $10}')
		if [ "$nosound" = "TRUE" ]
			then
					optionaudiocodec="-an"
					prefix=$prefix"_nosound"
		fi

		frame_rate=$( echo $AAA | awk -F ',' '{print $11}')
		if [ "$frame_rate" != "" ]
			then
					option_frame_rate="-r "$frame_rate
					prefix="_"$frame_rate"fps"
		fi
		
		for file in "$@"
			do kolfile=$(($kolfile+1))
		done


		counter=0
		for file in "$@"
			do
				counter=$(($counter+1))
				
				if [ -z $ext ]
					then ext=${file##*.}
				fi

				duration=`ffprobe -i "$file" -loglevel panic -show_entries format=duration -of default=noprint_wrappers=1:nokey=1`
				
				duration=${duration%%.*}
				durationM=$(($duration / 60))
				durationS=$(($duration - $durationM * 60))
				
				if [ "$durationM" != "0" ]
					then duration=$durationM" мин "$durationS" сек"
					else duration=$durationS" сек"
				fi
						
				gnome-terminal --wait --geometry 100x20 --hide-menubar -t "Обработка файла $counter из $kolfile - ${file##*/} длительностью $duration" -e "ffmpeg -hide_banner -i \"$file\" $cropprefix -y -b:v \"$bitrate\"k $option_rotate $optionvideocodec $optionsize $optionaudiocodec $option_frame_rate $testcode -strict -2 \"${file%.*}\"$sizeprefix\"_$bitrate\"k\"$prefix.$ext\""
			done

			notify-send -t 10000 -i "gtk-ok" "Завершено" "Обработка видео $codec $bitrate kbit"
fi
