variable "aws_region"{
	default = "us-east-2"
}

variable "drone_instance_type"{
	description = "Instance type on which DroneCI will run"
}

variable "drone_key"{
	description = "SSH key to access instance"
}

variable "zone_id"{
	description = "Route53 Zone ID"
}

variable "drone_host"{
	description = "prefix of url for route53 record"
}

variable "drone_gitlab_client_id"{
	description = "Gitlab OAuth app ID"
}

variable "drone_gitlab_secret_id"{
	description = "Gitlab OAuth app secret"
}

variable "drone_rpc_secret"{
	description = "RPC secret necessary for drone to communicate with runners"
}

variable "drone_address"{
	description = "DroneCI host adress"
}
