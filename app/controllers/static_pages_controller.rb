class StaticPagesController < ApplicationController
    def home
      	if signed_in?()
        	#User Signed In 
            #Create a blank Micropost
          	@micropost = current_user().microposts.build

            #Get a "chunk/page" of User Micropost(s) - (30 by default)
            @feed_items = current_user().feed().paginate(page: params[:page])
        end
    end

    def help
    end

    def about
    end

    def contact
    end
end
