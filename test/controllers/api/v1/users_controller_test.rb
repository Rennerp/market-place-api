require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'should show user' do
    get api_v1_user_url(@user), as: :json
    assert_response :success
    # Test to ensuer response contains the correct email
    json_response = JSON.parse(response.body)
    assert_equal @user.email, json_response['email']
  end

  test 'should create a user' do
    assert_difference('User.count') do
      post api_v1_users_url, params: { user: { email: 'test@test.org', password: '123456'} }, as: :json
    end

    assert_response :created
  end

  test 'should not create a user with taken email' do
    assert_no_difference('User.count') do
      post api_v1_users_url, params: { user: { email: @user.email, password: '123456' } }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test 'should update a user' do
    patch api_v1_user_url(@user), params: { user: { email: @user.email, password: '123456' } }, as: :json
    assert_response :success
  end

  test 'shouwld not update a user when invalida params are sent' do
    patch api_v1_user_url(@user), params: { user: { email: 'bad_email', password: '123456' } }, as: :json
    assert_response :unprocessable_entity
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user), as: :json
    end
    assert_response :no_content
  end
end
