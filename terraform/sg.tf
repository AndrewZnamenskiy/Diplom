resource "yandex_vpc_security_group" "sg_proxy" {
  name        = "sg_proxy"
  description = "sg for nginx"
  network_id  = "${yandex_vpc_network.network_terraform.id}"

#  labels = {
#    my-label = "sg-proxy"
#  }
}

resource "yandex_vpc_security_group_rule" "rule1" {
  security_group_binding = yandex_vpc_security_group.sg_proxy.id
  direction              = "ingress"
  description            = "rule1 description"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  port                   = 80
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "rule2" {
  security_group_binding = yandex_vpc_security_group.sg_proxy.id
  direction              = "egress"
  description            = "rule3 description"
  from_port              = 0
  to_port                 = 65535
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"

}


resource "yandex_vpc_security_group" "sg_self" {
  name        = "sg-self"
  description = "SG communication beetwen VMs"
  network_id  = yandex_vpc_network.network_terraform.id
}

resource "yandex_vpc_security_group_rule" "rule3" {
  security_group_binding = yandex_vpc_security_group.sg_self.id
  direction              = "ingress"
  description            = "rule3 description"
 # v4_cidr_blocks         = ["0.0.0.0/0"]
  from_port              = 0
  to_port                 = 65535
  protocol               = "ANY"
  predefined_target = "self_security_group"
}

resource "yandex_vpc_security_group_rule" "rule4" {
  security_group_binding = yandex_vpc_security_group.sg_self.id
  direction              = "egress"
  description            = "rule4 description"
  #v4_cidr_blocks         = ["0.0.0.0/0"]
  from_port              = 0
  to_port                 = 65535
  protocol               = "ANY"
  predefined_target = "self_security_group"
}


resource "yandex_vpc_security_group" "sg_zabbix" {
  name        = "sg_zabbix"
  description = "SG for zabbix"
  network_id  = yandex_vpc_network.network_terraform.id

#  labels = {
#    my-label = "sg_zabbix"
#  }
}

resource "yandex_vpc_security_group_rule" "rule5" {
  security_group_binding = yandex_vpc_security_group.sg_zabbix.id
  direction              = "ingress"
  description            = "rule5 description"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  port                   = 8080
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "rule6" {
  security_group_binding = yandex_vpc_security_group.sg_self.id
  direction              = "egress"
  description            = "rule6 description"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
}

resource "yandex_vpc_security_group" "sg_elk" {
  name        = "sg_elk"
  description = "SG for elk"
  network_id  = yandex_vpc_network.network_terraform.id
}

resource "yandex_vpc_security_group_rule" "rule7" {
  security_group_binding = yandex_vpc_security_group.sg_elk.id
  direction              = "ingress"
  description            = "rule7 description"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  port                   = 5601
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "rule8" {
  security_group_binding = yandex_vpc_security_group.sg_elk.id
  direction              = "egress"
  description            = "rule8 description"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
}


resource "yandex_vpc_security_group" "sg_ansible" {
  name        = "sg_ansible"
  description = "SG for ansible"
  network_id  = yandex_vpc_network.network_terraform.id

#  labels = {
#    my-label = "sg_ansible"
#  }
}
resource "yandex_vpc_security_group_rule" "rule9" {
  security_group_binding = yandex_vpc_security_group.sg_ansible.id
  direction              = "ingress"
  description            = "rule9 description"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  port                   = 22
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "rule10" {
  security_group_binding = yandex_vpc_security_group.sg_ansible.id
  direction              = "egress"
  description            = "rule10 description"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  protocol               = "ANY"
}


## SG
#resource "yandex_vpc_security_group" "sg-proxy" {
#  name        = "sg-proxy"
#  description = "sg for NGINX servers"
#  network_id  = yandex_vpc_network.network_terraform.id
#
#  ingress {
#    protocol       = "TCP"
#    description    = "Proxy access"
#    port           = "80"
#  }
#
#  egress {
#    protocol       = "ANY"
#    description    = "All VMs can access internet"
#    v4_cidr_blocks = ["0.0.0.0/0"]
#  }
#}
