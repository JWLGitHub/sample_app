class RelationshipsController < ApplicationController
    #User MUST be Signed In to Create, Delete  
    before_filter :signed_in_user


    def create
        #User "Following" Another User 
        @user = User.find(params[:relationship][:followed_id])

        #Create Relationship
        current_user.follow!(@user)

        respond_to do |format|
            #HTTP - Request the User "show" action
            format.html { redirect_to @user }
            #AJAX - Call "/views/relationships/create.js.erb"
            format.js
        end
    end


    def destroy
        #User "UnFollowing" Another User
        @user = Relationship.find(params[:id]).followed
        
        #Delete Relationship
        current_user.unfollow!(@user)
        
        respond_to do |format|
            #HTTP - Request the User "show" action
            format.html { redirect_to @user }
            #AJAX - Call "/views/relationships/destroy.js.erb"
            format.js
        end
    end
end