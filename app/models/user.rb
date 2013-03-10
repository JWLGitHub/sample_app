# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
    #------------------------#
    #---   ATTRIBUTE(S)   ---#
    #------------------------#
    attr_accessible(:name, 
                    :email, 
                    :password, 
                    :password_confirmation)
    has_secure_password


    #--------------------------#
    #---   ASSOCIATION(S)   ---#
    #--------------------------#
    has_many(:microposts, dependent: :destroy)

    #---   User(s) You Follow   ---#
    has_many(:relationships, foreign_key: "follower_id", 
                             dependent:   :destroy)
    has_many(:followed_users, through: :relationships, 
                              source:  :followed)

    #---   User(s) Following You   ---#
    has_many(:reverse_relationships, foreign_key: "followed_id",
                                     class_name:  "Relationship",
                                     dependent:   :destroy)
    has_many(:followers, through: :reverse_relationships, 
                         source:  :follower)


    #before_save { |user| user.email = email.downcase }
    #before_save { self.email.downcase! }

    #before_save :create_remember_token
    #before_save { self.remember_token = SecureRandom.urlsafe_base64 }

    before_save do 
      self.email.downcase! 
      self.remember_token = SecureRandom.urlsafe_base64
    end


    #-------------------------#
    #---   VALIDATION(S)   ---#
    #-------------------------#
    validates(:name, presence: true, 
    	               length: {maximum: 50})

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates(:email, presence: true, 
    	                format: { with: VALID_EMAIL_REGEX },
    	                uniqueness: { case_sensitive: false })

    validates(:password, length: { minimum: 6 })

    validates(:password_confirmation, presence: true)


    #---------------------#
    #---   METHOD(S)   ---#
    #---------------------#
    def feed
        # This is preliminary. See "Following users" for the full implementation.
        # Micropost.where("user_id = ?", id)

        # Get "Followed" User(s) Micropost(s) PLUS "Self" Micropost(s) 
        Micropost.from_users_followed_by(self)
    end

    def following?(other_user)
        #Check Following Relationship
        relationships.find_by_followed_id(other_user.id)
    end

    def follow!(other_user)
        #Create Following Relationship
        relationships.create!(followed_id: other_user.id)
    end

    def unfollow!(other_user)
        #Delete Following Relationship
        relationships.find_by_followed_id(other_user.id).destroy
    end


    #-----------------------------------#
    #---   PRIVATE   ---   PRIVATE   ---#
    #-----------------------------------#
    private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
