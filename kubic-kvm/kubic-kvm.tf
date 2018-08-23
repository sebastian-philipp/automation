provider "libvirt" {
  uri = "qemu:///system"
}

variable "network" {
  type        = "string"
  default     = "10.17.0.0/22"
  description = "Network used by the cluster"
}

resource "libvirt_network" "network" {
    name      = "kubic-dev-net"
    mode      = "nat"
    #domain    = "local"
    addresses = ["${var.network}"]
}


resource "libvirt_volume" "os_image" {
  name = "os_image"
  source = "../downloads/openSUSE-Tumbleweed-Kubic.x86_64-15.0-kubeadm-docker-hardware-x86_64-Build5.10.qcow2"
}

resource "libvirt_volume" "os_volume" {
  name = "os_volume-${count.index}"
  base_volume_id = "${libvirt_volume.os_image.id}"
  count = 3
}

resource "libvirt_volume" "data_volume" {
  name = "data_volume-${count.index}"
  size = 5368709120 # 5 * 1024 * 1024 * 1024
  count = 3
}


resource "libvirt_cloudinit" "commoninit" {
  name = "commoninit-${count.index}.iso"
  pool      = "default"
  user_data = "${file("commoninit.cfg")}"
  count = 3
}


resource "libvirt_domain" "domain" {
  name = "kubic-kubadm-${count.index}"
  cpu {
       mode = "host-passthrough"
  }
  memory = 2048
  disk {
       volume_id = "${element(libvirt_volume.os_volume.*.id, count.index)}"
  }
  disk {
       volume_id = "${element(libvirt_volume.data_volume.*.id, count.index)}"
  }
  network_interface {
      network_id     = "${libvirt_network.network.id}"
      wait_for_lease = true
      addresses = ["${cidrhost("${var.network}", 768 + count.index)}"]
  }
  connection {
      type     = "ssh"
      user     = "root"
      password = "linux"
  }
  cloudinit = "${element(libvirt_cloudinit.commoninit.*.id, count.index)}"
  provisioner "remote-exec" {
    inline = [
        "sleep 1"
    ]
  }

  count = 3
}

output "ips" {
  value = "${libvirt_domain.domain.*.network_interface.0.addresses}"
}
