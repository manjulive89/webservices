json.(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.partial! "api/v1/screening_lists/#{entry[:_source][:source].downcase}/entry", entry: entry
  end
end