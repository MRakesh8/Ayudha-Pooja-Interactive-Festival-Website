Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile("C:\Users\rakes\.gemini\antigravity-ide\brain\48bb4a45-86be-4a0d-a0a4-0212f1a3375e\.user_uploaded\media_1792079923641.jpg")

Write-Host "Scanning bottom at X=548:"
for ($y = 65; $y -lt 95; $y++) {
    $c = $img.GetPixel(548, $y)
    Write-Host "y=$($y): R=$($c.R) G=$($c.G) B=$($c.B)"
}

Write-Host "Scanning X range at Y=45 for center plaque:"
for ($x = 440; $x -lt 660; $x+=5) {
    $c = $img.GetPixel($x, 45)
    if ($c.R -gt 150 -and $c.G -gt 110) {
        Write-Host "Gold at X=$($x)"
    }
}

$img.Dispose()
