module SessionsHelper

  #---------------------#
  #---   Setter(s)   ---#
  #---------------------#
  def current_user=(user)
      @current_user = user
  end

  #---------------------#
  #---   Getter(s)   ---#
  #---------------------#
  def current_user()
    	if @current_user.nil?
    	   return User.find_by_remember_token(cookies[:remember_token])  
    	else
    	   return @current_user
      end
  end

  def current_user?(user)
      if self.current_user() == user
          return true
      else
          return false
      end  
  end

  def sign_in(user)
    	#Put User's remember_token in User's browser as cookie (expires in 20 years - i.e.: "permanent")
      cookies.permanent[:remember_token] = user.remember_token
      
      #Set the current_user
      self.current_user=(user)
  end

  def signed_in?()
      if current_user().nil?
          #User NOT Signed In
          return false
      else
          #User Signed In
          return true
      end
  end

  def sign_out()
      #Unset the current_user
      self.current_user=(nil)

      #Remove User's remember_token in User's browser as cookie 
      cookies.delete(:remember_token)
  end

  def redirect_session_url_or(default)
      if session[:request_url]
          #Session has a "request_url" from previous request
          redirect_to(session[:request_url])
          session.delete(:request_url)
      else
          redirect_to(default)
      end
  end

  def store_request_url()
      #Store Request URL in Session as ":request_url"
      session[:request_url] = request.url
  end
end