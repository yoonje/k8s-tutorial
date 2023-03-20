#!/bin/bash

count=0

while :
do
	curl $1:80 > /dev/null 2>&1

	if [ `expr $count % 100` -eq 0 ]
	then
		echo $count
	fi
	((count++))
done
