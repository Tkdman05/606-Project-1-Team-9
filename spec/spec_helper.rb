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

  data_files = [
    'data/recipes.json',
    'data/ingredients.json',
    'data/shopping_list.json'
  ]

  config.before(:suite) do
    data_files.each do |file|
      next unless File.exist?(file)

      FileUtils.cp(file, "#{file}.test_backup")
    end
  end

  config.after(:suite) do
    data_files.each do |file|
      backup = "#{file}.test_backup"

      next unless File.exist?(backup)

      FileUtils.mv(backup, file, force: true)
    end
  end
end
