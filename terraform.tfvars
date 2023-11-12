#AWS Keys & Region
AWS_REGION                    = "ap-southeast-1"
AZ_COUNT			          = "2"
RESOURCE_TAG			      = "AppDeploy"

# VPC Variables
VPC_CIDR_BLOCK                = "10.0.0.0/16"
SUBNET_CIDR_BITS		      = 8

# EC2 variable
PUBLIC_KEY			                   = "webapp.pub"
PRIVATE_KEY			                   = "webapp"
DEFAULT_USER                           = "ubuntu"
AMI_ID                                 = "ami-03caf91bb3d81b843"
INSTANCE_TYPE                          = "t2.micro"
ENVIRONMENT_TAG                        = "development"
EC2_HTTP_CIDR_IN		               = "0.0.0.0/0"
EC2_SSH_CIDR_IN			               = "0.0.0.0/0"

#LB & Autoscaling variables
LB_WEBAPP_CIDR_IN		      = "0.0.0.0/0"
MIN_INSTANCE 			      = "1"
MAX_INSTANCE 			      = "2"

#SNS
SNS_EMAIL			          = "arifnafees7@gmail.com"

#Cloudwatch
threshold_percentage		  = "70"