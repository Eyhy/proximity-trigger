$ErrorActionPreference = 'Stop'

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    throw 'ffmpeg was not found. Install FFmpeg, reopen PowerShell, and run this script again.'
}

if (-not (Get-Command ffprobe -ErrorAction SilentlyContinue)) {
    throw 'ffprobe was not found. Install the complete FFmpeg package and run this script again.'
}

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceDirectory = Join-Path $projectRoot 'webpage\videos'
$outputDirectory = Join-Path $projectRoot 'public\videos'

New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$shortSource = Join-Path $sourceDirectory 'release-short.avi'
$longSource = Join-Path $sourceDirectory 'release-long.avi'
$shortOutput = Join-Path $outputDirectory 'release-short.mp4'
$longOutput = Join-Path $outputDirectory 'release-long.mp4'

& ffprobe -v error -show_streams -show_format $shortSource
& ffprobe -v error -show_streams -show_format $longSource

& ffmpeg -y -i $shortSource -t 5 -vf 'setpts=2.0*PTS' -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -movflags +faststart -an $shortOutput
if ($LASTEXITCODE -ne 0) { throw 'Failed to convert release-short.avi.' }

& ffmpeg -y -i $longSource -t 5 -vf 'setpts=2.0*PTS' -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -movflags +faststart -an $longOutput
if ($LASTEXITCODE -ne 0) { throw 'Failed to convert release-long.avi.' }

Write-Host 'Conversion complete. Rebuild the site with: npm.cmd run build'
