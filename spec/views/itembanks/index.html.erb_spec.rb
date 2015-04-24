require 'rails_helper'

RSpec.describe "itembanks/index", type: :view do
  before(:each) do
    assign(:itembanks, [
      Itembank.create!(
        :name => "Name",
        :source => "Source"
      ),
      Itembank.create!(
        :name => "Name",
        :source => "Source"
      )
    ])
  end

  it "renders a list of itembanks" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Source".to_s, :count => 2
  end
end
