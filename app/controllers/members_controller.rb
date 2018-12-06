class MembersController < ApplicationController

    def index 
        @members = Member.all
    end

    def show 
        @member = Member.find_by(id: params[:id])
        @pairs = Member.pairs(@member.id)
    end 

end
