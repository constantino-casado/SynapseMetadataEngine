# Introduction 
This Repository contains the baseline code for Azure Synapse Analytics that is needed to deploy the Medatada engine to a 
Synapse Analytics Workspace and a Synapse Analytics Dedicated SQL Pool.


# Requirements
A Github or Azure DevOPS account,
An active Azure subscription with sufficient access to create:

1.	Azure Key Vault
2.	Azure Storage Account
3.	Azure Synapse Analytics Workspace
4.	Azure Synapse Analytics Dedicated Pool

Visual Studio 2019 Comunity Edition or Later

# Getting Started:

Before you begin Clone this Reposi into a brand new Github or Azure DevOPS repository,
once this is done create the Azure Key Vault and the Azure Synapse Analytics Workspace.

When this is done please make sure that the Synapse Analytics Managed Identity has Get access to Secrets ,keys and certificates,
then open the synapse workspace and connect it to the Git repository,
NB! make sure that you set the root path to "/SynapseWorkspace/".


# Initial asset setup

Now that the baseline components are in place you need to make sure that the Linked services are configured correctly so that you can publish
the workspace components, this must be done in the following steps:

Step 1: Disable the Keyvault usage in the SQLServer Dataset by:

        a) Open the Synapse Studio, 
        b) Click the Manage Blade, 
        c) Edit the "SQLServer" linked service,
        d) Disable the use of Key vault for password by clicking the password button.
        e) Type in any random text in the password field.
        f) Click Apply

Step 2: Resolve the Synapse Pool data sets by:

        a) Open the Integrate Blade.
        b) Click "Validate All"
        c) Follow the instructions and resolve the two detected issues.
        d) click the Publish button.

Step 3: Enable the Keyvault usage in the SQLServer Dataset by:

        a) Open the Synapse Studio, 
        b) Click the Manage Blade, 
        c) Edit the "SQLServer" linked service,
        d) Enable the use of Key vault for password by clicking the Key Vault button in the password section.
        e) Open the Dynamic content section for the key vault secret and paste in @linkedService().kvsecretname.
        f) Click Apply
        g) Click Apply
        h) click the Publish button.

# Deploy the SQL Server project

Using Vusual Studio open the "mesqldw.sln" in the SynapseSQLFolder of this repository.

Deploy the Database project to your Synapse Dedicated Pool by following the following documentation:
https://docs.microsoft.com/en-us/aspnet/web-forms/overview/deployment/web-deployment-in-the-enterprise/deploying-database-projects



# Create the baseline ADLS Filesystem containers

Before we configure any of the globals we need to ensure that the baseline Storage container filesystems exist on the ADLS storage account used for ingesting metadata etc.

By default the system is developed to use two primary file system containers.

1: "raw" this is hardcoded in the priming scripts, but this can be changed after by altering the ME_Config.Dataset table and setting the [TargetLake] attribute.
2: "metadata" this container is also hardcoded in the integration pipe lines, and in order to change this there is a mix of things to do that will not be covered by this Read Me.

Create the two filesystems named above using Azure Storage Explorer or any other supported way, 
here is the manual for Azure Storage Explorer: https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-explorer



# Setup the Globals using the ME_Config.sp_AlterGlobals Procedure

The metadata engine is based on a set of configurations, in order for any of the pipelines to function in the baseline code we need to know two things:

The 1st is the name of our storage account, this is being used in almost all pipelines and in some of the dynamic SQL in the system,
the 2nd is the name of the stage schema that is used by the Dedicated SQL Pool to stage the data in the Data Warehouse component.

These two global attributes are stored in the [ME_Config].[GLOBALS] table and need to be initially primed by executing the [ME_Config].[sp_AlterGlobals] stored procedure passing in two variables @STORAGE_ACCOUNT and @STAGE_SCHEMA,
when this is done the stored procedure will:

        1 - Truncate the [ME_Config].[GLOBALS] table
        2 - Insert the new attributes
        3 - Attempt to create the Stage Schema if needed
        
  


# Configure your 1st Connection and execute the discovery pipelined

In order to ingest data from a source we need to define its connection, 
in this Read me file we will discuss how to connect to a Microsoft SQL database using SQL Server Authentication (MSSQL).

The MSSQL part of this engine relies on storing passwords in an Azure Key Vault, and it makes the assumption that the username is the name of the Key Vault secret,
Before you populate the [ME_Config].[Connection] table it is important that the password has been stored in the Key Vault and named in exact case as the username deployed on the source MSSQL server, for more information about Azure Key Vault please click here: https://docs.microsoft.com/en-us/azure/key-vault/general/

Provided that the MSSQL password has been stored in the Azure Key Vault you can now populate the [ME_Config].[Connection],

The table contains four attributes they are: 

        [ConnectionType], this defines the source connection IE: MSSQL for Microsoft SQL Server database with SQL Server authentication, PLSSQL for oracle. 
        [ConnectionName], this is in the MSSQL server case the name of the Database to connect to,
        [ConnectionString] This is the fqdn of the SQL Server
        and [ConnectionKVSecret] this is the username that will be used to access the SQL Server and the name of the secret in the leyvault that stores its password.
        
 
Once this has been populated trigger the "PrimeDynamicSQLDBtoRAWMetadata" pipeline.
 
This process will configure the ME_Config.Dataset table and you are now in a position to start running the metadata engine.






# Collaborate on this project

If you want to contribute on this project please reachout to me on twitter @andreasbersgtedt
or on LinkedIn: HTTPS://linkedin.com/in/andreas-bergstedt-27411910