module TariffRate
  class PanamaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Panama_Data.csv'
  end
end
