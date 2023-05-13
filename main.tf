resource "aws_wafv2_ip_set" "this" {
  count = length(var.allow_ip_list) == 0 ? 0 : 1

  ip_address_version = "IPV4"
  scope              = "CLOUDFRONT"
  name        = "${var.waf_name}-ipset"
  description = "${var.waf_name}-ipset"
  addresses   = var.allow_ip_list
}

resource "aws_wafv2_web_acl" "this" {
  name = var.waf_name

  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled 
    metric_name                = var.waf_name
    sampled_requests_enabled   = var.sampled_requests_enabled  
  }

  dynamic "rule" {
    for_each = length(var.allow_custom_header) == 0 ? [] : var.allow_custom_header
    content {
      name     = "${var.waf_name}-allow-header-rule"
      priority = 1
      action {
        allow {}
      }
      statement {
        byte_match_statement {
          positional_constraint = "EXACTLY"
          search_string         = var.allow_custom_header.value
          field_to_match {
            single_header {
              name = var.allow_custom_header.key
            }
          }
          text_transformation {
            priority = 0
            type     = "NONE"
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled 
        metric_name                = "${var.waf_name}-allow-header-rule"
        sampled_requests_enabled   = var.sampled_requests_enabled  
      }
    }
  }

  dynamic "rule" {
    for_each = length(var.allow_ip_list) == 0 ? [] : [1]
    content {
      name     = "${var.waf_name}-allow-ip-rule"
      priority = 2

      action {
        block {}
      }

      statement {
        not_statement {
          statement {
            ip_set_reference_statement {
              arn = aws_wafv2_ip_set.ipset.arn
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled 
        metric_name                = "${var.waf_name}-allow-ip-rule"
        sampled_requests_enabled   = var.sampled_requests_enabled  
      }
    }
  }

  dynamic "rule" {
    for_each = var.basic_auth_config.user == "" ? [] : [var.basic_auth_config]
    content {
      name     = "${var.waf_name}-allow-basicauth-rule"
      priority = 3
      action {
        block {
          custom_response {
            response_code = 401
            response_header {
              name  = "www-authenticate"
              value = "Basic"
            }
          }
        }
      }
      statement {
        not_statement {
          statement {
            byte_match_statement {
              positional_constraint = "EXACTLY"
              search_string         = "Basic ${base64encode("${var.basic_auth_config.user}:${var.basic_auth_config.pass}")}"
              field_to_match {
                single_header {
                  name = "authorization"
                }
              }
              text_transformation {
                priority = 0
                type     = "NONE"
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled 
        metric_name                = "${var.waf_name}-allow-basicauth-rule"
        sampled_requests_enabled   = var.sampled_requests_enabled  
      }
    }
  }
}
