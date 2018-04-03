$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'eisiges/di/core'
require 'eisiges/di/provider/default'

require 'minitest/autorun'

require_relative 'example/example'
