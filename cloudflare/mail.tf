resource "cloudflare_record" "email_alias_1" {
  content  = "route3.mx.cloudflare.net"
  name     = "lhowsam.com"
  priority = 5
  proxied  = false
  ttl      = 1
  type     = "MX"
  zone_id  = var.cloudflare_zone_id
}

resource "cloudflare_record" "email_alias_2" {
  content  = "route2.mx.cloudflare.net"
  name     = "lhowsam.com"
  priority = 97
  proxied  = false
  ttl      = 1
  type     = "MX"
  zone_id  = var.cloudflare_zone_id
}

resource "cloudflare_record" "email_alias_3" {
  content  = "route1.mx.cloudflare.net"
  name     = "lhowsam.com"
  priority = 78
  proxied  = false
  ttl      = 1
  type     = "MX"
  zone_id  = var.cloudflare_zone_id
}

resource "cloudflare_record" "email_alias_txt" {
  content = "\"v=spf1 include:_spf.mx.cloudflare.net ~all\""
  name    = "lhowsam.com"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cloudflare_zone_id
}
