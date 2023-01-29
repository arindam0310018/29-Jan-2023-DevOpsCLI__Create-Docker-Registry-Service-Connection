# CREATE DOCKER REGISRY SERVICE CONNECTION USING DEVOPS CLI:-

Greetings to my fellow Technology Advocates and Specialists.

In this Session, I will demonstrate __How to Create Docker Registry Service Connection Using DevOps CLI.__

| __USE CASES:-__ |
| --------- |
| Create Docker Registry DevOps Service Connection, __Prompting PAT__ (Personal Access Token) |
| Create Docker Registry DevOps Service Connection, __Without Prompting PAT__ (Personal Access Token) |

| __REQUIREMENTS:-__ |
| --------- |

1. Azure Subscription.
2. Azure Container Registry with "Admin" User Enabled.
3. Azure DevOps Organisation and Project.
4. Azure DevOps Project ID.
5. Full Access PAT (Personal Access Token).

| __AZURE CONTAINER REGISTRY DETAILS:-__ |
| --------- |
| ![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5thc71xbmd2gor3xxlt7.jpg) |

| BELOW FOLLOWS THE CODE SNIPPET:- | 
| --------- |

| USE CASE #1:- | 
| --------- |

| CREATE DOCKER REGISTRY DEVOPS SERVICE CONNECTION WITH PAT AS USER INPUT (Create-Docker-Registry-DevOps-Service-Connection-Prompt-PAT.ps1):- | 
| --------- |

```
##############
# VARIABLES:-
############## 
$devopsOrg = "https://dev.azure.com/arindammitra0251/"
$devopsPrj = "AMCLOUD"
$configJSON = "acr-srv-connection.json"
$dockersrvconn = "AM-ACR-Srv-Connection"

##############
# CORE SCRIPT:-
############## 

# Perform DevOps Login. It will Prompt for PAT:-
az devops login

# Set Default DevOps Organisation and Project:-
az devops configure --defaults organization=$devopsOrg project=$devopsPrj

# Create DevOps Service Connection:-
az devops service-endpoint create --service-endpoint-configuration .\$configJSON

# Grant Access to all Pipelines to the Newly Created Docker Registry DevOps Service Connection:-
$srvEndpointID = az devops service-endpoint list --query "[?name=='$dockersrvconn'].id" -o tsv
az devops service-endpoint update --id $srvEndpointID --enable-for-all

```

| USE CASE #2:- | 
| --------- |

| CREATE DOCKER REGISTRY DEVOPS SERVICE CONNECTION WITH PAT AS ENVIRONMENT VARIABLE (Create-Docker-Registry-DevOps-Service-Connection-Without-Prompting-PAT.ps1):- | 
| --------- |

```
##############
# VARIABLES:-
############## 
$pat = "<Provide your own PAT>"
$devopsOrg = "https://dev.azure.com/arindammitra0251/"
$devopsPrj = "AMCLOUD"
$configJSON = "acr-srv-connection.json"
$dockersrvconn = "AM-ACR-Srv-Connection"

##############
# CORE SCRIPT:-
############## 

# Set environment variable for DevOps Login:-
$env:AZURE_DEVOPS_EXT_PAT = $pat

# Set Default DevOps Organisation and Project:-
az devops configure --defaults organization=$devopsOrg project=$devopsPrj

# Create DevOps Service Connection:-
az devops service-endpoint create --service-endpoint-configuration .\$configJSON

# Grant Access to all Pipelines to the Newly Created Docker Registry DevOps Service Connection:-
$srvEndpointID = az devops service-endpoint list --query "[?name=='$dockersrvconn'].id" -o tsv
az devops service-endpoint update --id $srvEndpointID --enable-for-all
```

| JSON FORMAT CONFIGURATION FILE:- | 
| --------- |

```
{
  "data": {},
  "name": "AM-ACR-Srv-Connection",
  "type": "dockerregistry",
  "authorization": {
    "parameters": {
      "username": "ampocapplacr",
      "password": "XXXXXXXXXXXXXXXXXXXXXXXXX",
	  "email": "mail2arindam2003@yahoo.com",
	  "registry": "https://ampocapplacr.azurecr.io"
    },
    "scheme": "UsernamePassword"
  },
  "isShared": false,
  "isReady": true,
  "serviceEndpointProjectReferences": [
    {
      "projectReference": {
        "id": "36aaac58-e06f-47ed-8b98-003ad670ee3c",
        "name": "AMCLOUD"
      },
      "name": "AM-ACR-Srv-Connection"
    }
  ]
}
```

| __DIFFERENCE BETWEEN BOTH USE CASES:-__ | 
| --------- |
| In Use Case 1, PAT is prompted as User Input during script execution. |
| In Use Case 2, PAT is set as Environment variable so that it is not prompted as User Input during script execution. |


| __TASKS TO BE PERFORMED BEFORE RUNNING THE SCRIPTS:-__ | 
| --------- |
| 1. __Fetch the ID of the DevOps Project for which, we need to create Docker Registry Service Connection.__ |
| 2. __Prepare the JSON Format Configuration file.__ |


| __COMMANDS TO FETCH THE ID OF THE DEVOPS PROJECT:-__ | 
| --------- |

```
az devops login
az devops project show --project AMCLOUD --query "[id]" -o tsv
```

| __SAMPLE OUTPUT:-__ | 
| --------- |
| ![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/kz7selp97thm9ygvu8ls.jpg) |

| __HOW TO PREPARE THE JSON FORMAT CONFIGURATION FILE:-__ | 
| --------- |
| __Sample format of the JSON Config file can be found [HERE](https://learn.microsoft.com/en-us/azure/devops/cli/service-endpoint?view=azure-devops)__ |
| __Below Needs to be changed in the JSON Configuration file:-__ |
| 1. __name: "Custom Name for Docker Registry DevOps Service Connection."__ |
| 2. __username: "Name of Azure Container Registry."__ |
| 3. __password: "Password of Azure Container Registry"__ |
| 4. __email: "Custom Email Address."__ |
| 5. __registry: "Azure Container Registry Login Server URL."__ |
| 6. __id: "ID of the DevOps Project where the Docker Registry Service Connection will be created."__ |
| 7. __name: "Name of the DevOps Project where the Docker Registry Service Connection will be created."__ |

__Now, let me explain the script, part by part for better understanding.__

| __VARIABLES:-__ | 
| --------- |

__USE CASE 1:-__

```
##############
# VARIABLES:-
############## 
$devopsOrg = "https://dev.azure.com/arindammitra0251/"
$devopsPrj = "AMCLOUD"
$configJSON = "acr-srv-connection.json"
$dockersrvconn = "AM-ACR-Srv-Connection"
```

__USE CASE 2:-__

```
##############
# VARIABLES:-
############## 
$pat = "<Provide your own PAT>"
$devopsOrg = "https://dev.azure.com/arindammitra0251/"
$devopsPrj = "AMCLOUD"
$configJSON = "acr-srv-connection.json"
$dockersrvconn = "AM-ACR-Srv-Connection"
```

| __NOTE:-__ | 
| --------- |
| 1. Please change the values of the variables accordingly. |
| 2. The entire script is build using __Variables__. No Values are Hardcoded. Changing the values of the variables should help you execute the script seamlessly. |
| 3. In __Use Case #1__, PAT is User Input, and in __Use Case #2__, PAT is defined as Variable and then passed as Environmental Variable for DevOps Login. | 
| 4. The Value of the Variable "$configJSON" is the Custom Name of the JSON Format Configuration File. |
| 5. The Value of the Variable "$dockersrvconn" is the Custom Name of Docker Registry DevOps Service Connection. __Please Remember to keep the Custom Name of Docker Registry Service Connection Same in both files - 1) In JSON Format Configuration, and 2) In Powershell Script.__  |

| __CORE SCRIPT:-__ | 
| --------- |

__Perform DevOps Login. It will Prompt for PAT Token:-__

```
az devops login
```

OR

__Set PAT as an environment variable for DevOps Login:-__

```
$env:AZURE_DEVOPS_EXT_PAT = $pat
```

__Set Default DevOps Organisation and Project:-__

```
az devops configure --defaults organization=$devopsOrg project=$devopsPrj
```

__Create Docker Registry DevOps Service Connection using the JSON Format Configuration File:-__

```
az devops service-endpoint create --service-endpoint-configuration .\$configJSON
```

__Grant Access to all Pipelines to the Newly Created Docker Registry DevOps Service Connection:-__

```
$srvEndpointID = az devops service-endpoint list --query "[?name=='$dockersrvconn'].id" -o tsv

az devops service-endpoint update --id $srvEndpointID --enable-for-all
```

__NOW ITS TIME TO TEST:-__

| __TEST CASES:-__ | 
| --------- |
| 1. __Output of the script when executed successfully.__ |
| ![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/v9sfvnonsdtnqbyhyvat.jpg) |
| __Output Continued...__ |
| ![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/41vcrxy1gtbts15t17xt.jpg) |
| 2. __Docker Registry DevOps Service Connection created successfully with access granted to all pipelines.__ |
| ![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/87duhr0jwn8cyckkgn0h.jpg) |
| __Output Continued...__ |
| ![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/zvlexptutaqdlxdeavl3.jpg) |


__Hope You Enjoyed the Session!!!__

__Stay Safe | Keep Learning | Spread Knowledge__
