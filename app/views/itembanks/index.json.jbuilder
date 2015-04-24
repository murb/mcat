json.array!(@itembanks) do |itembank|
  json.extract! itembank, :id, :name, :source
  json.url itembank_url(itembank, format: :json)
end
