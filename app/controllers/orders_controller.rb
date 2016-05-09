class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:notify]

  def sales 
    @orders = Order.all.where(seller: current_user).order("created_at DESC")
  end

  def purchases
    @orders = Order.all.where(buyer: current_user).order("created_at DESC")
  end

  # GET /orders/new
  def new
    @order = Order.new
    @listing = Listing.find(params[:listing_id])
  end


  # POST /orders
  # POST /orders.json
  def create
    # @order = Order.new(order_params)
    @order = current_user.orders.create(order_params)

    @listing = Listing.find(params[:listing_id])
    @seller = @listing.user 

    @order.listing_id = @listing.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id
    @order.price = @listing.price.to_i
    @order.name = @listing.name

    # Paypal Payment Start
    if @order.save
      # send request to paypal
      values = {
        business: User.find(@listing.user_id).email,
        cmd: '_xclick',
        upload: 1,
        notify_url: 'https://codingo-etsy.herokuapp.com/listings/notify',
        amount: @order.price,
        item_name: @order.name,
        item_number: @order.id,
        quantity: '1',
        return: 'https://codingo-etsy.herokuapp.com/listings/purchases'
      }

      redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
    else
      redirect_to @order, alert: "Something went wrong..."
    end

  end

  protect_from_forgery except: [:notify]
  def notify 
# binding.pry
    params.permit!
    status = params[:payment_status]

    order = Order.find(params[:item_number])
    if status = "Completed"
      order.update_attributes status: true
    else
      order.destroy
    end

    render nothing: true
  end

  protect_from_forgery except: [:your_orders]
  def your_orders
   
    # @orders = current_user.orders.where("status = ?", true)
    @orders = Order.all.where(buyer: current_user).order("created_at DESC")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:address, :city, :state, :postcode)
    end
end
