###############################################
#                  Vercel                     #
###############################################

# lhowsam.com (production)
resource "cloudflare_record" "lhowsam_production_a_record" {
  content = var.lhowsam_prod_a_record_content
  name    = "lhowsam.com"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = var.cloudflare_zone_id
}


resource "cloudflare_record" "lhowsam_prod_www_cname_record" {
  content = "cname.vercel-dns.com"
  name    = "www"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_record" "lhowsam_production_google_site_verification" {
  content = var.lhowsam_prod_google_site_vertification_content
  name    = "lhowsam.com"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = var.cloudflare_zone_id
}


# dev.lhowsam.com (development)
resource "cloudflare_record" "lhowsam_dev_cname_record" {
  content = "cname.vercel-dns.com"
  name    = "dev"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_record" "lhowsam_dev_www_cname_record" {
  content = "cname.vercel-dns.com"
  name    = "www.dev"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}

###############################################
#                  branches                   #
###############################################

resource "cloudflare_record" "branches_cname_record" {
  content = "cname.vercel-dns.com"
  name    = "branches"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}


###############################################
#               feature-flag-talk             #
###############################################

resource "cloudflare_record" "feature_flag_talk_cname_record" {
  content = "cname.vercel-dns.com"
  name    = "feature-flags-24.talks"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}


# staging.lhowsam.com AWS poc
resource "cloudflare_record" "sst_lhowsam_staging_caa_record" {
  comment = "SST"
  content = "0 issue \"amazonaws.com\""
  name    = "staging"
  proxied = false
  ttl     = 60
  type    = "CAA"
  zone_id = var.cloudflare_zone_id
  data {
    flags = 0
    tag   = "issue"
    value = "amazonaws.com"
  }
}

resource "cloudflare_record" "lhowsam_staging_cname_record" {
  comment = "SST"
  content = var.lhowsam_staging_content
  name    = "staging"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
}