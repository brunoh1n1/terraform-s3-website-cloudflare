#provider "aws" {
#  profile = "cloudprotegida-production"
#  region  = var.aws_region  # Altere para a sua região desejada
#}

# Criação do registro DNS na Cloudflare
provider "cloudflare" {
  alias = "dns"
  api_token = var.cloudflare_api_token
}
