class ChallengesController < ApplicationController
    before_action :logged_in_user, only: [:challenge_user ]
    def challenge_user
        if logged_in?
            @reaction = Reaction.new
            @comment = Comment.new
            @haiku_comment = HaikuComment.new
            @micropost = current_user.microposts.build
            @haiku = current_user.haikus.build
            # @haiku_feed_items = current_user.haiku_feed.paginate(:page => params[:page], :per_page => 5, :total_entries => 30)
            @haiku_feed_items = Haiku.where("public = ?", true).paginate(:page => params[:page], :per_page => 5, :total_entries => 30)
            @feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 5, :total_entries => 30)
            @challenge = current_user.challenges.last
            @after_search_user = false
        end
    end
end
