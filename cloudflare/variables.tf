variable "cloudflare_api_token" {
  description = "The Cloudflare API token"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare zone ID"
  type        = string
}

# lhowsam (todo - clean this up like now-playing later down the line)
variable "lhowsam_prod_a_record_content" {
  description = "lhowsam_prod_a_ip"
  type        = string
}

variable "lhowsam_prod_google_site_vertification_content" {
  description = "google site verification content"
  type        = string
}

variable "lhowsam_staging_content" {
  description = "The cloudfront domain for staging.lhowsam"
  type        = string
}

# now-playing production domain config
variable "now_playing_prod_domain_config" {
  type = map(object({
    name    = string
    content = string
  }))
}

# now-playing staging domain config
variable "now_playing_staging_domain_config" {
  type = map(object({
    name    = string
    content = string
  }))
}