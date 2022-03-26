param location string = 'westeurope'

resource appService 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'rubi-do-asp'
  location: location
  properties: {
    reserved:true    
  }
  kind: 'linux'
  sku: {
    name: 'B2'
  }
}

resource pubsub 'Microsoft.SignalRService/webPubSub@2021-10-01' = {
  name: 'rubi-do-pubsub'
  location: location
  properties: {
  }
  sku: {
    name: 'Free_F1'
  }
}
 
resource appConfig 'Microsoft.AppConfiguration/configurationStores@2021-10-01-preview' = {
  name: 'rubi-do-appconfig'
  location: location
  sku: {
    name: 'standard'
  }
}
