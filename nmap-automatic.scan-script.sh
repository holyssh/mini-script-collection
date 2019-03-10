#!/bin/bash


if [ "$#" -eq 1 ]; then
	
	delete_unwanted_symbols(){
		sed=`whereis sed |cut -d " " -f 2`
		echo $1 | $sed "s/\./\-/g"  
	}
	
	check_and_make_directory(){
		dir="$HOME/nmap_pentest_scans/"
		dir="$dir$(delete_unwanted_symbols "$1")"
		mkdir=`whereis mkdir |cut -d " " -f 2`
		if [ ! -d "$dir" ]; then
			echo -e "\nDirectory \"$dir\" doesn't exist, will be created\n"
			eval $($mkdir "-p" $dir)
		else
			echo -e "\nDirectory \"$dir\" still exists\n"
		fi	
	}
			
	host_is_online(){
		ping=`whereis ping |cut -d " " -f 2`
		$ping -c 1 -w 5 $1 &> /dev/null
		if [ $? -eq 0 ]; then
			echo "0"

		else
			echo "-1"
		fi
	}
	
	nmap_task(){
		echo -e "nmap is starting with 5 scans (3 TCP and 2 UDP)\n"
		echo -e "Results will be logged in a separate file for each scan in directory $dir"
		nmap=`whereis nmap |cut -d " " -f 2` 
		declare -a scans
		scans[0]="$nmap -sS $1 -O -Pn -sV -A -T4 -p- -vvv > $dir/nmap_full_scan-target-$(delete_unwanted_symbols "$1").txt &"
		scans[1]="$nmap -sS $1 -O -Pn -T4 -vvv > $dir/nmap_tcp_quick_scan-target-$(delete_unwanted_symbols "$1").txt &" 
		scans[2]="$nmap -sV $1 -oA bookversionnmap -vvv > $dir/nmap_tcp_bookversionnmap_scan-target-$(delete_unwanted_symbols "$1").txt &"
		scans[3]="$nmap -sU $1 -oA bookudp -vvv > $dir/nmap_udp_bookudp_scan-target-$(delete_unwanted_symbols "$1").txt &"
		scans[4]="$nmap -sUV -F $1 -p- -Pn -T4 -vvv > $dir/nmap_udp_scan_full-target-$(delete_unwanted_symbols "$1").txt &"
		
		for command in "${!scans[@]}"; 
		do 
			echo "Running Scan $(($command+1))/${#scans[@]} : ${scans[command]}" 
			eval ${scans[command]} 
		done 
	}
	
	if [ $(host_is_online "$1") -eq "0" ]; then
		check_and_make_directory "$1"
		nmap_task $1 $dir
	else
		echo "Host $1 is down or not reachable from this machine"
	fi	

else
	echo -e "Missing parameter\nUsage example : nmap.sh <ip>"
fi
