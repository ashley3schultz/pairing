class PairsController < ApplicationController 

    def index
        @pairs = Pair.where(current: true)
    end
    
    def create
        Pair.create_pairs
        redirect_to root_path
    end

end
