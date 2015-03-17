module ScreeningList
  class Part561Data
    include ::Importer
    include ScreeningList::TreasuryListImporter
    self.default_endpoint =
      'http://www.treasury.gov/ofac/downloads/consolidated/consolidated.xml'
    self.source_information_url =
      'http://www.treasury.gov/resource-center/sanctions/programs/pages/iran.aspx#part561'
    self.program_id = '561List'
  end
end
