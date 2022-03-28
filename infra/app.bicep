var sharedVariables = json(loadTextContent('../variables.json'))  

resource rubidoasp 'Microsoft.Web/serverfarms@2021-03-01' existing = {
  name: sharedVariables.appServicePlan.name
}

resource appconfig 'Microsoft.AppConfiguration/configurationStores@2021-10-01-preview' existing = {
  name: sharedVariables.appConfig.name
}

// linked template equivalent
module website 'site.bicep' = [for site in sharedVariables.appServicePlan.sites: {
  name: site.name
  params: {
    name: site.name
    location: sharedVariables.location
    appSettings: site.isHost ? site.settings : union(site.settings, array({
      name: 'appconfig' 
      value: appconfig.listKeys().value[0].connectionString // demo example, not for production
    }), array(json('{ "name": "inline", "value": "example" }')))
    serverfarm: rubidoasp.id
  }
}]

resource hub 'Microsoft.SignalRService/webPubSub/hubs@2021-10-01' = [for chatroom in sharedVariables.appServicePlan.chatrooms: {
  name: format('{0}/{1}', sharedVariables.webPubSub.name, chatroom)
  properties: {
    anonymousConnectPolicy: 'allow'
   }
}]

