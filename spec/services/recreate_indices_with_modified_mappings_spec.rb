require 'spec_helper'

shared_context 'with an adjusted MarketResearch.mappings' do
  let(:model) { MarketResearch }
  before do
    @original_mappings = model.mappings.deep_dup
    model.mappings[model.index_type][:properties][:description][:analyzer] = 'keyword'
  end
  after do
    model.mappings = @original_mappings
    model.recreate_index
  end
end

describe RecreateIndicesWithModifiedMappings do

  before(:all) { Webservices::Application.model_classes.each(&:recreate_index) }

  describe '.call' do
    include_context 'with an adjusted MarketResearch.mappings'

    it 'recreates and imports necessary indices' do
      expect(described_class.model_classes_which_need_recreating).to eq([model])
      expect_any_instance_of(model.importer_class).to receive(:import_and_if_possible_purge_old)
      described_class.call
      expect(described_class.model_classes_which_need_recreating).to be_empty
    end
  end

  describe '.model_classes_which_need_recreating' do
    subject { described_class.model_classes_which_need_recreating }

    context 'when all model mappings are the same as DB' do
      it { is_expected.to be_empty }
    end

    context 'when MarketResearch mappings are different from DB' do
      include_context 'with an adjusted MarketResearch.mappings'
      it { is_expected.to eq([model]) }
    end

    context 'when ScreeningList::Sdn DB mappings have extra fields' do
      let(:model) { ScreeningList::Sdn }
      let(:type) { model.index_type }
      let(:index) { model.index_name }
      let(:field) { 'foo' }
      let(:mappings) { { type: 'string' } }

      before do
        new_mappings = model.mappings.deep_dup
        new_mappings[type][:properties][field] = mappings
        ES.client.indices.put_mapping(index: index, type: type, body: new_mappings)
      end
      after { model.recreate_index }

      it "does not consider ScreeningList::Sdn's index to need recreating" do
        # Field mappings found in the DB but not in the model are assumed to
        # be "dynamic mappings" added by ES in the absence of any given by us.
        db_mappings = ES.client.indices.get_field_mapping(index: index, field: field)
        expect(db_mappings[index]['mappings'].keys.count).to be > 0  # i.e. the mapping we added is present

        expect(subject).to be_empty
      end
    end
  end

end
