#!/usr/bin/env rackup
# encoding: utf-8

#require File.expand_path("../config/boot.rb", __FILE__)
require_relative 'app'
run Rack::URLMap.new({
  "/"    => App
})
