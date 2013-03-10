require 'spec_helper'

describe "Micropost pages" do

  	subject { page }

  	let(:user) { FactoryGirl.create(:user) }
  	
  	before(:each) do 
  		  sign_in(user)
  	end

  	describe "micropost creation" do
        before(:each) do
    		    visit(root_path)
    	   end

      	describe "with invalid information" do
        		it "should not create a micropost" do
          		  expect { click_button("Post") }.to_not change(Micropost, :count)
        		end

        		describe "error messages" do
          		  before(:each) do
          			   click_button("Post")
          		  end
          	
          		  it { should have_content('error') } 
        		end
      	end

      	describe "with valid information" do
        		before(:each) do
        			 fill_in('micropost_content', with: "Lorem ipsum")
        		end

        		it "should create a micropost" do
          		  expect { click_button("Post") }.to change(Micropost, :count).by(1)
        		end
      	end
  	end

    describe "micropost destruction" do
        before(:each) do
            FactoryGirl.create(:micropost, user: user)
        end

        describe "as correct user" do
            before(:each) do
                visit(root_path)
            end

            it "should delete a micropost" do
                expect { click_link("delete") }.to change(Micropost, :count).by(-1)
            end
        end
    end
end