#!/bin/bash

path_script="/home/demonlibra/.local/share/nemo/scripts/Загрузить файл по ссылке из буфера"
path_tmp="$1"

link=`head -n 1 "$path_tmp"`

bash "$path_script" "${path_tmp%/*}" "$link" 
