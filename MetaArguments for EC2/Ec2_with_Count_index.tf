# this is one type for  create an multiple instances 

resource "aws_instance" "myinstance" {
    ami = ""
    instance_type = "t2.micro"
    key_name = "virginia" 
    count =  5

    tags = {
        Name = "Server ${count.index}"
    }
}

# create an instances with 5diffrent names, what names i have provided that much instances i need to create the code is

resource "aws_instance" "myinstance" {
    ami = ""
    instance_type = "t2.micro"
    key_name = "virginia" 
    count =  5

    tags = {
        Name = element(["Ravi", "Ram", "Sita", "Gita", "Arun"], count.index)  # Names examples: Ravi, Ram, sita, Gita, and Arun.
    }
}