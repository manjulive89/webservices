class Api::V1::ParatureFaqController < ApiController
  include Searchable
  search_by :question, :answer, :update_date_start, :update_date_end, :countries, :industries, :q, :topics
end
