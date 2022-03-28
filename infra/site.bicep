param name string
param location string
param serverfarm string
param appSettings array

resource rubidosite 'Microsoft.Web/sites@2021-03-01' = {
  name: name 
  location: location
  properties: {
    serverFarmId: serverfarm
    siteConfig: {
      appSettings: appSettings 
    }    
  }
}
