class SalesforceArticle::MarketInsightData
  include Importable
  include VersionableResource
  include SalesforceArticle::Importer

  self.source = 'MARKET_INSIGHT'

  self.query_string = <<-SOQL
    SELECT Id,
           Atom__c,
           Chapter__c,
           FirstPublishedDate,
           LastPublishedDate,
           Public_URL__c,
           References__c,
           Section__c,
           Summary,
           Title,
           UrlName,
           (SELECT Id, DataCategoryName, DataCategoryGroupName FROM DataCategorySelections)
    FROM Market_Insight__kav
    WHERE PublishStatus = 'Online'
    AND Language = 'en_US'
    AND IsLatestVersion=true
    AND IsVisibleInPkb=true
  SOQL
end
