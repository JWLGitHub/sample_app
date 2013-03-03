class MicropostsController < ApplicationController

    #User MUST be Signed In 
    before_filter :signed_in_user

    #User MUST have/own Micropost
    before_filter :micropost_owner,   only: :destroy



  	def create
  		#User creating a Micropost
	    @micropost = current_user().microposts.build(params[:micropost])

	    if @micropost.save
	    	#Valid Micropost Saved
	        flash[:success] = "Micropost created!"
	        #Request the "root" action
	        redirect_to(root_url)
	    else
	    	#Micropost Save ERROR
	    	#Empty the Micropost Feed
	    	@feed_items = []
	    	
	    	#Re-Display "Home" page 
	        render('static_pages/home')
	    end
	end


	def destroy
		#Delete Micropost
	    @micropost.destroy

	    #Request the "root" action
	    redirect_to(root_url)
	end


	#-----------------------------------#
	#---   PRIVATE   ---   PRIVATE   ---#
	#-----------------------------------#
  	private

    def micropost_owner
    	#Current User's Micropost?
      	@micropost = current_user().microposts.find_by_id(params[:id]) 
      	if @micropost.nil?
      		#Micropost NOT FOOUND
      		#Request the "root" action
	    	redirect_to(root_url)
	    end
    end

 end