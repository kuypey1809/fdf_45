class ProductsController < ApplicationController
  before_action :admin_user, :logged_in_user, only: %i(create destroy new)
  before_action :load_product, only: %i(show destroy edit update)
  before_action :load_parent_categories, only: :index
  before_action :load_categories, only: :new

  def index
    @products = Product.paginate(page: params[:page]).sort_by_datetime
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t ".product_created"
      redirect_to products_path
    else
      render :new
    end
  end

  def update
    if @product.update_attributes product_params
      flash[:success] = t ".updated"
      redirect_to @product
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      redirect_to products_path
    else
      flash[:danger] = t ".cant_delete"
    end
  end

  private

  def load_products_by_category
    @products = Product.find_by_cate(params[:id])
  end

  def product_params
    params.require(:product).permit :name, :description, :category_id,
      :price, :image
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product.present?
    flash[:danger] = t "layouts.flash.notfound"
    redirect_to products_path
  end

  def load_categories
    @categories = Category.all.map{|m| [m.name, m.id]}
  end

  def load_parent_categories
    @parents = Category.largest
  end

  def admin_user
    return unless current_user.present?
    redirect_to root_path unless current_user.admin?
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "layouts.flash.log_in"
    redirect_to login_path
  end
end
