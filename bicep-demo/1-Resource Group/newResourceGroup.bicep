targetScope = 'subscription'

resource newRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-westeu-demo'
  location: 'westeurope'
}
