# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-statsd-event"
  spec.version       = "0.1.0"
  spec.authors       = ["Atlassian"]

  spec.summary       = %q{fluentd plugin for statsd event}
  spec.description   = %q{fluentd plugin for statsd event}
  spec.homepage      = "https://github.com/atlassian/fluent-plugin-statsd_event"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|Gemfile|.git)}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.has_rdoc      = false

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~>3.2.0"
  spec.add_development_dependency "mocha", "~>1.1.0"
  spec.add_runtime_dependency "dogstatsd-ruby", "~> 1.6.0"
  spec.add_runtime_dependency "fluentd", ">= 0.12.0"
end