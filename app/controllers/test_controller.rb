class TestController < ApplicationController
  def new
    redirect_to new_response_path(item_id: Item.first)
  end


  def item
    @participant = Participant.find_by(session: session.id)
    @item = Item.find(params[:id])
  end
end
