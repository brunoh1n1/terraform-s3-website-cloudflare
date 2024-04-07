# terraform-s3-website-cloudflare



´´
Provider.tf

# Criação do bucket S3
provider "aws" {
  region  = var.aws_region  # Altere para a sua região desejada
}

# Criação do registro DNS na Cloudflare
provider "cloudflare" {
  alias = "dns"
  api_token = var.cloudflare_api_token
}


exampe.tf


module "s3_static_website" {
  source               = "github.com/brunoh1n1/terraform-s3-website-cloudflare"
  subdomain            = "subdominio-do-site"
  bucket_name          = "nome-do-bucket"
  aws_region           = "us-east-1"
  cloudflare_api_token = "cloudflare-api-token"
  zone_id              = "cloudflare-zone-id"
}

