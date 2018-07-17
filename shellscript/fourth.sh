#!/bin/sh
echo "What is your name?"
read name   #Taking input
echo "I will create a file named ${name}_file"
touch ${name}_file     #Creating File
echo "Enter a sentence to type in the file"
read line   #Read line
#echo $line
echo $line > ${name}_file #Entering line

