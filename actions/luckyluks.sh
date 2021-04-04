path="$1"
path_mount="/tmp/cry"

if ! [ -d "$path_mount" ]
	then
		mkdir "$path_mount"
	fi

x-terminal-emulator -e bash -c "sudo cryptsetup luksOpen $path volume2; sudo mount /dev/mapper/volume2 \"$path_mount\"; read -p \"Нажмите ENTER чтобы закрыть окно и отмонтировать контейнер\"; sudo umount -l \"$path_mount\"; sudo cryptsetup luksClose volume2"


