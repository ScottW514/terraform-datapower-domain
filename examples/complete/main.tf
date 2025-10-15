module "default_domain" {
  source              = "../../"
  app_domain          = "default"
  user_summary        = "Default domain"
  domain_availability = true
  statistics          = true
  system_settings = {
    custom_ui_xml = <<XMLTEXT
<User-Interface xmlns="http://www.datapower.com/schemas/user-interface/1.0">
    <MarkupBanner type="system-banner" location="header" foreground-color="black" background-color="yellow">
        MODULE TEST 123
    </MarkupBanner>
    <MarkupBanner type="system-banner" location="footer" foreground-color="black" background-color="yellow">
        MODULE TEST 123
    </MarkupBanner>
    <TextBanner type="system-banner">
        MODULE TEST 123
    </TextBanner>
</User-Interface>
XMLTEXT
  }
  time_settings = {
    local_time_zone = "EST5EDT"
  }
}

module "exmaple_domain" {
  source              = "../../"
  app_domain          = "ExampleDomain"
  neighbor_domains    = ["default"]
  user_summary        = "Example domain for module"
  domain_availability = true
  statistics          = true
  depends_on          = [module.default_domain]
}
