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

require 'spec_helper'

describe User do

    before(:each) do
      @user = User.new(name: "Test User", 
                       email: "test@user.com", 
                       password: "foobar", 
                       password_confirmation: "foobar")
    end

    subject { @user }

    describe "name attribute exists" do
        it { should respond_to(:name) }
    end

    describe "email attribute exists" do
        it { should respond_to(:email) }
    end

    describe "password attribute exists" do
        it { should respond_to(:password) }
    end 

    describe "password_confirmation attribute exists" do
        it { should respond_to(:password_confirmation) }
    end     

    describe "password_digest attribute exists" do
        it { should respond_to(:password_digest) }
    end

    describe "remember_token attribute exists" do
        it { should respond_to(:remember_token) }
    end

    describe "admin attribute exists" do
        it { should respond_to(:admin) }
    end

    describe "authenticate method exists" do
        it { should respond_to(:authenticate) }
    end

    describe "microposts relationship exists" do
        it { should respond_to(:microposts) }
    end

    describe "feed method exists" do
        it { should respond_to(:feed) }
    end

    describe "relationships attribute exists" do
        it { should respond_to(:relationships) }
    end

    describe "followed_users attribute exists" do
        it { should respond_to(:followed_users) }
    end
 
    describe "following? method exists" do
        it { should respond_to(:following?) }
    end

    describe "follow! method exists" do
        it { should respond_to(:follow!) }
    end

    describe "unfollow! method exists" do
        it { should respond_to(:unfollow!) }
    end

    describe "reverse_relationships attribute exists" do
        it { should respond_to(:reverse_relationships) }
    end

    describe "followers attribute exists" do
        it { should respond_to(:followers) }
    end

    describe "passes ALL validations" do
        it { should be_valid }
    end

    describe "name value is not present" do
        before { @user.name = " " }
        it { should_not be_valid}
    end

    describe "name value is too long" do
        before { @user.name = " a" * 51 }
        it { should_not be_valid }      
    end

    describe "email value is not present" do
        before { @user.email = " " }
        it { should_not be_valid }
    end

    describe "email format is invalid" do
        it "should be invalid" do
            addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
            addresses.each do |invalid_address|
                @user.email = invalid_address
                @user.should_not be_valid
            end      
        end
    end

    describe "email format is valid" do
        it "should be valid" do
            addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
            addresses.each do |valid_address|
                @user.email = valid_address
                @user.should be_valid
            end      
        end
    end

    describe "email address is already taken" do
        before do
            user_with_same_email = @user.dup
            user_with_same_email.email = @user.email.upcase
            user_with_same_email.save
        end

        it { should_not be_valid }
    end

    describe "email address has mixed case" do
        let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

        it "should be saved as all lower-case" do
            @user.email = mixed_case_email
            @user.save
            @user.reload.email.should == mixed_case_email.downcase
        end
    end

    describe "password/password_confirmation value is not present" do
        before { @user.password = @user.password_confirmation = " " }
        it { should_not be_valid}
    end

    describe "password value not equal password_confirmation value" do
        before { @user.password_confirmation = "oineg[qeorv" }
        it { should_not be_valid}
    end

    describe "password_confirmation value is nil" do
        before { @user.password_confirmation = nil }
        it { should_not be_valid}
    end

    describe "password is too short" do
        before { @user.password = @user.password_confirmation = "a" * 5 }
        it { should be_invalid }
    end

    describe "admin attribute set to 'fakse' (default)" do
        it { should_not be_admin }
    end

    describe "admin attribute set to 'true'" do
        before do
          @user.toggle!(:admin)
        end

        it { should be_admin }
    end

    it "should not allow access to admin" do
        expect do
            User.new(admin: true)
        end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    describe "return value of authenticate method" do
        before { @user.save }
        let(:found_user) { User.find_by_email(@user.email) }

        describe "with valid password" do
            it { should == found_user.authenticate(@user.password) }
        end

        describe "with invalid password" do
            let(:user_for_invalid_password) { found_user.authenticate("invalid") }

            it { should_not == user_for_invalid_password }
            specify { user_for_invalid_password.should be_false }
        end
    end

    describe "remember token" do
        before { @user.save }
        it { @user.remember_token.should_not be_blank }
    end

    describe "micropost associations" do
        before(:each)  do
            # Save "Test" User 
            @user.save
        end

        let!(:older_micropost) do
            # Create "Older" Micropost for "Test" User 
            FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
        end
        
        let!(:newer_micropost) do
            # Create "Newer" Micropost for "Test" User             
            FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
        end

        it "should have the right microposts in the right order" do
            # "Test" User Microposts in Descending "created_at" order 
            @user.microposts.should == [newer_micropost, older_micropost]
        end

        it "should destroy associated microposts" do
            # Duplicate "Test" User Microposts
            microposts = @user.microposts.dup

            # Delete "Test" User
            @user.destroy

            microposts.each do |micropost|
                # "Test" User Microposts Deleted 
                Micropost.find_by_id(micropost.id).should be_nil
            end
        end

        describe "feed" do
            let(:unfollowed_post) do
                # Create Micropost for an "UNFollowed" User
                FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
            end

            let(:followed_user) do
                # Create "Followed" User
                FactoryGirl.create(:user)
            end

            before(:each) do
                # "Test" User Follows "Followed" User
                @user.follow!(followed_user)

                # Create 3 "Followed" User Microposts
                3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
            end

            it "should include 'Newer' Micropost" do
                @user.feed().should include(newer_micropost) 
            end
           
            it "should include 'Older' Micropost" do
                @user.feed().should include(older_micropost) 
            end

            it "shouldn't include 'UNFollowed' User Micropost" do
                @user.feed().should_not include(unfollowed_post)
            end

            it "should include ALL 'Followed' User Microposts" do
                followed_user.microposts.each do |micropost|
                    @user.feed().should include(micropost)
                end
            end
        end
    end

    describe "following" do
        let(:other_user) { FactoryGirl.create(:user) }

        before(:each) do
            @user.save
            @user.follow!(other_user)
        end

        it { should be_following(other_user) }

        its(:followed_users) { should include(other_user) }

        describe "followed user" do
            subject { other_user }
            
            its(:followers) { should include(@user) }
        end

        describe "and unfollowing" do
            before(:each) do
                @user.unfollow!(other_user)
            end

            it { should_not be_following(other_user) }

            its(:followed_users) { should_not include(other_user) }
        end
    end        
end
