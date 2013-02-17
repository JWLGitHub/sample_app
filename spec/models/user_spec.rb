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
#

require 'spec_helper'

describe User do

    before do
      @user = User.new(name: "Example User", 
                       email: "user@example.com", 
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

    describe "authenticate method exists" do
      it { should respond_to(:authenticate) }
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
end
