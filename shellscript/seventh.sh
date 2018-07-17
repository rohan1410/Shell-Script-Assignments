#!/bin/sh
echo "Prime Numbers are"
echo "2"
for x in `seq 3 100`  #Looping from 3 to 100
do
 	flag=0
	temp=$((x-1))
  	for i in `seq 2 $temp`  #Looping from 2 to x
    	do
       		if [ $((x%i)) -eq 0 ]; then    #Check if any number is divisible
	 		flag=1
	 		break
       		fi
    	done
  	if [ "$flag" -eq 0 ]; then  #If no number is divisible then print
     		echo "$x"
  	fi
done


