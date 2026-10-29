Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile("C:\Users\rakes\.gemini\antigravity-ide\brain\48bb4a45-86be-4a0d-a0a4-0212f1a3375e\.user_uploaded\media_1792079923641.jpg")

# 1. Left Plaque: x=105, y=19, w=200, h=51
$rectL = New-Object System.Drawing.Rectangle(105, 19, 200, 51)
$rawL = $img.Clone($rectL, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# 2. Center Plaque: x=446, y=12, w=204, h=58 (includes full crown)
$rectC = New-Object System.Drawing.Rectangle(446, 12, 204, 58)
$rawC = $img.Clone($rectC, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# 3. Right Plaque: x=793, y=19, w=200, h=51
$rectR = New-Object System.Drawing.Rectangle(793, 19, 200, 51)
$rawR = $img.Clone($rectR, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Function to key out dark/brown exterior background
function CleanPlaque($bmp, $isCenter) {
    $w = $bmp.Width
    $h = $bmp.Height

    # Flood fill exterior transparent from corners
    $bg = New-Object 'bool[,]' $w, $h
    $q = New-Object System.Collections.Generic.Queue[System.Drawing.Point]

    # Seeds on borders
    for ($x = 0; $x -lt $w; $x++) {
        AddSeed $bmp $bg $q $x 0 $isCenter
        AddSeed $bmp $bg $q $x ($h - 1) $isCenter
    }
    for ($y = 0; $y -lt $h; $y++) {
        AddSeed $bmp $bg $q 0 $y $isCenter
        AddSeed $bmp $bg $q ($w - 1) $y $isCenter
    }

    while ($q.Count -gt 0) {
        $p = $q.Dequeue()
        $px = $p.X; $py = $p.Y
        AddSeed $bmp $bg $q ($px + 1) $py $isCenter
        AddSeed $bmp $bg $q ($px - 1) $py $isCenter
        AddSeed $bmp $bg $q $px ($py + 1) $isCenter
        AddSeed $bmp $bg $q $px ($py - 1) $isCenter
    }

    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            if ($bg[$x, $y]) {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            }
        }
    }
}

function AddSeed($bmp, $bg, $q, $x, $y, $isCenter) {
    if ($x -lt 0 -or $x -ge $bmp.Width -or $y -lt 0 -or $y -ge $bmp.Height -or $bg[$x, $y]) { return }
    $c = $bmp.GetPixel($x, $y)
    
    # Check if pixel is background (dark wood / brown / black)
    # Crown jewels at top of center can be red (R high, G low)
    $isPlaque = $false
    if ($isCenter -and $y -lt 16 -and $x -gt 70 -and $x -lt 135) {
        # Inside crown region: red velvet or jewels
        if ($c.R -gt 90) { $isPlaque = $true }
    }
    # Gold border/face: R > 130 and G > 85 and R-B > 25
    if ($c.R -gt 130 -and $c.G -gt 85 -and ($c.R - $c.B) -gt 25) {
        $isPlaque = $true
    }

    if (-not $isPlaque) {
        $bg[$x, $y] = $true
        $q.Enqueue((New-Object System.Drawing.Point($x, $y)))
    }
}

CleanPlaque $rawL $false
CleanPlaque $rawC $true
CleanPlaque $rawR $false

# Upscale 3x with HighQualityBicubic for crisp rendering
function Upscale3x($src, $dstPath) {
    $dstW = $src.Width * 3
    $dstH = $src.Height * 3
    $dst = New-Object System.Drawing.Bitmap($dstW, $dstH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($dst)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($src, 0, 0, $dstW, $dstH)
    $g.Dispose()
    $dst.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $dst.Dispose()
}

Upscale3x $rawL "d:\Downloads\project01\frontend\assets\plaque_college_triptych.png"
Upscale3x $rawC "d:\Downloads\project01\frontend\assets\plaque_technitix_triptych.png"
Upscale3x $rawR "d:\Downloads\project01\frontend\assets\plaque_dept_triptych.png"

$rawL.Dispose()
$rawC.Dispose()
$rawR.Dispose()
$img.Dispose()

Write-Host "Upscaled and saved all 3 triptych plaques successfully!"
