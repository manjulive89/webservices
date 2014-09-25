json.partial! 'api/v1/screening_lists/addresses',
              addresses: entry[:_source][:addresses]
json.call(entry[:_source],
          :alt_names,
          :citizenships,
          :dates_of_birth,
          :entity_number,
          :ids,
          :name,
          :nationalities,
          :nsp_type,
          :places_of_birth,
          :programs,
          :remarks,
          :source,
          :source_list_url,
          :title,
)
