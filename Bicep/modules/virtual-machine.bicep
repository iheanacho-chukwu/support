param vm object
param location string
param tags object = {}
param subnetId string
param networkSecurityGroupId string

resource publicIPAddressResource 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: '${vm.name}-pip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    idleTimeoutInMinutes: 4
  }
}

resource networkInterfaceResource 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: '${vm.name}-nic'
  tags: tags
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddressResource.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroupId
    }
  }
}

resource virtualMachineResource 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vm.name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vm.size
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: vm.imageReference
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceResource.id
        }
      ]
    }
    osProfile: {
      computerName: vm.name
      adminUsername: vm.adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${vm.adminUsername}/.ssh/authorized_keys'
              keyData: vm.sshPublicKey
            }
          ]
        }
      }
    }
  }
}

output vmManagedIdentityPrincipalId string = virtualMachineResource.identity.principalId
