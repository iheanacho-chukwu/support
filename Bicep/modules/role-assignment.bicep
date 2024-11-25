targetScope = 'resourceGroup'

param vmManagedIdentityPrincipalId string

resource ownerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
}

resource roleAssignmentOwner 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: resourceGroup()
  name: guid(resourceGroup().name, vmManagedIdentityPrincipalId, ownerRoleDefinition.id)
  properties: {
    roleDefinitionId: ownerRoleDefinition.id
    principalId: vmManagedIdentityPrincipalId
  }
}
