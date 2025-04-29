require "test_helper"

class ZakladControllerTest < ActionDispatch::IntegrationTest
  test "should get nowy" do
    get zaklad_nowy_url
    assert_response :success
  end
end
