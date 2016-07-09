class TransactionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @product = Product.find_by!(permalink: params[:permalink])
  end

  def create
    @product = Product.find_by!(permalink: params[:permalink])
    sale = @product.sales.create(
      amount: @product.price,
      email: params[:email],
      stripe_token: params[:stripeToken]
    )
    sale.process!
    if sale.finished?
      redirect_to pickup_url(guid: sale.guid)
    else
      flash.now[:alert] = sale.error
      render :new
    end
  end

  def pickup
    @sale = Sale.find_by!(guid: params[:guid])
    @product = @sale.product
  end

  def download
    @sale = Sale.find_by!(guid: params[:guid])
    resp = HTTParty.get(@sale.product.file.url)

    filename = @sale.product.file.url
    send_data resp.body,
      :filename => File.basename(filename),
      :content_type => resp.headers['Content-Type']
  end
end
