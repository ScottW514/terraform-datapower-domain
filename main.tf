resource "datapower_domain" "this" {
  app_domain      = var.app_domain
  neighbor_domain = var.neighbor_domains
  file_map = {
    copy_from = var.file_map.copy_from
    copy_to   = var.file_map.copy_to
    delete    = var.file_map.delete
    display   = var.file_map.display
    exec      = var.file_map.exec
    subdir    = var.file_map.subdir
  }
  monitoring_map = {
    audit = var.monitoring_map.audit
    log   = var.monitoring_map.log
  }
}

resource "datapower_domain_availability" "this" {
  app_domain = var.app_domain
  enabled    = var.domain_availability
  depends_on = [datapower_domain.this]
}

resource "datapower_statistics" "this" {
  app_domain = var.app_domain
  enabled    = var.statistics
  depends_on = [datapower_domain.this]
}
