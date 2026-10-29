Add-Type -AssemblyName System.Drawing

$bytes = [System.IO.File]::ReadAllBytes("d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png")
$ms = New-Object System.IO.MemoryStream($bytes, 0, $bytes.Length)
$src = [System.Drawing.Image]::FromStream($ms)
$bmp = New-Object System.Drawing.Bitmap($src)
$ms.Dispose()

# Clear anything below the bottom gold frame line (y > 250 for extreme left and right):
for ($y = 250; $y -lt $bmp.Height; $y++) {
    for ($x = 0; $x -lt $bmp.Width; $x++) {
        if ($x -lt 70 -or $x -gt ($bmp.Width - 70)) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

# Tightly crop
$minX = $bmp.Width; $maxX = 0; $minY = $bmp.Height; $maxY = 0
for ($y = 0; $y -lt $bmp.Height; $y++) {
    for ($x = 0; $x -lt $bmp.Width; $x++) {
        if ($bmp.GetPixel($x, $y).A -gt 15) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}

$cropRect = New-Object System.Drawing.Rectangle($minX, $minY, ($maxX - $minX + 1), ($maxY - $minY + 1))
$cropped = $bmp.Clone($cropRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$bmp.Dispose()
$src.Dispose()

$cropped.Save("d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cropped.Dispose()

Write-Host "Corner feet trimmed and perfected!"
