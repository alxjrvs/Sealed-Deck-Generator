class PoolController < ApplicationController

def index
  @pool = Release.first.gen_pool 6
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

