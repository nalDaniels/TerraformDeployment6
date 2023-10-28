# Purpose:
To deploy a two-tier retail banking application across multiple regions using Terraform and Jenkins agents. I created infrastructure for Jenkins and ran a pipeline that not only provisioned infrastructure in us-east-1 and us-west-2 but also deployed the applications to 4 EC2 instances. Creating separate VPCs for Jenkins and the application enhances security, providing an opportunity to ensure that only authorized users have access to Jenkins. 

To achieve redundancy and fault-tolerance, each region had two instances of the application, where a Application Load Balancer distributed traffic, and an Amazon RDS database. This ensured that each application instance had a copy of the same data, so the experience was consistent. 

# Steps to Deployment:
## 1. Create Infrastructure for a Jenkins Manager and Jenkins Agent using Terraform
### Purpose:
Instead of having to manually specify what VPC I want to use for my Jenkins manager and agents, I can use Terraform, which smartly fills in the gaps when creating resources.

### Process:
I was installing Jenkins on an instance in my default VPC, so I only had to create 2 instances and associate them with previously created subnets and security groups in my main.tf file. Terraform would then understand that it needs to use the default settings. You can find my main.tf file here: https://github.com/nalDaniels/TerraformDeployment6/blob/main/main.tf


On the instance for the Jenkins manager, I installed the following packages: Software-properties-common, which helps manage different repositories or sources of packages
add-apt-repository -y ppa:deadsnakes/ppa, which allows us to install multiple versions of python
python3.7 and python3.7-venv, which installs python3.7 and the virtual environment package, build-essentials, which allows you to build applications on Linux systems,  libmysqlclient-dev, which installs the dependencies necessary for using a mySQL database, and python3.7-dev, which installs files required for running an application that uses python3.7. 

On the second instance, I installed Java, so it could function as a Jenkins agent and installed Terraform, so it could configure infrastructure. 

## 2. Create a Repository and Configure Infrastructure for the Application using Terraform
### Purpose:
Using Terraform allowed me to reuse and edit my main.tf files to deploy applications across multiple regions. I can use this same file to deploy to another region. 
### Process:
I created a second branch then created two main.tf files for the us-east-1 region and us-west-2 region. Each file or region had one VPC, an internet gateway, a route table, two availability zones, 2 public subnets, and 2 instances associated with a security group with ports open for ssh and gunicorn. 

I, then, inputted my user script into user data of the instances in both regions. The script installed the dependencies I previously used for the Jenkins manager, created and activated a virtual environment, cloned my repository, upgraded pip, installed the packages required to run the application, installed gunicorn and mysqlclient, ran the database program which created a database and loaded data into it. Finally, the script then started the gunicorn server and deployed the application. 

After completing the main.tf files, I added the files to my local repository's staging environment, commited the changes, merged them into my main branch, and pushed the files to Github

### Issues:
I ran terraform plan and apply before executing the Jenkins pipeline to check for errors. I got the following messages. 
<img width="825" alt="main tf error" src="https://github.com/nalDaniels/TerraformDeployment6/assets/135375665/044dcda8-7893-480a-a8c7-3bc66beeced8">

Since I had two main.tf files in the same directory, I had to create aliases for provider blocks for us-east-1 and us-west-2 and specify which region-associated provider block should be attached with the resources I was creating. 

<img width="864" alt="ami error" src="https://github.com/nalDaniels/TerraformDeployment6/assets/135375665/0e14cfed-2532-4d25-8e59-d66d84fc3d24">

I also got an error regarding the AMI and key pairs. I realized that they are region-specific, so I had to find the Ubuntu 22.04 LTS AMI for the us-west-2 region and create a key pair in that region. 

## 3. Create a RDS Database
### Purpose:
Previously my applications were not redundant since they did not have the same information across all instances. Creating a RDS database ensures that all applications have access to the same information.
### Process:
I created a MySQL database called mydatabase. It has public access, so that all of my instances outside of the VPC it was launched in can have access to it. Also, I pened port 3306 to take requests from the application servers. 

Then, I changed the information in the app.py, database.py, and load_data.py to point to the RDS database. 

## 4. Configure Jenkins and Run Pipeline
### Purpose:
To have the Jenkins and Terraform agent use the initTerraform directory to initialize a Terraform environment, show the configurations, and execute the plan. 

### Process:
I connected my agent node, awsDeploy, and added my AWS access and secret keys to my Jenkins credentials, allowing Jenkins to act as a Terraform agent and create infrastructure on my behalf. 

The Jenkins manager fulfilled the build and test stages, where Jenkins used git to clone the repository and fetch the latest commits. The build stage created a virtual environment using python3, activated that test environment, installed python's package manager and all of the packages in the requirements.txt that are necessary for the application to run. The test stage activated the test environment, executed tests, and saved the results in test-reports/results.xml.

The Jenkins agent then ran terraform init, terraform plan, and terraform apply on the files in the initTerraform. 

### Successful Deployments:
Linked, please find the deployed application on 4 instances across the N. Virginia and Oregon regions: https://github.com/nalDaniels/TerraformDeployment6/blob/main/DeploymentSuccess.md

## 5. Create Application Load Balancers
### Purpose: 
To design a resilient and fault-tolerant system. If one application in one availability zone goes down, requests are not lost - instead they are rereouted to another instance of the application. Furthermore, it prevents one server from being overwhelmed by dividing traffic 50/50 between the instances in one region. 

An application load balancer was used because the retail banking application uses HTTP requests. 

### Process:
I created target groups for all 4 instances using port 8000. Essentially, a target group is what the load balancer interacts with. Next, I defined a security groups with ports open for HTTP requests and associated the load balancers with the instances. Be mindful that you have to go to the specific region to create this infrastructure. 

### Successful Deployments:
Linked, please find the load-balanced application on 4 instances across the N. Virginia and Oregon regions: https://github.com/nalDaniels/TerraformDeployment6/blob/main/LoadBalancerSuccess.md

# Optimization:
I would optimize this deployment by adding an additional database since it has a single point of failure. I would set up the second database so that it is synced with the main database. You can have one database for writes and the other that simply does reads. 

The applications, Jenkins and Terraform servers should be in private subnets with nginx web servers in the public subnet. For applications, it is essential to also add a NAT gateway so that the data can be sent back to the client from the private subnet. This will enhance the security of the application code and files

A CDN would also decrease latency. It could store and serve the home page, login pages, and user input pages. 

# Resources:

Linked, please find my system design for this deployment: 



