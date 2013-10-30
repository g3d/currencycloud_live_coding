class ShortenController < ApplicationController
  before_action :set_shorten, only: [:show]

  def index
    @shortens = Shorten.all
    @shorten = Shorten.new
  end

  def show
    if @shorten.present?
      @shorten.increment!(:visits)
      redirect_to @shorten.url
    else
      flash[:notice] = 'Item destroyed long time ago'
      redirect_to root_path
    end
  end

  def create
    @shorten = Shorten.where(url: shorten_params['url'].strip).first_or_initialize do |s|
      s.url = shorten_params['url'].strip
    end
    if @shorten.save
      flash[:notice] = 'Shorten created'
    else
      flash[:notice] = @shorten.errors.full_messages.join('. ')
    end
    redirect_to root_path
  end

  private

  def set_shorten
    @shorten = Shorten.find_by(slug: params[:id])
  end

  def shorten_params
    params[:shorten]
    params.require(:shorten).permit(:url)
  end
end
