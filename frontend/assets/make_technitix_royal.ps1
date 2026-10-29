Add-Type -AssemblyName System.Drawing

$baseSym = "d:\Downloads\project01\frontend\assets\test_mirror_sym.png"
$techDst = "d:\Downloads\project01\frontend\assets\plaque_technitix_royal.png"

$bytes = [System.IO.File]::ReadAllBytes($baseSym)
$ms = New-Object System.IO.MemoryStream($bytes, 0, $bytes.Length)
$srcImg = [System.Drawing.Image]::FromStream($ms)
$srcSym = New-Object System.Drawing.Bitmap($srcImg)
$ms.Dispose()

$sw = $srcSym.Width
$sh = $srcSym.Height

$tech = New-Object System.Drawing.Bitmap($sw, $sh, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gt = [System.Drawing.Graphics]::FromImage($tech)
$gt.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gt.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gt.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# 1. Draw symmetrical blank gold plaque
$gt.DrawImage($srcSym, 0, 0, $sw, $sh)
$srcSym.Dispose()
$srcImg.Dispose()

# 2. Draw Royal Imperial Crown at top apex (centered at X=507)
# Crown Velvet Dome (Rich Royal Maroon)
$velvetBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(450, 4)),
    (New-Object System.Drawing.Point(450, 32)),
    [System.Drawing.Color]::FromArgb(255, 175, 15, 25),
    [System.Drawing.Color]::FromArgb(255, 85, 4, 12)
)
$gt.FillPie($velvetBrush, 452, 6, 110, 50, 180, 180)
$velvetBrush.Dispose()

# Crown Gold Ribs
$goldRibPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 215, 60), 3)
$gt.DrawArc($goldRibPen, 462, 10, 90, 44, 195, 150)
$gt.DrawLine($goldRibPen, 507, 6, 507, 30)
$goldRibPen.Dispose()

# Crown Golden Tiara Base / Headband
$goldTiaraBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(440, 24)),
    (New-Object System.Drawing.Point(574, 24)),
    [System.Drawing.Color]::FromArgb(255, 215, 140, 25),
    [System.Drawing.Color]::FromArgb(255, 255, 235, 150)
)
$gt.FillRectangle($goldTiaraBrush, 446, 24, 122, 9)

# 5 Royal Golden Spikes/Fleurs (All Y >= 2)
$spikePoints = @(
    (New-Object System.Drawing.Point(446, 24)),
    (New-Object System.Drawing.Point(446, 12)),
    (New-Object System.Drawing.Point(460, 20)),
    (New-Object System.Drawing.Point(478, 5)),
    (New-Object System.Drawing.Point(493, 18)),
    (New-Object System.Drawing.Point(507, 2)),
    (New-Object System.Drawing.Point(521, 18)),
    (New-Object System.Drawing.Point(536, 5)),
    (New-Object System.Drawing.Point(554, 20)),
    (New-Object System.Drawing.Point(568, 12)),
    (New-Object System.Drawing.Point(568, 24))
)
$gt.FillPolygon($goldTiaraBrush, $spikePoints)

# Jewel Tips (All Y >= 1)
$jewelRed = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 20, 30))
$jewelCyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 215))
$jewelDiamond = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 250))
$jewelGold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 215, 0))

$gt.FillEllipse($jewelCyan, 443, 9, 7, 7)
$gt.FillEllipse($jewelRed, 474, 2, 7, 7)
# Apex Golden Cross & Diamond Pearl (Positive Y)
$gt.FillEllipse($jewelDiamond, 503, 1, 8, 8)
$gt.FillRectangle($jewelGold, 506, 1, 3, 8)
$gt.FillRectangle($jewelGold, 503, 3, 9, 3)
$gt.FillEllipse($jewelRed, 532, 2, 7, 7)
$gt.FillEllipse($jewelCyan, 564, 9, 7, 7)

# Pearls / Rubies on Crown Headband
for ($gx = 454; $gx -le 558; $gx += 14) {
    $gt.FillEllipse($jewelRed, $gx, 26, 5, 5)
    $gt.FillEllipse($jewelDiamond, $gx + 1, 27, 2, 2)
}
$jewelRed.Dispose(); $jewelCyan.Dispose(); $jewelDiamond.Dispose(); $jewelGold.Dispose(); $goldTiaraBrush.Dispose()

# 3. TECHNITIX Title (ONLY TECHNITIX - NO SUBTITLE, PERFECTLY CENTERED)
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center

$pathTech = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathTech.AddString("TECHNITIX", (New-Object System.Drawing.FontFamily("Georgia")), [int][System.Drawing.FontStyle]::Bold, 88, (New-Object System.Drawing.Point(507, 64)), $sf)

# Gold bevel stroke
$goldBevelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(225, 255, 230, 110), 7)
$goldBevelPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gt.DrawPath($goldBevelPen, $pathTech)

# Deep crimson gradient fill
$crimsonTechFill = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(507, 60)),
    (New-Object System.Drawing.Point(507, 185)),
    [System.Drawing.Color]::FromArgb(255, 190, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 75, 2, 10)
)
$gt.FillPath($crimsonTechFill, $pathTech)
$goldBevelPen.Dispose(); $crimsonTechFill.Dispose(); $pathTech.Dispose()

$gt.Dispose()

# Trim bottom tabs below y=232
for ($y = 232; $y -lt $sh; $y++) {
    for ($x = 0; $x -lt $sw; $x++) {
        $tech.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
    }
}

$tech.Save($techDst, [System.Drawing.Imaging.ImageFormat]::Png)
$tech.Dispose()

Write-Host "Created $techDst successfully without errors!"
