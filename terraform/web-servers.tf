## Network
resource "yandex_vpc_network" "network_terraform" {
  name = "network_terraform"
}

resource "yandex_vpc_subnet" "subnet1_terraform" {
  name           = "subnet1_terraform"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_terraform.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet2_terraform" {
  name           = "subnet2_terraform"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network_terraform.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}


## image

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

## HDDs for instances

resource "yandex_compute_disk" "boot-disk-proxy1" {
  name     = "proxy1-hdd"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "10"
  image_id = data.yandex_compute_image.ubuntu.id
}

resource "yandex_compute_disk" "boot-disk-proxy2" {
  name     = "proxy2-hdd"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  size     = "10"
  image_id = data.yandex_compute_image.ubuntu.id
}

resource "yandex_compute_disk" "boot-disk-ansible" {
  name     = "ansible-hdd"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  size     = "10"
  image_id = data.yandex_compute_image.ubuntu.id
}

resource "yandex_compute_disk" "boot-disk-elk" {
  name     = "elk-hdd"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  size     = "30"
  image_id = data.yandex_compute_image.ubuntu.id
}

resource "yandex_compute_disk" "boot-disk-zabbix" {
  name     = "zabbix-hdd"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  size     = "30"
  image_id = data.yandex_compute_image.ubuntu.id

}
## Instances

resource "yandex_compute_instance" "vm-proxy1" {
  name                      = "vm-proxy1"
  allow_stopping_for_update = true
   hostname = "proxy1.ru-central1.internal"
   platform_id = "standard-v3"
   zone        = "ru-central1-a"
  resources {
    cores  = 2
    memory = 2
  }

#  boot_disk {
#    initialize_params {
#      image_id = data.yandex_compute_image.ubuntu.id
#      size = 10
#    }
#  }

   boot_disk {
    disk_id = yandex_compute_disk.boot-disk-proxy1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1_terraform.id
    nat       = true
    ip_address = "192.168.10.10"
    security_group_ids = [yandex_vpc_security_group.sg_proxy.id,yandex_vpc_security_group.sg_self.id]
  }

    metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable=1
  }

    scheduling_policy {
    preemptible = true
  }

}

resource "yandex_compute_instance" "vm-proxy2" {
   name                      = "vm-proxy2"
   allow_stopping_for_update = true
   hostname = "proxy2.ru-central1.internal"
   platform_id = "standard-v3"
   zone        = "ru-central1-b"
   resources {
     cores  = 2
     memory = 2
   }

#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu.id
#       size = 10
#     }
#   }
   boot_disk {
    disk_id = yandex_compute_disk.boot-disk-proxy2.id
  }

   network_interface {
     subnet_id = yandex_vpc_subnet.subnet2_terraform.id
     nat       = true
     ip_address = "192.168.11.10"
     security_group_ids = [yandex_vpc_security_group.sg_proxy.id,yandex_vpc_security_group.sg_self.id]
   }
    metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable=1
  }
    scheduling_policy {
    preemptible = true
  }
 }


resource "yandex_compute_instance" "vm-zabbix" {
   name                      = "vm-zabbix"
   allow_stopping_for_update = true
   hostname = "zabbix.ru-central1.internal"
   platform_id = "standard-v3"
   zone        = "ru-central1-b"
   resources {
     cores  = 2
     memory = 4
   }

#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu.id
#       size = 30
#     }
#   }

    boot_disk {
    disk_id = yandex_compute_disk.boot-disk-zabbix.id
  }


   network_interface {
     subnet_id = yandex_vpc_subnet.subnet2_terraform.id
     ip_address = "192.168.11.11"
     security_group_ids = [yandex_vpc_security_group.sg_zabbix.id,yandex_vpc_security_group.sg_self.id]
     nat       = true
   }
    metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable=1
  }
    scheduling_policy {
    preemptible = true
  }
 }


resource "yandex_compute_instance" "vm-elastic" {
   name                      = "vm-elastic"
   allow_stopping_for_update = true
   hostname = "elastic.ru-central1.internal"
   platform_id = "standard-v3"
   zone        = "ru-central1-b"
   resources {
     cores  = 2
     memory = 4
   }

#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu.id
#       size = 30
#     }
#   }
    boot_disk {
    disk_id = yandex_compute_disk.boot-disk-elk.id
  }

   network_interface {
     subnet_id = yandex_vpc_subnet.subnet2_terraform.id
     ip_address = "192.168.11.12"
     security_group_ids = [yandex_vpc_security_group.sg_elk.id,yandex_vpc_security_group.sg_self.id]
     nat       = true
   }
    metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable=1
  }
    scheduling_policy {
    preemptible = true
  }
 }

resource "yandex_compute_instance" "vm-ansible" {
   name                      = "vm-ansible"
   allow_stopping_for_update = true
   hostname = "ansible.ru-central1.internal"
   platform_id = "standard-v3"
   zone        = "ru-central1-b"
   resources {
     cores  = 2
     memory = 2
   }

#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu.id
#       size = 30
#     }
#   }
   boot_disk {
    disk_id = yandex_compute_disk.boot-disk-ansible.id
  }

   network_interface {
     subnet_id = yandex_vpc_subnet.subnet2_terraform.id
     ip_address = "192.168.11.13"
     security_group_ids = [yandex_vpc_security_group.sg_ansible.id,yandex_vpc_security_group.sg_self.id]
     nat       = true
   }
    metadata = {
    user-data = "${file("./meta.yml")}"
    serial-port-enable=1
  }
    scheduling_policy {
    preemptible = true
  }
 }


## ALB

resource "yandex_alb_target_group" "alb-tg" {
  name = "web-servers-alb-tg"

target {
    subnet_id = "${yandex_vpc_subnet.subnet1_terraform.id}"
    ip_address   = "${yandex_compute_instance.vm-proxy1.network_interface.0.ip_address}"
  }

  target {
    subnet_id = "${yandex_vpc_subnet.subnet2_terraform.id}"
    ip_address   = "${yandex_compute_instance.vm-proxy2.network_interface.0.ip_address}"
  }

}

resource "yandex_alb_backend_group" "alb-bg" {
  name      = "alb-backend"

  http_backend {
    name = "http-backend"
    weight = 1
    port = 80
    target_group_ids = ["${yandex_alb_target_group.alb-tg.id}"]
    healthcheck {
      timeout = "1s"
      interval = "1s"
      http_healthcheck {
        path  = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "alb-router" {
  name      = "alb-router"
}


resource "yandex_alb_virtual_host" "alb-virtual-host" {
  name      = "alb-virtual-host"
  http_router_id = yandex_alb_http_router.alb-router.id
  route {
    name = "route-1"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.alb-bg.id
        timeout = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "alb-1" {
  name               = "alb-1"
  network_id         = yandex_vpc_network.network_terraform.id
  #security_group_ids = [yandex_vpc_security_group.alb-sg.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet1_terraform.id
    }

    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet2_terraform.id
    }
  }

  listener {
    name = "alb-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.alb-router.id
      }
    }
  }
}
