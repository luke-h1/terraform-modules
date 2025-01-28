resource "cloudflare_record" "status_page_cname_record" {
  content = "statuspage.betteruptime.com"
  name    = "status"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}
