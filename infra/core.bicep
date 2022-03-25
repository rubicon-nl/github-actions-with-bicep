resource appService 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'hosting'
  location: location
  properties: {
    reserved:true    
  }
  kind: 'linux'
  sku: {
    name: 'B2'
  }
}
