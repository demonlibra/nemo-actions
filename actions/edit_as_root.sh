#!/bin/bash

# В качестве редактора будет выбран первый из найденных в списке
if whereis -u geany				# моя прелесть )
	then editor="geany"
elif whereis -u xed				# cinnamon
	then editor="xed"
elif whereis -u gedit			# gnome
	then editor="gedit"
elif whereis -u mousepad		# xfce
	then editor="mousepad"
elif whereis -u pluma			# mate
	then editor="pluma"
elif whereis -u leafpad			# lxde
	then editor="leafpad"
elif whereis -u kate			# kde
	then editor="kate"
elif whereis -u featherpad
	then editor="featherpad"
elif whereis -u notepadqq
	then editor="notepadqq"
fi

# В следующей строке можно удалить символ # и указать команду запуска своего редактора
#editor="команда_запуска_редактора"

pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY "$editor" "$@"
