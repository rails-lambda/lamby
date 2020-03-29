module TestHelpers
  module Events
    class Alb < Base

      self.event = {
        "requestContext" =>  {
          "elb" =>  {
            "targetGroupArn" => "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/myawesomelambda-1rndy3u8psl2j/3f1bcbeec09c9050"}
          },
        "httpMethod" => "GET",
        "path" => "/",
        "multiValueQueryStringParameters" => {"colors[]" => ["blue", "red"]},
        "multiValueHeaders" => {
          "accept" => ["text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"],
          "accept-encoding" => ["gzip"],
          "connection" => ["Keep-Alive"],
          "cookie" => ["signal1=test; signal2=control"],
          "host" => ["myawesomelambda.example.com"],
          "user-agent" => ["Amazon CloudFront"],
          "via" => ["2.0 3dc5b7040885724e78019cc31f0ef3d9.cloudfront.net (CloudFront)"],
          "x-amz-cf-id" => ["BSlDkHoVD8-009TATJzymLqSBzViE_6jj7DlkiJkub-PpDb8wI4Pxw=="],
          "x-amzn-trace-id" => ["Root=1-5e7c160a-0a9065c7a28a428cd8b98215"],
          "x-forwarded-for" => ["72.218.219.201", "72.218.219.201", "34.195.252.132"],
          "x-forwarded-host" => ["myawesomelambda.example.com"],
          "x-forwarded-port" => ["443"],
          "x-forwarded-proto" => ["https"]
        },
        "body" => "",
        "isBase64Encoded" => false
      }.freeze

    end
  end
end
