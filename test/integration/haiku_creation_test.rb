require "test_helper"

class HaikuCreationTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "haiku creation valid submission" do
    log_in_as(@user)
    get root_path

    verse_1 = "cafe patio"
    verse_2 = "above the cacophony"
    verse_3 = "cafe patio"
    tag = "funny"
    is_public = true
    bgcolor = "#dfdfdf"

    image = fixture_file_upload('test/fixtures/kitten.jpg','image/jpeg')
    assert_difference 'Haiku.count', 1 do
      post haikus_path, params: { haiku: { verse_1: verse_1, verse_2: verse_2, verse_3: verse_3, tag: tag, public: is_public, bgcolor: bgcolor }, post_button: "Post"  }
    end
    
    assert_redirected_to root_url
    follow_redirect!
  end

  # test "haiku creation invaid submission" do
  #   log_in_as(@user)
  #   get root_path
  #   verse_1 = ""
  #   verse_2 = ""
  #   verse_3 = "My third verse"
  #   assert_difference 'Haiku.count', 0 do
  #     post haikus_path, params: { haiku: { verse_1: verse_1, verse_2: verse_2, verse_3: verse_3 } }
  #   end
    
  # end

end
