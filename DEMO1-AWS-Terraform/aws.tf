provider "aws" {
  region = "us-west-2"

}

data "local_file" "ssh_pub_key" {
  filename = "/home/grace/.ssh/id_rsa.pub"

}

resource "aws_key_pair" "ssh_pub" {
  key_name   = "grace-keypair"
  public_key = data.local_file.ssh_pub_key.content
}
