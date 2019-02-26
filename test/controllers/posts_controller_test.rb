require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = create(:post)
    @auth = ActionController::HttpAuthentication::Basic.encode_credentials(
      @post.author.username,
      attributes_for(:author)[:password]
    )
  end

  test 'should create and return a post' do
    assert_difference('Post.count', 1, "Did not create post") do
      post posts_url, params: request_params("post", attributes_for(:post, user_id: @post.user_id)),
        headers: {"Authorization": @auth}
    end
    assert_match /data/, @response.body, "Does not return created object"
  end

  test 'should fail and return errors for invalid data' do
    assert_no_difference('Post.count') do
      post posts_url, params: request_params("post", attributes_for(:post, title: "", user_id: @post.user_id)),
        headers: {"Authorization": @auth}
    end
    assert_response :bad_request
    assert_match /errors/, @response.body, "Does not return errors"
  end

  test 'should update and return post' do
    patch post_url(@post), params: request_params("post", attributes_for(:post, title: "updated title")),
        headers: {"Authorization": @auth}
    @post.reload
    assert_equal "updated title", @post.title, "Does not update post"
    assert_match /data/, @response.body, "Does not return updated post"
  end

  test 'should not update post with invalid data' do
    patch post_url(@post), params: request_params("post", {title: nil}),
        headers: {"Authorization": @auth}
    assert_response :bad_request
    assert_match /errors/, @response.body, "Does not return errors"
  end

  test 'should delete post' do
    assert_difference('Post.count', -1) do
      delete post_url(@post),
        headers: {"Authorization": @auth}
    end
  end

  test 'should return list of posts' do
    get posts_url
    assert_response :ok, "Does not return a successful response"
    assert_match /data/, @response.body, "Does not return list of posts"
  end

  test 'should return a post' do
    get post_url(@post)
    assert_response :ok, "Does not return an existing post"
    assert_match "#{@post.title}", @response.body, "Returns the wrong post"
  end

  test 'should return empty data if post does not exist' do
    get post_url(1)
    assert_response :not_found
    assert_match /(data)+.*null/, @response.body, "Does not return null on 404"
  end

  test 'should return 401 for missing credentials' do
    post posts_url, params: attributes_for(:post)
    assert_response :unauthorized, "Does not return 401 for missing credentials"
  end

  test 'only author should alter post' do
    auth = ActionController::HttpAuthentication::Basic.encode_credentials(
      create(:user).username,
      attributes_for(:author)[:password]
    )
    patch post_url(@post), params: attributes_for(:post, title: "updated title"),
        headers: {"Authorization": auth}
    assert_response :unauthorized, "Allows any user to edit a post"

    delete post_url(@post),
      headers: {"Authorization": auth}
    assert_response :unauthorized, "Allows any user to delete a post"
  end
end
