class AdminController < ActionController::Base

  layout "admin"

  def logout
    session[:admin] = nil
    redirect_to admin_login_url, :notice => 'You have been logged out!'
  end

  def login
    return redirect_to admin_dashboard_url if logged?
  end

  def dashboard
    admin = session[:admin]
    @users = admin.users
    return redirect_to admin_error_url unless logged?
  end

  def auth
    admin = Admin.find_by_username(params[:username])
    if admin.present? && admin.authenticate(params[:password])
      session[:admin] = admin
      redirect_to admin_dashboard_url
    else
      redirect_to admin_login_url, :notice => 'Username or password do not match!'
    end
  end

  private
    def logged?
      session[:admin].present?
    end
end
