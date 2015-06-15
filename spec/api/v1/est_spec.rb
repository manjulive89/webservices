require 'spec_helper'

describe 'Est API V1', type: :request do
  before(:each) do
    fixtures_file =  "#{Rails.root}/spec/fixtures/est_articles/est_articles.json"
    Est.recreate_index
    allow_any_instance_of(EstData).to receive(:fetch_data).and_return(File.open(fixtures_file).read)
    EstData.new(fixtures_file).import
  end

  describe 'GET /ests/search.json' do
    context 'when search parameters are empty' do
      let(:all_results) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/est/all_results.json").read }
      before { get '/ests/search', {} }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns all results' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(2)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to match_array(all_results)
      end
    end
  end

  describe 'GET /ests/search.json' do
    context 'when one document matches a query and filter' do
      let(:one_match) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/est/one_match.json").read }
      let(:params) { { q: 'Precipitadores' } }
      before { get '/ests/search', params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns the only result matching the query and filter' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results.first).to eq(one_match.first)
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end
  end
end
