class UsersController < ApplicationController
  
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
            #Display "Show" User page
            redirect_to @user
        else
            #Display "Sign Up" page 
            render 'new'
        end
    end

end