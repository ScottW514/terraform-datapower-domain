resource "datapower_system_settings" "this" {
  count                   = var.app_domain == "default" && var.system_settings != null ? 1 : 0
  provider_target         = var.provider_target
  audit_reserve           = var.system_settings.audit_reserve
  contact                 = var.system_settings.contact
  custom_ui_file          = (var.system_settings.custom_ui_file != null || var.system_settings.custom_ui_xml != null) ? datapower_file.ui[0].remote_path : null
  entitlement_number      = var.system_settings.entitlement_number
  locale                  = var.system_settings.locale
  location                = var.system_settings.location
  system_log_fixed_format = var.system_settings.system_log_fixed_format
  system_name             = var.system_settings.system_name
  user_summary            = var.system_settings.user_summary
  depends_on = [
    datapower_domain.this,
    datapower_file.ui[0],
  ]
}

resource "random_id" "ui" {
  count = var.system_settings != null && (var.system_settings.custom_ui_file != null || var.system_settings.custom_ui_xml != null) ? 1 : 0
  keepers = {
    local_file = var.system_settings.custom_ui_file != null ? filesha256(var.system_settings.custom_ui_file) : null
    xml        = var.system_settings.custom_ui_xml != null ? sha256(var.system_settings.custom_ui_xml) : null
  }
  byte_length = 8
}

resource "datapower_file" "ui" {
  count           = var.system_settings != null && (var.system_settings.custom_ui_file != null || var.system_settings.custom_ui_xml != null) ? 1 : 0
  app_domain      = var.app_domain
  provider_target = var.provider_target
  remote_path     = "local:///custom_ui_${random_id.ui[0].hex}.xml"
  local_path      = var.system_settings.custom_ui_file != null ? var.system_settings.custom_ui_file : null
  content         = var.system_settings.custom_ui_xml != null ? var.system_settings.custom_ui_xml : null
  depends_on = [
    datapower_domain.this,
    random_id.ui[0],
  ]
  lifecycle {
    create_before_destroy = true
  }
}
