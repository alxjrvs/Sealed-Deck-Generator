class PoolController < ApplicationController

def index
  @secret = true if params[:secret] == "images"

  if params[:short_name] and params[:packs]
    @short_name = params[:short_name].upcase
    @pool = Release.find_by_short_name(@short_name).gen_pool(params[:packs].to_i)
  else
    @secret = false
    @pool = Release.first.gen_pool 6
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
end

end

