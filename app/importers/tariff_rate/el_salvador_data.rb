module TariffRate
  class ElSalvadorData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_El_Salvador_Data.csv'
  end
end
