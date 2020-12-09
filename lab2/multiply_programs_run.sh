#!/bin/bash

if (($# == 0)); then
    echo "Usage: ./multiply_programs_run.sh -flag {argument}"
    echo "-p <program name>"
    echo "-f <filename1>"
    echo "-n <processes/threads number>.."
    exit 2
fi

counter=0
files_num=0

while getopts ":f:n:p:" opt; do
    case $opt in
    	p) PROGRAM=("$OPTARG") ;;
        f) files+=("$OPTARG") ; files_num=$((files_num + 1))
;;
		n) NUMBER_OF_PROCESSES="$OPTARG" ;;
    esac
done
shift $((OPTIND -1))

if [[ $files_num -gt 1 ]] ; then
	for fil in "${files[@]}"; do
		python3 $PROGRAM $fil &
	done
elif [[ $files_num -eq 1 ]] ; then
	while true;
	do
		python3 $PROGRAM $files &
		counter=$((counter + 1))
		if [[ $counter -eq $NUMBER_OF_PROCESSES ]] ; then
			break ;
			fi
		done
fi
