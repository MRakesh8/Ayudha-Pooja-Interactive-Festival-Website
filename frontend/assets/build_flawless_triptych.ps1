Add-Type -AssemblyName System.Drawing

$deptPath = "d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png"
$collegePath = "d:\Downloads\project01\frontend\assets\plaque_college_hd_perfect.png"
$techPath = "d:\Downloads\project01\frontend\assets\plaque_technitix_hd_perfect.png"
$crestPath = "d:\Downloads\project01\frontend\assets\srec_crest.png"

# Load source
$src = [System.Drawing.Bitmap]::FromFile($deptPath)
$w = $src.Width
$h = $src.Height

# =========================================================================
# STEP 1: CLEAN BASE FRAME (DEPT PLAQUE)
# =========================================================================
$cleanDept = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gd = [System.Drawing.Graphics]::FromImage($cleanDept)
$gd.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gd.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gd.DrawImage($src, 0, 0, $w, $h)
$gd.Dispose()
$src.Dispose()

# Make any pixels below the bottom gold molding (y >= 233) transparent
for ($y = 232; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $cleanDept.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
    }
}
$cleanDept.Save($deptPath, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "1. Department plaque cleaned: $deptPath"

# =========================================================================
# STEP 2: GENERATE COLLEGE PLAQUE (100% MATCHED)
# =========================================================================
$college = New-Object System.Drawing.Bitmap($cleanDept)
$gc = [System.Drawing.Graphics]::FromImage($college)
$gc.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gc.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gc.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Clear text region inside gold frame: x=290 to 935, y=32 to 214
$rectText = New-Object System.Drawing.Rectangle(292, 32, 642, 182)
$pathC = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathC.AddRectangle($rectText)
$pgradC = New-Object System.Drawing.Drawing2D.PathGradientBrush($pathC)
$pgradC.CenterPoint = New-Object System.Drawing.PointF(615, 123)
$pgradC.CenterColor = [System.Drawing.Color]::FromArgb(255, 255, 245, 218)
$pgradC.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 242, 192, 105))
$gc.FillPath($pgradC, $pathC)
$pgradC.Dispose(); $pathC.Dispose()

# Fill roundel center with deep velvet maroon
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

# String format
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center

# Line 1: SREE SAKTHI
$path1 = New-Object System.Drawing.Drawing2D.GraphicsPath
$path1.AddString("SREE SAKTHI", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 48, (New-Object System.Drawing.Point(615, 36)), $sf)

$goldGlowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(195, 255, 230, 120), 4)
$goldGlowPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gc.DrawPath($goldGlowPen, $path1)

$crimsonBrush1 = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 36)),
    (New-Object System.Drawing.Point(300, 115)),
    [System.Drawing.Color]::FromArgb(255, 185, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 95, 3, 12)
)
$gc.FillPath($crimsonBrush1, $path1)
$path1.Dispose(); $goldGlowPen.Dispose(); $crimsonBrush1.Dispose()

# Line 2: ENGINEERING COLLEGE
$path2 = New-Object System.Drawing.Drawing2D.GraphicsPath
$path2.AddString("ENGINEERING COLLEGE", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 30, (New-Object System.Drawing.Point(615, 118)), $sf)

$goldGlowPen2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 255, 230, 120), 3)
$goldGlowPen2.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gc.DrawPath($goldGlowPen2, $path2)

$crimsonMidBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 118)),
    (New-Object System.Drawing.Point(300, 175)),
    [System.Drawing.Color]::FromArgb(255, 175, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 90, 3, 12)
)
$gc.FillPath($crimsonMidBrush, $path2)
$path2.Dispose(); $goldGlowPen2.Dispose(); $crimsonMidBrush.Dispose()

# Line 3: AUTONOMOUS: TECHNICAL CAMPUS - KARAMADAI
$fontSub = New-Object System.Drawing.Font("Arial Black", 13.5, [System.Drawing.FontStyle]::Bold)
$darkSubBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 5, 10))
$gc.DrawString("AUTONOMOUS: TECHNICAL CAMPUS - KARAMADAI", $fontSub, $darkSubBrush, 615, 184, $sf)
$fontSub.Dispose(); $darkSubBrush.Dispose()

$gc.Dispose()
$college.Save($collegePath, [System.Drawing.Imaging.ImageFormat]::Png)
$college.Dispose()
Write-Host "2. College plaque generated: $collegePath"

# =========================================================================
# STEP 3: GENERATE TECHNITIX CENTER PLAQUE WITH CROWN (100% MATCHED)
# =========================================================================
$tech = New-Object System.Drawing.Bitmap($cleanDept)
$gt = [System.Drawing.Graphics]::FromImage($tech)
$gt.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gt.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gt.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# 1. Fill entire inner area between borders (x=76 to 932, y=32 to 215) with smooth brushed gold gradient
$rectInner = New-Object System.Drawing.Rectangle(75, 32, 858, 183)
$pathT = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathT.AddRectangle($rectInner)
$pgradT = New-Object System.Drawing.Drawing2D.PathGradientBrush($pathT)
$pgradT.CenterPoint = New-Object System.Drawing.PointF(503, 123)
$pgradT.CenterColor = [System.Drawing.Color]::FromArgb(255, 255, 245, 218)
$pgradT.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 242, 192, 105))
$gt.FillPath($pgradT, $pathT)
$pgradT.Dispose(); $pathT.Dispose()

# 2. Repair bottom gold border where the roundel leaf dipped (from x=75 to x=285, y=214 to y=232)
# Sample pristine border section from x=400 to 600, y=214 to 232
$borderSampleRect = New-Object System.Drawing.Rectangle(400, 214, 200, 18)
$borderSample = $cleanDept.Clone($borderSampleRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gt.DrawImage($borderSample, 75, 214, 210, 18)
$borderSample.Dispose()

# 3. Draw Royal Imperial Crown at top apex (centered at X=503)
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

# 4. TECHNITIX Title (Big bold serif with gold bevel and rich crimson body)
$pathTech = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathTech.AddString("TECHNITIX", (New-Object System.Drawing.FontFamily("Georgia")), [int][System.Drawing.FontStyle]::Bold, 76, (New-Object System.Drawing.Point(503, 46)), $sf)

$goldBevelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 255, 230, 110), 6)
$goldBevelPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gt.DrawPath($goldBevelPen, $pathTech)

$crimsonFill = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(503, 46)),
    (New-Object System.Drawing.Point(503, 145)),
    [System.Drawing.Color]::FromArgb(255, 185, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 80, 2, 10)
)
$gt.FillPath($crimsonFill, $pathTech)
$goldBevelPen.Dispose(); $crimsonFill.Dispose(); $pathTech.Dispose()

# 5. NATIONAL LEVEL TECHNICAL SYMPOSIUM Subtitle
$subFont = New-Object System.Drawing.Font("Arial Black", 16, [System.Drawing.FontStyle]::Bold)
$subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 50, 10, 15))
$gt.DrawString("NATIONAL LEVEL TECHNICAL SYMPOSIUM", $subFont, $subBrush, 503, 162, $sf)
$subFont.Dispose(); $subBrush.Dispose()

$gt.Dispose()
$tech.Save($techPath, [System.Drawing.Imaging.ImageFormat]::Png)
$tech.Dispose()
$cleanDept.Dispose()

Write-Host "3. Technitix center plaque generated: $techPath"
Write-Host "SUCCESS: All 3 HD plaques created with identical frames, continuous borders, and matching colors!"
