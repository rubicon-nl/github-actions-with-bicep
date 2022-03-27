// var <varable-name> = <variable-value>

var storageAccountName = concat('sa', uniqueString(resourceGroup().id), '001')

var storageAccountObject = {
  location: 'westeurope'
  kind: 'Storage'
  sku: 'Standard_LRS'
}

resource resSA 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: storageAccountObject.location
  kind: storageAccountObject.kind
  sku: {
    name: storageAccountObject.sku
  }
}


