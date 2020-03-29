require 'test_helper'

class RackApiTest < LambySpec

  let(:context) { TestHelpers::LambdaContext.new }

  it 'env' do
    event = TestHelpers::Events::Rest.create
    rack = Lamby::RackApi.new event, context
    expect(rack.env['REQUEST_METHOD']).must_equal             'GET'
    expect(rack.env['SCRIPT_NAME']).must_equal                ''
    expect(rack.env['PATH_INFO']).must_equal                  '/'
    expect(rack.env['QUERY_STRING']).must_equal               'colors[]=blue&colors[]=red'
    expect(rack.env['SERVER_NAME']).must_equal                '4o8v9z4feh.execute-api.us-east-1.amazonaws.com'
    expect(rack.env['SERVER_PORT']).must_equal                '443'
    expect(rack.env['SERVER_PROTOCOL']).must_equal            'HTTP/1.1'
    expect(rack.env['rack.url_scheme']).must_equal            'https'
    expect(rack.env['HTTP_ACCEPT']).must_equal                'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    expect(rack.env['HTTP_ACCEPT_ENCODING']).must_equal       'gzip'
    expect(rack.env['HTTP_HOST']).must_equal                  '4o8v9z4feh.execute-api.us-east-1.amazonaws.com'
    expect(rack.env['HTTP_USER_AGENT']).must_equal            'Amazon CloudFront'
    expect(rack.env['HTTP_VIA']).must_equal                   '2.0 7f7e359e1c06a914d3d305785359b84d.cloudfront.net (CloudFront)'
    expect(rack.env['HTTP_X_AMZ_CF_ID']).must_equal           'kXZzJ72NOsZSsPu-JzNUGyFei1G0r9uzoup3yHrwk4J5qGLKrdUrRA=='
    expect(rack.env['HTTP_X_AMZN_TRACE_ID']).must_equal       'Root=1-5e7fe714-fee6909429159440eb352c40'
    expect(rack.env['HTTP_X_FORWARDED_FOR']).must_equal       '72.218.219.201, 34.195.252.119'
    expect(rack.env['HTTP_X_FORWARDED_PORT']).must_equal      '443'
    expect(rack.env['HTTP_X_FORWARDED_PROTO']).must_equal     'https'
    expect(rack.env['HTTP_X_REQUEST_ID']).must_equal          'a59284fd-d48c-4de5-af9e-df4254489ac2'
    expect(rack.env['HTTP_COOKIE']).must_equal                'signal1=test; signal2=control'
  end

end
