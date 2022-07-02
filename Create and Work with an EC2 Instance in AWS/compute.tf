locals {
  name      = "Webserver"
  region    = "eu-west-1"
  user_data = <<-EOT
  #!/bin/bash
  yum update -y
  yum install -y httpd
  yum install -y curl
  chkconfig httpd on
  service httpd start
  EOT
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
  owners = ["137112412989"]
}

resource "aws_key_pair" "Lab" {
  key_name   = "Lab"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwZOKuTpBjhmIO+YfureQNi+Zm3hXsT4l7xlWDVnaBGhs88Q8ZQqelDhYzjH0pugZWeBXuvyyBJb0tchjV19Va30hPoTEuNJAGfc2RB7MePoTBrrY3M+IV5Aedkk5k0fMyKuuMXAOqRGDl1OnXmV8scX4+TF/y+njIiy71CqKpvBcinYxm0ADktsHD+Hzv1YWDsUFFDsc28K9XECk2Cfv5arteUiH2Kli74skgXTMzeYjMPd7YfpMnRbYwq6mUDrTaZBNBAX7cDT2AR0e8246y5IJ2ZsGmpoBuTXFM5Eyw1oYwadVyEM89kBnVHTErEtwMv9xGXLeT+qcw0XEZzeL5dv/xoE4Cf1IhuDbTAhcEO5e80DoKRHVtRNXEkbw+jREm0oitmnMZ2kWGDETSQ5hARZ18mvA66zD63mEvMlN097lVawsV7wSBdLsxGU+NTfaSSMEJi3TVVjIdwxUwkUtx21mvvMfnxK4baYo17SZD1omSXWgKCs2W+xEM7CGZOxKEOlAw7Pw5KaSNl+n57VXZ9kj/Zan8GXTaBOeTMSuNi425ZyYeB28490oSfYrdRz4fczn23GPpIlUKHgn5DZz0hczuEKyrJl/6GEj93TySXs1C9RiQlR4NcuZB0O4j43R/fQsGP6lGyPPuf9MLisyZRDLZVSK8oVDej5N7JOGUzQ== pavel_barysiuk@EPBYMINW03D3"
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon_linux.image_id
  associate_public_ip_address = true
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.Lab.key_name
  security_groups             = [aws_default_security_group.default.name, aws_security_group.LabSG.name]
  tags = {
    Name = "Webserver"
  }
}

output "ec2_ip" {
  value = aws_instance.ec2.public_ip
}