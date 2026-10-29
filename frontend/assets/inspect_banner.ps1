Add-Type -AssemblyName System.Drawing

$src = (Resolve-Path ".\frontend\assets\ayudha_pooja_banner_raw.png").Path
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$w = $bmp.Width
$h = $bmp.Height

Write-Output "Banner raw: $w x $h"

# Top left pixel (door wood)
$cTopLeft = $bmp.GetPixel(50, 10)
Write-Output "Top-left wood color: R=$($cTopLeft.R) G=$($cTopLeft.G) B=$($cTopLeft.B)"

# Center top pixel (door wood above arch)
$cCenterTop = $bmp.GetPixel([int]($w/2), 10)
Write-Output "Center-top wood color: R=$($cCenterTop.R) G=$($cCenterTop.G) B=$($cCenterTop.B)"

# Arch top gold border
$cArch = $bmp.GetPixel([int]($w/2), 48)
Write-Output "Arch top gold border: R=$($cArch.R) G=$($cArch.G) B=$($cArch.B)"

$bmp.Dispose()
