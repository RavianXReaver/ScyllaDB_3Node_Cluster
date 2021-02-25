//Generate the Private key
resource "tls_private_key" "scylla_cluster_pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

//Stores the generated private key as a file in Resources Folder
resource "local_file" "scylla_cluster_local_pk" {
  content     = tls_private_key.scylla_cluster_pk.private_key_pem
  filename = "../Resources/${var.Key_Pair_Name}.pem"
  file_permission = "0600"
}

//AWS Configuration for ScyllaDB Cluster

resource "aws_vpc" "vpc_scylla_cluster" {
  cidr_block = var.VPC_CIDR
  
  tags = {
      Name = "Scylla_Cluster"
  }
}

resource "aws_route_table" "route_scylla" {
  vpc_id = aws_vpc.vpc_scylla_cluster.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_scylla.id
  }

  tags = {
    Name = "Scylla_Cluster_RT"
  }
}

resource "aws_main_route_table_association" "route_association_scylla" {
  vpc_id         = aws_vpc.vpc_scylla_cluster.id
  route_table_id = aws_route_table.route_scylla.id
}

resource "aws_subnet" "subnet_scylla_a" {
    vpc_id     = aws_vpc.vpc_scylla_cluster.id
    cidr_block = var.Subnet_A
    availability_zone = var.Subnet_A_AZ

    tags = {
      "Name" = "Scylla_A"
    }
}

resource "aws_subnet" "subnet_scylla_b" {
    vpc_id     = aws_vpc.vpc_scylla_cluster.id
    cidr_block = var.Subnet_B
    availability_zone = var.Subnet_B_AZ

    tags = {
      "Name" = "Scylla_B"
    }
}

resource "aws_subnet" "subnet_scylla_c" {
    vpc_id     = aws_vpc.vpc_scylla_cluster.id
    cidr_block = var.Subnet_C
    availability_zone = var.Subnet_C_AZ
    
    tags = {
      "Name" = "Scylla_C"
    }
}

resource "aws_internet_gateway" "gateway_scylla" {
  vpc_id = aws_vpc.vpc_scylla_cluster.id
  tags = {
    Name = "Scylla_Cluster"
  }
}

resource "aws_iam_role" "iam_role_scylla" {
  name = "Scylla_Cluster_SSM_Role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  } 
  EOF
}

resource "aws_iam_role_policy" "policy_role_scylla" {
  name = "Scylla_Cluster_SSM_Policy"
  role = aws_iam_role.iam_role_scylla.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "iam_scylla_instance_profile" {
  name = "SSM_Instance_Profile_Scylla"
  role = aws_iam_role.iam_role_scylla.name
}

resource "aws_security_group" "security_group_cluster" {
  name        = "Scylla_Cluster"
  vpc_id      = aws_vpc.vpc_scylla_cluster.id

  ingress {
    description = "Allow All Internal"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc_scylla_cluster.cidr_block]
  }

  ingress {
    description = "Allow All SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Scylla_Cluster"
  }
}

resource "aws_key_pair" "private_key_scylla" {
  key_name   = var.Key_Pair_Name
  public_key = tls_private_key.scylla_cluster_pk.public_key_openssh
}

resource "aws_instance" "scylla_node_a" {
  ami           = var.AMI
  instance_type = var.Instance_Type
  subnet_id     = aws_subnet.subnet_scylla_a.id
  security_groups = ["${aws_security_group.security_group_cluster.id}"]
  iam_instance_profile = aws_iam_instance_profile.iam_scylla_instance_profile.name
  associate_public_ip_address = true
  key_name = aws_key_pair.private_key_scylla.key_name

  root_block_device {
    volume_size=16
  }

  tags = {
    Name = "Scylla_Node_A"
  }
}

resource "aws_instance" "scylla_node_b" {
  ami           = var.AMI
  instance_type = var.Instance_Type
  subnet_id     = aws_subnet.subnet_scylla_b.id
  security_groups = ["${aws_security_group.security_group_cluster.id}"]
  iam_instance_profile = aws_iam_instance_profile.iam_scylla_instance_profile.name
  associate_public_ip_address = true
  key_name = aws_key_pair.private_key_scylla.key_name

  root_block_device {
    volume_size=16
  }

  tags = {
    Name = "Scylla_Node_B"
  }
}

resource "aws_instance" "scylla_node_c" {
  ami           = var.AMI
  instance_type = var.Instance_Type
  subnet_id     = aws_subnet.subnet_scylla_c.id
  security_groups = ["${aws_security_group.security_group_cluster.id}"]
  iam_instance_profile = aws_iam_instance_profile.iam_scylla_instance_profile.name
  associate_public_ip_address = true
  key_name = aws_key_pair.private_key_scylla.key_name

  root_block_device {
    volume_size=16
  }

  tags = {
    Name = "Scylla_Node_C"
  }
}

resource "local_file" "ansible_inventory" {

  content = "[Cluster_Nodes]\n${join("\n",
              formatlist(
                "%s AZ=%s",
                aws_instance.scylla_node_a.public_ip,
                var.Subnet_A_AZ
              )
            )}\n${join("\n",
              formatlist(
                "%s AZ=%s",
                aws_instance.scylla_node_b.public_ip,
                var.Subnet_B_AZ
              )
            )}\n${join("\n",
              formatlist(
                "%s AZ=%s",
                aws_instance.scylla_node_c.public_ip,
                var.Subnet_C_AZ
              )
            )}\n\n[Cluster_Nodes:vars]\n${join("\n",
              formatlist(
                "ansible_user=ubuntu"
              )
            )}\n${join("\n",
              formatlist(
                "Node1_IP=%s",
                aws_instance.scylla_node_a.private_ip
              )
            )}\n${join("\n",
              formatlist(
                "Node2_IP=%s",
                aws_instance.scylla_node_b.private_ip
              )
            )}\n${join("\n",
              formatlist(
                "Node3_IP=%s",
                aws_instance.scylla_node_c.private_ip
              ))}\n${join("\n",
              formatlist(
                "Region=%s",
                var.Region
              ))}"

  filename = "../Ansible/ansible_inventory"
}

resource "null_resource" "scylla_ansible" {
  
  depends_on = [ aws_instance.scylla_node_a, aws_instance.scylla_node_b, aws_instance.scylla_node_c ]
  
  provisioner "local-exec" {
    command = "ansible-playbook -i ../Ansible/ansible_inventory --private-key=../Resources/Scylla_Cluster.pem --ssh-common-args='-o StrictHostKeyChecking=no' ../Ansible/ScyllaDB_Cluster_Playbook.yml"
  }
}