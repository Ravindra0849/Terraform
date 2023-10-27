resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "New_Vpc"
  }
}

resource "aws_subnet" "Web_SN_Public" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/16"
  
  tags = {
    Name = "Web_SN_Public"
  }
}

resource "aws_subnet" "Web_SN_Private" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/16"
  
  tags = {
    Name = "Web_SN_Private"
  }
}

resource "aws_subnet" "App_SN_Public"  {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.3.0/16"

  tags = {
    Name = "App_SN_Public"
  }
}

resource "aws_subnet" "App_SN_Private"  {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.4.0/16"

  tags = {
    Name = "App_SN_Private"
  }
}

resource "aws_subnet" "DB_SN_Private"  {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.5.0/16"

  tags = {
    Name = "DB_SN_Private"
  }
}

resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "MyIGW"
  }
}

resource "aws_route_table" "Web_RT_Public" {
  vpc_id = aws_vpc.myvpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
  }

  tags = {
    Name = "Web_RT_Public"
  }
}

resource "aws_route_table" "App_RT_Public" {
  vpc_id = aws_vpc.myvpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
  }

  tags = {
    Name = "App_RT_Public"
  }
}

resource "aws_eip" "My_EIP" {
  domain = aws_vpc.myvpc.id
  vpc = true
}

resource "aws_nat_gateway" "MyNAT_GW" {
  allocation_id = aws_eip.My_EIP.id
  subnet_id = aws_subnet.DB_SN_Private

  tags = {
    Name = "MyNAT_GW"
  }
}