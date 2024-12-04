class Admin::OrderController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_order, only: [:submit, :cancel, :pay]

  def index
    @orders = Order.includes(:offer, :user).order(created_at: :asc).page(params[:page]).per(10)

    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.joins(:user).where(users: { email: params[:email] }) if params[:email].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(offer_id: params[:offer_id]) if params[:offer_id].present?

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      end_date = Date.parse(params[:end_date]) rescue nil
      @orders = @orders.where(created_at: start_date.beginning_of_day..end_date.end_of_day) if start_date && end_date
    end

    @subtotal_amount = @orders.to_a.sum(&:amount)
    @subtotal_coins = @orders.to_a.sum(&:coin)

    total_orders = Order.all
    @total_amount = total_orders.sum(:amount)
    @total_coins = total_orders.sum(:coin)
  end

  def submit
    @order = Order.find_by(id: params[:id])
    if @order&.may_submit?
      @order.submit!
      redirect_to admin_order_index_path, notice: 'Order has been submitted.'
    else
      redirect_to admin_order_index_path, alert: 'Unable to submit the order.'
    end
  end

  def cancel
    @order = Order.find_by(id: params[:id])
    if @order&.may_cancel?
      @order.cancel!
      redirect_to admin_order_index_path, notice: 'Order has been cancelled.'
    else
      redirect_to admin_order_index_path, alert: 'Unable to cancel the order.'
    end
  end

  def pay
    @order = Order.find_by(id: params[:id])
    if @order&.may_pay?
      @order.pay!
      redirect_to admin_order_index_path, notice: 'Order has been paid.'
    else
      redirect_to admin_order_index_path, alert: 'Unable to mark the order as paid.'
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end