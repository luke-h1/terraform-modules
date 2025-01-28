#!/bin/bash

set -e 


CLOUDFLARE_EMAIL=""
CLOUDFLARE_API_TOKEN=""
CLOUDFLARE_ZONE_ID=""

cf-terraforming generate -e "$CLOUDFLARE_EMAIL" -t "$CLOUDFLARE_API_TOKEN" --resource-type "cloudflare_record" --zone "$CLOUDFLARE_ZONE_ID"
