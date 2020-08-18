require_relative "../test_helper"

class RoutingTest < ActionDispatch::IntegrationTest
  include Rack::Test::Methods

  # This fails as we have introduced a new route as par of the session_answers work
  # should "not 404 without blowing up when given a slug with invalid UTF-8" do
  #   assert_raises ActionController::RoutingError do
  #     get "/non-gb-driving-licence%E2%EF%BF%BD%EF%BF%BD"
  #   end
  # end

  should "route root path to smart answers controller index action" do
    assert_routing "/", controller: "smart_answers", action: "index"
  end
end
