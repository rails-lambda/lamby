module TestHelpers
  module Events
    class HttpV2Post < Base

      # Via Custom Domain Name integration.
      #
      self.event = {"version"=>"2.0", "routeKey"=>"$default", "rawPath"=>"/production/login", "rawQueryString"=>"", "cookies"=>["signal1=test", "signal2=control"], "headers"=>{"accept"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "accept-encoding"=>"gzip, deflate, br", "accept-language"=>"en-us", "content-length"=>"146", "content-type"=>"application/x-www-form-urlencoded", "host"=>"myawesomelambda.example.com", "origin"=>"https://myawesomelambda.example.com", "referer"=>"https://myawesomelambda.example.com/?colors[]=blue&colors[]=red", "user-agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15", "x-amzn-trace-id"=>"Root=1-5e852ca4-3a8dd0c91bfb6e85f0dc55ba", "x-forwarded-for"=>"72.218.219.201", "x-forwarded-port"=>"443", "x-forwarded-proto"=>"https"}, "requestContext"=>{"accountId"=>nil, "apiId"=>"n12pmpajak", "domainName"=>"myawesomelambda.example.com", "domainPrefix"=>"myawesomelambda", "http"=>{"method"=>"POST", "path"=>"/production/login", "protocol"=>"HTTP/1.1", "sourceIp"=>"72.218.219.201", "userAgent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15"}, "requestId"=>"KVPpsgCooAMEMBQ=", "routeKey"=>"$default", "stage"=>"production", "time"=>"02/Apr/2020:00:07:00 +0000", "timeEpoch"=>1585786020373}, "body"=>"YXV0aGVudGljaXR5X3Rva2VuPThHR3ZFTTYlMkZiandERzNYQTNjaklaQk5Vc1RudWdTNXBjNEd1ZHlwNVpuZWNvcFFSNTYwcEt2bmJOcmhMYTRpVWpGT0NZT214JTJGeUV5SXBKcHNkM3NHQSUzRCUzRCZwYXNzd29yZD1wYXNzd29yZCZjb21taXQ9TG9naW4=", "isBase64Encoded"=>true}

    end
  end
end
