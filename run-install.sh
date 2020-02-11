#!/bin/bash

az group create --name UnityBuilds --location westus2
az group deployment create --resource-group UnityBuilds --template-file azuredeploy.json --parameters \
    vmName="jwunitybuild" \
    vmSize="Standard_D4s_v3" \
    adminUsername="jwendl" \
    adminPassword="" \
    dnsName="jwunitybuild" configurationFunction="InstallUnity.ps1\\Main" \
    unityVersion="2019.2.20f1" \
    unityComponents="[ 'Windows', 'UWP' ]" \
    azdoUrl="https://dev.azure.com/jw-unity-demo/" \
    azdoToken=""
