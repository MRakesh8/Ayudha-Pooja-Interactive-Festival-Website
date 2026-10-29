Add-Type -AssemblyName System.Drawing

$baseDept = "d:\Downloads\project01\frontend\assets\plaque_base_smooth.png"
$baseSym = "d:\Downloads\project01\frontend\assets\test_mirror_sym.png"
$crestPath = "d:\Downloads\project01\frontend\assets\srec_crest.png"

$deptDst = "d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png"
$techDst = "d:\Downloads\project01\frontend\assets\plaque_technitix_perfect.png"
$collegeDst = "d:\Downloads\project01\frontend\assets\plaque_college_perfect.png"

# String formats
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center

# =========================================================================
# 1. GENERATE RIGHT PLAQUE: DEPARTMENT OF IT & AIDS (ONLY ONE '&')
# =========================================================================
$srcDept = [System.Drawing.Bitmap]::FromFile($baseDept)
$w = $srcDept.Width
$h = $srcDept.Height

$dept = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gd = [System.Drawing.Graphics]::FromImage($dept)
$gd.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gd.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gd.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Draw flawless blank frame with AI brain chip
$gd.DrawImage($srcDept, 0, 0, $w, $h)
$srcDept.Dispose()

# Line 1: DEPARTMENT OF
$pathDep = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathDep.AddString("DEPARTMENT OF", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 44, (New-Object System.Drawing.Point(615, 46)), $sf)

$goldGlowPen1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(195, 255, 230, 120), 4)
$goldGlowPen1.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gd.DrawPath($goldGlowPen1, $pathDep)

$crimsonBrush1 = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 46)),
    (New-Object System.Drawing.Point(300, 108)),
    [System.Drawing.Color]::FromArgb(255, 185, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 95, 3, 12)
)
$gd.FillPath($crimsonBrush1, $pathDep)
$pathDep.Dispose(); $goldGlowPen1.Dispose(); $crimsonBrush1.Dispose()

# Line 2: IT & AIDS (Large bold crimson with 3D gold bevel, exactly ONE '&')
$pathIT = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathIT.AddString("IT & AIDS", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 82, (New-Object System.Drawing.Point(615, 102)), $sf)

$goldGlowPen2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(210, 255, 230, 120), 6)
$goldGlowPen2.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gd.DrawPath($goldGlowPen2, $pathIT)

$crimsonBrush2 = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 100)),
    (New-Object System.Drawing.Point(300, 210)),
    [System.Drawing.Color]::FromArgb(255, 190, 12, 28),
    [System.Drawing.Color]::FromArgb(255, 80, 2, 10)
)
$gd.FillPath($crimsonBrush2, $pathIT)
$pathIT.Dispose(); $goldGlowPen2.Dispose(); $crimsonBrush2.Dispose()

$gd.Dispose()

# Trim bottom tabs below y=232
for ($y = 232; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $dept.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
    }
}
$dept.Save($deptDst, [System.Drawing.Imaging.ImageFormat]::Png)
$dept.Dispose()
Write-Host "1. Generated: $deptDst"


# =========================================================================
# 2. GENERATE CENTER PLAQUE: TECHNITIX (NO SUBTITLE, CENTERED WITH CROWN)
# =========================================================================
$srcSym = [System.Drawing.Bitmap]::FromFile($baseSym)
$sw = $srcSym.Width
$sh = $srcSym.Height

$tech = New-Object System.Drawing.Bitmap($sw, $sh, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gt = [System.Drawing.Graphics]::FromImage($tech)
$gt.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gt.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gt.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Draw symmetrical blank gold plaque
$gt.DrawImage($srcSym, 0, 0, $sw, $sh)
$srcSym.Dispose()

# Draw Royal Imperial Crown at top apex (centered at X=503)
# Crown Velvet Dome (Rich Royal Maroon)
$velvetBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(440, 4)),
    (New-Object System.Drawing.Point(440, 36)),
    [System.Drawing.Color]::FromArgb(255, 175, 15, 25),
    [System.Drawing.Color]::FromArgb(255, 85, 4, 12)
)
$gt.FillPie($velvetBrush, 450, 5, 106, 56, 180, 180)
$velvetBrush.Dispose()

# Crown Gold Ribs
$goldRibPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 215, 60), 3.5)
$gt.DrawArc($goldRibPen, 460, 9, 86, 50, 195, 150)
$gt.DrawLine($goldRibPen, 503, 5, 503, 33)
$goldRibPen.Dispose()

# Crown Golden Tiara Base / Headband
$goldTiaraBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(440, 26)),
    (New-Object System.Drawing.Point(566, 26)),
    [System.Drawing.Color]::FromArgb(255, 215, 140, 25),
    [System.Drawing.Color]::FromArgb(255, 255, 235, 150)
)
$gt.FillRectangle($goldTiaraBrush, 444, 27, 118, 9)

# 5 Royal Golden Spikes/Fleurs
$spikePoints = @(
    (New-Object System.Drawing.Point(444, 27)),
    (New-Object System.Drawing.Point(444, 13)),
    (New-Object System.Drawing.Point(458, 22)),
    (New-Object System.Drawing.Point(475, 5)),
    (New-Object System.Drawing.Point(490, 20)),
    (New-Object System.Drawing.Point(503, 0)),
    (New-Object System.Drawing.Point(516, 20)),
    (New-Object System.Drawing.Point(531, 5)),
    (New-Object System.Drawing.Point(548, 22)),
    (New-Object System.Drawing.Point(562, 13)),
    (New-Object System.Drawing.Point(562, 27))
)
$gt.FillPolygon($goldTiaraBrush, $spikePoints)

# Jewel Tips
$jewelRed = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 20, 30))
$jewelCyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 215))
$jewelDiamond = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 250))
$jewelGold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 215, 0))

$gt.FillEllipse($jewelCyan, 441, 10, 7, 7)
$gt.FillEllipse($jewelRed, 471, 2, 8, 8)
# Apex Golden Cross & Diamond Pearl
$gt.FillEllipse($jewelDiamond, 499, -3, 8, 8)
$gt.FillRectangle($jewelGold, 501, -8, 4, 11)
$gt.FillRectangle($jewelGold, 497, -6, 12, 4)
$gt.FillEllipse($jewelRed, 527, 2, 8, 8)
$gt.FillEllipse($jewelCyan, 558, 10, 7, 7)

# Pearls / Rubies on Crown Headband
for ($gx = 452; $gx -le 554; $gx += 14) {
    $gt.FillEllipse($jewelRed, $gx, 29, 6, 6)
    $gt.FillEllipse($jewelDiamond, $gx + 1, 30, 2, 2)
}
$jewelRed.Dispose(); $jewelCyan.Dispose(); $jewelDiamond.Dispose(); $jewelGold.Dispose(); $goldTiaraBrush.Dispose()

# TECHNITIX Title (Vertically & horizontally centered, majestic bold serif, NO SUBTITLE)
$pathTech = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathTech.AddString("TECHNITIX", (New-Object System.Drawing.FontFamily("Georgia")), [int][System.Drawing.FontStyle]::Bold, 90, (New-Object System.Drawing.Point(503, 62)), $sf)

# Gold bevel stroke
$goldBevelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(225, 255, 230, 110), 7)
$goldBevelPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gt.DrawPath($goldBevelPen, $pathTech)

# Deep crimson gradient fill
$crimsonTechFill = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(503, 60)),
    (New-Object System.Drawing.Point(503, 190)),
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
Write-Host "2. Generated: $techDst"


# =========================================================================
# 3. GENERATE COLLEGE PLAQUE (FROM BASE DEPT WITH SREC SEAL)
# =========================================================================
$srcDept2 = [System.Drawing.Bitmap]::FromFile($baseDept)
$college = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gc = [System.Drawing.Graphics]::FromImage($college)
$gc.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gc.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gc.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$gc.DrawImage($srcDept2, 0, 0, $w, $h)
$srcDept2.Dispose()

# Cover AI chip inside roundel with deep velvet maroon
$darkMaroon = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 115, 6, 18))
$gc.FillEllipse($darkMaroon, 108, 68, 142, 142)
$darkMaroon.Dispose()

# Inner gold circular ring
$goldPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 215, 0), 2.5)
$gc.DrawEllipse($goldPen, 107, 67, 144, 144)
$goldPen.Dispose()

# Draw official SREC Crest
$crest = [System.Drawing.Bitmap]::FromFile($crestPath)
$gc.DrawImage($crest, 110, 70, 138, 138)
$crest.Dispose()

# Line 1: SREE SAKTHI
$path1 = New-Object System.Drawing.Drawing2D.GraphicsPath
$path1.AddString("SREE SAKTHI", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 48, (New-Object System.Drawing.Point(615, 36)), $sf)

$goldGlowPenC1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(195, 255, 230, 120), 4)
$goldGlowPenC1.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gc.DrawPath($goldGlowPenC1, $path1)

$crimsonBrushC1 = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 36)),
    (New-Object System.Drawing.Point(300, 115)),
    [System.Drawing.Color]::FromArgb(255, 185, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 95, 3, 12)
)
$gc.FillPath($crimsonBrushC1, $path1)
$path1.Dispose(); $goldGlowPenC1.Dispose(); $crimsonBrushC1.Dispose()

# Line 2: ENGINEERING COLLEGE
$path2 = New-Object System.Drawing.Drawing2D.GraphicsPath
$path2.AddString("ENGINEERING COLLEGE", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 30, (New-Object System.Drawing.Point(615, 118)), $sf)

$goldGlowPenC2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 255, 230, 120), 3)
$goldGlowPenC2.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gc.DrawPath($goldGlowPenC2, $path2)

$crimsonMidBrushC = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 118)),
    (New-Object System.Drawing.Point(300, 175)),
    [System.Drawing.Color]::FromArgb(255, 175, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 90, 3, 12)
)
$gc.FillPath($crimsonMidBrushC, $path2)
$path2.Dispose(); $goldGlowPenC2.Dispose(); $crimsonMidBrushC.Dispose()

# Line 3: AUTONOMOUS: TECHNICAL CAMPUS - KARAMADAI
$fontSub = New-Object System.Drawing.Font("Arial Black", 13.5, [System.Drawing.FontStyle]::Bold)
$darkSubBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 5, 10))
$gc.DrawString("AUTONOMOUS: TECHNICAL CAMPUS - KARAMADAI", $fontSub, $darkSubBrush, 615, 184, $sf)
$fontSub.Dispose(); $darkSubBrush.Dispose()

$gc.Dispose()

# Trim bottom tabs below y=232
for ($y = 232; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $college.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
    }
}
$college.Save($collegeDst, [System.Drawing.Imaging.ImageFormat]::Png)
$college.Dispose()
Write-Host "3. Generated: $collegeDst"

Write-Host "ALL 3 PLAQUES GENERATED FLAWLESSLY FROM SEAMLESS BASES!"
