# Here iam creating the Ec2 Instance

resource "aws_instance" "myinstance" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name  
    count =   var.count

    tags = {
        Name = "instance-${count.index + 1}"
    } 

    user_data = file(script.sh)
}

resource "aws_vpc" "new_vpc" {
    cidr_block = var.cidr_block
    tags = {
        name = "My-VPC"
    }
}

resource "aws_subnet" "Public" {
    vpc_id = aws_vpc.new_vpc
    cidr_block = var.Public_Subnet
    tags = {
        Name = "Public_Subnet"
    }
}

resource "aws_subnet" "Private" {
    vpc_id = aws_vpc.new_vpc
    cidr_block = var.Private_Subnet
    tags = {
        Name = "Private_Subnet"
    }
}

resource "aws_internet_gateway" "My_IGW" {
    vpc_id = aws_vpc.new_vpc
    tags = {
        Name = "my-IGW"
    }
}

resource "aws_eip" "MyIP" {
    domain = "vpc"
}

resource "aws_nat_gateway" "My_Nat" {
    allocation_id =   aws_eip.MyIP.id
    subnet_id = aws_subnet.Public.id
}

resource "aws_route_table" "My-RT1" {
    vpc_id = aws_vpc.new_vpc
    route {
        cidr_block = var.RT_Cidr
        gateway_id = aws_internet_gateway.My_IGW.id
    }
    tags = {
        Name = "My-RT1"
    }
  
}

resource "aws_route_table" "My-RT2" {
    vpc_id =  aws_vpc.new_vpc
    route {
        cidr_block = var.RT_Cidr
        gateway_id  = aws_nat_gateway.My_Nat.id
    } 
    tags = {
        Name = "my-RT2"
    }
}

resource "aws_route_table_association" "MY-RTA1" {
    subnet_id =  aws_subnet.Public.id
    route_table_id = aws_route_table.My-RT1.id
}

resource "aws_route_table_association" "My-RTA2" {
    subnet_id = aws_subnet.Private.id
    route_table_id = aws_route_table.My-RT2.id
}

resource "aws_security_group" "my-SG" {
    name = "first-SG"
    description = "Allow TLS inbound traffic"
    vpc_id = aws_vpc.new_vpc.id

    ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.new_vpc.cidr_block]
    }

    ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = {
        Name = "my-SG"
    }  
}