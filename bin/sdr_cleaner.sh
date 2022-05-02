#!/bin/bash
(
IFS=$'\n'
sdrpath="/mnt/us/documents"
sdrFileCount=0

deleteSingleFolder(){
	sinleFolder=$(find $1 -type d  | grep -v ".sdr")
	for i in ${sinleFolder[@]}; do
		if [ "$(ls -A $i)" ]; then
			deleteFile $i
		else
			echo $i "is an empty folder, delete"
			rm -rf $i
		fi
	done
}

deleteFile(){
	filePath=$1
	sdrList=$(find $filePath -maxdepth 1 -type d -name "*.sdr" | sed 's/\.[^.]*$//')
	fileList=$(find $filePath -maxdepth 1  -type f | sed 's/\.[^.]*$//' )


	for host in ${fileList[@]}; do
		sdrList=( "${sdrList[@]/"$host"}" )
	done

	finleList=()
	for i in $sdrList; do
		finleList+=($i.sdr)
	done
	
	# list size > 0
	sdrFileCount=${#finleList[@]}
	if [ $sdrFileCount -gt 0 ]
	then
		printMsg="delete $sdrFileCount folder -> "${finleList[@]}
		echo $printMsg
		rm -rf ${finleList[@]}
	fi

}



echo "start delete sdr folder"
deleteFile $sdrpath
if [ $sdrFileCount -eq 0 ]
then
echo "not find sdr folder"
else
echo "delete folder success"
fi


echo "start delete single folder"
deleteSingleFolder $sdrpath
if [ $sdrFileCount -eq 0 ]
then
echo "not find single folder"
else
echo "delete single folder success"
fi


)