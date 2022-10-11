Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox

function Get-VisualStudioCommand
{
    [CmdletBinding()]
    param ( [AllowNull()][String] $vsVersion )
    $vs10 = """${env:ProgramFiles(x86)}\Microsoft Visual Studio 10.0\Common7\IDE\devenv.exe"""
    $vs13 = """${env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"""
    $vs15 = """${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe"""
    $vs17 = """${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe"""
    $vs19 = """${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"""
    $vs22 = """${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"""

    switch ($vsVersion) 
    { 
        '10' {$vs10}
        '13' {$vs13}
        '15' {$vs15} 
        '17' {$vs17} 
        '19' {$vs19}
        '22' {$vs22}
        default {$vs22} 
    }
}

function Get-SolutionName
{
    [CmdletBinding()]
    param ( [AllowNull()][String] $Name )

    if (!$Name)
    {
        $Name = Get-ChildItem -Filter *.sln
    }

    if ($Name)
    {
        $Name = ('"{0}"' -f $Name)
    }

    return $Name
}

function Start-VisualStudioProcess
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param([String]$Version, [String]$Sln)

    $VsCommand = Get-VisualStudioCommand -vsVersion $Version
    $Sln = Get-SolutionName -Name $Sln

    Write-Verbose -Message ('Starting: command={0} solutionName={1}' -f $VsCommand, $Sln)

    if ($PSCmdlet.ShouldProcess($VsCommand, 'Start-Process'))
    {
        if ($Sln)
        {
            Start-Process -FilePath $vsCommand -ArgumentList $sln
        }
        else
        {
            Start-Process -FilePath $vsCommand 
        }

    }
}

function Open-CurrentFolder
{
    explorer .
}

function Invoke-GitClone($url) {
    $name = $url.Split('/')[-1].Replace('.git', '')
    git clone $url $name
    Set-Location $name
}

function Invoke-GitLogOneline
{
    git log --oneline -5
}

Set-Alias -Name vs -Value Start-VisualStudioProcess
Set-Alias -Name fld -Value Open-CurrentFolder
Set-Alias -Name gcd -Value Invoke-GitClone
Set-Alias -Name sb -Value servicebusexplorer
Set-Alias -Name glo -Value Invoke-GitLogOneline

Remove-Variable -Force HOME
Set-Variable HOME "D:\Repos\"
Set-Location $HOME

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
