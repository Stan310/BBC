require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "should get roulette" do
    get games_roulette_url
    assert_response :success
  end

  test "should get blackjack" do
    get games_blackjack_url
    assert_response :success
  end

  test "should get slots" do
    get games_slots_url
    assert_response :success
  end
end
