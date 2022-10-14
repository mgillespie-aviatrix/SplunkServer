
data "aws_ami" "workload_ami" {
    most_recent = true
    owners = ["amazon","aws-marketplace"]
    filter {
        name = "name"
        values = ["Amazon Linux*"]
    }
}

resource "aws_security_group" "splunk-sg" {
  name        = "splunk-sg"
  description = "Allow Splunk traffic"
  vpc_id      = var.splunk_vpc_id
  
  ingress {
    description = "Ingress Syslog"
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "Ingress SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "Ingress Web Interface"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Default egress Rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "splunk-sg"
  }
}

module "splunk_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name    = var.splunk_server_name
  ami           = data.aws_ami.workload_ami.id
  instance_type = var.splunk_instance_size
  key_name      = var.default_ssh_key
  monitoring = false
  subnet_id = var.splunk_subnet_id
  vpc_security_group_ids = [aws_security_group.splunk-sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "splunk_server",
  }
  user_data = <<EOF
	#!/bin/bash
    #Grab the Splunk RPM
    sudo curl https://mgillespie-aviatrix-toolset.s3.us-east-2.amazonaws.com/splunk-9.0.1-82c987350fde-linux-2.6-x86_64.rpm -o /usr/src/splunk-9.0.1-82c987350fde-linux-2.6-x86_64.rpm 
	#Installing git and cloning the repository
    sudo rpm -i /usr/src/splunk-9.0.1-82c987350fde-linux-2.6-x86_64.rpm
   EOF
}

output "Splunk_IP" {
    description = "Public IP assigned to Splunk Server"
    value = "Please log into the Splunk server at ${module.splunk_server.public_ip} and enable splunk via /opt/splunk/bin/splunk start)"
}