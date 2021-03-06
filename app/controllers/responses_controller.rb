class ResponsesController < ApplicationController
  before_action :set_response, only: [:show, :edit, :update, :destroy]
  before_action :set_itembank, only: [:create, :new]
  before_filter :require_admin_or_examinator!, only: [:show, :index]


  # GET /responses
  # GET /responses.json
  def index
    @responses = Response
    if params["participant_hashes"]
      @responses = @responses.filter_by_participant_hashes(params["participant_hashes"].split(","))
    end
    @responses = @responses.all
  end
  #
  # # GET /responses/1
  # # GET /responses/1.json
  # def show
  # end

  # GET /responses/new
  def new

    if current_participant.responses.count > 0
      @prev_eval_results = current_participant.evaluate

      #@prev_eval_results = params[:eval_results]
      @item = @prev_eval_results[:next_item]
    elsif params[:item_id]
      @item = Item.find(params[:item_id])
    else
      @item = Item.first
    end
    vraagnummer = current_participant.responses.count + 1
    @title = "Vraag #{vraagnummer}"
    @response = Response.new(item_id: @item.id)
  end

  # # GET /responses/1/edit
  # def edit
  # end

  # POST /responses
  # POST /responses.json
  def create
    @response = current_participant.init_response(response_params)
    #

    respond_to do |format|
      if @response.save
        # eval_results = current_participant.evaluate #@itembank.evaluate(current_participant.responses,[1,1,1])
        eval_results = current_participant.evaluate
        if eval_results[:done] == true
          format.html { redirect_to participant_path(current_participant), notice: 'Vragenlijst is afgerond!' }
          format.json { render :show, status: :finished, location: current_participant }
        else
          format.html { redirect_to new_response_path({item_id:eval_results[:next_item].id, eval_results:eval_results}) }
          format.json { render :show, status: :created, location: @response }
        end
      else
        @item = @response.item
        format.html { render :new }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PATCH/PUT /responses/1
  # # PATCH/PUT /responses/1.json
  # def update
  #   respond_to do |format|
  #     if @response.update(response_params)
  #       format.html { redirect_to @response, notice: 'Response is bijgewerkt.' }
  #       format.json { render :show, status: :ok, location: @response }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @response.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /responses/1
  # # DELETE /responses/1.json
  # def destroy
  #   @response.destroy
  #   respond_to do |format|
  #     format.html { redirect_to responses_url, notice: 'Response is verwijderd.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Response.find(params[:id])
    end

    def set_itembank
      # @itembank = Itembank.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def response_params
      params.require(:response).permit(:participant_id, :item_id, :item_serialized, :value)
    end
end
