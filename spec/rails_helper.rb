# frozen_string_literal: true

require 'simplecov'

# SimpleCov.start :rails

SimpleCov.start do
  add_group 'Controllers', 'lib/undercarriage/controllers'
  add_group 'Models', 'lib/undercarriage/models'
  add_group 'Libraries', %r{lib/(\w*).rb}
  add_filter '/spec/'
end

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('dummy/config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'spec_helper'

require 'pry-byebug'
require 'rspec/rails'

Dir[Rails.root.join('../support/**/*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
