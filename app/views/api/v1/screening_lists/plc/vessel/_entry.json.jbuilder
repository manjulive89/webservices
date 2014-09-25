json.partial! 'api/v1/screening_lists/addresses',
              addresses: entry[:_source][:addresses]
json.call(entry[:_source],
          :alt_names,
          :call_sign,
          :entity_number,
          :gross_registered_tonnage,
          :gross_tonnage,
          :ids,
          :name,
          :nsp_type,
          :programs,
          :remarks,
          :source,
          :source_list_url,
          :title,
          :vessel_flag,
          :vessel_owner,
          :vessel_type,
)
