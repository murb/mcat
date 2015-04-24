json.array!(@participants) do |participant|
  json.extract! participant, :id, :session, :invite_hash, :participant_hash, :age, :gender
  json.url participant_url(participant, format: :json)
end
