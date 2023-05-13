# terraform-aws-wafv2-customized-rules
AWS WAFv2 ACLs with customized rules

## Usage

```hcl
module "waf" {
    source = "cloudarchit/aws/waf/customrule"

    name = "waf-name"

    allow_ip_list = [
        "xx.xx.xx.xx/32"
    ]

    allow_custom_header = [
        {
            key   = "host"
            value = "example.com"
        }
    ]

    basic_auth_config = {
        user = "user"
        pass = "password"
    }

    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
}
```

### Examples

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.35 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_ip_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="name"></a> [name](#input\_name) | Name of waf acl resource as indentifier. | `string` | `waf-acl` | no |
| <a name="allow_ip_list"></a> [allow_ip_list](#input\_allow_ip_list) | List of IP addresses to allow access through waf. | `list(string)` | `[]` | no |
| <a name="allow_custom_header"></a> [allow_custom_header](#input\_allow_custom_header) | Custom header key and value to allow access through waf. | `list(map(string))` | `[]` | no |
| <a name="basic_auth_config"></a> [basic_auth_config](#input\_basic_auth_config) | Whether to set basic authentication and its values. | `map(string)` | `{}` | no |
| <a name="cloudwatch_metrics_enabled"></a> [cloudwatch_metrics_enabled](#input\_cloudwatch_metrics_enabled) | Whether the associated resource sends metrics to CloudWatch | `bool` | `true` | no |
| <a name="sampled_requests_enabled"></a> [sampled_requests_enabled](#input\_sampled_requests_enabled) | Whether AWS WAF should store a sampling of the web requests that match the rules | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="waf_arn"></a> [waf_arn](#output\_waf_arn) | The ARN of the WAF WebACL. |
| <a name="waf_id"></a> [waf_id](#output\_waf_id) | The ID of the WAF WebACL. |

## License
Apache 2 Licensed.
