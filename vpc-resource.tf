resource "aws_vpc" "myapp_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    
tags = var.vpc_name
}

resource "aws_subnet" "pub_subnet" {
    vpc_id = aws_vpc.myapp_vpc.id
    cidr_block = var.pub_subnet_cidr
    tags = var.pub_subnet_name
    map_public_ip_on_launch = true 
}

resource "aws_subnet" "pvt_subnet" {
    vpc_id = aws_vpc.myapp_vpc.id
    cidr_block = var.pvt_subnet_cidr 
    #availability_zone = "ap-south-1a"
    tags = var.pvt_subnet_name
}

resource "aws_internet_gateway" "vpc_igw" {
tags =var.ig_name
}

resource "aws_internet_gateway_attachment" "name" {
  vpc_id = aws_vpc.myapp_vpc.id
  internet_gateway_id = aws_internet_gateway.vpc_igw.id
}


# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "ngw-eip" {
  depends_on = [aws_internet_gateway.vpc_igw]
}

#create NAT Gateway
resource "aws_nat_gateway" "nat_igw" {
  allocation_id = aws_eip.ngw-eip.id
  subnet_id     = aws_subnet.pub_subnet.id
  depends_on = [ aws_eip.ngw-eip ]
  tags =var.nat_ig_name
  }

resource "aws_route_table" "pub_route" {
    vpc_id = aws_vpc.myapp_vpc.id
    route {
        gateway_id = aws_internet_gateway.vpc_igw.id
        cidr_block = var.cidr
    }
  tags = var.Public_route_table_tag
}

#attaching public route table to public subnet
resource "aws_route_table_association" "public_subnet_route" {
  subnet_id = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.pub_route.id
}

#private route table Add a route to the NAT Gateway in the private route table
resource "aws_route_table" "private_rt" {
 vpc_id = aws_vpc.myapp_vpc.id
  tags ={
  Name="private_route_table"
  }
}

# Add a route to the NAT Gateway in the private route table
resource "aws_route" "private_nat" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = var.cidr
  nat_gateway_id         = aws_nat_gateway.nat_igw.id
}

#attaching private route table to private subnet 
resource "aws_route_table_association" "private_association" {
  subnet_id = aws_subnet.pvt_subnet.id
  route_table_id = aws_route_table.private_rt.id
}


# Create a Security Group for Bastion Host and private EC2 instance
resource "aws_security_group" "bastion_sg" {
  name        = "ssh-sg"
  description = "Allow SSH access"
  vpc_id = aws_vpc.myapp_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
  tags = {
    "Name"="bastion-sg"
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.myapp_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] # Allow SSH only from Bastion Host
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }

}

resource "aws_instance" "my_ec2" {
  ami           = var.ami[1]  # Amazon Linux 2 AMI ID for ap-south-1 region
  instance_type = var.instance_type[1]
  subnet_id = aws_subnet.pvt_subnet.id
  key_name      =  aws_key_pair.terr-key.key_name
  security_groups = [aws_security_group.private_sg.id]
  associate_public_ip_address = var.use_public_ip
  
  tags = var.aws_instant_tag
}

resource "aws_instance" "bastion" {
  ami           = var.ami[0]  # Amazon Linux 2 AMI ID for ap-south-1 region
  instance_type = var.instance_type[0]
  subnet_id = aws_subnet.pub_subnet.id
  key_name      =  aws_key_pair.terr-key.key_name
  security_groups = [aws_security_group.bastion_sg.id]
  #associate_public_ip_address =  var.use_public_ip ? true : false
  
  tags = var.bastion
}

