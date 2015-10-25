module Envirotech
  class RelationalData
    def import
      new_data_process
    end

    private

    def new_data_process
      # relations = {issue: {regulation: [solutions]}}

      relations.keys.each do |issue_name|
        issue = get_updatable_document(q: issue_name, index_name: 'issues')

        relations[issue_name].keys.each do |regulation_name|
          regulation = get_updatable_document(q: regulation_name, index_name: 'regulations')

          issue[:regulation_ids].uniq_push!(regulation[:source_id])
          regulation[:issue_ids].uniq_push!(issue[:source_id])

          relations[issue_name][regulation_name].each do |solution_name|
            solution = get_updatable_document(q: solution_name, index_name: 'solutions')

            issue[:solution_ids].uniq_push!(solution[:source_id])
            regulation[:solution_ids].uniq_push!(solution[:source_id])

            solution[:regulation_ids].uniq_push!(regulation[:source_id])
            solution[:issue_ids].uniq_push!(issue[:source_id])

            Envirotech::Solution.update([solution])
          end
          Envirotech::Regulation.update([regulation])
        end
        Envirotech::Issue.update([issue])
      end
    end

    def get_updatable_document(q: '', index_name: '')
      hit = Envirotech::Consolidated.search_for(sources: index_name, q: q)[:hits].first
      hit[:_source][:id] = hit[:_id]
      hit[:_source]
    end

    def relations
      @relations ||= Envirotech::ToolkitData.fetch_relational_data
    end
  end
end
