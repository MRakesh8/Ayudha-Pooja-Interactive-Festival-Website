Add-Type -AssemblyName System.Drawing
$ref = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\ref_left_plaque.png").Path)

# Find center of the old circular seal in ref_left_plaque.png:
# It has a distinctive red ring at top, bottom, left, right.
# Let's inspect along y=20 across x
Write-Host "--- Scanning red pixels along y=20 ---"
for ($x = 40; $x -lt 220; $x++) {
    $c = $ref.GetPixel($x, 20)
    if ($c.R -gt 160 -and $c.G -lt 60 -and $c.B -lt 60) {
        Write-Host "Red at x=$x, y=20"
    }
}

Write-Host "--- Scanning red pixels along y=58 (horizontal equator of seal) ---"
for ($x = 40; $x -lt 220; $x++) {
    $c = $ref.GetPixel($x, 58)
    if ($c.R -gt 160 -and $c.G -lt 60 -and $c.B -lt 60) {
        Write-Host "Red at x=$x, y=58"
    }
}
$ref.Dispose()
