require 'rails_helper'

RSpec.describe "itembanks/show", type: :view do
  before(:each) do
    @itembank = assign(:itembank, Itembank.create!(
      :name => "Name",
      :source => "Source"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Source/)
  end
end
