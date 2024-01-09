require "application_system_test_case"

class RvpsTest < ApplicationSystemTestCase
  setup do
    @rvp = rvps(:one)
  end

  test "visiting the index" do
    visit rvps_url
    assert_selector "h1", text: "Rvps"
  end

  test "should create rvp" do
    visit rvps_url
    click_on "New rvp"

    fill_in "First name", with: @rvp.first_name
    fill_in "Last name", with: @rvp.last_name
    fill_in "Solution number", with: @rvp.solution_number
    click_on "Create Rvp"

    assert_text "Rvp was successfully created"
    click_on "Back"
  end

  test "should update Rvp" do
    visit rvp_url(@rvp)
    click_on "Edit this rvp", match: :first

    fill_in "First name", with: @rvp.first_name
    fill_in "Last name", with: @rvp.last_name
    fill_in "Solution number", with: @rvp.solution_number
    click_on "Update Rvp"

    assert_text "Rvp was successfully updated"
    click_on "Back"
  end

  test "should destroy Rvp" do
    visit rvp_url(@rvp)
    click_on "Destroy this rvp", match: :first

    assert_text "Rvp was successfully destroyed"
  end
end
