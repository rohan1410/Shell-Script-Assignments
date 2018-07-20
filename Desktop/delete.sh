#!/bin/sh
#
#
while read -r line; do declare  $line; done <details
#
#
#
#Deleting NAT GATEWAY
echo "Deleting NAT GATEWAY...."
aws ec2 delete-nat-gateway \
--nat-gateway-id $NAT_GW_ID \
--region $aws_region
#
#
#
#Checking for the NAT GATEWAY TO BE DELETED
SECONDS=0
LAST_CHECK=0
CHECK_FREQUENCY=5 
STATE='deleting'
until [[ $STATE == 'deleted' ]]; do
  INTERVAL=$SECONDS-$LAST_CHECK
  if [[ $INTERVAL -ge $CHECK_FREQUENCY ]]; then
    STATE=$(aws ec2 describe-nat-gateways \
      --nat-gateway-ids $NAT_GW_ID \
      --query 'NatGateways[*].{State:State}' \
      --output text \
      --region $aws_region)
    STATE=$(echo $STATE | tr '[:upper:]' '[:lower:]')
    LAST_CHECK=$SECONDS
    echo "Please wait .... in progress "
  fi
  SECS=$SECONDS
  sleep 1
done
echo "NAT GATEWAY ID '$NAT_GW_ID' is now deleted."
#
#Releasing EIP
echo "Releasing EIP"
aws ec2 release-address --allocation-id $EIP_ALLOC_ID
#
#Deleting public subnet
echo "Deleting Public Subnet"
aws ec2 delete-subnet --subnet-id $subnet_public_id --region $aws_region
#
#Deleting subnet1
echo "Deleting Private Subnet1 and Isolated Subnet" 
aws ec2 delete-subnet --subnet-id $subnet_private_id1 --region $aws_region
aws ec2 delete-subnet --subnet-id $subnet_isolated_id1 --region $aws_region
#
#Deleting subnnet2
echo "Deleting Private Subnet2 and Isolated Subnet2"
aws ec2 delete-subnet --subnet-id $subnet_private_id2 --region $aws_region
aws ec2 delete-subnet --subnet-id $subnet_isolated_id2 --region $aws_region
#
#Deleting subnet3
echo "Deleting Private Subnet3 and Isolated Subnet3"
aws ec2 delete-subnet --subnet-id $subnet_private_id3 --region $aws_region
aws ec2 delete-subnet --subnet-id $subnet_isolated_id3 --region $aws_region
#
#Deleting Route-table
echo "Deleting Route Table"
aws ec2 delete-route-table --route-table-id $ROUTE_PRIVATE_TABLE_ID
aws ec2 delete-route-table --route-table-id $ROUTE_PUBLIC_TABLE_ID 
#
#Detaching Internet Gateway
echo "Detaching Internet Gateway"
aws ec2 detach-internet-gateway --internet-gateway-id $igw_id --vpc-id $vpc_id
#
#Deleting Internet Gateway
echo "Deleting Internet Gateway"
aws ec2 delete-internet-gateway --internet-gateway-id $igw_id
#
#Deleting VPC
echo "Deleting VPC"
aws ec2 delete-vpc --vpc-id $vpc_id 
#Deleting details file
echo "Deleting details file "
[ -e details ] && rm details
