#! /bin/bash

topfile_list="440_F_FilesCommitCounts_sorted.txt"
developer_list="440_F_DeveloperList_Numeric.txt"

declare -i total_commit
total_commit="$(git rev-list --all --count)"


findTopDevelopers(){ #$1=total_commit, $2=%x
	declare -i thresold
	declare -i temp
	temp=0
	thresold=total_commit*$2/100


	while IFS= read -r line  #while read line;
	do
		current=$(echo $line | awk '{print $1}')
		percent=$(echo "$(echo "($current*100)/$total_commit" | bc -l)" | awk '{printf "%.10f\n",$1}')
		
		temp=$(($temp+$current))		
		dev=$(echo $line | awk '{ for(i=2; i<NF; i++) printf "%s ", $i OFS; if(NF) printf "%s",$NF; printf ORS}')
		echo -e $percent '\t' $dev
		
		if [ $temp -ge $thresold ]
		then
			break
		fi
	done < "$developer_list"  #<<<"$(git log --pretty=format:\"%cn\" | sort | uniq --count | sort -nr)"
}

findTopFiles(){
	declare -i thresold
	declare -i temp
	temp=0
	thresold=total_commit*$2/100


	while IFS= read -r line
	do
		#echo $line
		#echo "$(git log --oneline -- $line | wc -l)" $line
		current=$(echo $line | awk '{print $1}')
		percent=$(echo "$(echo "($current*100)/$total_commit" | bc -l)" | awk '{printf "%.10f\n",$1}')
		
		temp=$(($temp+$current))		
		dev=$(echo $line | awk '{ for(i=2; i<NF; i++) printf "%s ", $i OFS; if(NF) printf "%s",$NF; printf ORS}')
		echo -e $percent '\t' $dev
		
		if [ $temp -ge $thresold ]
		then
			break
		fi
		
	done < "$topfile_list"

}




#findTopDevelopers $total_commit 80

findTopFiles $total_commit 80


