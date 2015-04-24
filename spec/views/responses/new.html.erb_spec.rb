require 'rails_helper'

RSpec.describe "responses/new", type: :view do
  before(:each) do
    assign(:response, Response.new(
      :participant_id => 1,
      :item_id => 1,
      :item_serialized => "MyText",
      :value => 1
    ))
  end

  it "renders new response form" do
    render

    assert_select "form[action=?][method=?]", responses_path, "post" do

      assert_select "input#response_participant_id[name=?]", "response[participant_id]"

      assert_select "input#response_item_id[name=?]", "response[item_id]"

      assert_select "textarea#response_item_serialized[name=?]", "response[item_serialized]"

      assert_select "input#response_value[name=?]", "response[value]"
    end
  end
end
