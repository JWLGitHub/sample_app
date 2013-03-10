class UsersController < ApplicationController
    #User MUST be Signed Out to "Sign up"   
    before_filter :signed_out_user, only: [:new, :create]

    #User MUST be Signed In to List, Edit, Update or Delete   
    before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]

    #User CANNOT Edit or Update Other User(s)     
    before_filter :correct_user,   only: [:edit, :update]

    #ONLY Admin User CAN delete   
    before_filter :admin_user,     only: :destroy

  
    def show
        #Display "Show" User page
        @user = User.find(params[:id])

        #Get a "chunk/page" of User Micropost(s) - (30 by default)
        @microposts = @user.microposts.paginate(page: params[:page])
    end

    def new
         #Display "Sign Up" page (i.e: NEW User)
      	@user = User.new
    end

    def create
        #User "Signing Up"
        @user = User.new(params[:user])   #Create User

        if @user.save
            #User Save SUCCESS
            sign_in(@user)          
            flash[:success] = "Welcome to the Sample App!"

            #Request the "show" action
            redirect_to(@user)
        else
            #User Save ERROR
            #Display "Sign Up" page 
            render('new')
        end
    end

    def edit
         #Display "Update your profile" page (i.e: EDIT User)
    end

    def update
        #User "Updating changes to profile"
        if @user.update_attributes(params[:user])
            #User Updated
            flash[:success] = "Profile updated"

            #User's "remember_token" reset during update - User signed-in again 
            sign_in(@user)

            #Request the "show" action
            redirect_to(@user)
        else
            #Display "Update your profile" page
            render('edit')
        end
    end

    def index
        #Display "ALL User(s)" page
        #@users = User.all

        #Get a "chunk/page" of User(s) - (30 by default)
        @users = User.paginate(page: params[:page])
    end

    def destroy
        #Find User
        @user = User.find(params[:id])

        if !current_user?(@user)
            #Delete User
            User.destroy(params[:id])
            flash[:success] = "User destroyed."
        end

        #Request the "index" action
        redirect_to(users_url)
    end

    def following
        #Find User(s) You Follow
        @title = "Following"
        @user = User.find(params[:id])
        @users = @user.followed_users.paginate(page: params[:page])
        #Display "Show Follow" page
        render('show_follow')
    end

    def followers
        #Find User(s) Following You        
        @title = "Followers"
        @user = User.find(params[:id])
        @users = @user.followers.paginate(page: params[:page])
        #Display "Show Follow" page
        render('show_follow')
    end

    #-----------------------------------#
    #---   PRIVATE   ---   PRIVATE   ---#
    #-----------------------------------#
    private

    def signed_out_user
        if signed_in?()
            #User Signed In
            #Request the "root" action
            redirect_to(root_path)
        end
    end

    def correct_user
        #Find User
        @user = User.find(params[:id])

        if !current_user?(@user)
            #User NOT Current User
            #Request the "root" action
            redirect_to(root_path)
        end 
    end

    def admin_user
        if !(current_user().admin?)
            #User NOT Admin User
            #Request the "root" action
            redirect_to(root_path)
        end
    end
end