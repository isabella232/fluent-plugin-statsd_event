require 'fluent/filter'
require 'fluent/config/error'

module Fluent
  class StatsdEventFilter < Filter
    Fluent::Plugin.register_filter('statsd_event', self)

    def initialize
      super
      require 'statsd'
      require 'json'
    end

    config_param :host, :string, :default => 'localhost'
    config_param :port, :string, :default => '8125'
    config_param :tags, :array, :default => []
    config_param :grep, :array, :default => []
    config_param :record_key, :string, :default => nil
    config_param :alert_type, :string, :default => nil
    config_param :priority, :string, :default => nil
    config_param :aggregation_key, :string, :default => nil
    config_param :source_type_name, :array, :default => []

    def configure(conf)
      super
      @regexps = []
      @grep.each do |regexp|
        begin
          @regexps << Regexp.compile(regexp)
        rescue RegexpError => e
          log.error "Error: invalid regular expression in grep: #{e}"
        end
      end
      @statsd = Statsd.new(@host, @port)
    end

    def filter(tag, time, record)

      if @record_key.nil?
        message = record.to_json
      else
        if record[@record_key].is_a? String
          message = record[@record_key].to_s
        else
          message = record[@record_key].to_json
        end
      end

      if @regexps.empty?
        post_event(time, tag, message)
      else
        @regexps.each do |regexp|
          if ::Fluent::StringUtil.match_regexp(regexp, message)
            post_event(time, tag, message)
            break
          end
        end
      end


      record
    end

    private

    def post_event(time, event_title, event_msg)
      @statsd.event(
          event_title,
          event_msg,
          :date_happened => time.to_s,
          :alert_type => @alert_type,
          :priority => @priority,
          :aggregation_key => @aggregation_key,
          :tags => @tags,
          :source_type_name => @source_type_name
      )
    end

  end
end