require 'test/unit'
require 'mocha/test_unit'
require 'fluent/test'
require 'fluent/log'

unless defined?(Test::Unit::AssertionFailedError)
  class Test::Unit::AssertionFailedError < StandardError
  end
end
