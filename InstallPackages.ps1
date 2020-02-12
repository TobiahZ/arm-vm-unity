Configuration Main
{
    param (
        [String]$AzdoUrl,
        [String]$AzdoToken,
        [String]$UnityVersion,
        [String[]]$UnityComponents
    )

    Node 'localhost' {
        $azdoUrl = $AzdoUrl
        $azdoToken = $AzdoToken
        $unityVersion = $UnityVersion
        $unityComponents = $UnityComponents

        Script InstallRequirements {
            GetScript = {
                @{
                    Result = ""
                }
            }
    
            TestScript = {
                $false
            }
    
            SetScript = {
                Install-Module UnitySetup
                Find-UnitySetupInstaller -Version '$using:UnityVersion'  -Components $using:UnityComponents | Install-UnitySetupInstance
    
                Add-Type -AssemblyName System.IO.Compression.FileSystem
                $WebClient = New-Object System.Net.WebClient
                $WebClient.DownloadFile("https://vstsagentpackage.azureedge.net/agent/2.164.7/vsts-agent-win-x64-2.164.7.zip", "c:\agent\vsts-agent.zip")
                [System.IO.Compression.ZipFile]::ExtractToDirectory("c:\agent\vsts-agent.zip", "c:\agent\vsts-agent")
                Start-Process -WorkingDirectory "c:\agent\vsts-agent" -ArgumentList "--unattended --url $using:AzdoUrl --auth pat --token $using:AzdoToken --runAsService" .\config.cmd
            }
        }
    }
}