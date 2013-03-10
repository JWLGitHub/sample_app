# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Relationship < ActiveRecord::Base
    #------------------------#
    #---   ATTRIBUTE(S)   ---#
    #------------------------#
  	attr_accessible :followed_id

  	
  	#--------------------------#
  	#---   ASSOCIATION(S)   ---#
  	#--------------------------#
  	#Rails infers foreign key (follower_id)
  	belongs_to(:follower, class_name: "User")
  	
  	#Rails infers foreign key (followed_id)
  	belongs_to(:followed, class_name: "User")


  	#-------------------------#
  	#---   VALIDATION(S)   ---#
  	#-------------------------#
  	validates(:follower_id, presence: true)
    validates(:followed_id, presence: true)
end
