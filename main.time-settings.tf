resource "datapower_time_settings" "this" {
  count                       = var.app_domain == "default" && var.time_settings != null ? 1 : 0
  provider_target             = var.provider_target
  local_time_zone             = var.time_settings.local_time_zone
  custom_tz_name              = var.time_settings.custom_tz_name
  utc_direction               = var.time_settings.utc_direction
  offset_hours                = var.time_settings.offset_hours
  offset_minutes              = var.time_settings.offset_minutes
  daylight_offset_hours       = var.time_settings.daylight_offset_hours
  tz_name_dst                 = var.time_settings.tz_name_dst
  daylight_start_month        = var.time_settings.daylight_start_month
  daylight_start_week         = var.time_settings.daylight_start_week
  daylight_start_day          = var.time_settings.daylight_start_day
  daylight_start_time_hours   = var.time_settings.daylight_start_time_hours
  daylight_start_time_minutes = var.time_settings.daylight_start_time_minutes
  daylight_stop_month         = var.time_settings.daylight_stop_month
  daylight_stop_week          = var.time_settings.daylight_stop_week
  daylight_stop_day           = var.time_settings.daylight_stop_day
  daylight_stop_time_hours    = var.time_settings.daylight_stop_time_hours
  daylight_stop_time_minutes  = var.time_settings.daylight_stop_time_minutes
  depends_on = [
    datapower_domain.this,
  ]
}
