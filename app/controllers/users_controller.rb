class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit destroy)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".success_signin"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".deleted"
    else
      flash[:danger] = t ".cant_delete"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :address, :phone,
      :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user.present?
    flash[:danger] = t ".notfound"
    redirect_to root_path
  end

  def correct_user
    load_user
    return if current_user? @user
    redirect_to root_path
    flash[:danger] = t ".cant_edit"
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".log_in"
    redirect_to login_path
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
