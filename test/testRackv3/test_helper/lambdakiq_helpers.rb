module TestHelpers
  module LambdakiqHelpers

    private

    def lambdakiq_client
      Lambdakiq.client.sqs
    end

    def lambdakiq_client_reset!
      Lambdakiq.instance_variable_set :@client, nil
    end

    def lambdakiq_client_stub_responses
      lambdakiq_client.stub_responses(:get_queue_url, {
        queue_url: 'https://sqs.us-stubbed-1.amazonaws.com'
      })
      redrive_policy = JSON.dump({maxReceiveCount: 8})
      lambdakiq_client.stub_responses(:get_queue_attributes, {
        attributes: { 'RedrivePolicy' => redrive_policy }
      })
    end

    def lambdakiq_api_requests
      lambdakiq_client.api_requests
    end

  end
end
