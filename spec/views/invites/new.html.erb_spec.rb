require 'rails_helper'

RSpec.describe "invites/new", type: :view do
  before(:each) do
    assign(:invite, Invite.new(
      :hash => "MyString",
      :comments => "MyText",
      :examinator_id => 1,
      :participant_id => 1
    ))
  end

  it "renders new invite form" do
    render

    assert_select "form[action=?][method=?]", invites_path, "post" do

      assert_select "input#invite_hash[name=?]", "invite[hash]"

      assert_select "textarea#invite_comments[name=?]", "invite[comments]"

      assert_select "input#invite_examinator_id[name=?]", "invite[examinator_id]"

      assert_select "input#invite_participant_id[name=?]", "invite[participant_id]"
    end
  end
end
