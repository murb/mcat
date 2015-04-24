require "rails_helper"

RSpec.describe ItembanksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/itembanks").to route_to("itembanks#index")
    end

    it "routes to #new" do
      expect(:get => "/itembanks/new").to route_to("itembanks#new")
    end

    it "routes to #show" do
      expect(:get => "/itembanks/1").to route_to("itembanks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/itembanks/1/edit").to route_to("itembanks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/itembanks").to route_to("itembanks#create")
    end

    it "routes to #update" do
      expect(:put => "/itembanks/1").to route_to("itembanks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/itembanks/1").to route_to("itembanks#destroy", :id => "1")
    end

  end
end
