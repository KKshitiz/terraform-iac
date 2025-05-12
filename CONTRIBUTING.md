# Contribution Guidelines

## Naming Conventions

- **Environments**: Separate environments in the `environments` folder based on the cloud provider.
- **Scripts**: Place any script in the `scripts` folder.
- **Modules**: Separate modules based on the cloud provider. If they are common to all, put them in the `platform` folder.

## Tagging and Labeling Standards

### Terraform Resource Tagging

- **Default Tags**: Use the provider's `default_tags` configuration block to automatically apply common tags to all resources.
  - Example (AWS):
    ```hcl
    provider "aws" {
      region = var.region
      default_tags {
        tags = {
          ManagedBy   = "Terraform"
          Environment = var.environment
          Project     = var.project_name
        }
      }
    }
    ```
- **Resource-Specific Tags**: Add any additional, resource-specific tags directly to the resource.
  - Example:
    ```hcl
    resource "aws_s3_bucket" "example" {
      bucket = "my-bucket"
      tags = {
        Department = "Finance"
        Owner      = "alice@example.com"
      }
    }
    ```
- **Tag Format**:
  - Tags should be UpperCamelCase (e.g., `ManagedBy`, `Environment`, `Project`)
  - Required tags:
    - `ManagedBy: Terraform`
    - `Environment: {staging, production, all}`
    - `Project: <project_name>`

### Kubernetes Resource Labeling

- **Standard Labels**: Label Kubernetes resources with the [Kubernetes recommended labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/):
  - `app.kubernetes.io/name`: The name of the application
  - `app.kubernetes.io/instance`: A unique name identifying the instance of the application
  - `app.kubernetes.io/version`: The current version of the application
  - `app.kubernetes.io/component`: The component within the architecture
  - `app.kubernetes.io/part-of`: The name of a higher-level application this one is part of
  - `app.kubernetes.io/managed-by`: The tool being used to manage the operation of an application (e.g., `terraform`)
- **Example**:
  ```hcl
  resource "kubernetes_deployment" "example" {
    metadata {
      name = "my-app"
      labels = {
        "app.kubernetes.io/name"       = "my-app"
        "app.kubernetes.io/instance"   = "my-app-staging"
        "app.kubernetes.io/version"    = "1.0.0"
        "app.kubernetes.io/component"  = "backend"
        "app.kubernetes.io/part-of"    = "my-platform"
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }
    # ...
  }
  ```

## Summary

- Use provider `default_tags` for common tags; add specific tags at the resource level as needed.
- Always include `ManagedBy`, `Environment`, and `Project` tags.
- Use UpperCamelCase for tag keys.
- Label Kubernetes resources with the standard recommended labels for consistency and discoverability.
- See the examples above for reference.
