Add-Type -AssemblyName System.Drawing

$src = (Resolve-Path ".\frontend\assets\College_logo.png").Path
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$w = $bmp.Width
$h = $bmp.Height

Write-Output "College logo dimensions: $w x $h"

# Circular crest is on the left: from x=0 to x=h (square)
$crestRect = New-Object System.Drawing.Rectangle(0, 0, $h, $h)
$crest = $bmp.Clone($crestRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Make pure white background transparent
for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $h; $x++) {
        $c = $crest.GetPixel($x, $y)
        if ($c.R -gt 245 -and $c.G -gt 245 -and $c.B -gt 245) {
            $crest.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

$crestPath = "d:\Downloads\project01\frontend\assets\srec_crest.png"
$crest.Save($crestPath, [System.Drawing.Imaging.ImageFormat]::Png)

$bmp.Dispose()
$crest.Dispose()
Write-Output "Saved isolated crest to $crestPath"
