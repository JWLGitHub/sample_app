require 'spec_helper'
# Run the generator again with the --webrat flag if you want to use webrat methods/matchers

describe "Static pages" do

    subject { page }

    #let(:base_title) { "Ruby on Rails Tutorial Sample App"}
    shared_examples_for "all static pages" do
        it { should have_selector('h1',    text: heading) }

        it { should have_selector('title', text: full_title(page_title)) }
    end

    describe "Home page" do
        before(:each) do
            visit(root_path)
        end

        let(:heading)    { 'Sample App' }
        let(:page_title) { '' }

        it_should_behave_like "all static pages"

        it { should_not have_selector 'title', text: '| Home' }

        describe "for signed-in users" do
            let(:user) { FactoryGirl.create(:user) }

            before(:each) do
                FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
                FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
                sign_in(user)
                visit(root_path)
            end

            it "should render the user's feed" do
                user.feed.each do |item|
                    page.should have_selector("li##{item.id}", text: item.content)
                end
            end

            describe "follower/following counts" do
                let(:other_user) { FactoryGirl.create(:user) }

                before(:each) do
                    other_user.follow!(user)
                    visit(root_path)
                end

                it { should have_link("0 following", href: following_user_path(user)) }
                it { should have_link("1 followers", href: followers_user_path(user)) }
            end
        end
    end

    describe "Help page" do
        before(:each) do
            visit(help_path)
        end

        let(:heading)    { 'Help' }
        let(:page_title) { 'Help' }

        it_should_behave_like "all static pages"
    end

    describe "About page" do
        before(:each) do
            visit(about_path)
        end

        let(:heading)    { 'About' }
        let(:page_title) { 'About Us' }

        it_should_behave_like "all static pages"
    end

    describe "Contact" do
        before(:each) do
            visit(contact_path)
        end

        let(:heading)    { 'Contact' }
        let(:page_title) { 'Contact' }

        it_should_behave_like "all static pages"
    end

    it "should have the right links on the layout" do
        visit(root_path)

        click_link("Home")
        page.should have_selector 'title', text: full_title('')

        click_link("Help")
        page.should have_selector 'title', text: full_title('Help')

        click_link("About")
        page.should have_selector 'title', text: full_title('About Us')

        click_link("Contact")
        page.should have_selector 'title', text: full_title('Contact')

        click_link("sample app")
        page.should have_selector 'title', text: full_title('')  

        click_link("Sign up now!")
        page.should have_selector 'title', text: full_title('Sign up')
      end

end