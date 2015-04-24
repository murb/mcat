json.array!(@responses) do |response|
  json.extract! response, :id, :participant_id, :item_id, :item_serialized, :value
  json.url response_url(response, format: :json)
end
