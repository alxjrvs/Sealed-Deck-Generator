class PoolController < ApplicationController

 caches_page :index

  def index
    #@releases = Release.all.map {|r| [r.name, r.id]}
    @releases = Release.all.map {|r| r.name}
    respond_to do |format|
      format.html #index.html.haml
      format.json { render json: @releases }
    end
  end


  def card_pool
    if Release.find_by_name(params[:release])
      @secret = true if params[:secret]
      @release = Release.find_by_name(params[:release])
      @pool = @release.gen_pool(params[:packs].to_i)
      pool_color  = []
      pool_rarity  = []
      @pool.flatten.each do |card|
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
