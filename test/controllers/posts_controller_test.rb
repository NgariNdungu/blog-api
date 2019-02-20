require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = create(:post)
  end
  
  test 'should create and return a post' do
    assert_difference('Post.count', 1, "Did not create post") do
      post posts_url, params: attributes_for(:post)
    end
    assert_match /data/, @response.body, "Does not return created object"
  end

  test 'should update and return post' do
    patch post_url(@post), params: attributes_for(:post, title: "updated title")
    assert_equal "updated title", @post.title, "Does not update post"
    assert_match /data/, @response.body, "Does not return updated post"
  end

  test 'should delete post' do
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end
  end

  test 'should return list of posts' do
    
  end
end
