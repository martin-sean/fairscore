require "application_system_test_case"

class MediaTest < ApplicationSystemTestCase
  setup do
    @media = media(:one)
  end

  test "visiting the index" do
    visit media_url
    assert_selector "h1", text: "Media"
  end

  test "creating a Media" do
    visit media_url
    click_on "New Media"

    fill_in "Info", with: @media.info
    fill_in "Title", with: @media.title
    fill_in "Year", with: @media.year
    click_on "Create Media"

    assert_text "Media was successfully created"
    click_on "Back"
  end

  test "updating a Media" do
    visit media_url
    click_on "Edit", match: :first

    fill_in "Info", with: @media.info
    fill_in "Title", with: @media.title
    fill_in "Year", with: @media.year
    click_on "Update Media"

    assert_text "Media was successfully updated"
    click_on "Back"
  end

  test "destroying a Media" do
    visit media_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Media was successfully destroyed"
  end
end
