# Creating a local 

locals {
  environment = var.project_Name
}

# Create VPC 

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = var.dns_support
  enable_dns_hostnames = var.hostname

  tags = {
    Name = "${local.environment}_vpc"
  }
}

# Create a Public subnets for WEB Server

resource "aws_subnet" "web_public-1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.web_public-1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = var.public_ip_launch

  tags = {
    Name = "${local.environment}_web_public_subnet_1"
  }
}

resource "aws_subnet" "web_public-2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.web_public-2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = var.public_ip_launch
  
  tags = {
    Name = "${local.environment}_web_Public_subnet_2"
  }
}

# create an Internet Gateway 

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "${local.environment}_IGW"
  }
}

# create route Tables and Route table association

resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.myvpc.id

  route = {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "${local.environment}_Public_RT"
  }
}

resource "aws_route_table_association" "Public_RTA" {
  subnet_id = aws_subnet.web_public-1.id
  route_table_id = aws_route_table.Public_RT.id
}


# create a Private subnets for App server

resource "aws_subnet" "App_private-1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.App_private-1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${local.environment}_App_private_subnet-1"
  }
}

resource "aws_subnet" "App_private-2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.App_private-2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"
  
  tags = {
    Name = "${local.environment}_App_Private_subnet-2"
  }
}

# Create a private Subnet for DB Server

resource "aws_subnet" "DB_private_subnet-1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.DB_private-1
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"
  
  tags = {
    Name = "${local.environment}_DB_Private_subnet-1"
  }
}

resource "aws_subnet" "DB_private_subnet-2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.DB_private-2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"
  
  tags = {
    Name = "${local.environment}_DB_Private_subnet-2"
  }
}

# Create an elastic Ip

resource "aws_eip" "eip_nat" {
  vpc = true

  tags = {
    Name = "${local.environment}_eip-1"
  }
}

# Create a Nat gateway for APP & DB Tier

resource "aws_nat_gateway" "nat-1" {
  allocation_id = aws_eip.eip_nat.id 
  subnet_id = aws_subnet.web_public-2.id

  tags = {
    Name = "${local.environment}_nat-1"
  }
}

resource "aws_route_table" "Private_route_table" {
  vpc_id = aws_vpc.myvpc.id

  route = {
    cidr_block = var.route_cidr
    nat_gateway_id = aws_nat_gateway.nat-1.id
  }
}

# Create a route table association for App tier

resource "aws_route_table_association" "nat_app_route_1" {
  subnet_id = aws_subnet.App_private-1.id
  route_table_id = aws_route_table.Private_route_table.id
}

resource "aws_route_table_association" "nat_app_route_1" {
  subnet_id = aws_subnet.App_private-2.id
  route_table_id = aws_route_table.Private_route_table.id
}

# Create a route table association for DB tier

resource "aws_route_table_association" "nat_app_route_1" {
  subnet_id = aws_subnet.DB_private_subnet-1.id
  route_table_id = aws_route_table.Private_route_table.id
}

resource "aws_route_table_association" "nat_app_route_1" {
  subnet_id = aws_subnet.DB_private_subnet-2.id
  route_table_id = aws_route_table.Private_route_table.id
}

# Security Group for Application Load Balancer

resource "aws_security_group" "ALB_SG" {
  name = "ALB Security Gropu"
  description = "Enable HTTP/HTTPS access on ports 80/443"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.SG_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.SG_cidr]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.SG_cidr]
  }

   tags = {
    Name = "${local.environment}_App_Security_group"
  }
}

# Security Group for SSH access

resource "aws_security_group" "SSH_Sg" {
  name = "SSH Access"
  description = "Enable SSH port on 22"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["here we provide our ip" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.SG_cidr]
  }

   tags = {
    Name = "${local.environment}_Bastion_SG"
  }
}

# Security Group for Web Server

resource "aws_security_group" "Web_tier_SG" {
  name = "Web Server Security Group"
  description = "Enable HTTP/HTTPS ports for access"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "http access"
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = ["${aws_security_group.ALB_SG.id}"]
  }

  ingress {
    description = "https access"
    from_port = 443
    protocol = "tcp"
    to_port = 443
    security_groups = ["${aws_security_group.ALB_SG.id}"]
  }

  ingress {
    description = "ssh access"
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = ["${aws_security_group.SSH_Sg.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.environment}_Web_server_SG"
  }
}

# Security Group for DB Server

resource "aws_security_group" "DB_SG" {
  name = "Database server SG"
  description = "Enable MYSQL access port on 3306"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "MYSQL Access"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = ["${aws_security_group.Web_tier_SG.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.environment}_DB_server_SG"
  }
}

# Create an EC2 Instances for Web Server and App Server

resource "aws_instance" "_Web_server" {
  ami = "ami-029c925c0f16a0956"
  key_name = "mumbai"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.web_public-1.id
  vpc_security_group_ids = [aws_security_group.ALB_SG.id]
  user_data = file("script.sh")

  tags = {
    Name = "${local.environment}_Webserver"
  }
}

resource "aws_instance" "App_Server" {
  ami = "ami-029c925c0f16a0956"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.App_private-1.id
  vpc_security_group_ids = [aws_security_group.SSH_Sg.id]
  key_name = "mumbai"

  tags = {
    Name = "${local.environment}_Appserver"
  }
}

# Auto Scaling Group for Web Server

resource "aws_launch_template" "auto-Scaling-group-web" {
  name_prefix = "auto-scaling-group"
  image_id = "ami-029c925c0f16a0956"
  instance_type = "t2.micro"
  key_name = "mumbai"
  user_data = file(script.sh)
  network_interfaces {
    subnet_id = aws_subnet.web_public-1.id
    security_groups = [aws_security_group.Web_tier_SG.id]
  }
}

resource "aws_autoscaling_group" "asg-1" {
  availability_zones = ["us-east-1a"]
  desired_capacity = 1
  max_size = 2
  min_size = 1
  launch_template {
    id = aws_launch_template.auto-Scaling-group-web.id
    version = "$Latest"
  }
}

# Auto Scaling Group for Application Server

resource "aws_launch_template" "auto-scaling-App" {
  name_prefix = "App-auto-scaling-group"
  image_id = "ami-029c925c0f16a0956"
  instance_type = "t2.micro"
  key_name = "mumbai"

  network_interfaces {
    subnet_id = aws_subnet.App_private-1.id
    security_groups = [aws_security_group.SSH_Sg.id]
  }
}

resource "aws_autoscaling_group" "asg-2" {
  availability_zones = ["us-east-1a"]
  desired_capacity = 1
  max_size = 2
  min_size = 1
  launch_template {
    id = aws_launch_template.auto-scaling-App.id
    version = "$Latest"
  }
}

# creating Application Load Balancer for web Server

resource "aws_alb" "Application-Load-Balancer" {
  name = "Web-load-balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.ALB_SG.id]
  subnets = [aws_subnet.web_public-1.id, aws_subnet.web_public-2.id]
  enable_deletion_protection = false

  tags = {
    Name = "app-load-balancer"
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name = "appbalancer_tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_lb_target_group_attachment" "web-attachment" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id = aws_instance._Web_server.id
  port = 80
}

resource "aws_lb_listener" "alb-http-listener" {
  load_balancer_arn = aws_alb.Application-Load-Balancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port = 443
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Create a file for the Database Instance.

resource "aws_db_subnet_group" "database-subnet-group" {
  name = "database subnets"
  subnet_ids = [aws_subnet.DB_private_subnet-1.id, aws_subnet.DB_private_subnet-2.id]
  description = "subnet group for database instance"

  tags = {
    Name = "Database-subnet"
  }
}

resource "aws_db_instance" "database-instance" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = var.db_instance
  db_name = "sqldb"
  username = "admin"
  password = "admin"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  availability_zone = "us-east-1b"
  db_subnet_group_name = aws_db_subnet_group.database-subnet-group.name
  multi_az = var.multi_az
  vpc_security_group_ids = [aws_security_group.DB_SG.id]
}

output "lb_dns_name" {
  description = "DNS name of the load balancer"
  value = "${aws_alb.Application-Load-Balancer.dns_name}"
}