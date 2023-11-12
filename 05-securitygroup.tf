#Security Group for Load Balancer
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow 80 and 443 inbound traffic on WebApp LB"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [var.LB_WEBAPP_CIDR_IN]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.LB_WEBAPP_CIDR_IN]
  }
}

resource "aws_security_group" "appinstance-sg" {
  name        = "appinstance-sg"
  description = "Internet reaching access for EC2 Instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = [var.EC2_HTTP_CIDR_IN]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.EC2_SSH_CIDR_IN]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}