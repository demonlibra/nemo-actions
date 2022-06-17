#!/bin/bash

fullpathname="$@"

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

# Проверка наличия изменений
if [[ -z `git --no-pager diff` ]] && [[ -z `git ls-files --others --exclude-standard` ]]
	then
		# Если изменения отсутствуют, завершаем сценарий
		echo
		echo "Вывод команды git diff пуст"
		echo "Отсутствуют изменения"
		echo
		read -p "Нажмите ENTER чтобы закрыть окно"
		exit 0
fi

# Вывод изменений
echo "Изменения"
git --no-pager diff
echo
echo "Новые файлы"
git ls-files --others --exclude-standard
echo

read -p "Нажмите ENTER чтобы загрузить изменения на GitHub"

# Добавление файлов для загрузки
echo
git add .
echo -e '\E[1;32m'"Выполнена команда: git add ."
tput sgr0 

# Ввод описания коммита
echo
echo -n "Введите описание коммита: "
read commit_text

echo
git commit -m "${commit_text}"
echo
echo -e '\E[1;32m'"Выполнена команда: git commit -m \"${commit_text}\""
tput sgr0 

# Загрузка коммита
echo
git push
echo
echo -e '\E[1;32m'"Выполнена команда: git push"
tput sgr0 

echo
read -p "Нажмите ENTER чтобы закрыть окно"
