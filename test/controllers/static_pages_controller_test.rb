require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Instagram"
  end


  test "should redirect serach when not logged in" do
    get search_path
    assert_redirected_to root_url
  end

end
