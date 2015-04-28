require 'rails_helper'

RSpec.describe TestController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #item" do
    it "returns http success" do
      get :item
      expect(response).to have_http_status(:success)
    end
  end

end
