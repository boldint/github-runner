plugin "google" {
    enabled = true
    version = "0.10.0"
    source  = "github.com/terraform-linters/tflint-ruleset-google"
}
plugin "aws" {
    enabled = true
    version = "0.5.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
plugin "azurerm" {
    enabled = true
    version = "0.11.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
