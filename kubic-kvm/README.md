# kubic-kvm

The goal is to provide a simple setup of three Kubic VMs.
No fancy configuration is possible right now.

## Prerequisites

You're going to need at least:

* `terraform`
* [`terraform-provider-libvirt`](https://github.com/dmacvicar/terraform-provider-libvirt)

Running `caasp-devenv` should install the packages.

## Download the image

run

    ../misc-tools/download-image --type kvm https://download.opensuse.org/repositories/devel:/kubic:/images:/experimental/images_devel_kubic/openSUSE-Tumbleweed-Kubic.x86_64-15.0-kubeadm-docker-hardware-x86_64-Build5.10.qcow2
    

In order to download the VM image.

# Usage

Run 

    $ terraform init
    $ terraform plan
    $ terraform apply
    
to start the VMs and follow [https://kubic.opensuse.org/blog/2018-08-20-kubeadm-intro/](https://kubic.opensuse.org/blog/2018-08-20-kubeadm-intro/) to initialize Kubernetes.
    
