require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require_relative '../app'

RSpec.configure do |config|
config.include Rack::Test::Methods

def app
Sinatra::Application
end
end
