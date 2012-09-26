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
      @secret = true if params[:secret] == "images"
        @release = Release.find(params[:release])
      case params[:sortable]
        when "rarity"
          @pool = @release.gen_pool(params[:packs].to_i).sort_by {|c| c.lazy_rarity}
        when "color"
          @pool = @release.gen_pool(params[:packs].to_i).sort_by {|c| c.lazy_color}
        else
          @pool = @release.gen_pool(params[:packs].to_i)
      end
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
