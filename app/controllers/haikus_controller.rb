class HaikusController < ApplicationController
    include HaikusHelper
    before_action :logged_in_user, only: [:create, :destroy, :update]
    before_action :correct_user, only: [:destroy, :update]

    def create
        verse_1 = params[:haiku][:verse_1]
        verse_2 = params[:haiku][:verse_2]
        verse_3 = params[:haiku][:verse_3]
        tag = params[:haiku][:tag]

        is_public = true
        if params[:visibility] && params[:visibility] === 'Private'
            is_public = false
        end
        @haiku = current_user.haikus.build(verse_1: verse_1, verse_2: verse_2, verse_3: verse_3,tag: tag, public: is_public)        
        @haiku.image.attach(params[:haiku][:image])
        if @haiku.save
            p "verse1:#{SyllableCount(verse_1)}................................"
                p verse_1_haiku?(verse_1)
                p "verse1:#{SyllableCount(verse_2)}................................"
                p "verse1:#{SyllableCount(verse_3)}................................"
                flash[:success] = "Haiku created!"
                # redirect_to root_url
            if current_user.challenge_mode
                if @haiku.created_at >= current_user.challenge_start_date
                    p "haiku--------------------#{@haiku.created_at}"
                    # find the daily challenge by user_id and date  
                    # update posted = tru
                    "2021-03-08 14:23:02.383848"
                    # @postedDate = DailyChallenge.where("user_id = ? and thirtyDates = ? ", current_user.id,  "2021-03-08 14:23:02.383848")
                    @postedDate = DailyChallenge.where("user_id = ? and thirtyDates LIKE ? ", current_user.id, "%#{@haiku.created_at.to_date}%")
                    p "#######################====================#{@postedDate.length}"
                    if  @postedDate && @postedDate.length >= 0 && !@postedDate.first.postStatus?
                        @postedDate.first.update_columns(postStatus: true)
                        # @postedDate = DailyChallenge.update('postStatus').where("user_id = ? and thirtyDates = ? ", current_user.id, @haiku.created_at)
                    else
                        p "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
                    end
                    
                
                end
                
            end
            redirect_to daily_challenges_url
        else
            @comment = Comment.new
            @haiku_comment = HaikuComment.new
            @micropost = Micropost.new

            @feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 5, :total_entries => 30)
            # @haiku_feed_items = current_user.haiku_feed.paginate(:page => params[:page], :per_page => 5, :total_entries => 30)
            @haiku_feed_items = Haiku.where("public = ?", true).paginate(:page => params[:page], :per_page => 5, :total_entries => 30)
            render 'static_pages/home'
        end
    end
    def update
        if !@haiku.public?
            @haiku.update(public: true)
            redirect_to request.referrer || root_url
        else
            redirect_to request.referrer || root_url
        end
        
    end

    def show
        @haiku_comment = HaikuComment.new
        @haiku = Haiku.find(params[:id])
    end

    def destroy
        @haiku.destroy
        flash[:success] = "Haiku deleted"
        redirect_to request.referrer || root_url
    end

    private
        def haiku_params
            params.require(:haiku).permit(:verse_1, :verse_2, :verse_3, :tag, :visibility, :image)
        end
        def correct_user
            @haiku = current_user.haikus.find_by(id: params[:id])
            redirect_to root_url if @haiku.nil?
        end
end
