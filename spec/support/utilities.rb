def full_title(page_title)
	base_title = "Ruby on Rails Tutorial Sample App"
	  
	if page_title.empty?
	    base_title
	else
	    "#{base_title} | #{page_title}"
	end
end

def sign_in(user)
	  visit signin_path
	  fill_in "email",    with: user.email
	  fill_in "password", with: user.password
	  click_button "Sign in"
	  # Sign in when not using Capybara as well.
	  cookies[:remember_token] = user.remember_token
end