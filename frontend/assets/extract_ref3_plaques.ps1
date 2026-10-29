Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile("C:\Users\rakes\.gemini\antigravity-ide\brain\48bb4a45-86be-4a0d-a0a4-0212f1a3375e\.user_uploaded\media_1792079923641.jpg")

# 1. Left Plaque: x=105, y=14, w=202, h=62
$rectL = New-Object System.Drawing.Rectangle(105, 14, 202, 62)
$cropL = $img.Clone($rectL, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# 2. Center Plaque: x=446, y=11, w=206, h=65 (includes the crown at top)
$rectC = New-Object System.Drawing.Rectangle(446, 11, 206, 65)
$cropC = $img.Clone($rectC, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# 3. Right Plaque: x=792, y=14, w=202, h=62
$rectR = New-Object System.Drawing.Rectangle(792, 14, 202, 62)
$cropR = $img.Clone($rectR, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Function to key out outer dark background
function CleanPlaqueEdges($bmp) {
    $w = $bmp.Width
    $h = $bmp.Height
    for ($y = 0; $y -lt $h; $y++) {
        # From left inwards
        for ($x = 0; $x -lt 25; $x++) {
            $c = $bmp.GetPixel($x, $y)
            # If not gold
            if ($c.R -lt 140 -or $c.G -lt 95) {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            } else { break }
        }
        # From right inwards
        for ($x = $w - 1; $x -gt ($w - 25); $x--) {
            $c = $bmp.GetPixel($x, $y)
            if ($c.R -lt 140 -or $c.G -lt 95) {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            } else { break }
        }
    }
    # Clean top and bottom corners
    for ($x = 0; $x -lt $w; $x++) {
        for ($y = 0; $y -lt 12; $y++) {
            $c = $bmp.GetPixel($x, $y)
            if ($c.R -lt 140 -or $c.G -lt 95) {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            } else { break }
        }
        for ($y = $h - 1; $y -gt ($h - 8); $y--) {
            $c = $bmp.GetPixel($x, $y)
            if ($c.R -lt 140 -or $c.G -lt 95) {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            } else { break }
        }
    }
}

CleanPlaqueEdges $cropL
CleanPlaqueEdges $cropC
CleanPlaqueEdges $cropR

$cropL.Save("d:\Downloads\project01\frontend\assets\plaque_college_ref3_clean.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cropC.Save("d:\Downloads\project01\frontend\assets\plaque_technitix_ref3_clean.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cropR.Save("d:\Downloads\project01\frontend\assets\plaque_dept_ref3_clean.png", [System.Drawing.Imaging.ImageFormat]::Png)

$cropL.Dispose()
$cropC.Dispose()
$cropR.Dispose()
$img.Dispose()

Write-Host "Saved 3 clean transparent plaques from ref3"
