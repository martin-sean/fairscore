require 'test_helper'

class MediaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @media  = media(:one)
  end

  test "should get index" do
    get media_index_url
    assert_response :success
  end

  test "should get new" do
    get new_media _url
    assert_response :success
  end

  test "should create media " do
    assert_difference('Media.count') do
      post media_index_url, params: { media : { info: @media .info, title: @media .title, year: @media .year } }
    end

    assert_redirected_to media _url(Media.last)
  end

  test "should show media " do
    get media _url(@media )
    assert_response :success
  end

  test "should get edit" do
    get edit_media _url(@media )
    assert_response :success
  end

  test "should update media " do
    patch media _url(@media ), params: { media : { info: @media .info, title: @media .title, year: @media .year } }
    assert_redirected_to media _url(@media )
  end

  test "should destroy media " do
    assert_difference('Media.count', -1) do
      delete media _url(@media )
    end

    assert_redirected_to media_index_url
  end
end
