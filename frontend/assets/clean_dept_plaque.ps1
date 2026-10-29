Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\plaque_dept_it_aids_clean.png").Path)

# Clean brown pedestal in middle bottom (between x=70 and x=950, for y > 278)
for ($y = 278; $y -lt $src.Height; $y++) {
    for ($x = 70; $x -lt ($src.Width - 70); $x++) {
        $c = $src.GetPixel($x, $y)
        if ($c.A -gt 0 -and ($c.R -lt 200 -or $c.G -lt 140)) {
            $src.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

# Crop bounding box of non-transparent pixels
$minX = $src.Width
$maxX = 0
$minY = $src.Height
$maxY = 0

for ($y = 0; $y -lt $src.Height; $y++) {
    for ($x = 0; $x -lt $src.Width; $x++) {
        if ($src.GetPixel($x, $y).A -gt 15) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}

Write-Host "Non-transparent bounds: X=$minX..$maxX (W=$($maxX - $minX + 1)), Y=$minY..$maxY (H=$($maxY - $minY + 1))"

$cropRect = New-Object System.Drawing.Rectangle($minX, $minY, ($maxX - $minX + 1), ($maxY - $minY + 1))
$cropped = $src.Clone($cropRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$src.Dispose()

$cropped.Save("d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cropped.Dispose()

Write-Host "Saved trimmed plaque_dept_it_aids_perfect.png"
