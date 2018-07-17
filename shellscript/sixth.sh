# !/bin/bash
echo "enter a number"
read num  #Enter number
fact=1
while [ $num -gt 1 ] #Loop until num greater than 1
do
fact=$(($fact * $num))  
num=$((num-1))
done
echo "factorial of $n is $fact" #Result of the factorial
