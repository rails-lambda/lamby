module TestHelpers
  module Events
    class HttpV1 < Base
      # Via Custom Domain Name integration.
      #
      self.event = {
        "version" => "1.0",
        "resource" => "$default",
        "path" => "/",
        "httpMethod" => "GET",
        "headers" => {
          "Content-Length" => "0",
          "Host" => "myawesomelambda.example.com",
          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15",
          "X-Amzn-Trace-Id" => "Root=1-5e7fe714-fee6909429159440eb352c40",
          "X-Forwarded-For" => "72.218.219.201",
          "X-Forwarded-Port" => "443",
          "X-Forwarded-Proto" => "https",
          "accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
          "accept-encoding" => "gzip, deflate, br",
          "accept-language" => "en-us",
          "cookie" => "signal1=test; signal2=control"
        },
        "multiValueHeaders" => {
          "Content-Length" => ["0"],
          "Host" => ["myawesomelambda.example.com"],
          "User-Agent" => ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15"],
          "X-Amzn-Trace-Id" => ["Root=1-5e7fe714-fee6909429159440eb352c40"],
          "X-Forwarded-For" => ["72.218.219.201"],
          "X-Forwarded-Port" => ["443"],
          "X-Forwarded-Proto" => ["https"],
          "accept" => ["text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"],
          "accept-encoding" => ["gzip, deflate, br"],
          "accept-language" => ["en-us"]
        },
        "queryStringParameters" => {
          "colors[]" => "red"
        },
        "multiValueQueryStringParameters" => {
          "colors[]" => ["blue", "red"]
        },
        "requestContext" => {
          "accountId" => nil,
          "apiId" => "n12pmpajak",
          "domainName" => "myawesomelambda.example.com",
          "domainPrefix" => "myawesomelambda",
          "extendedRequestId" => "KSCL-irBIAMEJIA=",
          "httpMethod" => "GET",
          "identity" => {
            "accessKey" => nil,
            "accountId" => nil,
            "caller" => nil,
            "cognitoAuthenticationProvider" => nil,
            "cognitoAuthenticationType" => nil,
            "cognitoIdentityId" => nil,
            "cognitoIdentityPoolId" => nil,
            "principalOrgId" => nil,
            "sourceIp" => "72.218.219.201",
            "user" => nil,
            "userAgent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15",
            "userArn" => nil
          },
          "path" => "/production/",
          "protocol" => "HTTP/1.1",
          "requestId" => "KSCL-irBIAMEJIA=",
          "requestTime" => "01/Apr/2020:00:44:22 +0000",
          "requestTimeEpoch" => 1585701862143,
          "resourceId" => "$default",
          "resourcePath" => "$default",
          "stage" => "production"
        },
        "pathParameters" => nil,
        "stageVariables" => nil,
        "body" => nil,
        "isBase64Encoded" => false
      }.freeze

      # Via CloudFront directly to API Gateway w/Origin Path.
      #
      # self.event = {
      #   "version" => "1.0",
      #   "resource" => "$default",
      #   "path" => "/production/",
      #   "httpMethod" => "GET",
      #   "headers" => {
      #     "Content-Length" => "0",
      #     "Host" => "n12pmpajak.execute-api.us-east-1.amazonaws.com",
      #     "User-Agent" => "Amazon CloudFront",
      #     "X-Amz-Cf-Id" => "XPTzwjMoVu5Vlp6QLBl_f1NNa2IXRpF_LAFJ9isoq_Pb4MUarItT0w==",
      #     "X-Amzn-Trace-Id" => "Root=1-5e83cbd2-bfd143859e9214f4860e2779",
      #     "X-Forwarded-For" => "72.218.219.201, 3.231.2.50",
      #     "X-Forwarded-Host" => "myawesomelambda.example.com",
      #     "X-Forwarded-Port" => "443",
      #     "X-Forwarded-Proto" => "https",
      #     "accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      #     "accept-encoding" => "gzip",
      #     "via" => "2.0 613faec4b883bfe2ebdd8a74d5006f4c.cloudfront.net (CloudFront)"
      #   },
      #   "multiValueHeaders" => {
      #     "Content-Length" => ["0"],
      #     "Host" => ["n12pmpajak.execute-api.us-east-1.amazonaws.com"],
      #     "User-Agent" => ["Amazon CloudFront"],
      #     "X-Amz-Cf-Id" => ["XPTzwjMoVu5Vlp6QLBl_f1NNa2IXRpF_LAFJ9isoq_Pb4MUarItT0w=="],
      #     "X-Amzn-Trace-Id" => ["Root=1-5e83cbd2-bfd143859e9214f4860e2779"],
      #     "X-Forwarded-For" => ["72.218.219.201, 3.231.2.50"],
      #     "X-Forwarded-Host" => ["myawesomelambda.example.com"],
      #     "X-Forwarded-Port" => ["443"],
      #     "X-Forwarded-Proto" => ["https"],
      #     "accept" => ["text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"],
      #     "accept-encoding" => ["gzip"],
      #     "via" => ["2.0 613faec4b883bfe2ebdd8a74d5006f4c.cloudfront.net (CloudFront)"]
      #   },
      #   "queryStringParameters" => {
      #     "colors[]" => "red"
      #   },
      #   "multiValueQueryStringParameters" => {
      #     "colors[]" => ["blue", "red"]
      #   },
      #   "requestContext" => {
      #     "accountId" => nil,
      #     "apiId" => "n12pmpajak",
      #     "domainName" => "n12pmpajak.execute-api.us-east-1.amazonaws.com",
      #     "domainPrefix" => "n12pmpajak",
      #     "extendedRequestId" => "KRzI1i2uoAMEPCA=",
      #     "httpMethod" => "GET",
      #     "identity" => {
      #       "accessKey" => nil,
      #       "accountId" => nil,
      #       "caller" => nil,
      #       "cognitoAuthenticationProvider" => nil,
      #       "cognitoAuthenticationType" => nil,
      #       "cognitoIdentityId" => nil,
      #       "cognitoIdentityPoolId" => nil,
      #       "principalOrgId" => nil,
      #       "sourceIp" => "3.231.2.50",
      #       "user" => nil,
      #       "userAgent" => "Amazon CloudFront",
      #       "userArn" => nil
      #     },
      #     "path" => "/production/",
      #     "protocol" => "HTTP/1.1",
      #     "requestId" => "KRzI1i2uoAMEPCA=",
      #     "requestTime" => "31/Mar/2020:23:01:38 +0000",
      #     "requestTimeEpoch" => 1585695698070,
      #     "resourceId" => "$default",
      #     "resourcePath" => "$default",
      #     "stage" => "production"
      #   },
      #   "pathParameters" => nil,
      #   "stageVariables" => nil,
      #   "body" => nil,
      #   "isBase64Encoded" => false
      # }.freeze
    end
  end
end