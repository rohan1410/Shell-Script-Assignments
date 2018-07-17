#!/bin/sh
echo "Enter two numbers"
read x  #Taking first number as input
read y  #Taking second number as input
echo "Sum = "$(expr "$x" + "$y")
echo "Difference = "$(expr "$x" - "$y")
echo "Product = "$(($x*$y))
echo "Quotient = "$(($x/$y))
