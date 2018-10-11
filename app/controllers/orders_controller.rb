class OrdersController < ApplicationController
  before_action :load_data, only: :create
  before_action :admin_user, only: [:index, :edit]
  before_action :load_order, :check_user, :load_order_details, only: :show

  def new; end

  def create
    islogin = false
    ActiveRecord::Base.transaction do
      if logged_in?
        islogin = true
        @order = Order.new
        @order.user_id = current_user.id
        @order.total_cost = 0
        @order.save
        @order_id = @order.id
        @data.each do |element|
          new_order_detail element
        end
        @order.save
      end
    end
    render json: {islogin: islogin}
  end

  def show; end

  def index
    @orders = Order.paginate page: params[:page]
  end

  def edit; end

  def personal_show
    @orders = Order.personal(current_user.id).paginate page: params[:page]
  end

  private

  def order_params
    params.require(:order).permit(:user_id)
  end

  def load_data
    @data = JSON.parse(params[:demo])
  end

  def load_order
    @order = Order.includes(order_details: :product).find_by(id: params[:id])
    return if @order.present?
    flash[:danger] = t ".notfound"
    redirect_to root_path
  end

  def admin_user
    return unless current_user.present?
    redirect_to root_path unless current_user.admin?
  end

  def check_user
    return unless current_user.customer? && (@order.user_id != current_user.id)
    redirect_to myOrders_path
    flash[:warning] = t ".cant_see"
  end

  def load_order_details
    @order_details = @order.order_details
  end

  def new_order_detail element
    @order_detail = OrderDetail.new
    @order_detail.quantity = element["quantity"]
    @order_detail.order_id = @order_id
    @order_detail.product_id = element["id"]
    @order_detail.unit_price =
      Product.find(@order_detail.product_id).price
    @order_detail.total_price =
      @order_detail.unit_price * @order_detail.quantity
    @order_detail.save
    @order.total_cost += @order_detail.total_price
  end
end
