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

