#! /bin/bash

committer_list="440_F_DeveloperList_Alphabetic.txt"
file_list="440_F_FileList.txt"

declare -A names

# print commiter names in the first line
declare -i index
index=0
while IFS= read -r name
do
	names["\"$name\""]=$index
	((index++))
done < "$committer_list"


# Construct adj matrix
declare -i column_number
declare -i row_number

initializeMatrix()
{
	local index=0
	local total=$(($row_number * $column_number))

	while [ "$index" -lt "$total" ]
	do    
		AdjMatrix[$index]=0
		let "index += 1"
	done  

}

printMatrix()
{
	local index=0
	for ((r=0; r<row_number;r++))
	do
		for ((c=0; c<column_number; c++))
		do
			let "index = $r*$column_number + $c"
			echo -n "${AdjMatrix[$index]} "
		done
		echo ""
	done
}

printRow()	#$1:row
{
	local index=0
	
		for ((c=0; c<column_number; c++))
		do
			let "index = $1*$column_number + $c"
			echo -n "${AdjMatrix[$index]} "
		done
		echo ""
}

modifyValue()	## row col value
{
	local index=0
	let "index = $1*$column_number + $2"
	AdjMatrix["$index"]=$3
}

# for each file in the list, check its collaborators
declare -i row_count
declare -i temp
declare -i constant_v

row_count=0
temp=0
constant_v=1


declare -a AdjMatrix

row_number=1
column_number=${#names[@]}



while IFS= read -r item
do
	
	initializeMatrix
 
	while read n;
	do 
		temp=${names[$n]}
		
		modifyValue 0 ${names[$n]} 1
 		
	done <<<"$(git log  --pretty=format:\"%cn\" -- $item | sort | uniq )"
	
	printRow 0

	
done < "$file_list"

