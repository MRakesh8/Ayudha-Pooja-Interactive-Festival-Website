Add-Type -AssemblyName System.Drawing

$src = (Resolve-Path ".\frontend\assets\technitix_ayudha_puja_gateway_ref.png").Path
$bmp = [System.Drawing.Bitmap]::FromFile($src)

# Left Plaque: x=160, y=22, width=508, height=108
$leftRect = New-Object System.Drawing.Rectangle(160, 22, 508, 108)
$leftBmp = $bmp.Clone($leftRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Right Plaque: x=1004, y=22, width=508, height=108
$rightRect = New-Object System.Drawing.Rectangle(1004, 22, 508, 108)
$rightBmp = $bmp.Clone($rightRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Function to clear background outside the plaque border
function CleanPlaqueCorners($img, $isLeft) {
    $w = $img.Width
    $h = $img.Height
    # Corners: top-left, bottom-left, top-right, bottom-right outside the gold border
    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            # Outside bounds:
            $isCorner = $false
            if ($isLeft) {
                if ($x -lt 28 -and ($y -lt 24 -or $y -gt ($h - 24))) { $isCorner = $true }
                if ($x -lt 12) { $isCorner = $true }
            } else {
                if ($x -gt ($w - 28) -and ($y -lt 24 -or $y -gt ($h - 24))) { $isCorner = $true }
                if ($x -gt ($w - 12)) { $isCorner = $true }
            }
            if ($isCorner) {
                $c = $img.GetPixel($x, $y)
                # If dark or background, make transparent
                if ($c.R -lt 120 -and $c.G -lt 80 -and $c.B -lt 60) {
                    $img.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
                }
            }
        }
    }
}

CleanPlaqueCorners $leftBmp $true
CleanPlaqueCorners $rightBmp $false

$leftBmp.Save("d:\Downloads\project01\frontend\assets\header_college_plaque.png", [System.Drawing.Imaging.ImageFormat]::Png)
$rightBmp.Save("d:\Downloads\project01\frontend\assets\header_dept_plaque.png", [System.Drawing.Imaging.ImageFormat]::Png)

$bmp.Dispose()
$leftBmp.Dispose()
$rightBmp.Dispose()
Write-Output "Successfully saved header_college_plaque.png and header_dept_plaque.png"
