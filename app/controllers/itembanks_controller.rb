class ItembanksController < ApplicationController
  before_action :set_itembank, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  # GET /itembanks
  # GET /itembanks.json
  def index
    @itembanks = Itembank.all
  end

  # GET /itembanks/1
  # GET /itembanks/1.json
  def show
  end

  # GET /itembanks/new
  def new
    @itembank = Itembank.new
  end

  # GET /itembanks/1/edit
  def edit
  end

  # POST /itembanks
  # POST /itembanks.json
  def create
    @itembank = Itembank.new(itembank_params)

    respond_to do |format|
      if @itembank.save
        format.html { redirect_to @itembank, notice: 'Itembank was successfully created.' }
        format.json { render :show, status: :created, location: @itembank }
      else
        format.html { render :new }
        format.json { render json: @itembank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /itembanks/1
  # PATCH/PUT /itembanks/1.json
  def update
    respond_to do |format|
      if @itembank.update(itembank_params)
        format.html { redirect_to @itembank, notice: 'Itembank was successfully updated.' }
        format.json { render :show, status: :ok, location: @itembank }
      else
        format.html { render :edit }
        format.json { render json: @itembank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /itembanks/1
  # DELETE /itembanks/1.json
  def destroy
    @itembank.destroy
    respond_to do |format|
      format.html { redirect_to itembanks_url, notice: 'Itembank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_itembank
      @itembank = Itembank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def itembank_params
      params.require(:itembank).permit(:name, :source)
    end
end
