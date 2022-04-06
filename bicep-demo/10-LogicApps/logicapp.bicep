param parLogicAppName string = 'demo-d-la001'
param parApiConnName string = 'demo-d-la-apiconn-sta'
param parLocation string = 'westeurope'
param parStorageAccountName string = 'demodsta001'

var varSubscriptionId = '${subscription().subscriptionId}'
var varResourceGroupName = '${resourceGroup().name}'
var varStorageConnectionString = '/subscriptions/${varSubscriptionId}/resourceGroups/${varResourceGroupName}/providers/Microsoft.Web/connections/${parApiConnName}'

resource storage 'Microsoft.Storage/storageAccounts@2021-08-01' existing = {
  name: parStorageAccountName
}
resource resAPiConnectionStorage 'Microsoft.Web/connections@2016-06-01' = {
  name: parApiConnName
  location: parLocation
  properties: {
    displayName: 'boomtsa'
    parameterValues: {
      accountName: storage.name
      accessKey: listKeys(storage.id, storage.apiVersion).keys[0].value
    }
    api: {
      name: 'azureblob'
      displayName: 'Azure Blob Storage'
      id: '/subscriptions/${varSubscriptionId}/providers/Microsoft.Web/locations/${parLocation}/managedApis/azureblob'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://management.azure.com:443/subscriptions/${varSubscriptionId}/resourceGroups/${varResourceGroupName}/providers/Microsoft.Web/connections/${parApiConnName}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}

resource resLaStorage 'Microsoft.Logic/workflows@2019-05-01' = {
  name: parLogicAppName
  dependsOn: [
    resAPiConnectionStorage
  ]
  location: parLocation
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        Recurrence: {
          recurrence: {
            frequency: 'Minute'
            interval: 3
          }
          evaluatedRecurrence: {
            frequency: 'Minute'
            interval: 3
          }
          type: 'Recurrence'
        }
      }
      actions: {
        'Lists_blobs_(V2)': {
          runAfter: {}
          metadata: {
            'JTJmY291cnNlcw==': '/courses'
          }
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azureblob\'][\'connectionId\']'
              }
            }
            method: 'get'
            path: '/v2/datasets/@{encodeURIComponent(encodeURIComponent(\'AccountNameFromSettings\'))}/foldersV2/@{encodeURIComponent(encodeURIComponent(\'JTJmY291cnNlcw==\'))}'
            queries: {
              nextPageMarker: ''
              useFlatListing: false
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {
    '$connections': {
      value: {
        azureblob: {
          connectionId: varStorageConnectionString
          connectionName: parApiConnName
          id: '/subscriptions/${varSubscriptionId}/providers/Microsoft.Web/locations/${parLocation}/managedApis/azureblob'
        }
      }
    }
  }
  }
}
