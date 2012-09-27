class PoolController < ApplicationController

  def index
    @releases = Release.all.map {|r| [r.name, r.id]}
    respond_to do |format|
      format.html #index.html.haml
      format.json { render json: @releases }
    end
  end


  def card_pool
    if params[:release] and params[:packs]
      @secret = true if params[:secret]
      @release = Release.find(params[:release])
      @pool = @release.gen_pool(params[:packs].to_i)
      pool_color  = []
      pool_rarity  = []
      @pool.flatten.each do |card|
        p card
        pool_rarity << card.rarity
        pool_color << card.color
        end
      @pool_rarity  = pool_rarity.flatten
      @pool_color = pool_color.flatten
      respond_to do |format|
        format.html #index.html.haml
        format.json { render json: @pool }
      end
    else
      redirect_to :action => 'index'
      flash[:notice] = 'Must Supply Both Pack Size and Set.'
    end
  end
end
