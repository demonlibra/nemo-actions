#!/bin/bash

fullpathname=$@

echo "Обрабатывается каталог $fullpathname"

# Переходим в выбранный каталог
cd "$fullpathname"

# Проверяем наличие каталога .git
if ! [ -d ".git" ]
	then
		echo
		echo "Отсутствует каталог $fullpathname/.git"
		echo "Вероятно Вы выбрали каталог не имеющий отношение к git"
		echo
		read -p "Нажмите ENTER чтобы закрыть окно"
		exit 0
fi


# Добавление файлов для загрузки
echo
git add .
echo -e '\E[1;32m'"Выполнена команда: git add ."
tput sgr0 

echo
git commit --amend
echo
echo -e '\E[1;32m'"Выполнена команда: git commit --ammend"
tput sgr0 

echo
git push --force
echo
echo -e '\E[1;32m'"Выполнена команда: git push --force"
tput sgr0 

echo
read -p "Нажмите ENTER чтобы закрыть окно"
