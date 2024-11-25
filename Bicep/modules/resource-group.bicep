targetScope='subscription'

param resourceGroup object = {}
param tags object

resource resourceGroupResource 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroup.name
  location: resourceGroup.location
  tags: tags
}
