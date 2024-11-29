resource "aws_key_pair" "terr-key" {
  key_name   = "terr-key"
  public_key = tls_private_key.rsa.public_key_openssh
  }

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "terr-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "terr-key.pem"
}

