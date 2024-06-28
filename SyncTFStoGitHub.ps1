param(
     [Parameter()]
     [string]$DestinationPAT,
 
     [Parameter()]
     [string]$SourcePAT
 )

# Write your PowerShell commands here.
Write-Host ' - - - - - - - - - - - - - - - - - - - - - - - - -'
Write-Host ' reflect Azure Devops repo changes to GitHub repo'
Write-Host ' - - - - - - - - - - - - - - - - - - - - - - - - - '
$AzureRepoName = "ProjectFromGit"
$ADOCloneURL = "dev.azure.com/yangalwar/ProjectFromGit/_git/ProjectFromGit"
$GitHubCloneURL = "github.dxc.com/GLOBAL-XLPro/ProjectFromGit.git"
$stageDir = pwd | Split-Path
Write-Host "stage Dir is : $stageDir"
$githubDir = $stageDir +"\"+"gitHub"
Write-Host "github Dir : $githubDir"
#$destination = $githubDir+"\"+ $AzureRepoName+".git"
#Write-Host "destination: $destination"
#Please make sure, you remove https from azure-repo-clone-url
$sourceURL = "https://$($SourcePAT)"+"@"+"$($ADOCloneURL)"
write-host "source URL : $sourceURL"
#Please make sure, you remove https from github-repo-clone-url
$destURL = "https://" + $($DestinationPAT) +"@"+"$($GitHubCloneURL)"
write-host "dest URL : $destURL"
$destination = $destURL
Write-Host "destination: $destination"
#Check if the parent directory exists and delete
if((Test-Path -path $githubDir))
{
  Remove-Item -Path $githubDir -Recurse -force
}
if(!(Test-Path -path $githubDir))
{
  New-Item -ItemType directory -Path $githubDir
  Set-Location $githubDir
  git clone --mirror $sourceURL
}
else
{
  Write-Host "The given folder path $githubDir already exists";
}
Set-Location $destination
Write-Output '*****Git removing remote secondary****'
git remote rm secondary
Write-Output '*****Git remote add****'
git remote add --mirror=fetch secondary $destURL
Write-Output '*****Git fetch origin****'
git fetch $sourceURL
Write-Output '*****Git push secondary****'
#git remote set-url origin $destURLSetURL
git push secondary  --all -f
Write-Output '**Azure Devops repo synced with Github repo**'
Set-Location $stageDir
if((Test-Path -path $githubDir))
{
 Remove-Item -Path $githubDir -Recurse -force
}
write-host "Job completed"


windows-2019
ubuntu-latest

