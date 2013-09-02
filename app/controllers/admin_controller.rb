class AdminController < ActionController::Base

  layout "admin"

  def logout
    session[:admin] = nil
    redirect_to admin_login_url, :notice => 'You have been logged out!'
  end

  def login
    if logged? && !admin.super?
      redirect_to admin_dashboard_url(admin.customer)
    end
  end

  def dashboard
    customer = Customer.find(params[:id])
    @users = customer.users
    redirect_to admin_error_url unless logged?
  end

  def auth
    admin = Admin.find_by_username(params[:username])
    if admin.present? && admin.authenticate(params[:password])
      if admin.customer.super?
        session[:admin] = admin
        redirect_to admin_customers_dashboard_url
      else
        session[:admin] = admin
        redirect_to admin_dashboard_url(admin.customer)
      end
    else
      redirect_to admin_login_url, :notice => 'Username or password do not match!'
    end
  end

  def customers_dashboard
    @customers = Customer.find_all_by_super(false)
  end

  private
    def logged?
      session[:admin].present?
    end
end
