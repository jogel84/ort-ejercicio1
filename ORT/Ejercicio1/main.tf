resource "aws_instance" "instancia1" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.aws_instancia_tipo}"
  availability_zone = var.aws_az
  key_name = "${var.claves_ssh}"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id = aws_subnet.sub_net_us-east-1.id

  tags = {
    Name = "Instancia_desde_Terraform"
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = aws_instance.instancia1.public_ip
    private_key = file("./vockey.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install apache2 git -y",
      "sudo git -C /var/www/html clone https://github.com/mauricioamendola/chaos-monkey-app.git",
      "sudo systemctl start apache2"
    ]
  }
}