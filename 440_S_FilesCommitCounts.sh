#! /bin/bash

file_list="440_F_FileList.txt"

findCommitCountOfFiles(){

	while IFS= read -r line
	do
		#echo $line
		echo "$(git log --oneline -- $line | wc -l)" $line
	done < "$file_list"
}

findCommitCountOfFiles
