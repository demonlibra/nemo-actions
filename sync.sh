#!/bin/bash

path_nemo="$HOME/.local/share/nemo"
path_git="$PWD"
readme="$path_git/README.md"

rm -f "$readme"
rsync -av --progress --delete $path_nemo"/actions/" $path_git"/actions/"
rsync -av --progress --delete --exclude="*Яндекс*" --exclude="*dropbox*" $path_nemo"/scripts/" $path_git"/scripts/"

echo "# Контекстное меню Nemo" >> "$readme"
echo "### Действия (actions) и сценарии (scripts) при нажатии правой кнопкой мыши" >> "$readme"
echo "" >> "$readme"

echo "Для решения рутинных задач с файлами и каталогами в файловом менеджере Nemo, развиваемого в рамках среды рабочего стола Cinnamon, присутствует возможность создавать *Действия (actions)* и *Сценарии (scripts)*." >> "$readme"
echo "" >> "$readme"

echo "**Сценарии** отображаются при выборе любых файлов и/или каталогов.  " >> "$readme"
echo "Файлы *сценариев* хранятся в каталоге \`/home/имя_пользователя/.local/share/nemo/scripts/\`  " >> "$readme"
echo "Для группировки по вкладкам создайте внутри \`scripts\` дополнительные каталоги и разместите в них файлы сценариев." >> "$readme"
echo "" >> "$readme"

echo "**Действия** удобно применять целенаправлено при выделении определенных объектов и имеют множество настроек.  " >> "$readme"
echo "Файлы *действий* хранятся в каталоге \`/home/имя_пользователя/.local/share/nemo/actions/\`.  " >> "$readme"
echo "Настройки задаются в одноименных файлах с расширением \`.nemo_action\`  " >> "$readme"
echo "Подробное описание смотрите в файлах [help](https://github.com/demonlibra/nemo-actions/blob/master/actions/help) и [help_ru](https://github.com/demonlibra/nemo-actions/blob/master/actions/hep_ru)." >> "$readme"
echo "" >> "$readme"

echo "Вопросы можно задать в разделе [Issues](https://github.com/demonlibra/nemo-actions/issues) или на форуме [LinuxMint.com.ru](https://linuxmint.com.ru/viewtopic.php?t=4416)" >> "$readme"
echo "" >> "$readme"



echo "## Установка" >> "$readme"
echo "Скачайте нужные файлы и разместите их в соответствующих каталогах или используйте полный архив следующим способом:" >> "$readme"
echo "" >> "$readme"
echo "1. Скачайте архив целиком, используя ссылку [Clone or download - Download ZIP](https://github.com/demonlibra/nemo-actions/archive/master.zip)" >> "$readme"
echo "" >> "$readme"
echo "2.1. Если вы скачали архив, распакуйте его  " >> "$readme"
echo "\`\`\`" >> "$readme"
echo 'unzip nemo-actions-master.zip' >> "$readme"
echo "\`\`\`" >> "$readme"
echo "2.2. Скопируйте файлы в каталог **/home/имя_пользователя/.local/share/nemo/**" >> "$readme"
echo "\`\`\`" >> "$readme"
echo 'cd nemo-actions-master' >> "$readme"
echo 'cp actions/*.sh $HOME/.local/share/nemo/actions/' >> "$readme"
echo 'cp actions/*.nemo_action $HOME/.local/share/nemo/actions/' >> "$readme"
echo 'cp scripts/* $HOME/.local/share/nemo/scripts/' >> "$readme"
echo "\`\`\`" >> "$readme"
echo "" >> "$readme"

echo "3. Сделайте файлы исполняемыми" >> "$readme"
echo "\`\`\`" >> "$readme"
echo 'chmod +x $HOME/.local/share/nemo/actions/*.sh' >> "$readme"
echo 'chmod +x $HOME/.local/share/nemo/scripts/*' >> "$readme"
echo "\`\`\`" >> "$readme"
echo "" >> "$readme"

echo "## Скрыть/показать действия (actions)" >> "$readme"
echo "Некоторые действия скрыты. Проверьте параметр **Active** в файле **.nemo_action**" >> "$readme"
echo "- Active=true - активно" >> "$readme"
echo "- Active=false - скрыто" >> "$readme"
echo "" >> "$readme"

echo "## Установка дополнительных программ" >> "$readme"
echo "1. В некоторых действиях и сценариях используются программы формирования диалогового окна **yad**, вывода уведомлений **notify-send**, записи данных в буфер обмена **xclip**. Для их установки выполните в терминале следующую команду:  " >> "$readme"
echo "\`sudo apt install yad libnotify-bin xclip\`" >> "$readme"
echo "" >> "$readme"
echo "" >> "$readme"

echo "2. Для работы действий и сценариев, использующих специальные программы, требуется установка этих программ, например: cuneiform, doublecommnder, enca, ffmpeg, imagemagick, mediainfo, qcad, recoll, secure-delete, tesseract, webp. Для их установки выполните в терминале следующую команду:  " >> "$readme"
echo "\`sudo apt install cuneiform doublecmd-gtk enca ffmpeg freecad imagemagick mediainfo openscad recoll secure-delete tesseract-ocr tesseract-ocr-rus unoconv\`" >> "$readme"
echo "" >> "$readme"

echo "3. **dwgdxf_convert** использует модули программы **QCAD**. Необходимо скачать и распаковать архив [qcad-3.xxx.linux.tar.gz или qcad-3.xxx.linux-qt4.tar.gz](https://www.ribbonsoft.com/en/qcad-downloads-trial)  " >> "$readme"
echo "При выполнении присутствует 15 секундная задержка. Если выполнить в терминале то увидите сообщение: You are using a trial version of the QCAD Professional plugin. If you would like to use this software productively, please purchase the full version ... После истечения 15 секунд выполнение продолжается.  " >> "$readme"
echo "В переменной **pathtoqcad** необходимо указать путь к папке, содержащей скрипты **dwg2bmp, dwg2svg и dwg2bmp**." >> "$readme"
echo "" >> "$readme"

echo "## Действия (actions)" >> "$readme"
echo "" >> "$readme"
echo "/home/имя_пользователя/.local/share/nemo/actions" >> "$readme"
echo "" >> "$readme"
echo "|Файл|Описание|" >> "$readme"
echo "|---|---|" >> "$readme"

cd $path_git"/actions"

for file in *.nemo_action
	do
		name=${file/.nemo_action/}
	
		comment=`cat $file | grep -m 1 "Comment"`
		comment=${comment/"Comment="/}
		
		echo "|**$name**|$comment|" >> "$readme"
done

echo "## Сценарии (scripts)" >> "$readme"
echo "" >> "$readme"
echo "/home/имя_пользователя/.local/share/nemo/scripts" >> "$readme"
echo "" >> "$readme"
echo "|Файл|" >> "$readme"
echo "|---|" >> "$readme"

cd $path_git"/scripts"
for file in *
	do
		echo "|**$file**|" >> "$readme"
done

echo ; echo ------------------ ; echo "Резервное копирование завершено"; echo; read -p "Нажмите ENTER чтобы закрыть окно"
