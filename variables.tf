#aws provider variables
variable "AZ_COUNT" {}
variable "AWS_REGION" {}
variable "RESOURCE_TAG" {}

#VPC variables
variable "VPC_CIDR_BLOCK" {}
variable "SUBNET_CIDR_BITS" {}

#EC2 Variables
variable "PUBLIC_KEY" {}
variable "PRIVATE_KEY" {}
variable "DEFAULT_USER" {}
variable "AMI_ID" {}
variable "INSTANCE_TYPE" {}
variable "ENVIRONMENT_TAG" {}
variable "EC2_HTTP_CIDR_IN" {}
variable "EC2_SSH_CIDR_IN" {}

#Load Balancer & Autoscaling
variable "LB_WEBAPP_CIDR_IN" {}
variable "MIN_INSTANCE" {}
variable "MAX_INSTANCE" {}

#SNS
variable "SNS_EMAIL" {}

#Cloudwatch
variable threshold_percentage {}