#!/bin/bash

check_disk_usage(){
df_output=$(df -h | grep wamedia | sed 's/.* \([0-9]*\)% .*/\1/g')
echo $df_output
}

cleanup_month_logic(){
current_month=$(date '+%b')
all_month_data=$(ls -ltr | awk 'NR>1{print $6}' | sort| uniq)

	for i in $all_month_data
	do
        	if [ "$i" != "$current_month" ]
        	then
        	datain=$(ls -ltr | grep -e "$i" | grep -v grep | awk '{print $9}')
        	rm -rf $datain
        	fi
	done
	
	

}

cleanup_day_logic(){
current_day=$(date '+%D %T')
datain=$(ls -ltr | grep -v -e "$current_day" | grep -v grep | awk '{print $9}')
rm -rf $datain
}


if [ "$(check_disk_usage)" -gt "60" ]
then
	echo "$(date '+%D %T') - clean up older month data in /usr/local/wamedia/shared"
	cd /usr/local/wamedia/shared
	cleanup_month_logic
	echo "$(date '+%D %T') - clean up activity is completed with /usr/local/wamedia/shared"
	echo "$(date '+%D %T') - clean up older month data in /usr/local/wamedia/outgoing/sent"
	cd /usr/local/wamedia/outgoing/sent
	cleanup_month_logic
	echo "$(date '+%D %T') - clean up activity is completed with /usr/local/wamedia/outgoing/sent"
	echo "$(date '+%D %T') - checking disk usage on server again"
		if [ "$(check_disk_usage)" -gt "60" ]
		then
		echo "$(date '+%D %T') - clean up older days data in /usr/local/wamedia/shared"
		cd /usr/local/wamedia/shared
		cleanup_day_logic
		echo "$(date '+%D %T') - clean up day activity is completed with /usr/local/wamedia/shared"
		echo "$(date '+%D %T') - clean up older days data in /usr/local/wamedia/outgoing/sent"
		cd /usr/local/wamedia/outgoing/sent
		echo "$(date '+%D %T') - clean up day activity is completed with /usr/local/wamedia/outgoing/sent"
		else
		echo "$(date '+%D %T') - disk usage is under control value is $(check_disk_usage) day"
		fi
else
	echo "$(date '+%D %T') - disk usage is under control value is $(check_disk_usage)"
fi
