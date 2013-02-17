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
  def current_user
    	#If current_user is nil
    	#   return User based on remember_token 
    	#else
    	#   return current_user
      return @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def sign_in(user)
    	#Put User's remember_token in User's browser as cookie (expires in 20 years - i.e.: "permanent")
      cookies.permanent[:remember_token] = user.remember_token
      
      #Set the current_user
      self.current_user=(user)
  end

  def signed_in?
      !current_user.nil?
  end

  def sign_out
      self.current_user = nil

      #Remove User's remember_token in User's browser as cookie 
      cookies.delete(:remember_token)
  end

end
