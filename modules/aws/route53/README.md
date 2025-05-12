# AWS Route53 Module

This Terraform module creates and manages AWS Route53 hosted zones and DNS records.

## Features

- Create public or private hosted zones
- Support for standard DNS records
- Support for alias records
- Tagging support
- VPC association for private zones

## Usage

```hcl
module "route53" {
  source = "../../../modules/aws/route53"

  environment  = "staging"
  domain_name  = "example.com"
  private_zone = false
  vpc_id       = "vpc-12345678"

  tags = {
    Project = "MyProject"
  }

  records = [
    {
      name    = "www"
      type    = "A"
      ttl     = 300
      records = ["192.0.2.1"]
    }
  ]

  alias_records = [
    {
      name = "api"
      type = "A"
      alias = {
        name                   = "alb-123456789.us-west-1.elb.amazonaws.com"
        zone_id                = "Z35SXDOTRQ7X7K"
        evaluate_target_health = true
      }
    }
  ]
}
```

## Inputs

| Name          | Description                                      | Type         | Default | Required |
| ------------- | ------------------------------------------------ | ------------ | ------- | -------- |
| environment   | Environment name                                 | string       | -       | yes      |
| domain_name   | The domain name for the hosted zone              | string       | -       | yes      |
| private_zone  | Whether this is a private hosted zone            | bool         | false   | no       |
| vpc_id        | VPC ID to associate with the private hosted zone | string       | null    | no       |
| tags          | A map of tags to add to all resources            | map(string)  | {}      | no       |
| records       | List of DNS records to create                    | list(object) | []      | no       |
| alias_records | List of alias records to create                  | list(object) | []      | no       |

## Outputs

| Name         | Description                                         |
| ------------ | --------------------------------------------------- |
| zone_id      | The ID of the hosted zone                           |
| name_servers | A list of name servers in associated delegation set |
| zone_name    | The name of the hosted zone                         |

## Requirements

- Terraform >= 1.0.0
- AWS Provider >= 4.0.0
