require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @comment = create(:comment)
    @auth = ActionController::HttpAuthentication::Basic.encode_credentials(
      @comment.commenter.username,
      attributes_for(:user)[:password]
    )
  end

  test 'should create a comment' do
    assert_difference('Comment.count') do
      post post_comments_url(@comment.post), params: attributes_for(:comment),
        headers: {"Authorization": @auth}
    end
    assert_response :created, "Returns an incorrect response code"
    assert_match /data/, @response.body, "Does not return created comment"
  end

  test 'should not create comment without a body' do
    assert_no_difference('Comment.count') do
      post post_comments_url(@comment.post), params: attributes_for(:empty_comment),
        headers: {"Authorization": @auth}
    end
    assert_response :bad_request, "Does not raise error for an empty comment"
    assert_match /errors/, @response.body, "Does not return errors on 400"
  end

  test 'should delete comment' do
    assert_difference('Comment.count', -1) do
      delete post_comment_url(@comment.post, @comment),
        headers: {"Authorization": @auth}
    end
    assert_response :no_content, "Fails to delete comment"
  end

  test 'only commenter should delete comment' do
    auth = ActionController::HttpAuthentication::Basic.encode_credentials(
      User.first.username,
      attributes_for(:commenter)[:password]
    )
    assert_no_difference('Comment.count') do
      delete post_comment_url(@comment.post, @comment),
        headers: {"Authorization":auth}
    end
    assert_response :unauthorized, "User other than commenter can delete comment"
  end

  test 'should return a list of comments' do
    get post_comments_url(post_id: @comment.post.id)
    assert_response :ok, "Fails to retrieve comments"
    assert_match /data/, @response.body, "Returns improperly formatted data"
  end

  test 'should return a single comment' do
    get post_comment_url(id: @comment.id, post_id: @comment.post.id)
    assert_response :ok, "Does not return a comment"
    assert_match "#{@comment.body[0..5]}", @response.body, "Returns the wrong comment"
  end

  test 'should return null on 404' do
    get post_comment_url(id: 0, post_id: @comment.post.id)
    assert_response :not_found, "Does not return 404 on missing comment"
    assert_match /null/, @response.body, "Does not return empty data on 404"
  end

  test 'should return 401' do
    post post_comments_url(@comment.post)
    assert_response :unauthorized, "Does return 401 for missing credentials"
  end
end
