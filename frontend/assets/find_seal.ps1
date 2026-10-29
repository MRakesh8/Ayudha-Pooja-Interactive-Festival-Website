Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile("d:/Downloads/project01/frontend/assets/ref_left_plaque.png")
$redMin = 999
$redMax = -1
$yMin = 999
$yMax = -1
for ($x = 0; $x -lt 160; $x++) {
    for ($y = 0; $y -lt $b.Height; $y++) {
        $c = $b.GetPixel($x, $y)
        # Check for circular red ring
        if ($c.R -gt 180 -and $c.G -lt 50 -and $c.B -lt 50) {
            if ($x -lt $redMin) { $redMin = $x }
            if ($x -gt $redMax) { $redMax = $x }
            if ($y -lt $yMin) { $yMin = $y }
            if ($y -gt $yMax) { $yMax = $y }
        }
    }
}
Write-Host "Circular seal: x: $redMin to $redMax (width: $($redMax - $redMin)), y: $yMin to $yMax (height: $($yMax - $yMin))"
$b.Dispose()
