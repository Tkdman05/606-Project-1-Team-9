# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  skip '/spec/'
end

require 'rack/test'
require 'rspec'
require 'json'
require 'fileutils'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../app.rb', __dir__)

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end
