Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile("C:\Users\rakes\.gemini\antigravity-ide\brain\48bb4a45-86be-4a0d-a0a4-0212f1a3375e\.user_uploaded\media_1792079923641.jpg")

for ($y = 0; $y -lt 30; $y++) {
    $c = $img.GetPixel(548, $y)
    Write-Host "y=$($y): R=$($c.R) G=$($c.G) B=$($c.B)"
}
$img.Dispose()
