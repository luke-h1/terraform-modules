###############################################
#           AWS now playing lambdas           #
###############################################

# production (nowplaying.lhowsam.com)

# validation
resource "cloudflare_record" "now_playing_production_lambda_validation_record" {
  comment = "NOW PLAYING LAMBDA VALIDATION PROD"
  content = var.now_playing_prod_domain_config["validation"].content
  name    = var.now_playing_prod_domain_config["validation"].name
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_record" "now_playing_prod_acm_cert_validation_record" {
  comment = "PROD NOW PLAYING ACM VALIDATION"
  content = var.now_playing_prod_domain_config["acm_cert_validation"].content
  name    = var.now_playing_prod_domain_config["acm_cert_validation"].name
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}


# CNAME
resource "cloudflare_record" "nowplaying_lambda_production_cname_record" {
  content = var.now_playing_prod_domain_config["cname_record"].content
  name    = "nowplaying"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}


# staging (nowplaying-staging.lhowsam.com)

# validation
resource "cloudflare_record" "now_playing_staging_lambda_validation_record" {
  comment = "STAGING NOW PLAYING VALIDATION"
  content = var.now_playing_staging_domain_config["acm_cert_validation"].content
  name    = var.now_playing_staging_domain_config["acm_cert_validation"].name
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}

# CNAME
resource "cloudflare_record" "nowplaying_staging_lambda_cname_record" {
  content = var.now_playing_staging_domain_config["cname_record"].content
  name    = "nowplaying-staging"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}
