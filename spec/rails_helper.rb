# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  group "Controllers", "lib/undercarriage/controllers"
  group "Models", "lib/undercarriage/models"
  group "Libraries", %r{lib/(\w*).rb}
  skip "/spec/"
  skip "/test/"
end

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../test/dummy/config/environment", __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "spec_helper"
require "rspec/rails"

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }

ActiveRecord::Schema.verbose = false
load Rails.root.join("db/schema.rb")

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.use_transactional_fixtures = true
end
