require 'rails_helper'

RSpec.describe "participants/show", type: :view do
  before(:each) do
    @participant = assign(:participant, Participant.create!(
      :session => "Session",
      :invite_hash => "Invite Hash",
      :participant_hash => "Participant Hash",
      :age => 1,
      :gender => "Gender"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Session/)
    expect(rendered).to match(/Invite Hash/)
    expect(rendered).to match(/Participant Hash/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Gender/)
  end
end
