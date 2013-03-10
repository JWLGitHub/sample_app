FactoryGirl.define do
	# ----------------------------------------- #
	# Create multiple/different/unique  User(s) #
	# ----------------------------------------- #
    factory :user do
	    sequence(:name)  { |n| "Person #{n}" }
	    sequence(:email) { |n| "person_#{n}@example.com"}   
	    password "foobar"
	    password_confirmation "foobar"

	    factory :admin do
	        admin true
	    end
	end

	# -------------------- #
	# Create Specific User #
	# -------------------- #
	#    factory :user do
	#        name     "Michael Hartl"
	#        email    "michael@example.com"
	#        password "foobar"
	#        password_confirmation "foobar"
	#    end	

	# ------------------------- #
	# Create Specific Micropost #
	# ------------------------- #
	factory :micropost do
        content "Lorem ipsum"
        user
    end
end