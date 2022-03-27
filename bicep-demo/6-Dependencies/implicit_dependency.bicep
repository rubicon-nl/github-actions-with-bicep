// Implicit dependency
resource nsg 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'vm-euw-nsg001'
  location: resourceGroup().location
}

resource nsgRule 'Microsoft.Network/networkSecurityGroups/securityRules@2019-11-01' = {
  name: '${nsg}/AllowAllRule'
  properties: {
    description: 'Allow all'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
  }
}
