provider "aws" {
  region = var.aws_region
}

data "aws_ami" "droneCI"{
	most_recent = true
	
	filter {
		name = "name"
		values = ["Drone-CI*"]
	}

	filter {
     name   = "architecture"
     values = ["x86_64"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
  owners = ["self", "amazon"]

}

resource "aws_instance" "droneCI_instance" {
    ami           = data.aws_ami.droneCI.id
    instance_type = var.drone_instance_type 
		key_name			= var.drone_key
		user_data			= data.template_file.init.rendered
		security_groups = [aws_security_group.drone_sg.name, ]
		//security_groups = ["sg-028231d5a4103c208", ]
    tags = {
        Name = "Dronce CI (Gitlab)"
    }
		
		depends_on = [aws_route53_record.drone_host_record,
					aws_security_group.drone_sg]
}

resource "aws_eip" "drone_eip"{
	tags = {
		Name = "Dronce CI (Gitlab) EIP"
	}
}

resource "aws_eip_association" "drone_eip_assoc" {
  instance_id   = aws_instance.droneCI_instance.id
  allocation_id = aws_eip.drone_eip.id
}

resource "aws_route53_record" "drone_host_record" {
  zone_id = var.zone_id 
  name    = var.drone_host 
  type    = "CNAME"
  ttl     = "300"
  records = [aws_eip.drone_eip.public_dns]
}

data "template_file" "init" {
  template = file("${path.module}/drone.sh")
  vars = {
    drone_gitlab_client_id = var.drone_gitlab_client_id 
    drone_gitlab_secret_id = var.drone_gitlab_secret_id 
    drone_rpc_secret			 = var.drone_rpc_secret 
    drone_host						 = var.drone_address
    //certbot_email = var.certbot_email                          
  }

}
