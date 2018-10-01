class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.paginate(page: params[:page])
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "layouts.flash.success_signin"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "layouts.flash.updated"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :address, :phone,
      :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user.present?
    flash[:danger] = t "layouts.flash.notfound_user"
    redirect_to root_path
  end

  def correct_user
    load_user
    return if current_user? @user
    redirect_to root_path
    flash[:danger] = t "layouts.flash.cant_edit"
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "layouts.flash.log_in"
    redirect_to login_path
  end
end
