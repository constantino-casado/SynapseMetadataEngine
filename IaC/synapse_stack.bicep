param prefix string = 'etlframework'
param location string = 'westeurope'

//  The stack is within a Res Group and composed of a Storage Account with a Hierarchical Namespace. 
//  + KeyVault + Synapse Workspace
//
var resgroupname = '${prefix}-rg'
var saname = '${prefix}-sa'


module myModule 'resgroup.bicep' = {
  name: 'myModule'
  params: {
    resgroupname: resgroupname
    location: location
  }
  // deploy this module at the subscription scope
  scope: subscription()
}


// modules deployed to resource group
targetScope = resourceGroup(resgroupname)

resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: saname // must be globally unique
  location: location
  kind: 'Storage'
  sku: {
    name: 'Standard_LRS'
  }
}

resource symbolicname 'Microsoft.Synapse/workspaces@2021-03-01' = {
  name: 'string'
  tags: {}
  location: 'string'
  properties: {
    defaultDataLakeStorage: {
      accountUrl: 'string'
      filesystem: 'string'
    }
    sqlAdministratorLoginPassword: 'string'
    managedResourceGroupName: 'string'
    sqlAdministratorLogin: 'string'
    virtualNetworkProfile: {
      computeSubnetId: 'string'
    }
    connectivityEndpoints: {}
    managedVirtualNetwork: 'string'
    privateEndpointConnections: [
      {
        properties: {
          privateEndpoint: {}
          privateLinkServiceConnectionState: {
            status: 'string'
            description: 'string'
          }
        }
      }
    ]
    encryption: {
      cmk: {
        key: {
          name: 'string'
          keyVaultUrl: 'string'
        }
      }
    }
    managedVirtualNetworkSettings: {
      preventDataExfiltration: bool
      linkedAccessCheckOnTargetResource: bool
      allowedAadTenantIdsForLinking: [
        'string'
      ]
    }
    workspaceRepositoryConfiguration: {
      type: 'string'
      hostName: 'string'
      accountName: 'string'
      projectName: 'string'
      repositoryName: 'string'
      collaborationBranch: 'string'
      rootFolder: 'string'
      lastCommitId: 'string'
      tenantId: 'string'
    }
    purviewConfiguration: {
      purviewResourceId: 'string'
    }
    networkSettings: {
      publicNetworkAccess: 'string'
    }
  }
  identity: {
    type: 'string'
  }
}
