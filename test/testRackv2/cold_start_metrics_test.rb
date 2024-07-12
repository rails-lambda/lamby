require 'test_helper'

class ColdStartMetricsSpec < LambySpec

  before { Lamby::ColdStartMetrics.clear! }

  it 'has a config that defaults to false' do
    refute Lamby.config.cold_start_metrics?
  end

  it 'calling instrument for the first time will output a CloudWatch count metric for ColdStart' do
    out = capture(:stdout) { Lamby::ColdStartMetrics.instrument! }
    metric = JSON.parse(out)
    expect(metric['AppName']).must_equal 'Dummy'
    expect(metric['ColdStart']).must_equal 1
    metrics = metric['_aws']['CloudWatchMetrics']
    expect(metrics.size).must_equal 1
    expect(metrics.first['Namespace']).must_equal 'Lamby'
    expect(metrics.first['Dimensions']).must_equal [['AppName']]
    expect(metrics.first['Metrics']).must_equal [{'Name' => 'ColdStart', 'Unit' => 'Count'}]
  end
  
  it 'only ever sends one metric for the lifespan of the function' do
    assert_output(/ColdStart/) { Lamby::ColdStartMetrics.instrument! }
    assert_output('') { Lamby::ColdStartMetrics.instrument! }
    Timecop.travel(Time.now + 10) { assert_output('') { Lamby::ColdStartMetrics.instrument! } }
    Timecop.travel(Time.now + 50000000) { assert_output('') { Lamby::ColdStartMetrics.instrument! } }
  end

  it 'will record a ProactiveInit metric if the function is called after 10 seconds' do
    Timecop.travel(Time.now + 11) do
      out = capture(:stdout) { Lamby::ColdStartMetrics.instrument! }
      metric = JSON.parse(out)
      expect(metric['AppName']).must_equal 'Dummy'
      expect(metric['ProactiveInit']).must_equal 1
      metrics = metric['_aws']['CloudWatchMetrics']
      expect(metrics.size).must_equal 1
      expect(metrics.first['Namespace']).must_equal 'Lamby'
      expect(metrics.first['Dimensions']).must_equal [['AppName']]
      expect(metrics.first['Metrics']).must_equal [{'Name' => 'ProactiveInit', 'Unit' => 'Count'}]
    end
  end

  it 'will not record a ProactiveInit metric if the function is called before 10 seconds' do
    Timecop.travel(Time.now + 9) do
      assert_output(/ColdStart/) { Lamby::ColdStartMetrics.instrument! }
    end
  end

  private
  
  def now_ms
    (Time.now.to_f * 1000).to_i
  end

end
