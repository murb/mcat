require 'rails_helper'

RSpec.describe "responses/edit", type: :view do
  before(:each) do
    @response = assign(:response, Response.create!(
      :participant_id => 1,
      :item_id => 1,
      :item_serialized => "MyText",
      :value => 1
    ))
  end

  it "renders the edit response form" do
    render

    assert_select "form[action=?][method=?]", response_path(@response), "post" do

      assert_select "input#response_participant_id[name=?]", "response[participant_id]"

      assert_select "input#response_item_id[name=?]", "response[item_id]"

      assert_select "textarea#response_item_serialized[name=?]", "response[item_serialized]"

      assert_select "input#response_value[name=?]", "response[value]"
    end
  end
end
