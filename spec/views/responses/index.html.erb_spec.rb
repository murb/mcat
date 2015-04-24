require 'rails_helper'

RSpec.describe "responses/index", type: :view do
  before(:each) do
    assign(:responses, [
      Response.create!(
        :participant_id => 1,
        :item_id => 2,
        :item_serialized => "MyText",
        :value => 3
      ),
      Response.create!(
        :participant_id => 1,
        :item_id => 2,
        :item_serialized => "MyText",
        :value => 3
      )
    ])
  end

  it "renders a list of responses" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
