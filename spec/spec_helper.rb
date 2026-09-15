# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  skip '/spec/' # Exclude spec directory
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

  # Clean up the data directory before and after each test
  config.before(:each) do
    FileUtils.rm_rf('data')
    FileUtils.mkdir_p('data')
  end

  config.after(:each) do
    FileUtils.rm_rf('data')
    FileUtils.mkdir_p('data')
  end
end
