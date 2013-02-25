class UsersController < ApplicationController
    #User MUST be Signed In to edit or update    
    before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]

    #User CANNOT edit or update Other User(s)     
    before_filter :correct_user,   only: [:edit, :update]

    #ONLY Admin User CAN delete   
    before_filter :admin_user,     only: :destroy

  
    def show
        #Display "Show" User page
        @user = User.find(params[:id])
    end

    def new
         #Display "Sign Up" page (i.e: NEW User)
      	@user = User.new
    end

    def create
        #User "Signing Up"
        @user = User.new(params[:user])   #Create User

        if @user.save
            #Valid User Saved
            sign_in(@user)          
            flash[:success] = "Welcome to the Sample App!"

            #Request the "show" action
            redirect_to(@user)
        else
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

        #Display "ALL User(s)" page - one chunk at a time (30 by default)
        @users = User.paginate(page: params[:page])
    end

    def destroy
        #Find/Delete User
        User.find(params[:id]).destroy
        flash[:success] = "User destroyed."

        #Request the "index" action
        redirect_to(users_url)
    end

    #-----------------------------------#
    #---   PRIVATE   ---   PRIVATE   ---#
    #-----------------------------------#
    private

    def signed_in_user
        if !signed_in?()
            #User NOT Signed In
            store_request_url()
            #Request the "/signin" action
            redirect_to(signin_url, notice: "Please sign in.")
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