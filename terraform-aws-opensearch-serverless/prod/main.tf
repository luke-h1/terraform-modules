module "opensearch_serverless" {
  source = "../"
  
  collection_name = "lho-logs"
  index_name      = "aws-logs"
  log_group_names = [
    # foam proxy gw
    "/aws/api_gw/foam-proxy-gw-production",
    "/aws/api_gw/foam-proxy-gw-staging",

    # foam lambda 
    "/aws/lambda/foam-proxy-lambda-production",
    "/aws/lambda/foam-proxy-lambda-staging",

    # foam api authorizer
    "/aws/lambda/foam-proxy-api-authorizer-staging",
    "/aws/lambda/foam-proxy-api-authorizer-production",


    # now playing gw
    "/aws/api_gw/now-playing-gw-production",
    "/aws/api_gw/now-playing-gw-staging",


    # now playing lambda
    "/aws/lambda/now-playing-lambda-live",
    "/aws/lambda/now-playing-lambda-staging",

    # now playing api authorizer
    "/aws/lambda/now-playing-api-authorizer-staging",
    "/aws/lambda/now-playing-api-authorizer-production",
    "/aws/lambda/now-playing-api-key-authorizer-staging",
    "/aws/lambda/now-playing-api-key-authorizer-production",

  ]
  
  tags = {
    Environment = "production"
    Project     = "logging"
  }
}