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

require 'spec_helper'

describe Micropost do

	 let(:user) { FactoryGirl.create(:user) }

  	before(:each) do
		# This code is wrong!
        # @micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)

	    @micropost = user.microposts.build(content: "Lorem ipsum") 
	end

	subject { @micropost }

    describe "content attribute exists" do
        it { should respond_to(:content) }
    end	

    describe "user_id attribute exists" do
		it { should respond_to(:user_id) }
    end		

    describe "user relationship exists" do
		it { should respond_to(:user) }

		its(:user) { should == user }
    end	

    describe "passes ALL validations" do
		it { should be_valid }
    end	

    describe "when user_id is not present" do
    	before(:each) do
    		@micropost.user_id = nil
    	end

        it { should_not be_valid }
    end

    describe "accessible attributes" do
    	it "should not allow access to user_id" do
        	expect do
        		Micropost.new(user_id: user.id)
      		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    	end    
    end

    describe "with blank content" do
        before (:each) do 
            @micropost.content = " "
        end

        it { should_not be_valid }
    end

    describe "with content that is too long" do
        before (:each) do 
            @micropost.content = "a" * 141 
        end

        it { should_not be_valid }
    end
end
