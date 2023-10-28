##### VARIABLES FOR PROVIDER BLOCK #####
aws_access_key = ""
aws_secret_key = ""


##### VARIABLES FOR VPC BLOCK #####
vpcname1 = "deployment6vpc-east"
vpcname2 = "deployment6vpc-west"

##### VARIABLES FOR SUBNET BLOCK #####
subnet1name = "publicsubnet1-east"
subnet1AZ = "us-east-1a"
subnet2name = "publicsubnet2-east"
subnet2AZ = "us-east-1b"
subnet3name = "publicsubnet3-west"
subnet3AZ = "us-west-2a"
subnet4name = "publicsubnet4-west"
subnet4AZ = "us-west-2b"





##### VARIABLES FOR SECURITY GROUP BLOCK #####
SGNameEast =  "gunicornSG-east"
SGNameWest =  "gunicornSG-west" 




##### VARIABLES FOR INTERNET GATEWAY BLOCK #####
IGNameEast = "d6IG-East"
IGNameWest = "d6IG-West"

##### VARIABLES FOR ROUTE TABLE BLOCK #####
RTnameEast = "d6RT-East"
RTnameWest = "d6RT-West"



##### VARIABLES FOR INSTANCE BLOCK #####
ami                    = "ami-053b0d53c279acc90"
instance_type =  "t2.micro"
key_name               = "D5.1Key"
InstanceName1 = "applicationServer01-east"
InstanceName2 = "applicationServer02-east"
InstanceName3 = "applicationServer01-west"
InstanceName4 = "applicationServer02-west"


