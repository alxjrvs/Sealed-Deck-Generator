class PoolController < ApplicationController

def index
  @pool = Release.first.gen_pool 6
  respond_to do |format|
    format.html #index.html.haml
    format.json { render json: @pool }
  end
end

end

