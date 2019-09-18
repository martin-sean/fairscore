require 'test_helper'

class MediaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @media = media(:one)
  end

  test "should get index" do
    get media_index_url
    assert_response :success
  end

  test "should get new" do
    get new_media_url
    assert_response :success
  end

  test "should create media" do
    assert_difference('Media.count') do
      post media_index_url, params: { media: { info: @media.info, title: @media.title, year: @media.year } }
    end

    assert_redirected_to media_url(Media.last)
  end

  test "should show media" do
    get media_url(@media)
    assert_response :success
  end

  test "should get edit" do
    get edit_media_url(@media)
    assert_response :success
  end

  test "should update media" do
    patch media_url(@media), params: { media: { info: @media.info, title: @media.title, year: @media.year } }
    assert_redirected_to media_url(@media)
  end

  test "should destroy media" do
    assert_difference('Media.count', -1) do
      delete media_url(@media)
    end

    assert_redirected_to media_index_url
  end
end