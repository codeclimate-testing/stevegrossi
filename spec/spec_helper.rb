require "rubygems"
require "coveralls"
Coveralls.wear!

ENV["RAILS_ENV"] = "test"
ENV["SECRET_TOKEN"] = "Shhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "capybara/rails"
require "capybara/rspec"
require "database_cleaner"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/utilities.rb")].each { |f| require f }

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods

  # Allow focusing on particular specs
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Configure 'database_cleaner' gem
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.infer_base_class_for_anonymous_controllers = false

  config.infer_spec_type_from_file_location!
end

FactoryGirl.reload

# Require shared examples on each run
Dir[Rails.root.join("spec/support/shared_examples/*.rb")].each { |f| require f }
