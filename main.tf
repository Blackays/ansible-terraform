terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.21.0"
    }
  }
}

provider "digitalocean" {
  # Configuration options
  token = "dop_v1_3e0bcca8d429b609f0667fbb0605d901b8a25b713e8825560d37a0450893a2be"
}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "web" {
  image  = "fedora-36-x64"
  name   = "ansible"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  
  ssh_keys = [ "36483389" ]

  tags = {
    Name = "prod-server"
  }

#   provisioner "local-exec" {
#   working_dir = "/home/nazar/Devops/ansible/bootcamp/ansible-terraform"
#   command = "ansible-playbook --inventory ${self.ipv4_address}, --private-key ${var.ssh_key_private} --user root playbook.yaml"
#   }
}

resource "null_resource" "configure_server" {
  triggers = {
    trigger = digitalocean_droplet.web.ipv4_address
  }
  provisioner "local-exec" {
  working_dir = "/home/nazar/Devops/ansible/bootcamp/ansible-terraform"
  command = "ansible-playbook --inventory ${digitalocean_droplet.web.ipv4_address}, --private-key ${var.ssh_key_private} --user root playbook.yaml"
  }
}
