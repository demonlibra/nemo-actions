# Контекстное меню Nemo (Actions and Srcipts)
# Действия и сценарии при нажатии правой кнопкой мыши

Скопируйте действия из каталога **actions** в **/home/имя_пользователя/.local/share/nemo/actions/**
>cp *.sh $HOME/.local/share/nemo/actions/

>cp *.nemo_action $HOME/.local/share/nemo/actions/

Скопируйте сценарии из каталога **scripts** в **/home/имя_пользователя/.local/share/nemo/scripts/**
>cp *.sh $HOME/.local/share/nemo/scripts/

Сделайте файлы *.sh исполняемыми
>chmod +x $HOME/.local/share/nemo/actions/*.sh

*Некоторые действия выключены. Проверьте параметр в файле .nemo_action*
>Active=true

*Описание структуры файлов .nemo_action смотрите в файлах help и help_ru*

*Для работы действий и сценариев, использующих специальные программы, требуется установка этих программ, например: cuneiform, doublecommnder, enca, ffmpeg, imagemagick, mediainfo, qcad, recoll, secure-delete, tesseract. Для их установки выполните в терминале следующую команду:*
>sudo apt install cuneiform doublecmd-gtk enca ffmpeg imagemagick mediainfo secure-delete tesseract-ocr tesseract-ocr-rus unoconv yad

*В некоторых действиях и сценариях используются программы формирования диалогового окна yad, вывода уведомлений notify-send, записи данных в буфер обмена xclip. Для их установки выполните в терминале следующую команду:*
>sudo apt install yad libnotify-bin xclip


## Действия (actions)
|Файл|Описание|
|---|---|
|**appimage_run**|Скопировать в домашний каталог, сделать исполняемым и запустить пакет AppImage|
|**bin_run**|Сделать исполняемым и запустить бинарный файл|
|**clamav**|Проверить на вирусы программой clamav|
|**deb_install**|Установить пакет deb в терминале утилитой dpkg|
|**docs_print**|Распечатать документы csv doc docx html ods odt ppt rtf txt xls xsls |
|**docs_search_text**|Найти строку в документах при помощи recoll|
|**docs_to_pdf**|Преобразовать документы в PDF с помощью libreoffice|
|**docs_to_pdf_unoconv**|Преобразовать документы в PDF с помощью unoconv и libreoffice|
|**doublecmd**|Открыть выбранный каталог в DoubleCommander|
|**dwgdxf_convert**|Преобразовать чертеж в изображение или pdf средствами QCAD|
|**firefoxsend**|Загрузить на Firefox Send|
|**gpg_encrypt**|Расшифровать файл gpg|
|**hash**|Вычислить хэш-суммы MD5 или SHAх|
|**image_compress**|Сжать изображения|
|**image_convert**|Конвертировать формат изображения|
|**image_gamma**|Изменить гамму изображений|
|**image_montage**|Объединить изображения|
|**image_resolution**|Изменить разрешение изображений|
|**image_rotate**|Повернуть изображения|
|**iso_mount**|Монтировать образ ISO программой gnome-disk-image-mounter|
|**ocr_cuneiform**|Распознать текст программой cuneiform|
|**ocr**|Распознать текст программами cuneiform или tesseract|
|**ocr_tesseract**|Распознать текст программой tesseract|
|**pdf_compress**|Уменьшить размер файла PDF сжатием изображений |
|**pdf_convert_to_image**|Преобразовать страницы PDF в изображения|
|**pdf_convert_to_text**|Преобразовать PDF в текст|
|**pdf_decrypt**|Снять защиту с PDF|
|**pdf_export_image**|Извлечь изображения из PDF|
|**pdf_export_pages**|Извлечь страницы из PDF|
|**pdf_print**|Распечатать документ PDF|
|**pdf_search_text**|Найти строку в файлах PDF|
|**pdf_unite2**|Объединить файлы pdf и изображения в PDF|
|**pdf_unite**|Объединить (только) файлы PDF|
|**ps_convert**|Преобразовать postscript в PDF или PNG|
|**py_run**|Выполнить сценарий python|
|**qbittorrent**|Добавить в qbittorrent с одинаковыми параметрами|
|**secure_delete**|Удаление без возможности восстановления средствами Secure delete|
|**sh_run**|Выполнить скрипт bash|
|**transfersh**|Загрузить на Transfer.sh|
|**txt_convert_encoding**|Изменить кодировку текстовых файлов при помощи enconv|
|**video_cut**|Вырезать фрагмент мультимедиа|
|**video_info**|Получить информацию о файле мультимедиа при помощи mediainfo|
|**video_process**|Изменить формат, bitrate, разрешение, кодек, поворот|
|**wetransfer**|Загрузить на Wetransfer|
|**xed_as_root**|Открыть текстовый файл в редакторе xed от имени root|
## Сценарии (scripts)
|Файл|
|---|
|**Безвозвратное удаление**|
|**Загрузить на firefoxsend**|
|**Загрузить на transfersh**|
|**Загрузить на wetransfer**|
|**Контрольная сумма**|
