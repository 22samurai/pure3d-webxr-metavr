# Decode Draco-compressed GLBs with the pinned glTF Transform CLI.
# The source files are never changed. Output names end in "_godot.glb".
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory,

    [switch]$Overwrite
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Read-GlbDocument {
    param([Parameter(Mandatory = $true)][string]$Path)

    [byte[]]$bytes = [System.IO.File]::ReadAllBytes($Path)
    if ($bytes.Length -lt 20 -or [System.Text.Encoding]::ASCII.GetString($bytes, 0, 4) -ne 'glTF') {
        throw "Not a binary glTF file: $Path"
    }
    $jsonLength = [System.BitConverter]::ToUInt32($bytes, 12)
    $jsonType = [System.Text.Encoding]::ASCII.GetString($bytes, 16, 4)
    if ($jsonType -ne 'JSON' -or 20 + $jsonLength -gt $bytes.Length) {
        throw "Invalid glTF JSON chunk: $Path"
    }
    $json = [System.Text.Encoding]::UTF8.GetString($bytes, 20, [int]$jsonLength).TrimEnd([char]' ', [char]0)
    return $json | ConvertFrom-Json
}

function Get-DocumentArray {
    param(
        [Parameter(Mandatory = $true)]$Document,
        [Parameter(Mandatory = $true)][string]$Name
    )
    $property = $Document.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) { return ,@() }
    return ,@($property.Value)
}

function Get-GlbStructure {
    param([Parameter(Mandatory = $true)]$Document)

    $primitiveCount = 0
    $meshes = Get-DocumentArray -Document $Document -Name 'meshes'
    foreach ($mesh in $meshes) {
        $primitiveCount += (Get-DocumentArray -Document $mesh -Name 'primitives').Count
    }
    return [ordered]@{
        scenes = (Get-DocumentArray -Document $Document -Name 'scenes').Count
        nodes = (Get-DocumentArray -Document $Document -Name 'nodes').Count
        meshes = $meshes.Count
        primitives = $primitiveCount
        materials = (Get-DocumentArray -Document $Document -Name 'materials').Count
        textures = (Get-DocumentArray -Document $Document -Name 'textures').Count
        images = (Get-DocumentArray -Document $Document -Name 'images').Count
    }
}

$source = Get-Item -LiteralPath $InputPath -ErrorAction Stop
if ($source.PSIsContainer) {
    $inputs = @(Get-ChildItem -LiteralPath $source.FullName -Filter '*.glb' -File | Sort-Object Name)
} elseif ($source.Extension -ieq '.glb') {
    $inputs = @($source)
} else {
    throw 'InputPath must name a .glb file or a directory containing .glb files.'
}
if ($inputs.Count -eq 0) { throw 'No .glb files found.' }

$outputRoot = [System.IO.Path]::GetFullPath($OutputDirectory)
New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null
$toolRoot = Join-Path $PSScriptRoot 'draco-converter'
$cli = Join-Path $toolRoot 'node_modules\.bin\gltf-transform.cmd'
if (-not (Test-Path -LiteralPath $cli)) {
    $cache = Join-Path $toolRoot '.npm-cache'
    & npm.cmd ci --prefix $toolRoot --cache $cache --no-audit --no-fund
    if ($LASTEXITCODE -ne 0) { throw 'Could not install the pinned glTF Transform CLI.' }
}

$results = @()
foreach ($input in $inputs) {
    $output = Join-Path $outputRoot ($input.BaseName + '_godot.glb')
    if ((Test-Path -LiteralPath $output) -and -not $Overwrite) {
        throw "Output already exists; use -Overwrite to replace it: $output"
    }

    $before = Read-GlbDocument -Path $input.FullName
    $beforeStructure = Get-GlbStructure -Document $before
    $hadDraco = (Get-DocumentArray -Document $before -Name 'extensionsRequired') -contains 'KHR_draco_mesh_compression'

    & $cli copy $input.FullName $output
    if ($LASTEXITCODE -ne 0) { throw "Conversion failed: $($input.Name)" }

    $after = Read-GlbDocument -Path $output
    $afterStructure = Get-GlbStructure -Document $after
    if ((Get-DocumentArray -Document $after -Name 'extensionsRequired') -contains 'KHR_draco_mesh_compression' -or
        (Get-DocumentArray -Document $after -Name 'extensionsUsed') -contains 'KHR_draco_mesh_compression') {
        throw "Draco compression remains in converted file: $output"
    }
    foreach ($key in $beforeStructure.Keys) {
        if ($beforeStructure[$key] -ne $afterStructure[$key]) {
            throw "Scene structure changed ($key) for $($input.Name): $($beforeStructure[$key]) to $($afterStructure[$key])"
        }
    }

    $results += [pscustomobject]@{
        source = $input.Name
        output = Split-Path -Leaf $output
        source_sha256 = (Get-FileHash -LiteralPath $input.FullName -Algorithm SHA256).Hash
        output_sha256 = (Get-FileHash -LiteralPath $output -Algorithm SHA256).Hash
        source_had_draco = $hadDraco
        structure = $afterStructure
    }
    Write-Host "Converted $($input.Name) -> $(Split-Path -Leaf $output)"
}

$manifest = Join-Path $outputRoot 'conversion-manifest.json'
[pscustomobject]@{
    converter = '@gltf-transform/cli@4.5.1 copy'
    created_utc = [DateTime]::UtcNow.ToString('o')
    files = $results
} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $manifest -Encoding UTF8
Write-Host "Verified $($results.Count) GLB files. Manifest: $manifest"
