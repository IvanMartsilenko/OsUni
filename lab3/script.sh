dir=my_virtual_dir

home_path=/mnt/DATA/projects-in-progress/uni/operation-systems/bash-scripting

virtdir=$home_path/$dir

script_path=/mnt/DATA/projects-in-progress/uni/operation-systems/processes_threads

R=12

N1=2
N2=2

r1=10
r2=12

a1=9
a2=11
a3=5
a4=6

t1=-9
t2=-8

folder=folder

function check()
{
	if [[ ! -e $1 ]] ; then
		mkdir $1
	elif [[ ! -d $1 ]] ; then
		echo "$1 already exists but is not a directory" 1>&2
	fi
	return 0
}


function recur_dirs ()
{
	counter=1
	while true
	do
		mkdir -p ./$counter$folder
		cd ./$counter$folder
		counter=$((counter + 1))
		if [[ $counter -gt $1 ]] ; then
			break 
		fi
	done
}


function get_dir ()
{
	cd $virtdir
	counter=1
	while true;
	do
		cd ./$counter$folder
		counter=$((counter + 1))
		if [[ $counter -gt $1 ]] ; then
			break
		fi
	done
}


function start_script()
{
	get_dir $1
	sudo dd if=/dev/urandom of=./file bs=4 count=10000 1>/dev/null 2>/dev/null
	$2 $3 1>/dev/null
	rm file
}

function create_archive()
{
	get_dir $1
	# echo `pwd`
	tar -czf archive_from_$1_on_$2_level.tar.gz *.txt
	#rm *txt
	mv archive_from_$1_on_$2_level.tar.gz ../
}


function sort_and_locate()
{
	get_dir $1
	locate $2
	destination=`pwd`
	get_dir $1
	cat ./*.txt > input.txt 
	sort -nr -o $destination/output$1.txt input.txt
	rm input.txt
}

function locate()
{
	counter=$1
	if [[ $counter -gt 0 ]] ; then
		curr_dir=${PWD##*/}
		curr_dir_nb=`cut -b 1,2 $curr_dir`
		counter=`expr $curr_dir_nb + $1`
		get_dir $counter
	elif [[ $counter -lt 0 ]] ; then
		while true ;
		do
			cd ..
			counter=$((counter + 1))
			if [[ $counter -eq 0 ]] ; then
				break
			fi
		done
	fi
}


function add_file_to_archive()
{
	loc=`find $virtdir -iname *output$1.txt`
	archive_loc=`find $virtdir -iname *archive_from_$1_*.tar.gz`
	get_dir $1
	dest=`pwd`
	# echo $loc
	# echo $archive_loc
	tar -xzf $archive_loc 2>/dev/null
	rm $archive_loc
	mv $loc .
	tar -C ./ -czf $dest/archive_from_$1_on_$2_level.tar.gz *.txt 2>/dev/null
	mv $dest/archive_from_$1_on_$2_level.tar.gz ../
}


function extract_archive()
{
	get_dir $2
	destin=`pwd`
	archive_location=`find $virtdir -iname archive_from_*_on_$1_level.tar.gz`
	# echo $destin
	tar -xzf $archive_location -C $destin 2>/dev/null
	# ls -ClR
}

function finish()
{
	echo ""
	echo ""
	echo ""
	echo -e "\e[1m\e[94m=========== Script has just finished its work! Thanks for coming :) ===========\e[21m"
	echo " "
	echo -e "\e[38;5;198m============== Here the recent locations of involved archives : ==============\e[93m"
	find $virtdir -iname archive_from_*.tar.gz
	echo ""
	echo -e "\e[38;5;198m========================== Final content of archives =========================="
	echo ""
	echo -e "\e[38;5;198m======== First : \e[96m"
	tar -tf $virtdir/1folder/2folder/3folder/4folder/5folder/6folder/7folder/8folder/9folder/10folder/11folder/archive_from_12_on_11_level.tar.gz
	echo ""
	echo -e "\e[38;5;198m======== Second : \e[96m"
	tar -tf $virtdir/1folder/2folder/3folder/4folder/5folder/6folder/7folder/8folder/9folder/archive_from_10_on_9_level.tar.gz
	echo -e "\e[39m"
}


function main()
{
	check $dir

	if [[ -e $dir ]]; then
		cd $dir
	fi

	PWD=`pwd`
	recur_dirs $R

	start_script $r1 $script_path/processes_implementation.py $N1
	start_script $r2 $script_path/threads_implementation.py $N2

	create_archive $r1 $a1
	create_archive $r2 $a2

	sort_and_locate $r1 $t1
	sort_and_locate $r2 $t2

	add_file_to_archive $r1 $a1
	add_file_to_archive $r2 $a2

	extract_archive $a1 $a3
	extract_archive $a2 $a4
	finish
}



main
