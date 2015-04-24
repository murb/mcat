require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe ParticipantsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Participant. As you add validations to Participant, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ParticipantsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all participants as @participants" do
      participant = Participant.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:participants)).to eq([participant])
    end
  end

  describe "GET #show" do
    it "assigns the requested participant as @participant" do
      participant = Participant.create! valid_attributes
      get :show, {:id => participant.to_param}, valid_session
      expect(assigns(:participant)).to eq(participant)
    end
  end

  describe "GET #new" do
    it "assigns a new participant as @participant" do
      get :new, {}, valid_session
      expect(assigns(:participant)).to be_a_new(Participant)
    end
  end

  describe "GET #edit" do
    it "assigns the requested participant as @participant" do
      participant = Participant.create! valid_attributes
      get :edit, {:id => participant.to_param}, valid_session
      expect(assigns(:participant)).to eq(participant)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Participant" do
        expect {
          post :create, {:participant => valid_attributes}, valid_session
        }.to change(Participant, :count).by(1)
      end

      it "assigns a newly created participant as @participant" do
        post :create, {:participant => valid_attributes}, valid_session
        expect(assigns(:participant)).to be_a(Participant)
        expect(assigns(:participant)).to be_persisted
      end

      it "redirects to the created participant" do
        post :create, {:participant => valid_attributes}, valid_session
        expect(response).to redirect_to(Participant.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved participant as @participant" do
        post :create, {:participant => invalid_attributes}, valid_session
        expect(assigns(:participant)).to be_a_new(Participant)
      end

      it "re-renders the 'new' template" do
        post :create, {:participant => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested participant" do
        participant = Participant.create! valid_attributes
        put :update, {:id => participant.to_param, :participant => new_attributes}, valid_session
        participant.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested participant as @participant" do
        participant = Participant.create! valid_attributes
        put :update, {:id => participant.to_param, :participant => valid_attributes}, valid_session
        expect(assigns(:participant)).to eq(participant)
      end

      it "redirects to the participant" do
        participant = Participant.create! valid_attributes
        put :update, {:id => participant.to_param, :participant => valid_attributes}, valid_session
        expect(response).to redirect_to(participant)
      end
    end

    context "with invalid params" do
      it "assigns the participant as @participant" do
        participant = Participant.create! valid_attributes
        put :update, {:id => participant.to_param, :participant => invalid_attributes}, valid_session
        expect(assigns(:participant)).to eq(participant)
      end

      it "re-renders the 'edit' template" do
        participant = Participant.create! valid_attributes
        put :update, {:id => participant.to_param, :participant => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested participant" do
      participant = Participant.create! valid_attributes
      expect {
        delete :destroy, {:id => participant.to_param}, valid_session
      }.to change(Participant, :count).by(-1)
    end

    it "redirects to the participants list" do
      participant = Participant.create! valid_attributes
      delete :destroy, {:id => participant.to_param}, valid_session
      expect(response).to redirect_to(participants_url)
    end
  end

end
