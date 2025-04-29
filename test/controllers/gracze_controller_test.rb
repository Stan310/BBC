require "test_helper"

class GraczeControllerTest < ActionDispatch::IntegrationTest
  test "should get nowy" do
    get gracze_nowy_url
    assert_response :success
  end
end
