class SessionsController < ApplicationController

    def new
        #Display "Sign In" page (i.e: NEW Session)
    end

    def create
        #User "Signing In"     
        user = User.find_by_email(params[:email].downcase)   #Find/authenticate User

        if user && user.authenticate(params[:password])
            sign_in(user)
            #Display "Show" User page
            redirect_to(user)
        else
            #Re-Display "Sign In" page 
            flash.now[:error] = 'Invalid email/password combination'
            render 'new'
        end
    end

    def destroy
        #User "Signing Out"
        sign_out()
        redirect_to root_url
    end
  
end
