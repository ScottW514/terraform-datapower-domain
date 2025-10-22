# IBM DataPower Gateway Domain Configuration Module

This Terraform module manages IBM DataPower Gateway domain configurations, enabling users to create and configure application domains, file permissions, monitoring settings, statistics collection, system-wide settings, and time zone configurations. It leverages the `scottw514/datapower` provider to interact with IBM DataPower Gateway appliances and supports both default and non-default domains.

The module is designed to be flexible, allowing conditional configuration of domain-specific settings and system-wide settings (applicable only to the `default` domain). It includes robust validation to ensure compliance with DataPower Gateway constraints, such as domain name formatting and restrictions on neighbor domains. Additionally, it supports custom UI file uploads and detailed time zone configurations for precise system time management.

## Features
- Create and manage DataPower Gateway application domains.
- Configure file permissions and monitoring for the `local:` directory.
- Enable or disable domain availability and statistics collection.
- Manage system-wide settings, including audit reserve, contact information, and custom UI files (for the `default` domain only).
- Configure custom or predefined time zones for the system (for the `default` domain only).

## Usage
This module is intended for use with IBM DataPower Gateway appliances and requires the `scottw514/datapower` provider. Ensure the provider is properly configured with the necessary credentials and endpoint details before using this module. For detailed provider documentation, refer to the [DataPower provider documentation](https://registry.terraform.io/providers/ScottW514/datapower/latest/docs).

To use this module, include it in your Terraform configuration and provide the required variables, such as `app_domain`. Optional variables can be used to customize file permissions, monitoring, system settings, and time zones as needed.

### Example
```hcl
module "datapower_domain" {
  source        = "scottw514/domain/datapower"
  app_domain    = "my-app-domain"
  domain_availability = true
  file_map = {
    delete    = false
  }
  monitoring_map = {
    audit = true
    log   = true
  }
  statistics = true
}
```

For configurations targeting the `default` domain, additional settings like `system_settings` and `time_settings` can be specified:

```hcl
module "datapower_default_domain" {
  source        = "scottw514/domain/datapower"
  app_domain    = "default"
  system_settings = {
    audit_reserve = 50
    locale        = "en"
    system_name   = "MyDataPowerGateway"
  }
  time_settings = {
    local_time_zone = "UTC"
  }
}
```

## Notes
- The `system_settings` and `time_settings` variables are only applicable to the `default` domain, as enforced by validation rules.
- The module uses the `hashicorp/random` provider to generate unique file names for custom UI files, ensuring no conflicts during uploads.
- Ensure the `scottw514/datapower` provider is compatible with your DataPower Gateway version and is actively maintained.
