resource "yandex_compute_snapshot_schedule" "default" {
  name           = "my-snapshot"

  schedule_policy {
	expression = "0 16 * * *"
  }

  snapshot_count = 7
  #start_at: 2024-05-29T16:04:05Z
  retention_period = "168h"

  snapshot_spec {
	  description = "VMs-disk-snapshot"
	  labels = {
	    snapshot-label = "daily-disk-snapshot"
	}
	  }
     disk_ids = [yandex_compute_disk.boot-disk-proxy1.id, yandex_compute_disk.boot-disk-proxy2.id, yandex_compute_disk.boot-disk-ansible.id, yandex_compute_disk.boot-disk-elk.id, yandex_compute_disk.boot-disk-zabbix.id]

}
