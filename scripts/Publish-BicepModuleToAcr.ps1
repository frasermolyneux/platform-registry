param (
    [Parameter(Mandatory = $true)]
    [string] $moduleName,

    [Parameter(Mandatory = $true)]
    [string] $modulesRootPath,

    [Parameter(Mandatory = $true)]
    [string] $acrName,

    [Parameter(Mandatory = $true)]
    [string] $version,

    [string] $repositoryPrefix = "bicep/modules",

    [boolean] $previewRelease = $true
)

$moduleFilePath = Join-Path $modulesRootPath $moduleName "main.bicep"
$acrRepository = "$repositoryPrefix/$moduleName".ToLower()

if ((Test-Path $moduleFilePath) -eq $false) {
    Write-Error "The module at '$moduleFilePath' could not be found!"
    exit 1
}

Write-Host "Using module file: '$moduleFilePath'"
Write-Host "Version: '$version'"

# Parse version components
$versionParts = $version -split '\.'
if ($versionParts.Count -lt 2) {
    Write-Error "Version '$version' must be at least major.minor format"
    exit 1
}

$major = $versionParts[0]
$minor = $versionParts[1]
$patch = if ($versionParts.Count -ge 3) { $versionParts[2] } else { "0" }

$tagsToPushTo = @()

if ($previewRelease) {
    $fullVersionTag = "V${major}.${minor}.${patch}-preview"
} else {
    $fullVersionTag = "V${major}.${minor}.${patch}"
}

$majorXVersion = "V${major}.x"
$majorMinorXVersion = "V${major}.${minor}.x"

$repositories = az acr repository list --name $acrName | ConvertFrom-Json
if ($null -eq $repositories -or !$repositories.Contains($acrRepository)) {
    $tagsToPushTo += $fullVersionTag

    if (!$previewRelease) {
        $tagsToPushTo += $majorXVersion
        $tagsToPushTo += $majorMinorXVersion
        $tagsToPushTo += "latest"
    }
} else {
    $moduleTags = az acr repository show-tags --name $acrName --repository $acrRepository | ConvertFrom-Json

    if ($moduleTags.Contains($fullVersionTag)) {
        Write-Warning "There is already a published image with the tag '$fullVersionTag'"
    } else {
        $tagsToPushTo += $fullVersionTag

        if (!$previewRelease) {
            $tagsToPushTo += $majorXVersion
            $tagsToPushTo += $majorMinorXVersion
            $tagsToPushTo += "latest"
        }
    }
}

$tagsToPushTo | ForEach-Object {
    Write-Host "Publishing module to: 'br:$acrName.azurecr.io/${acrRepository}' with tag: '$_'"
    az bicep publish --file $moduleFilePath --target "br:$acrName.azurecr.io/${acrRepository}:$_" --force
}
