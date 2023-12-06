

resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${var.bucket_name}/*",
        Condition = {
          IpAddress = {
            "aws:SourceIp": [
              "103.21.244.0/22",
              "103.22.200.0/22",
              "103.31.4.0/22",
              "104.16.0.0/13",
              "104.24.0.0/14",
              "108.162.192.0/18",
              "131.0.72.0/22",
              "141.101.64.0/18",
              "162.158.0.0/15",
              "172.64.0.0/13",
              "173.245.48.0/20",
              "188.114.96.0/20",
              "190.93.240.0/20",
              "197.234.240.0/22",
              "198.41.128.0/17",
              "2400:cb00::/32",
              "2606:4700::/32",
              "2803:f800::/32",
              "2405:b500::/32",
              "2405:8100::/32",
              "2a06:98c0::/29",
              "2c0f:f248::/32"
            ]
          }
        }
      }
    ]
  })
  depends_on = [
   aws_s3_bucket.static_website,
   aws_s3_bucket_public_access_block.static_website
  ]
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket                  = aws_s3_bucket.static_website.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      http_error_code_returned_equals = 403
    }
    redirect {
      host_name = var.subdomain
    }
  }
}

data "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name
  depends_on = [
   aws_s3_bucket.static_website
  ]
}

resource "aws_s3_bucket_cors_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["https://${var.subdomain}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

output "website_url" {
  value = "http://${var.subdomain}.${var.bucket_name}.s3-website-${var.aws_region}.amazonaws.com/"
}

resource "cloudflare_record" "bucket_to_subdomain" {
  provider = cloudflare.dns
  zone_id = var.zone_id
  name    = var.subdomain
  type    = "CNAME"
  value   = data.aws_s3_bucket.static_website.website_endpoint
  proxied = true 
  ttl     = 1
  depends_on = [
   aws_s3_bucket.static_website
  ]
}
