variable "app_domain" {
  type        = string
  description = <<DESCRIPTION
The name of the application domain.
DESCRIPTION
  nullable    = false
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,128}$", var.app_domain))
    error_message = "app_domain must be a between 1 and 128 characters, and only contain letters, numbers, dashes and underscores."
  }
}

variable "domain_availability" {
  type        = bool
  description = <<DESCRIPTION
(Optional) Enable domain availability
DESCRIPTION
  nullable    = false
  default     = false
}

variable "file_map" {
  type = object({
    copy_from = optional(bool, true)
    copy_to   = optional(bool, true)
    delete    = optional(bool, true)
    display   = optional(bool, true)
    exec      = optional(bool, true)
    subdir    = optional(bool, true)
  })
  default     = {}
  description = <<DESCRIPTION
(Optional) Specify the file permissions to apply to the `local:` directory.

- `copy_from` - (Optional) Allow files to be copied from. Default value: `true`
- `copy_to` - (Optional) Allow files to be copied to. Default value: `true`
- `delete` - (Optional) Allow files to be deleted. Default value: `true`
- `display` - (Optional) Allow file content to be displayed. Default value: `true`
- `exec` - (Optional) Allow files to be run as scripts. Default value: `true`
- `subdir` - (Optional) Allow subdirectories to be created. Default value: `true`
DESCRIPTION
  nullable    = false
}

variable "monitoring_map" {
  type = object({
    audit = optional(bool, false)
    log   = optional(bool, false)
  })
  default     = {}
  description = <<DESCRIPTION
(Optional) File-monitoring of the `local:` directory.

- `audit` - (Optional) Enable auditing. Default value: `false`
- `log` - (Optional) Enable logging. Default value: `false`
DESCRIPTION
  nullable    = false
}

variable "neighbor_domains" {
  type        = list(string)
  default     = null
  description = <<DESCRIPTION
(Optional) Specify which domains have their `local:` directory visible to this domain.
-> **Note:** Not valid for the `default` domain.
DESCRIPTION
  validation {
    condition     = var.neighbor_domains == null ? true : var.app_domain != "default"
    error_message = "neighbor_domains is not supported for the default domain."
  }
  validation {
    condition = var.neighbor_domains == null ? true : alltrue([
      for d in var.neighbor_domains : can(regex("^[a-zA-Z0-9_-]{1,128}$", d))
    ])
    error_message = "app_domain must be a between 1 and 128 characters, and only contain letters, numbers, dashes and underscores."
  }
  validation {
    condition = var.neighbor_domains == null ? true : alltrue([
      for d in var.neighbor_domains : d != var.app_domain
    ])
    error_message = "The neighbor_domains list cannot be self-referencing."
  }
}

variable "statistics" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
(Optional) Manages whether the system collects and presents statistics to help you determine whether the system correctly processes the transactions.
DESCRIPTION
}

variable "system_settings" {
  type = object({
    audit_reserve           = optional(number, 40)
    contact                 = optional(string, null)
    custom_ui_file          = optional(string, null)
    custom_ui_xml           = optional(string, null)
    entitlement_number      = optional(string, null)
    locale                  = optional(string, "en")
    location                = optional(string, null)
    system_log_fixed_format = optional(bool, false)
    system_name             = optional(string, null)
    user_summary            = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
(Optional) System-wide settings.  
-> **Note:** This is configurable for the default domain only.  

- `audit_reserve` - (Optional) Specifies the amount of disk space to reserve for audit records. Default value: `40`
- `contact` - (Optional) Specify any information that identifies the individual or functional area that is responsible maintenance and management. Default value: `null`
- `custom_ui_file` - (Optional) Specifies the local path (to this module) to the custom user interface file. Not valid if `custom_ui_xml` is set. Default value: `null`
- `custom_ui_xml` - (Optional) XML for the custom user interface file. Not valid if `custom_ui_file` is set. Default value: `null`
- `entitlement_number` - (Optional) After an appliance replacement, the serial number of the original appliance. Default value: `null`
- `locale` - (Optional) Specifies the locale for the operating language of the DataPower Gateway. Valid choices are `de`, `en`, `es`, `fr`, `it`, `ja`, `ko`, `pt_BR`, `zh_CN`, `zh_TW`.  Default value: `en`
- `location` - (Optional) Location of the DataPower Gateway. Default value: `null`
- `system_log_fixed_format` - (Optional) Indicates whether to enable fixed format in system logs. Default value: `false`
- `system_name` - (Optional) Enter the name of the DataPower Gateway to use internally as a custom prompt and to use externally to integrate with remote systems. Default value: `null`
- `user_summary` - (Optional) Descriptive summary for the configuration. Default value: `null`
DESCRIPTION
  nullable    = true
  validation {
    condition     = var.system_settings == null ? true : var.app_domain == "default"
    error_message = "system_settings is only configurable in the default domain."
  }
  validation {
    condition     = var.system_settings == null ? true : var.system_settings.custom_ui_file == null && var.system_settings.custom_ui_xml == null ? true : (var.system_settings.custom_ui_file != null && var.system_settings.custom_ui_xml == null) || (var.system_settings.custom_ui_file == null && var.system_settings.custom_ui_xml != null)
    error_message = "only system_settings.custom_ui_file or system_settings.custom_ui_xml can be specified, not both."
  }
  validation {
    condition = var.system_settings == null ? true : contains(
    ["de", "en", "es", "fr", "it", "ja", "ko", "pt_BR", "zh_CN", "zh_TW"], var.system_settings.locale)
    error_message = "system_settings.locale must be one of: de, en, es, fr, it, ja, ko, pt_BR, zh_CN, zh_TW"
  }
}

variable "time_settings" {
  type = object({
    local_time_zone             = optional(string, "EST5EDT")
    custom_tz_name              = optional(string, null)
    utc_direction               = optional(string, null)
    offset_hours                = optional(number, null)
    offset_minutes              = optional(number, null)
    daylight_offset_hours       = optional(number, null)
    tz_name_dst                 = optional(string, null)
    daylight_start_month        = optional(string, null)
    daylight_start_week         = optional(number, null)
    daylight_start_day          = optional(string, null)
    daylight_start_time_hours   = optional(number, null)
    daylight_start_time_minutes = optional(number, null)
    daylight_stop_month         = optional(string, null)
    daylight_stop_week          = optional(number, null)
    daylight_stop_day           = optional(string, null)
    daylight_stop_time_hours    = optional(number, null)
    daylight_stop_time_minutes  = optional(number, null)
  })
  default     = null
  description = <<DESCRIPTION
The time zone for the system. The time zone affects the time that the system displays. All timestamps use this time zone.  
-> **Note:** This is configurable for the default domain only.  

- `local_time_zone` - (Optional) Specify the time zone to use in management interfaces. Valid choices: `HST10`, `AKST9AKDT`, `PST8PDT`, `MST7MDT`, `CST6CDT`, `EST5EDT`, `AST4ADT`, `UTC`, `GMT0BST`, `CET-1CEST`, `EET-2EEST`, `MSK-3MSD`, `AST-3`, `KRT-5`, `IST-5:30`, `NOVST-6NOVDT`, `CST-8`, `WST-8`, `WST-8WDT`, `JST-9`, `CST-9:30CDT`, `EST-10EDT`, `EST-10`, `Custom`. Default value: `EST5EDT`
- `custom_tz_name` - (Optional) Specify the symbolic name for the custom time zone. This name is appended to local times. The name must be three or more alphabetic characters. Default Value: `STD`
- `utc_direction` - (Optional) Specify the direction relative to UTC for the custom time zone. Asia is east. North America is west. Default value: `East`
- `offset_hours` - (Optional) Specify the number of hours the custom time zone is from UTC. If 2 hours and 30 minutes from UTC, enter 2.
- `offset_minutes` - (Optional) Specify the number of minutes the time zone is from UTC. If 2 hours and 30 minutes from UTC, enter 30.
- `daylight_offset_hours` - (Optional) Specify the offset in hours when the custom time zone observes DST. Generally, the offset is 1 hour. Default value: `1`
- `tz_name_dst` - (Optional) Specify the symbolic name for the custom time zone during DST. This name is appended to local times. The name must be three or more alphabetic characters. Default value: `DST`
- `daylight_start_month` - (Optional) Specify the month when DST starts for the custom time zone. Default value: `March`.
- `daylight_start_week` - (Optional) Specify the instance of the day in the month when DST starts for the custom time zone. If DST starts on the second Sunday in the month, enter 2. Default value: `2`
- `daylight_start_day` - (Optional) Specify the day of the week when DST starts for the custom time zone. Default value: `Sunday`
- `daylight_start_time_hours` - (Optional) Specify the hour when DST starts for the custom time zone. If the start boundary is 2:30 AM, enter 2. Default value: `2`
- `daylight_start_time_minutes` - (Optional) Specify the minute when DST starts for the custom time zone. If the start boundary is 2:30 AM, enter 30.
- `daylight_stop_month` - (Optional) Specify the month when DST ends for the custom time zone. Default value: `November`
- `daylight_stop_week` - (Optional) Specify the instance of the day in the month when DST ends for the custom time zone. If DST ends on the second Sunday in the month, enter 2. Default value: `1`
- `daylight_stop_day` - (Optional) Specify the day of the week when DST ends for the custom time zone. Default value: `Sunday`
- `daylight_stop_time_hours` - (Optional) Specify the hour when DST ends for the custom time zone. If the end boundary is 2:30 AM, enter 2. Default value: `2`
- `daylight_stop_time_minutes` - (Optional) Specify the minute when DST ends for the custom time zone. If the end boundary is 2:30 AM, enter 30.
DESCRIPTION
  nullable    = true
  validation {
    condition     = var.time_settings == null ? true : var.app_domain == "default"
    error_message = "time_settings is only configurable in the default domain."
  }
  validation {
    condition = var.time_settings == null ? true : contains(
    ["HST10", "AKST9AKDT", "PST8PDT", "MST7MDT", "CST6CDT", "EST5EDT", "AST4ADT", "UTC", "GMT0BST", "CET-1CEST", "EET-2EEST", "MSK-3MSD", "AST-3", "KRT-5", "IST-5:30", "NOVST-6NOVDT", "CST-8", "WST-8", "WST-8WDT", "JST-9", "CST-9:30CDT", "EST-10EDT", "EST-10", "Custom"], var.time_settings.local_time_zone)
    error_message = "time_settings.local_time_zone must be one of: HST10, AKST9AKDT, PST8PDT, MST7MDT, CST6CDT, EST5EDT, AST4ADT, UTC, GMT0BST, CET-1CEST, EET-2EEST, MSK-3MSD, AST-3, KRT-5, IST-5:30, NOVST-6NOVDT, CST-8, WST-8, WST-8WDT, JST-9, CST-9:30CDT, EST-10EDT, EST-10, Custom"
  }
}

variable "user_summary" {
  type        = string
  default     = null
  description = <<DESCRIPTION
Comments
DESCRIPTION
}
