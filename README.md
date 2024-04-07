# Terraform S3 Website Cloudflare

Este é um módulo Terraform para criar um site estático hospedado no Amazon S3 com DNS gerenciado pelo Cloudflare.

## Como Usar

### Pré-requisitos

- Conta AWS com permissões para criar recursos S3
- Conta Cloudflare com acesso à API Token

### Exemplo

```hcl
# provider.tf

# Criação do bucket S3
provider "aws" {
  region  = var.aws_region  # Altere para a sua região desejada
}

# Criação do registro DNS na Cloudflare
provider "cloudflare" {
  alias      = "dns"
  api_token  = var.cloudflare_api_token
}

# example.tf

module "s3_static_website" {
  source               = "github.com/brunoh1n1/terraform-s3-website-cloudflare"
  subdomain            = "subdominio-do-site"
  bucket_name          = "nome-do-bucket"
  aws_region           = "us-east-1"
  cloudflare_api_token = "cloudflare-api-token"
  zone_id              = "cloudflare-zone-id"
}


```

# Contribuindo

Se você quiser contribuir para este projeto, siga estas etapas:

  1  Fork este repositório
  2  Crie um branch para sua funcionalidade (git checkout -b feature/sua-funcionalidade)
  3  Faça commit das suas alterações (git commit -am 'Adicionar nova funcionalidade')
  4  Faça push do branch para o seu fork (git push origin feature/sua-funcionalidade)
  5  Abra um pull request

# Licença

Este projeto é licenciado sob a licença MIT - veja o arquivo LICENSE para mais detalhes.
