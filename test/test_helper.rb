ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'minitest/reporters'
Minitest::Reporters.use!

require 'pry'
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include FactoryBot::Syntax::Methods

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def request_params(type, attributes)
    params = {:data => 
              {
                :type => type,
                :attributes => attributes
              }
             }
  end
end
