# this is the one type for key pair passed in code

resource "aws_instance" "myinstance" {
    ami = ""
    instance_type = "t2.micro"
    key_name = "virginia"     
}


# this is another way to create a keypair

resource "aws_key_pair" "Demo" {  
  key_name = "Demo"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "Demo" {
  content = tls_private_key.rsa.private_key_pem
  filename = "Demo"
}
