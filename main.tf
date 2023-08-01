provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "tera-test" {
  ami           = "ami-0e00e602389e469a3"
  instance_type = "t2.micro"
  tags = {
    Name = "test-compose-TF"
  }
  key_name = "ori109"
  vpc_security_group_ids = ["sg-0f73632c8fdd03b08"]
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install git -y",
      "git clone https://github.com/Haknin/crypto-site.git",
      "sudo yum install docker -y",
      "sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "cd /home/ec2-user/crypto-site/",
      "sudo docker-compose up -d"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/var/lib/jenkins/.ssh/ori109.pem")
      host        = self.public_ip
    }
  }
}

resource "aws_instance" "prod2" {
  ami           = "ami-0e00e602389e469a3"
  instance_type = "t2.micro"
  tags = {
    Name = "prod-compose-TF"
  }
  key_name = "ori109"
  vpc_security_group_ids = ["sg-0f73632c8fdd03b08"]
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install git -y",
      "git clone https://github.com/Haknin/crypto-site.git",
      "sudo yum install docker -y",
      "sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "cd /home/ec2-user/crypto-site/",  // Add a comma here to separate the commands
      "sudo docker-compose up -d"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/var/lib/jenkins/.ssh/ori109.pem")
      host        = self.public_ip
    }
  }
}
