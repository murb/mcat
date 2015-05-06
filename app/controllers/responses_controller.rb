class ResponsesController < ApplicationController
  before_action :set_response, only: [:show, :edit, :update, :destroy]
  before_action :set_itembank, only: [:create, :new]

  # GET /responses
  # GET /responses.json
  def index
    @responses = Response
    if params["participant_hashes"]
      puts "AAA"
      @responses = @responses.filter_by_participant_hashes(params["participant_hashes"].split(","))
    end
    @responses = @responses.all
  end

  # GET /responses/1
  # GET /responses/1.json
  def show
  end

  # GET /responses/new
  def new
    @prev_eval_results = @itembank.evaluate(current_participant.responses,[1,1,1])
    @item = @prev_eval_results[:next_item]
    if params[:item_id]
      @item = Item.find(params[:item_id])
    end

    @response = Response.new(item_id: @item.id)
  end

  # GET /responses/1/edit
  def edit
  end

  # POST /responses
  # POST /responses.json
  def create
    @response = Response.new(response_params)
    @response.participant = current_participant
    respond_to do |format|
      if @response.save
        # @item = @response.item
        eval_results = @itembank.evaluate(current_participant.responses,[1,1,1])
        format.html { redirect_to new_response_path({item_id:eval_results[:next_item].id, eval_results:eval_results}), notice: 'Response was successfully created.' }
        format.json { render :show, status: :created, location: @response }
      else
        format.html { render :new }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responses/1
  # PATCH/PUT /responses/1.json
  def update
    respond_to do |format|
      if @response.update(response_params)
        format.html { redirect_to @response, notice: 'Response was successfully updated.' }
        format.json { render :show, status: :ok, location: @response }
      else
        format.html { render :edit }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.destroy
    respond_to do |format|
      format.html { redirect_to responses_url, notice: 'Response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Response.find(params[:id])
    end

    def set_itembank
      @itembank = Itembank.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def response_params
      params.require(:response).permit(:participant_id, :item_id, :item_serialized, :value)
    end
end
