require "test_helper"

class RvpsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rvp = rvps(:one)
  end

  test "should get index" do
    get rvps_url
    assert_response :success
  end

  test "should get new" do
    get new_rvp_url
    assert_response :success
  end

  test "should create rvp" do
    assert_difference("Rvp.count") do
      post rvps_url, params: { rvp: { first_name: @rvp.first_name, last_name: @rvp.last_name, solution_number: @rvp.solution_number } }
    end

    assert_redirected_to rvp_url(Rvp.last)
  end

  test "should show rvp" do
    get rvp_url(@rvp)
    assert_response :success
  end

  test "should get edit" do
    get edit_rvp_url(@rvp)
    assert_response :success
  end

  test "should update rvp" do
    patch rvp_url(@rvp), params: { rvp: { first_name: @rvp.first_name, last_name: @rvp.last_name, solution_number: @rvp.solution_number } }
    assert_redirected_to rvp_url(@rvp)
  end

  test "should destroy rvp" do
    assert_difference("Rvp.count", -1) do
      delete rvp_url(@rvp)
    end

    assert_redirected_to rvps_url
  end
end
