class AdminController < ActionController::Base

  layout "admin"

  before_filter :only_super_admin, :only => [:customers_dashboard]
  before_filter :only_my_dashboard, :only => [:dashboard]

  def logout
    session[:admin_id] = nil
    redirect_to admin_login_url, :notice => 'You have been logged out!'
  end

  def login
    if logged?
      redirect_to admin_dashboard
    end
  end

  def dashboard
    customer = Customer.find(params[:id])
    @users = customer.users
    redirect_to admin_error_url unless logged?
  end

  def auth
    admin = Admin.find_by_username(params[:username])
    if admin.nil? || !admin.authenticate(params[:password])
      redirect_to admin_login_url, :notice => 'Username or password do not match!'
    else
      session[:admin_id] = admin.id
      redirect_to admin_dashboard
    end
  end

  def customers_dashboard
    @customers = Customer.find_all_by_super(false)
  end

  helper_method :current_admin
  def current_admin
    @admin ||= Admin.find(session[:admin_id])
  end

  private

    def admin_dashboard
      if current_admin.super?
        admin_customers_dashboard_url
      else
        admin_dashboard_url(current_admin.customer)
      end
    end

    def logged?
      session[:admin_id].present?
    end

    def only_super_admin
      if !logged? || !current_admin.super?
        redirect_to admin_login_url
      end
    end

    def only_my_dashboard
      if !current_admin.super? && current_admin.customer_id != params[:id].to_i
        redirect_to admin_login_url
      end
    end
end
