output "waf_arn"{
  description = "The ARN of the WAF WebACL"
  value = try(aws_wafv2_web_acl.this.arn,"")
}

output "waf_id"{
  description = "The ID of the WAF WebACL"
  value = try(aws_wafv2_web_acl.this.id,"")
}