terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
#      version = "0.97.0"
    }
  }
required_version = ">= 0.13"
}

variable "yandex_cloud_token" {
  type        = string
  description = "Yandex Cloud authorization token"
  sensitive   = true
}

provider "yandex" {
 # token                    = var.yandex_cloud_token #секретные данные должны быть в сохранности!! Никогда не выкладывайте токен в публичный доступ.
  service_account_key_file = "/home/andy/Terraform/Lab_VMs/authorized_key.json"
  cloud_id                 = "b1g4f8pn1f07pfknbi6p"
  folder_id                = "b1g9cuffnr1dd2d2t8pb"
  zone                     = "ru-central1-a"
}


resource "yandex_resourcemanager_folder_iam_member" "admin-account-iam" {
  folder_id   = "b1g9cuffnr1dd2d2t8pb"
  role        = "backup.editor"
  member      = "serviceAccount:aje967brfqcom0tq7g5o"
}
