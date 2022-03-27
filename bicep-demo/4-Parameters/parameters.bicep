// decorators
@description('Location input')
@allowed([
  'westeurope'
  'northeurope'
])
param location string

@secure()
param password string

@minLength(4)
@maxLength(10)
param userName string
