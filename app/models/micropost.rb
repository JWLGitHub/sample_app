# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
    #------------------------#
    #---   ATTRIBUTE(S)   ---#
    #------------------------#
    attr_accessible(:content)


    #--------------------------#
    #---   ASSOCIATION(S)   ---#
    #--------------------------#
    belongs_to(:user)


  	#-------------------------#
  	#---   VALIDATION(S)   ---#
  	#-------------------------#
    validates(:user_id, presence: true)
    validates(:content, presence: true,
    	                length: { maximum: 140 })


    default_scope(order: 'microposts.created_at DESC')

    #---------------------#
    #---   METHOD(S)   ---#
    #---------------------#
    def self.from_users_followed_by(user)
        #--------------------------------------#
        #-----     THIS WORKS FINE!!!     -----#
        #                                      #
        # HOWEVER - BOTH User_Id(s) and        # 
        # Micropost(s) are stored in memory    #
        #--------------------------------------#
        # Get User Id(s) of "Followed" User(s)
        #followed_user_ids = user.followed_user_ids

        # Get "Followed" User(s) Micropost(s) PLUS "Self" Micropost(s) 
        #Micropost.where("user_id IN (?) OR user_id = ?", followed_user_ids, user)

        #------------------------------------------#
        #-----     THIS IS MORE EFFICIENT     -----#
        #                                          #
        # ONLY Micropost(s) are stored in memory   #
        #------------------------------------------# 
        # Create Subselect for User Id(s) of "Followed" User(s)
        followed_user_ids = "SELECT followed_id FROM relationships
                             WHERE follower_id = :user_id"

        # Get "Followed" User(s) Micropost(s) PLUS "Self" Micropost(s) 
        Micropost.where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
                         user_id: user.id)

    end
end
