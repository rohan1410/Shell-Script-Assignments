#!/bin/sh
echo "Enter three lengths of triangle"
read s1 s2 s3     #Read sides of triangle
if [ $((s1+s2)) -lt $s3 ] || [ $((s1+s3)) -lt $s2 ] || [ $((s2+s3)) -lt $s1 ]; then  #Invalid triangle conditions
echo "Enter Valid lengths"
elif [ $s1 -eq $s2 ] && [ $s1 -eq $s3 ]; then   #All sides equal
echo "Equilateral triangle"
elif [ $s1 -eq $s2 ] || [ $s2 -eq $s3 ] || [ $s1 -eq $s3 ]; then   #any two sides equal
echo "Isosceles triangle"
else
echo "Scalene triangle"
fi
