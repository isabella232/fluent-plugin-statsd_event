# fluent-plugin-statsd_event, a plugin for [Fluentd](http://fluentd.org)

## Installation

    gem install fluent-plugin-statsd_event

## Configuration

* `host` - Statsd host. String, default: '127.0.0.1'
* `port` - Statsd port. String, default: '8125'
* `grep` - If set only matched lines will be sent to statsd. Array, default: none
* `tags` - Tags to be added to every message. Array, default: none
* `record_key` - Key for fluentd log record. Usually it's value set to 'message'. If not set, whole fluentd record will be sent as JSON. String, default: none
* `alert_type` - Datadog statsd alert type. Can be "error", "warning", "info" or "success". String, default: none
* `priority` - Datadog statsd priority. Can be "normal" or "low". String, default: none
* `aggregation_key` - Datadog statsd aggregation key. Assign an aggregation key to the event, to group it with some others. String, default: none
* `source_type_name` - Datadog statsd source type name. An array of tags. Array, default: none

### The simplest configuration
Stream kernel messages to local datadog-statsd instance
```
<filter syslog.kernel>
  type statsd_event
</filter>
```

### A bit more sophisticated example
Stream all error messages from syslog to a remote statsd instance
```
<filter syslog.**>
  host statsd.example.com
  port 8125
  type statsd_event
  grep ["ERROR", "err[^\w]"]
  tags ["alert:syslog", "role:controller"]
  alert_type error
  record_key message
</filter>
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Test it (`GEM_HOME=vendor bundle install; GEM_HOME=vendor bundle exec rake test`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## Copyright
  Copyright (c) 2016 Atlassian