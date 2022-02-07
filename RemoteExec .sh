#!/bin/bash

#tput clear

START=$(date +%s)
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"

# Создаем лог-файл
touch log

# Цикл для 3-го октета
for ((a=1; a < 2; a++))
do
	# Цикл для 4-го октета
	for ((b=1; b < 254; b++))
	do
		clear
		tail log
		echo "Проверка доступности 192.168.$a.$b"
		# Проверка доступности хоста
		ping -c1 192.168.$a.$b > /dev/null
		if [ $? -eq 0 ]
		then
			clear
			tail log
                        $SETCOLOR_SUCCESS
                        echo -n "192.168.$a.$b доступен"
                        echo -n "192.168.$a.$b доступен" >> log
                        $SETCOLOR_NORMAL
                        echo
			echo "Подключение и выполнение скрипта"
			# Подключение по SSH и запуск выбранного скрипта на выполнение
			# Для корректной работе, на запускаемой машине должен быть установлен sshpass
			sshpass -p 'i$tG4*sor1L981+' ssh root@192.168.$a.$b -p 22 'bash -s' < CommandScrits.sh
			if [ $? -eq 0 ]; then
				$SETCOLOR_SUCCESS
				echo -n "192.168.$a.$b скрипт выполнен"
				echo -n ", скрипт выполнен" >> log
				echo -e "" >> log
				$SETCOLOR_NORMAL
			else
				$SETCOLOR_FAILURE
				echo -n "192.168.$a.$b ошибка"
				echo -n ", ошибка выполнения" >> log
				echo -e "" >> log
				$SETCOLOR_NORMAL
				echo
			fi
#			echo -n "${reset}"
		else
			clear
			tail log
                        $SETCOLOR_FAILURE
                        echo -n "192.168.$a.$b не доступен"
                        $SETCOLOR_NORMAL
			echo "192.168.$a.$b"
		fi
	done
done
END=$(date +%s)
TIMEsec=$(( $END - $START ))
clear
tail log
echo -e "\nОперация завершена. Хосты с успешным выполнением сохранены в лог"
echo -e "Время работы $TIMEsec сек."
