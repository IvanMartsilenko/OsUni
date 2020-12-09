#!/bin/bash

INPUT_FILE=$2
NUMBER_OF_PROCESSES=$1

counter=0

while true;
do
	python3 start_process.py $INPUT_FILE &
	counter=$((counter + 1))
	if [[ $counter -eq $NUMBER_OF_PROCESSES ]] ; then
		break ;
	fi
done

