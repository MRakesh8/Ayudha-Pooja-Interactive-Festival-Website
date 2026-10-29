Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile("C:\Users\rakes\.gemini\antigravity-ide\brain\48bb4a45-86be-4a0d-a0a4-0212f1a3375e\.user_uploaded\media_1792079923641.jpg")

Write-Host "Scanning along y=40 for gold plaque pixels:"
$inPlaque = $false
$start = 0

for ($x = 0; $x -lt $img.Width; $x++) {
    $c = $img.GetPixel($x, 40)
    $isGold = ($c.R -gt 150 -and $c.G -gt 100 -and ($c.R - $c.B) -gt 30)
    if ($isGold -and -not $inPlaque) {
        $inPlaque = $true
        $start = $x
    } elseif (-not $isGold -and $inPlaque) {
        $inPlaque = $false
        Write-Host "Plaque section from X=$start to X=$x (Width=$($x - $start))"
    }
}
if ($inPlaque) {
    Write-Host "Plaque section from X=$start to X=$($img.Width) (Width=$($img.Width - $start))"
}

function FindYRange($img, $xTest) {
    $yMin = 999; $yMax = -1
    for ($y = 0; $y -lt 150; $y++) {
        $c = $img.GetPixel($xTest, $y)
        if ($c.R -gt 140 -and $c.G -gt 90 -and ($c.R - $c.B) -gt 25) {
            if ($y -lt $yMin) { $yMin = $y }
            if ($y -gt $yMax) { $yMax = $y }
        }
    }
    Write-Host "At X=$($xTest): Y=$yMin to Y=$yMax (Height=$($yMax - $yMin + 1))"
}

FindYRange $img 200
FindYRange $img 512
FindYRange $img 880

$img.Dispose()
