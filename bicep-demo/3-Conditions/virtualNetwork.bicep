param virtualNetworkName string = 'vnet-hub-weu-001'
param subnetName string = 'vnet-hub-weu-subnet001'

resource resVirtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = if (!empty(virtualNetworkName)) {
  name: virtualNetworkName
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        // Conditional expression
        name: !empty(subnetName) ? subnetName : 'myFalseConditionName'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}
