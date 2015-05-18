require 'rails_helper'

RSpec.describe "invites/show", type: :view do
  before(:each) do
    @invite = assign(:invite, Invite.create!(
      :hash => "Hash",
      :comments => "MyText",
      :examinator_id => 1,
      :participant_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Hash/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
