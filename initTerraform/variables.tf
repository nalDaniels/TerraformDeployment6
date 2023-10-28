##### VARIABLES FOR PROVIDER BLOCK #####
variable "aws_access_key" {}
variable "aws_secret_key" {}

##### VARIABLES FOR VPC BLOCK #####
variable "vpcname1" {} 
variable "vpcname2" {} 

##### VARIABLES FOR SUBNET BLOCK #####
variable "subnet1name" {} 
variable "subnet1AZ" {} 
variable "subnet2name" {}
variable "subnet2AZ" {} 
variable "subnet3name" {}
variable "subnet3AZ" {} 
variable "subnet4name" {}
variable "subnet4AZ" {} 



##### VARIABLES FOR SECURITY GROUP BLOCK #####
variable "SGNameEast" {} 
variable "SGNameWest" {} 



##### VARIABLES FOR INTERNET GATEWAY BLOCK #####
variable "IGNameEast" {} 
variable "IGNameWest" {} 

##### VARIABLES FOR ROUTE TABLE BLOCK #####
variable "RTnameEast" {} 
variable "RTnameWest" {} 



##### VARIABLES FOR INSTANCE BLOCK #####
variable "ami1" {} 
variable "ami2" {} 
variable "instance_type" {} 
variable "key_name1" {} 
variable "key_name2" {} 
variable "InstanceName1" {} 
variable "InstanceName2" {} 
variable "InstanceName3" {} 
variable "InstanceName4" {} 


