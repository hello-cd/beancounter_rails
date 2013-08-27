class AdminController < ActionController::Base

  def is_logged?
  	!session[:admin].nil?
  end

  def login
  	render 'admin/login', :layout => "admin"
  end

  def logout
  	session[:admin] = nil
		redirect_to "/admin/login", :notice => 'You have been logged out!'
	end

	def main
		return redirect_to "/admin/error" unless is_logged?
		render "admin/main", :layout => "admin"
	end

	def auth
		return redirect_to "/admin/main" if is_logged?
		admin = Admin.new(params[:username])
  	if ( admin.authenticate(params[:password]) )
  		session[:admin] = admin
  		redirect_to "/admin/main"
  	else
			redirect_to "/admin/login", :notice => 'Username or password do not match!'
  	end
	end

end