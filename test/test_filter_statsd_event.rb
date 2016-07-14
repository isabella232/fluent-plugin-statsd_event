require_relative 'helper'
require_relative '../lib/fluent/plugin/filter_statsd_event'

class StatsdEventFilterTest < Test::Unit::TestCase
  include Fluent

  setup do
    Fluent::Test.setup
    @time = Fluent::Engine.now
  end

  def create_driver(conf = '')
    Test::FilterTestDriver.new(StatsdEventFilter).configure(conf, true)
  end

  sub_test_case 'simple tests' do
    def message_1
      {'message' => 'hello!'}
    end

    def message_2
      {'msg' => 'hello kitty!'}
    end

    def config_1
      ''
    end

    def config_2
      [
          'host 127.0.0.1',
          'port 1234',
          'tags ["source:fluetd"]',
          'grep ["hello"]',
          'record_key msg',
          'alert_type warning',
          'priority low',
          'aggregation_key aggrk',
          'source_type_name ["source:test"]'
      ].join("\n")
    end

    def statsd_stub_1
      ['filter.test', message_1.to_json,
      {
          :date_happened    => @time.to_s,
          :alert_type       => nil,
          :priority         => nil,
          :aggregation_key  => nil,
          :tags             => [],
          :source_type_name => []
      }]
    end

    def statsd_stub_2
      ['filter.test', message_2['msg'].to_s,
       {
           :date_happened    => @time.to_s,
           :alert_type       => 'warning',
           :priority         => 'low',
           :aggregation_key  => 'aggrk',
           :tags             => ['source:fluetd'],
           :source_type_name => ['source:test']
       }]
    end

    def stub(obj, data)
      statsd = obj.instance.instance_variable_get(:@statsd)
      statsd.expects(:event).with(*data)
    end

    def emit(msg, config, stub_data)
      d = create_driver(config)
      d.emit(msg, @time)
      stub(d, stub_data)
      d.run.filtered
    end

    test 'default params' do
      emit(message_1, config_1, statsd_stub_1)
    end

    test 'params full override' do
      emit(message_2, config_2, statsd_stub_2)
    end
  end
end