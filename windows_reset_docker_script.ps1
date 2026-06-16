<#
.SYNOPSIS
  Reset Docker image/container cleanup and rebuild for Windows hosts.

.DESCRIPTION
  This script performs cleanup of Docker containers/images and builds the
  my-devcontainer-image:latest Docker image from the repository's
  src\.devcontainer folder.

  It is intended for use in PowerShell. For cmd.exe, use the wrapper
  windows_reset_docker_script.cmd.
#>

[CmdletBinding()]
param()

function Prompt-YesNo {
    param(
        [string]$Message,
        [string]$Default = 'N'
    )

    $choice = Read-Host "$Message"
    if ([string]::IsNullOrWhiteSpace($choice)) {
        $choice = $Default
    }

    return $choice.Trim().ToLower() -eq 'y'
}

function Run-DockerCommand {
    param(
        [string]$Command
    )

    Write-Host "Running: docker $Command"
    & docker $Command
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Docker command failed: docker $Command"
    }
}

$homePath = $env:USERPROFILE
if (-not $homePath) {
    $homePath = $env:HOME
}
if (-not $homePath) {
    Write-Error 'Unable to determine home directory.'
    exit 1
}

$defaultPath = Join-Path $homePath 'turtlebot-cms-repo\src\.devcontainer'

Write-Host '================================='
Write-Host 'DOCKER CLEANUP'
Write-Host '================================='
$cleanAll = Prompt-YesNo 'Perform FULL system cleanup? (Removes ALL images/volumes) [y/N]:'

if ($cleanAll) {
    Write-Host 'Performing full cleanup...'
    $containers = docker ps -aq
    if ($containers) {
        docker stop $containers | Out-Null
        docker rm -f $containers | Out-Null
    }

    $images = docker images -aq
    if ($images) {
        docker rmi -f $images | Out-Null
    }

    $volumes = docker volume ls -q
    if ($volumes) {
        docker volume rm $volumes | Out-Null
    }

    docker system prune -a -f --volumes
} else {
    Write-Host "Targeted cleanup: Removing only 'my-devcontainer-image:latest'..."
    $containerIds = docker ps -a -q --filter ancestor=my-devcontainer-image:latest
    if ($containerIds) {
        docker stop $containerIds | Out-Null
        docker rm -f $containerIds | Out-Null
    }

    docker rmi -f my-devcontainer-image:latest 2>$null
}

Write-Host 'Cleanup complete.'
Write-Host ''
Write-Host '================================='
Write-Host 'BUILD CONFIGURATION'
Write-Host '================================='
Write-Host "Default .devcontainer path: $defaultPath"
$inputPath = Read-Host 'Enter .devcontainer folder path, or press ENTER to use default'
$targetDir = if ([string]::IsNullOrWhiteSpace($inputPath)) { $defaultPath } else { $inputPath }

if (-not (Test-Path -Path $targetDir -PathType Container)) {
    Write-Error "Directory '$targetDir' not found."
    exit 1
}

Set-Location -Path $targetDir
if (-not (Test-Path -Path 'Dockerfile' -PathType Leaf) -and -not (Test-Path -Path 'dockerfile' -PathType Leaf)) {
    Write-Error "No Dockerfile found in $targetDir"
    exit 1
}

Write-Host "Building image 'my-devcontainer-image:latest' from $targetDir..."
$buildProcess = Start-Process -FilePath 'docker' -ArgumentList 'build', '-t', 'my-devcontainer-image:latest', '.' -NoNewWindow -Wait -PassThru
if ($buildProcess.ExitCode -ne 0) {
    Write-Error 'Docker build failed.'
    exit $buildProcess.ExitCode
}

Write-Host '================================='
Write-Host 'Build complete.'
Write-Host '================================='
