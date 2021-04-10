#!/bin/bash


if whereis -u geany
	then editor="geany"
elif whereis -u xed
	then editor="xed"
elif whereis -u gedit
	then editor="gedit"
elif whereis -u leafpad
	then editor="leafpad"
elif whereis -u featherpad
	then editor="featherpad"
elif whereis -u notepadqq
	then editor="notepadqq"
elif whereis -u mousepad
	then editor="mousepad"
fi

pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY $editor "$@"
