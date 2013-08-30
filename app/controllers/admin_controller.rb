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
    return redirect_to admin_error_url unless logged?
    @users = current_admin.users
  end

  def auth
    admin = Admin.find_by_username(params[:username])
    if current_admin.present? && current_admin.authenticate(params[:password])
      session[:admin] = current_admin
      redirect_to admin_dashboard_url
    else
      redirect_to admin_login_url, :notice => 'Username or password do not match!'
    end
  end

  private
    def logged?
      session[:admin].present?
    end

    def current_admin
      admin ||= Admin.find_by_username(params[:username])
    end
end
