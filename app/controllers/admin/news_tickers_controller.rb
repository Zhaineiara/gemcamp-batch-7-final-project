class Admin::NewsTickersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_news_ticker, only: [:edit, :update, :destroy]

  def index
    @news_tickers = NewsTicker.order(status: :desc).page(params[:page]).per(10)
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.admin_id = current_admin_user.id
    if @news_ticker.save
      redirect_to admin_news_tickers_path, notice: 'News ticker was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @news_ticker.update(news_ticker_params)
      redirect_to action: 'index'
    else
      render :edit
    end
  end

  def destroy
    if @news_ticker.destroy
      redirect_to admin_news_tickers_path, notice: 'News ticker was successfully destroyed.'
    else
      redirect_to admin_news_tickers_path, notice: 'News ticker could not be destroyed.'
    end
  end

  private

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status)
  end
end
