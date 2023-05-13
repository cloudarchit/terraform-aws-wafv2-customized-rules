variable "name" {
  description = "Name of waf acl resource as indentifier"
  type = string
  default = "waf-acl"
}

variable "allow_ip_list" {
  description = "List of IP addresses to allow access through waf"
  type    = list(string)
  default = []
}

variable "allow_custom_header" {
  description = "Custom header key and value to allow access through waf"
  type = list(map(string))
  default = [
  #{
  #  key   = ""
  #  value = ""
  #}
  ]
}

variable "basic_auth_config" {
  description = "Whether to set basic authentication and its values"
  type = map(string)
  default = {
    user = ""
    pass = ""
  }
}

variable "cloudwatch_metrics_enabled"{
  description = "Whether the associated resource sends metrics to CloudWatch" 
  type = bool
  default = true
}

variable "sampled_requests_enabled"{
  description = "Whether AWS WAF should store a sampling of the web requests that match the rules" 
  type = bool
  default = true
}