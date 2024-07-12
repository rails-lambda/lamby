require 'test_helper'

class RackAlbTest < LambySpec

  let(:context) { TestHelpers::LambdaContext.new }

  it 'env' do
    event = TestHelpers::Events::Alb.create
    rack = Lamby::RackAlb.new event, context
    expect(rack.env['REQUEST_METHOD']).must_equal             'GET'
    expect(rack.env['SCRIPT_NAME']).must_equal                ''
    expect(rack.env['PATH_INFO']).must_equal                  '/'
    expect(rack.env['QUERY_STRING']).must_equal               'colors[]=blue&colors[]=red'
    expect(rack.env['SERVER_NAME']).must_equal                'myawesomelambda.example.com'
    expect(rack.env['SERVER_PORT']).must_equal                '443'
    expect(rack.env['SERVER_PROTOCOL']).must_equal            'HTTP/1.1'
    expect(rack.env['rack.url_scheme']).must_equal            'https'
    expect(rack.env['HTTP_ACCEPT']).must_equal                'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    expect(rack.env['HTTP_ACCEPT_ENCODING']).must_equal       'gzip'
    expect(rack.env['HTTP_HOST']).must_equal                  'myawesomelambda.example.com'
    expect(rack.env['HTTP_USER_AGENT']).must_equal            'Amazon CloudFront'
    expect(rack.env['HTTP_VIA']).must_equal                   '2.0 3dc5b7040885724e78019cc31f0ef3d9.cloudfront.net (CloudFront)'
    expect(rack.env['HTTP_X_AMZ_CF_ID']).must_equal           'BSlDkHoVD8-009TATJzymLqSBzViE_6jj7DlkiJkub-PpDb8wI4Pxw=='
    expect(rack.env['HTTP_X_AMZN_TRACE_ID']).must_equal       'Root=1-5e7c160a-0a9065c7a28a428cd8b98215'
    expect(rack.env['HTTP_X_FORWARDED_FOR']).must_equal       '72.218.219.201, 72.218.219.201, 34.195.252.132'
    expect(rack.env['HTTP_X_FORWARDED_PORT']).must_equal      '443'
    expect(rack.env['HTTP_X_FORWARDED_PROTO']).must_equal     'https'
    expect(rack.env['HTTP_X_REQUEST_ID']).must_equal          'a59284fd-d48c-4de5-af9e-df4254489ac2'
    expect(rack.env['HTTP_COOKIE']).must_equal                'signal1=test; signal2=control'
  end

end
