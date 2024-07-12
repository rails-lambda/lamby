module TestHelpers
  class LambdaContext

    RAW_DATA ={
      "clock_diff" => 1681486457423,
      "deadline_ms" => 1681492072985,
      "aws_request_id" => "d6f5961b-5034-4db5-b3a9-fa378133b0f0",
      "invoked_function_arn" => "arn:aws:lambda:us-east-1:576043675419:function:lamby-ws-production-WSConnectLambda-5in18cNskwz6",
      "log_group_name" => "/aws/lambda/lamby-ws-production-WSConnectLambda-5in18cNskwz6",
      "log_stream_name" => "2023/04/14/[$LATEST]55a1d458479a4546b64acca17af3a69f",
      "function_name" => "lamby-ws-production-WSConnectLambda-5in18cNskwz6",
      "memory_limit_in_mb" => "1792",
      "function_version" => "$LATEST"
    }.freeze 

    def self.raw_data
      RAW_DATA.dup
    end

    def clock_diff
      1585237646907
    end

    def deadline_ms
      1585238452698
    end

    def aws_request_id
      'a59284fd-d48c-4de5-af9e-df4254489ac2'
    end

    def invoked_function_arn
      'arn:aws:lambda:us-east-1:123456789012:function:myawesomelambda'
    end

    def log_stream_name
      '2020/03/26[$LATEST]88b3605521bf4d7abfaa7bfa6dcd45f1'
    end

    def function_name
      'myawesomelambda'
    end

    def memory_limit_in_mb
      '512'
    end

    def function_version
      '$LATEST'
    end

  end
end
