json.array!(@invites) do |invite|
  json.extract! invite, :id, :hash, :comments, :examinator_id, :participant_id
  json.url invite_url(invite, format: :json)
end
