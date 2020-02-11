Configuration Main
{
    param (
        [String]$AzdoUrl,
        [String]$AzdoToken,
        [String]$UnityVersion,
        [String[]]$UnityComponents
    )

    Import-DscResource -ModuleName UnitySetup

    Node 'localhost' {
        xUnitySetupInstance Unity {
            Versions   = '$UnityVersion'
            Components = $UnityComponents
            Ensure     = 'Present'
        }

		GetScript = {
            @{
                Result = ""
            }
        }

        TestScript = {
            $false
        }

        SetScript = {
            Add-Type -AssemblyName System.IO.Compression.FileSystem

            $WebClient = New-Object System.Net.WebClient
            $WebClient.DownloadFile("https://vstsagentpackage.azureedge.net/agent/2.164.7/vsts-agent-win-x64-2.164.7.zip", "c:\agent\vsts-agent.zip")
            [System.IO.Compression.ZipFile]::ExtractToDirectory("c:\agent\vsts-agent.zip", "c:\agent\vsts-agent")
            Start-Process -WorkingDirectory "c:\agent\vsts-agent" -ArgumentList "--unattended --url $AzdoUrl --auth pat --token $AzdoToken --runAsService" .\config.cmd
        }
    }
}