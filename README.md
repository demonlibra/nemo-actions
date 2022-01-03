# Контекстное меню Nemo
### Действия (actions) и сценарии (scripts) при нажатии правой кнопкой мыши

Для решения рутинных задач с файлами и каталогами в файловом менеджере Nemo, развиваемого в рамках среды рабочего стола Cinnamon, присутствует возможность создавать *Действия (actions)* и *Сценарии (scripts)*.

**Сценарии** отображаются при выборе любых файлов и/или каталогов.  
Файлы *сценариев* хранятся в каталоге `/home/имя_пользователя/.local/share/nemo/scripts/`  
Для группировки по вкладкам создайте внутри `scripts` дополнительные каталоги и разместите в них файлы сценариев.

**Действия** удобно применять целенаправлено при выделении определенных объектов и имеют множество настроек.  
Файлы *действий* хранятся в каталоге `/home/имя_пользователя/.local/share/nemo/actions/`.  
Настройки задаются в одноименных файлах с расширением `.nemo_action`  
Подробное описание смотрите в файлах [help](https://github.com/demonlibra/nemo-actions/blob/master/actions/help) и [help_ru](https://github.com/demonlibra/nemo-actions/blob/master/actions/hep_ru).

Вопросы можно задать в разделе [Issues](https://github.com/demonlibra/nemo-actions/issues) или на форуме [LinuxMint.com.ru](https://linuxmint.com.ru/viewtopic.php?t=4416)

## Установка
Скачайте нужные файлы и разместите их в соответствующих каталогах или используйте полный архив следующим способом:

1. Скачайте архив целиком, используя ссылку [Clone or download - Download ZIP](https://github.com/demonlibra/nemo-actions/archive/master.zip)

2.1. Если вы скачали архив, распакуйте его  
```
unzip nemo-actions-master.zip
```
2.2. Скопируйте файлы в каталог **/home/имя_пользователя/.local/share/nemo/**
```
cd nemo-actions-master
cp actions/*.sh $HOME/.local/share/nemo/actions/
cp actions/*.nemo_action $HOME/.local/share/nemo/actions/
cp scripts/* $HOME/.local/share/nemo/scripts/
```

3. Сделайте файлы исполняемыми
```
chmod +x $HOME/.local/share/nemo/actions/*.sh
chmod +x $HOME/.local/share/nemo/scripts/*
```

## Скрыть/показать действия (actions)
Некоторые действия скрыты. Проверьте параметр **Active** в файле **.nemo_action**
- Active=true - активно
- Active=false - скрыто

## Установка дополнительных программ
1. В некоторых действиях и сценариях используются программы формирования диалогового окна **yad**, вывода уведомлений **notify-send**, записи данных в буфер обмена **xclip**. Для их установки выполните в терминале следующую команду:  
`sudo apt install yad libnotify-bin xclip`


2. Для работы действий и сценариев, использующих специальные программы, требуется установка этих программ, например: cuneiform, doublecommnder, enca, ffmpeg, imagemagick, mediainfo, qcad, recoll, secure-delete, tesseract, webp. Для их установки выполните в терминале следующую команду:  
`sudo apt install cuneiform doublecmd-gtk enca ffmpeg freecad imagemagick mediainfo openscad recoll secure-delete tesseract-ocr tesseract-ocr-rus unoconv`

3. **dwgdxf_convert** использует модули программы **QCAD**. Необходимо скачать и распаковать архив [qcad-3.xxx.linux.tar.gz или qcad-3.xxx.linux-qt4.tar.gz](https://www.ribbonsoft.com/en/qcad-downloads-trial)  
При выполнении присутствует 15 секундная задержка. Если выполнить в терминале то увидите сообщение: You are using a trial version of the QCAD Professional plugin. If you would like to use this software productively, please purchase the full version ... После истечения 15 секунд выполнение продолжается.  
В переменной **pathtoqcad** необходимо указать путь к папке, содержащей скрипты **dwg2bmp, dwg2svg и dwg2bmp**.

## Действия (actions)

/home/имя_пользователя/.local/share/nemo/actions

|Файл|Описание|
|---|---|
|**appimage_run**|Скопировать в домашний каталог, сделать исполняемым и запустить пакет AppImage|
|**bin_run**|Сделать исполняемым и запустить бинарный файл|
|**clamav**|Проверить на вирусы программой clamav|
|**deb_install**|Установить пакет deb в терминале утилитой dpkg|
|**docs_print**|Распечатать документы csv doc docx html ods odt ppt rtf txt xls xsls |
|**docs_search_text**|Найти строку в документах|
|**docs_to_pdf**|Преобразовать документы в PDF с помощью libreoffice|
|**docs_to_pdf_unoconv**|Преобразовать документы в PDF с помощью unoconv и libreoffice|
|**doublecmd**|Открыть выбранный каталог в DoubleCommander|
|**dwgdxf_convert**|Преобразовать чертеж в изображение или pdf средствами QCAD|
|**edit_as_root**|Открыть текстовый файл в редакторе от имени root|
|**git_last_change**|Изменить последний commit на GitHub|
|**git**|Добавить commit на GitHub|
|**gpg_encrypt**|Расшифровать файл gpg|
|**hash**|Вычислить хэш-суммы MD5 или SHAх|
|**image_compress**|Отправить файл с g-кодом на SD-карту платы DUET|
|**image_convert**|Конвертировать формат изображения|
|**image_crop**|Обрезать изображения|
|**image_gamma**|Изменить гамму изображений|
|**image_montage**|Объединить изображения|
|**image_resolution**|Изменить разрешение изображений|
|**image_rotate**|Повернуть изображения|
|**iso_mount**|Монтировать образ ISO программой gnome-disk-image-mounter|
|**luckyluks**|Монтировать контейнер|
|**ocr_cuneiform**|Распознать текст программой cuneiform|
|**ocr**|Распознать текст программами cuneiform или tesseract|
|**ocr_tesseract**|Распознать текст программой tesseract|
|**pdf_compress**|Уменьшить размер файла PDF сжатием изображений |
|**pdf_convert_to_image_multiple**|Преобразовать несколько документов PDF в изображения|
|**pdf_convert_to_image**|Преобразовать страницы PDF в изображения|
|**pdf_convert_to_text**|Преобразовать PDF в текст|
|**pdf_decrypt**|Снять защиту с PDF|
|**pdf_export_image**|Извлечь изображения из PDF|
|**pdf_export_pages**|Извлечь страницы из PDF|
|**pdf_print**|Отправить на принтер по умолчанию документ|
|**pdf_search_text**|Найти строку в файлах PDF при помощи pdfgrep|
|**pdf_unite2**|Объединить файлы pdf и изображения в PDF|
|**pdf_unite**|Объединить (только) файлы PDF|
|**print**|Отправить на принтер по умолчанию документ или изображение |
|**ps_convert**|Преобразовать postscript в PDF или PNG|
|**py_run**|Выполнить сценарий python|
|**qbittorrent**|Добавить в qbittorrent с одинаковыми параметрами|
|**rrf_send**|Сжать изображения|
|**secure_delete**|Удаление без возможности восстановления средствами Secure delete|
|**send_by_email**|Отправить по почте|
|**sh_run**|Выполнить скрипт bash|
|**step2stl**|Конвертировать STEP в STL|
|**stl2apng**|Создать анимированное изображение из STL|
|**stl2png**|Создать изображение из STL|
|**transfersh**|Загрузить на Transfer.sh|
|**txt_convert_encoding**|Изменить кодировку текстовых файлов при помощи enconv|
|**video_cut**|Вырезать фрагмент мультимедиа|
|**video_info**|Получить информацию о файле мультимедиа при помощи mediainfo|
|**video_process**|Изменить формат, bitrate, разрешение, кодек, поворот|
|**video_storyboard**|Раскадровка видео|
|**wetransfer**|Загрузить на Wetransfer|
## Сценарии (scripts)

/home/имя_пользователя/.local/share/nemo/scripts

|Файл|
|---|
|**Безвозвратное удаление**|
|**Загрузить на dropbox**|
|**Загрузить на transfersh**|
|**Загрузить на wetransfer**|
|**Конвертировать step в stl**|
|**Контрольная сумма**|
|**Отправить через ssh**|
|**Получить ссылку dropbox**|
|**Проверить на вирусы**|
|**Создать анимированное превью моделей stl**|
|**Создать превью моделей stl**|
