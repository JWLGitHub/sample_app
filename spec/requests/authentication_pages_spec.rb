require 'spec_helper'

describe "Authentication" do

    subject { page }

    describe "signin page" do
        before(:each) do
            visit(signin_path) 
        end

        it { should have_selector('h1',    text: 'Sign in') }

        it { should have_selector('title', text: 'Sign in') }
    end

    describe "signin" do
        before(:each) do
            visit(signin_path) 
        end

        describe "with invalid information" do
            before(:each) do
                click_button("Sign in")
            end

            it { should have_selector('title', text: 'Sign in') }

            it { should have_selector('div.alert.alert-error', text: 'Invalid') }

            describe "after visiting another page" do
                before(:each) do
                    click_link("Home")
                end

                it { should_not have_selector('div.alert.alert-error') }
            end
        end

        describe "with valid information" do
            #Create a User model object (see /spec/factories.rb)
            let(:user) { FactoryGirl.create(:user) }
          
            before(:each) do
                #Sign in a User (see /spec/support/utilities.rb)
                sign_in(user)
            end

            it { should have_selector('title', text: user.name) }

            it { should have_link('Users',       href: users_path) }
          
            it { should have_link('Profile',     href: user_path(user)) }

            it { should have_link('Settings',    href: edit_user_path(user)) }
          
            it { should have_link('Sign out',    href: signout_path) }
          
            it { should_not have_link('Sign in', href: signin_path) }

            describe "followed by signout" do
                before(:each) do 
                    click_link("Sign out") 
                end

                it { should have_link('Sign in') }

                it { should_not have_link('Profile') }

                it { should_not have_link('Settings') }
            end
        end
    end

    describe "authorization" do

        describe "for non-signed-in users" do
            let(:user) { FactoryGirl.create(:user) }

            describe "in the Users controller" do

                describe "visiting the edit page" do
                    before(:each) do
                        visit(edit_user_path(user))
                    end

                    it { should have_selector('title', text: 'Sign in') }
                end

                describe "submitting to the update action" do
                    before(:each) do
                        #"put" needed to replicate RESTful "update" of existing record
                        put(user_path(user))
                    end

                    #From the HTTP Response object
                    specify { response.should redirect_to(signin_path) }
                end

                describe "visiting the user index" do
                    before(:each) do
                        visit(users_path)
                    end

                    it { should have_selector('title', text: 'Sign in') }
                end
            end

            describe "when attempting to visit a protected page" do
                before(:each) do
                    visit(edit_user_path(user))
                    sign_in(user)
                end

                describe "after signing in" do
                    it "should render the desired protected page" do
                        page.should have_selector('title', text: 'Edit user')
                    end
                end
            end

            describe "in the Microposts controller" do

                describe "submitting to the create action" do
                    before(:each) do 
                        post(microposts_path)
                    end 

                    specify { response.should redirect_to(signin_path) }
                end

                describe "submitting to the destroy action" do
                    before(:each) do 
                        delete(micropost_path(FactoryGirl.create(:micropost))) 
                    end
                    
                    specify { response.should redirect_to(signin_path) }
                end
            end
        end

        describe "as wrong user" do
            let(:user) { FactoryGirl.create(:user) }
            let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

            before(:each) do
                sign_in(user)
            end  

            describe "visiting Users#edit page" do
                before(:each) do
                    visit edit_user_path(wrong_user) 
                end

                it { should_not have_selector('title', text: full_title('Edit user')) }
            end

            describe "submitting a PUT request to the Users#update action" do
                before(:each) do
                    #"put" needed to replicate RESTful "update" of existing record
                    put user_path(wrong_user)
                end

                specify { response.should redirect_to(root_path) }
              end
        end

        describe "as non-admin user" do
            let(:user)      { FactoryGirl.create(:user) }
            let(:non_admin) { FactoryGirl.create(:user) }

            before(:each) do
                sign_in(non_admin)
            end

            describe "submitting a DELETE request to the Users#destroy action" do
                before(:each) do
                    delete user_path(user)
                end

                specify { response.should redirect_to(root_path) }        
            end
        end
    end
end