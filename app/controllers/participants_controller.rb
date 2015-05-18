class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_or_examinator!, only: [:index, :destroy, :edit, :update]


  # GET /participants
  # GET /participants.json
  def index
    @participants = Participant
    if current_admin
      @participants = @participants.all
    elsif current_examinator
      @participants = @participants.for_examinator(current_examinator)
    else
      @participants = []
    end
  end

  # GET /participants/1
  # GET /participants/1.json
  def show
  end

  # GET /participants/new
  def new
    session.destroy
    invite_hash = params[:invite_hash].to_s
    @participant = Participant.new(session: session.id, invite_hash: invite_hash)
  end

  # GET /participants/1/edit
  def edit
  end

  # POST /participants
  # POST /participants.json
  def create
    @participant = Participant.new(participant_params.merge({session: session.id, itembank_id: Itembank.first.id}))


    respond_to do |format|
      if @participant.save
        format.html { redirect_to new_test_path, notice: 'Participant was successfully created.' }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { render :new }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participants/1
  # PATCH/PUT /participants/1.json
  def update
    respond_to do |format|
      if @participant.update(participant_params)
        format.html { redirect_to @participant, notice: 'Participant was successfully updated.' }
        format.json { render :show, status: :ok, location: @participant }
      else
        format.html { render :edit }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1
  # DELETE /participants/1.json
  def destroy
    @participant.destroy
    respond_to do |format|
      format.html { redirect_to participants_url, notice: 'Participant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_participant
      @participant = Participant.find_by_participant_hash(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def participant_params
      params.require(:participant).permit(:session, :invite_hash, :participant_hash, :age, :gender)
    end

    def require_admin_or_examinator!
      redirect_to root_path, notice: "U dient ingelogd te zijn als administrator of examinator van deze deelnemer." unless (current_admin or (current_examinator and (@participant.examinator == current_examinator or @participant.examinator.nil?)))
    end

end
