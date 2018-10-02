class CategoriesController < ApplicationController
  before_action :load_category, only: :destroy
  before_action :admin_user, only: [:destroy, :create]

  def index
    @parents = Category.largest
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t ".new_category"
      redirect_to categories_path
    else
      render :new
    end
  end

  def destroy
    if @category.destroy
    redirect_back fallback_location: category_path
    else
      flash[:danger] = t ".cant_delete"
    end
  end

  private

  def category_params
    params.require(:category).permit :name, :parent_id
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category.present?
    flash[:danger] = t ".notfound"
    redirect_to root_path
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
