class InvitesController < ApplicationController
  before_action :set_invite, only: [:show, :edit, :update, :destroy]
  before_action :own_invite_only, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_or_examinator!

  # GET /invites
  # GET /invites.json
  def index
    if current_examinator
      @invites = Invite.by_examinator(current_examinator)
    elsif current_admin
      @invites = Invite.all
    else
      @invites = []
    end

    respond_to do |format|
      format.xlsx {
        w = @invites.to_workbook
        send_data  w.stream_xlsx, :filename => "responses #{Time.now}.xlsx"
      }
      format.html {}
    end
  end

  # GET /invites/1
  # GET /invites/1.json
  def show

  end

  # GET /invites/new
  def new
    @invite = Invite.new
  end

  # GET /invites/1/edit
  def edit
  end

  # POST /invites
  # POST /invites.json
  def create
    myparams = invite_params
    myparams[:examinator_id] = current_examinator.id if current_examinator
    @invite = Invite.new(myparams)


    respond_to do |format|
      if @invite.save
        format.html { redirect_to @invite, notice: 'De uitnodiging is aangemaakt.' }
        format.json { render :show, status: :created, location: @invite }
      else
        format.html { render :new }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invites/1
  # PATCH/PUT /invites/1.json
  def update
    respond_to do |format|
      if @invite.update(invite_params)
        format.html { redirect_to @invite, notice: 'De uitnodiging is bijgewerkt.' }
        format.json { render :show, status: :ok, location: @invite }
      else
        format.html { render :edit }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invites/1
  # DELETE /invites/1.json
  def destroy
    @invite.destroy
    respond_to do |format|
      format.html { redirect_to invites_url, notice: 'De uitnodiging is verwijderd.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      @invite = Invite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invite_params
      params.require(:invite).permit(:comments, :code)
    end

    def own_invite_only
      @invite.examinator == current_examinator or current_admin
    end
end
