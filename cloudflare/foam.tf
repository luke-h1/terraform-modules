# Currently not deployed but that will change soon
resource "cloudflare_record" "foam_auth_lambda_staging_record" {
  content = "d-ub19va5gt4.execute-api.eu-west-2.amazonaws.com"
  name    = "foam-staging"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}
