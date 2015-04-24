require 'rails_helper'

RSpec.describe "itembanks/edit", type: :view do
  before(:each) do
    @itembank = assign(:itembank, Itembank.create!(
      :name => "MyString",
      :source => "MyString"
    ))
  end

  it "renders the edit itembank form" do
    render

    assert_select "form[action=?][method=?]", itembank_path(@itembank), "post" do

      assert_select "input#itembank_name[name=?]", "itembank[name]"

      assert_select "input#itembank_source[name=?]", "itembank[source]"
    end
  end
end
