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