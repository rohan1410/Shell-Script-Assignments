#!/bin/sh
#
#Input Details
aws_region="us-east-2"
vpc_block="16"
subnet_block="20"
vpc_name="PE_RM"
echo "Enter the region code you want to enter your vpc:"
read aws_region
echo "Enter the CIDR BLOCK NUMBER for VPC:"
read vpc_block
echo "Enter the SUBNET BLOCK NUMBER for VPC:"
read subnet_block
echo "Enter the VPC name:"
read vpc_name 
#
#
#Creating VPC and getting VPC id
vpc_cidr="10.0.0.0/$vpc_block"
echo "Creating VPC with given in preferred region with VPC CIDR: $vpc_cidr"
vpc_id=$(aws ec2 create-vpc \
  --cidr-block $vpc_cidr \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text \
  --region $aws_region)
#
#
#Add name tag to VPC
aws ec2 create-tags \
  --resources $vpc_id \
  --tags "Key=Name,Value=$vpc_name" \
  --region $aws_region
echo "  VPC ID '$vpc_id' NAMED as '$vpc_name'."
#
#Create Public Subnet
echo "Creating Public Subnet..."
SUBNET_PUBLIC_AZ1="us-east-2a"
SUBNET_PUBLIC_AZ2="us-east-2b"
SUBNET_PUBLIC_AZ3="us-east-2c"
SUBNET_PUBLIC_CIDR="10.0.0.0/$subnet_block"
subnet_public_id=$(aws ec2 create-subnet \
  --vpc-id $vpc_id \
  --cidr-block $SUBNET_PUBLIC_CIDR \
  --availability-zone $SUBNET_PUBLIC_AZ1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $aws_region)
#
#
#Add tags to public subnet
aws ec2 create-tags \
  --resources $subnet_public_id \
  --tags "Key=Name,Value=${vpc_name}_publicsubnet" \
  --region $aws_region
#
#
#Create Private Subnet 1
temp=$((24-$subnet_block))
id1=$((2**$temp))
echo "Creating Private and Isolated Subnet 1..."
SUBNET_PUBLIC_CIDR="10.0.$id1.0/$subnet_block"
subnet_private_id1=$(aws ec2 create-subnet \
  --vpc-id $vpc_id \
  --cidr-block $SUBNET_PUBLIC_CIDR \
  --availability-zone $SUBNET_PUBLIC_AZ1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $aws_region)
#
#
#Add tags to private subnet 1
aws ec2 create-tags \
  --resources $subnet_private_id1 \
  --tags "Key=Name,Value=${vpc_name}_privatesubnet1" \
  --region $aws_region
#
#
#Create Isolated Subnet 1
id=$(($id1+$id1))
SUBNET_PUBLIC_CIDR="10.0.$id.0/$subnet_block"
subnet_isolated_id1=$(aws ec2 create-subnet \
  --vpc-id $vpc_id \
  --cidr-block $SUBNET_PUBLIC_CIDR \
  --availability-zone $SUBNET_PUBLIC_AZ1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $aws_region)
#
#
#Add tags to isolate subnet1
aws ec2 create-tags \
  --resources $subnet_isolated_id1 \
  --tags "Key=Name,Value=${vpc_name}_isolatedsubnet1" \
  --region $aws_region
#
#
#Create Private Subnet 2
id=$(($id+$id1))
echo "Creating Private and Isolated Subnet 2..."
SUBNET_PUBLIC_CIDR="10.0.$id.0/$subnet_block"
subnet_private_id2=$(aws ec2 create-subnet \
  --vpc-id $vpc_id \
  --cidr-block $SUBNET_PUBLIC_CIDR \
  --availability-zone $SUBNET_PUBLIC_AZ2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $aws_region)
#
#
#Add tags to private subnet 2
aws ec2 create-tags \
  --resources $subnet_private_id2 \
  --tags "Key=Name,Value=${vpc_name}_privatesubnet2" \
  --region $aws_region
#
#
#Create Isolated Subnet 2
id=$(($id+$id1))
SUBNET_PUBLIC_CIDR="10.0.$id.0/$subnet_block"
subnet_isolated_id2=$(aws ec2 create-subnet \
  --vpc-id $vpc_id \
  --cidr-block $SUBNET_PUBLIC_CIDR \
  --availability-zone $SUBNET_PUBLIC_AZ2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $aws_region)
#
#
#Add tags to isolated subnet 2
aws ec2 create-tags \
  --resources $subnet_isolated_id2 \
  --tags "Key=Name,Value=${vpc_name}_isolatedsubnet2" \
  --region $aws_region
#
#Create Private Subnet 3
id=$(($id+$id1))
echo "Creating Private and Isolated Subnet 3..."
SUBNET_PUBLIC_CIDR="10.0.$id.0/$subnet_block"
subnet_private_id3=$(aws ec2 create-subnet \
  --vpc-id $vpc_id \
  --cidr-block $SUBNET_PUBLIC_CIDR \
  --availability-zone $SUBNET_PUBLIC_AZ2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $aws_region)
#
#
#
#
#Add tags to public subnet
aws ec2 create-tags \
  --resources $subnet_private_id3 \
  --tags "Key=Name,Value=${vpc_name}_privatesubnet3" \
  --region $aws_region
#
#
#Create Isolated Subnet 3
id=$(($id+$id1))
SUBNET_PUBLIC_CIDR="10.0.$id.0/$subnet_block"
subnet_isolated_id3=$(aws ec2 create-subnet \
  --vpc-id $vpc_id \
  --cidr-block $SUBNET_PUBLIC_CIDR \
  --availability-zone $SUBNET_PUBLIC_AZ2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $aws_region)
#
#
#
#
#Add tags to public subnet
aws ec2 create-tags \
  --resources $subnet_isolated_id3 \
  --tags "Key=Name,Value=${vpc_name}_isolatedsubnet3" \
  --region $aws_region
#
#
#
# Create Internet gateway
echo "Creating Internet Gateway..."
igw_id=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
  --output text \
  --region $aws_region)
echo "  Internet Gateway ID '$igw_id' CREATED."
#
#
#
# Attach Internet gateway to your VPC
aws ec2 attach-internet-gateway \
  --vpc-id $vpc_id \
  --internet-gateway-id $igw_id \
  --region $aws_region
echo "  Internet Gateway ID '$igw_id' ATTACHED to VPC ID '$vpc_id'."
#
#
#
# Create Private Route Table
echo "Creating Route Table..."
ROUTE_PRIVATE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $vpc_id \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region $aws_region)
echo "  Route Table ID '$ROUTE_TABLE_ID' CREATED."
#
#
#
# Create Public Route Table
echo "Creating Route Table..."
ROUTE_PUBLIC_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $vpc_id \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region $aws_region)
echo "  Route Table ID '$ROUTE_TABLE_ID' CREATED."
#
#
#
# Allocate Elastic IP Address for NAT Gateway
echo "Creating NAT Gateway..."
EIP_ALLOC_ID=$(aws ec2 allocate-address \
  --domain vpc \
  --query '{AllocationId:AllocationId}' \
  --output text \
  --region $aws_region)
echo "  Elastic IP address ID '$EIP_ALLOC_ID' ALLOCATED."
#
#
#
# Create NAT Gateway
NAT_GW_ID=$(aws ec2 create-nat-gateway \
  --subnet-id $subnet_public_id \
  --allocation-id $EIP_ALLOC_ID \
  --query 'NatGateway.{NatGatewayId:NatGatewayId}' \
  --output text \
  --region $aws_region)
#
#
#
#
SECONDS=0
LAST_CHECK=0
CHECK_FREQUENCY=5
STATE='pending'
until [[ $STATE == 'available' ]]; do
  INTERVAL=$SECONDS-$LAST_CHECK
  if [[ $INTERVAL -ge $CHECK_FREQUENCY ]]; then
    STATE=$(aws ec2 describe-nat-gateways \
      --nat-gateway-ids $NAT_GW_ID \
      --query 'NatGateways[*].{State:State}' \
      --output text \
      --region $aws_region)
    STATE=$(echo $STATE | tr '[:upper:]' '[:lower:]')
    LAST_CHECK=$SECONDS
    echo "Please wait....in progress"
  fi
  SECS=$SECONDS
  sleep 1
done
echo "NAT GATEWAY ID '$NAT_GW_ID' is now available."
#
#
#
# Create route to INTERNET GATEWAY
RESULT=$(aws ec2 create-route \
  --route-table-id $ROUTE_PUBLIC_TABLE_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $igw_id \
  --region $aws_region)
#
#
#
# Associate Public Subnet with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $subnet_public_id \
  --route-table-id $ROUTE_PUBLIC_TABLE_ID \
  --region $aws_region)

#
#
#
# Create route to NAT GATEWAY
RESULT=$(aws ec2 create-route \
  --route-table-id $ROUTE_PRIVATE_TABLE_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $NAT_GW_ID \
  --region $aws_region)
#
#
#
# Associate Private Subnet 1 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $subnet_private_id1 \
  --route-table-id $ROUTE_PRIVATE_TABLE_ID \
  --region $aws_region)
#
#
#
# Associate Private Subnet 2 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $subnet_private_id2 \
  --route-table-id $ROUTE_PRIVATE_TABLE_ID \
  --region $aws_region)
#
#
#
# Associate Private Subnet 3 with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $subnet_private_id3 \
  --route-table-id $ROUTE_PRIVATE_TABLE_ID \
  --region $aws_region)
#
#
#
# Entering data into the file
echo "aws_region=$aws_region" >> details
echo "vpc_id=$vpc_id" >> details
echo "subnet_public_id=$subnet_public_id" >> details
echo "subnet_private_id1=$subnet_private_id1" >> details
echo "subnet_isolated_id1=$subnet_isolated_id1" >> details
echo "subnet_private_id2=$subnet_private_id2" >> details
echo "subnet_isolated_id2=$subnet_isolated_id2" >> details
echo "subnet_private_id3=$subnet_private_id3" >> details
echo "subnet_isolated_id3=$subnet_isolated_id3" >> details
echo "igw_id=$igw_id" >> details
echo "ROUTE_PRIVATE_TABLE_ID=$ROUTE_PRIVATE_TABLE_ID" >> details
echo "ROUTE_PUBLIC_TABLE_ID=$ROUTE_PUBLIC_TABLE_ID" >> details
echo "NAT_GW_ID=$NAT_GW_ID" >> details
echo "EIP_ALLOC_ID=$EIP_ALLOC_ID" >> details
