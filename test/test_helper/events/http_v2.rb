module TestHelpers
  module Events
    class HttpV2 < Base

      # Via Custom Domain Name integration.
      #
      self.event = {"version"=>"2.0", "routeKey"=>"$default", "rawPath"=>"/production/", "rawQueryString"=>"colors[]=blue&colors[]=red", "cookies"=>["signal1=test", "signal2=control"], "headers"=>{"accept"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "accept-encoding"=>"gzip, deflate, br", "accept-language"=>"en-us", "content-length"=>"0", "host"=>"myawesomelambda.example.com", "user-agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15", "x-amzn-trace-id"=>"Root=1-5e7fe714-fee6909429159440eb352c40", "x-forwarded-for"=>"72.218.219.201", "x-forwarded-port"=>"443", "x-forwarded-proto"=>"https"}, "requestContext"=>{"accountId"=>nil, "apiId"=>"n12pmpajak", "domainName"=>"myawesomelambda.example.com", "domainPrefix"=>"myawesomelambda", "http"=>{"method"=>"GET", "path"=>"/production/", "protocol"=>"HTTP/1.1", "sourceIp"=>"72.218.219.201", "userAgent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15"}, "requestId"=>"KSP7Mj94IAMEMFQ=", "routeKey"=>"$default", "stage"=>"production", "time"=>"01/Apr/2020:02:18:09 +0000", "timeEpoch"=>1585707489142}, "isBase64Encoded"=>false}.freeze

      # Via CloudFront directly to API Gateway w/Origin Path.
      #
      # {"version"=>"2.0", "routeKey"=>"$default", "rawPath"=>"/production/", "rawQueryString"=>"colors[]=blue&colors[]=red", "headers"=>{"accept"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "accept-encoding"=>"gzip", "content-length"=>"0", "host"=>"n12pmpajak.execute-api.us-east-1.amazonaws.com", "user-agent"=>"Amazon CloudFront", "via"=>"2.0 2f66aa06710fece8ed203ab0ea81eb56.cloudfront.net (CloudFront)", "x-amz-cf-id"=>"rQOlQ0dg3A9zrTfLqgBRWS8tDQJVmxtm3QrCf0wN0jEczCNucdJqKw==", "x-amzn-trace-id"=>"Root=1-5e83c9c2-b01dc280b06a4d00bcaeb480", "x-forwarded-for"=>"72.218.219.201, 3.231.2.1", "x-forwarded-host"=>"myawesomelambda.example.com", "x-forwarded-port"=>"443", "x-forwarded-proto"=>"https"}, "queryStringParameters"=>{"colors[]"=>"blue,red"}, "requestContext"=>{"accountId"=>nil, "apiId"=>"n12pmpajak", "domainName"=>"n12pmpajak.execute-api.us-east-1.amazonaws.com", "domainPrefix"=>"n12pmpajak", "http"=>{"method"=>"GET", "path"=>"/production/", "protocol"=>"HTTP/1.1", "sourceIp"=>" 3.231.2.1", "userAgent"=>"Amazon CloudFront"}, "requestId"=>"KRx2bgOfoAMETBA=", "routeKey"=>"$default", "stage"=>"production", "time"=>"31/Mar/2020:22:52:50 +0000", "timeEpoch"=>1585695170625}, "isBase64Encoded"=>false}

    end
  end
end
