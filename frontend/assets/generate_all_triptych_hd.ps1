Add-Type -AssemblyName System.Drawing

# Paths
$deptPath = "d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png"
$collegePath = "d:\Downloads\project01\frontend\assets\plaque_college_hd_perfect.png"
$techPath = "d:\Downloads\project01\frontend\assets\plaque_technitix_hd_perfect.png"
$crestPath = "d:\Downloads\project01\frontend\assets\srec_crest.png"

# ========================================================
# 1. Clean the base Dept plaque of any bottom yellow tabs
# ========================================================
$origDept = [System.Drawing.Bitmap]::FromFile($deptPath)
$dept = New-Object System.Drawing.Bitmap($origDept)
$origDept.Dispose()
$w = $dept.Width
$h = $dept.Height

# Make sure any stray bottom pixels below y=233 are transparent
for ($y = 233; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $dept.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
    }
}
$dept.Save($deptPath, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Dept plaque bottom cleaned: $w x $h"

# ========================================================
# 2. Generate HD College Plaque
# ========================================================
$college = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gc = [System.Drawing.Graphics]::FromImage($college)
$gc.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gc.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gc.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Draw base frame
$gc.DrawImage($dept, 0, 0, $w, $h)

# Fill text area with identical gold gradient
$pathC = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathC.AddRectangle((New-Object System.Drawing.Rectangle(290, 28, 655, 204)))
$pgradC = New-Object System.Drawing.Drawing2D.PathGradientBrush($pathC)
$pgradC.CenterPoint = New-Object System.Drawing.PointF(620, 130)
$pgradC.CenterColor = [System.Drawing.Color]::FromArgb(255, 255, 245, 215)
$pgradC.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 240, 185, 95))
$gc.FillPath($pgradC, $pathC)
$pgradC.Dispose()
$pathC.Dispose()

# Fill roundel center with deep velvet maroon
$darkMaroon = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 115, 6, 18))
$gc.FillEllipse($darkMaroon, 108, 68, 142, 142)
$darkMaroon.Dispose()

# Inner gold circular ring
$goldPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 215, 0), 2.5)
$gc.DrawEllipse($goldPen, 107, 67, 144, 144)
$goldPen.Dispose()

# Draw official crest
$crest = [System.Drawing.Bitmap]::FromFile($crestPath)
$gc.DrawImage($crest, 110, 70, 138, 138)
$crest.Dispose()

# Fonts & String format
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center

# SREE SAKTHI (Large bold serif crimson with gold bevel)
$path1 = New-Object System.Drawing.Drawing2D.GraphicsPath
$path1.AddString("SREE SAKTHI", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 48, (New-Object System.Drawing.Point(620, 35)), $sf)

$goldGlowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(190, 255, 230, 120), 4)
$goldGlowPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gc.DrawPath($goldGlowPen, $path1)

$crimsonBrush1 = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 35)),
    (New-Object System.Drawing.Point(300, 120)),
    [System.Drawing.Color]::FromArgb(255, 185, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 95, 3, 12)
)
$gc.FillPath($crimsonBrush1, $path1)
$path1.Dispose(); $goldGlowPen.Dispose(); $crimsonBrush1.Dispose()

# ENGINEERING COLLEGE
$path2 = New-Object System.Drawing.Drawing2D.GraphicsPath
$path2.AddString("ENGINEERING COLLEGE", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 30, (New-Object System.Drawing.Point(620, 118)), $sf)

$goldGlowPen2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 255, 230, 120), 3)
$goldGlowPen2.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gc.DrawPath($goldGlowPen2, $path2)

$crimsonMidBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 118)),
    (New-Object System.Drawing.Point(300, 180)),
    [System.Drawing.Color]::FromArgb(255, 175, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 90, 3, 12)
)
$gc.FillPath($crimsonMidBrush, $path2)
$path2.Dispose(); $goldGlowPen2.Dispose(); $crimsonMidBrush.Dispose()

# AUTONOMOUS: TECHNICAL CAMPUS - KARAMADAI
$fontSub = New-Object System.Drawing.Font("Arial Black", 14, [System.Drawing.FontStyle]::Bold)
$darkSubBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 5, 10))
$gc.DrawString("AUTONOMOUS: TECHNICAL CAMPUS - KARAMADAI", $fontSub, $darkSubBrush, 620, 186, $sf)
$fontSub.Dispose(); $darkSubBrush.Dispose()

$gc.Dispose()
$college.Save($collegePath, [System.Drawing.Imaging.ImageFormat]::Png)
$college.Dispose()
Write-Host "College plaque regenerated: $collegePath"

# ========================================================
# 3. Generate HD Center TECHNITIX Plaque with Royal Crown
# ========================================================
$tech = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gt = [System.Drawing.Graphics]::FromImage($tech)
$gt.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gt.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gt.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Draw base frame
$gt.DrawImage($dept, 0, 0, $w, $h)

# Clear ALL inner face including roundel petals: x=50 to x=955, y=20 to y=232
$pathT = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathT.AddRectangle((New-Object System.Drawing.Rectangle(55, 20, 895, 212)))
$pgradT = New-Object System.Drawing.Drawing2D.PathGradientBrush($pathT)
$pgradT.CenterPoint = New-Object System.Drawing.PointF(503, 125)
$pgradT.CenterColor = [System.Drawing.Color]::FromArgb(255, 255, 245, 215)
$pgradT.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 240, 185, 95))
$gt.FillPath($pgradT, $pathT)
$pgradT.Dispose()
$pathT.Dispose()

# Royal Crown at top center
# Crown Arch (deep velvet maroon dome)
$velvetBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(440, 5)),
    (New-Object System.Drawing.Point(440, 36)),
    [System.Drawing.Color]::FromArgb(255, 180, 20, 30),
    [System.Drawing.Color]::FromArgb(255, 90, 5, 15)
)
$gt.FillPie($velvetBrush, 448, 6, 110, 56, 180, 180)
$velvetBrush.Dispose()

# Golden cross-bars across velvet dome
$goldArchPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 215, 60), 3)
$gt.DrawArc($goldArchPen, 458, 10, 90, 50, 195, 150)
$gt.DrawLine($goldArchPen, 503, 6, 503, 34)
$goldArchPen.Dispose()

# Crown Gold Headband with decorative gradient
$goldCrownBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(440, 28)),
    (New-Object System.Drawing.Point(566, 28)),
    [System.Drawing.Color]::FromArgb(255, 215, 140, 25),
    [System.Drawing.Color]::FromArgb(255, 255, 235, 150)
)
$gt.FillRectangle($goldCrownBrush, 442, 28, 122, 10)

# 5 Royal Golden Spikes/Fleurs
$spikePoints = @(
    (New-Object System.Drawing.Point(442, 28)),
    (New-Object System.Drawing.Point(442, 12)),
    (New-Object System.Drawing.Point(457, 22)),
    (New-Object System.Drawing.Point(475, 4)),
    (New-Object System.Drawing.Point(490, 20)),
    (New-Object System.Drawing.Point(503, -1)),
    (New-Object System.Drawing.Point(516, 20)),
    (New-Object System.Drawing.Point(531, 4)),
    (New-Object System.Drawing.Point(549, 22)),
    (New-Object System.Drawing.Point(564, 12)),
    (New-Object System.Drawing.Point(564, 28))
)
$gt.FillPolygon($goldCrownBrush, $spikePoints)

# Jewel tips (Emerald, Ruby, Diamond Cross, Ruby, Emerald)
$jewelRed = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 20, 30))
$jewelCyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 215))
$jewelDiamond = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 250))
$jewelGold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 215, 0))

$gt.FillEllipse($jewelCyan, 439, 9, 7, 7)
$gt.FillEllipse($jewelRed, 471, 1, 8, 8)
# Apex Golden Cross & Pearl
$gt.FillEllipse($jewelDiamond, 499, -5, 8, 8)
$gt.FillRectangle($jewelGold, 501, -9, 4, 12)
$gt.FillRectangle($jewelGold, 497, -7, 12, 4)
$gt.FillEllipse($jewelRed, 527, 1, 8, 8)
$gt.FillEllipse($jewelCyan, 560, 9, 7, 7)

# Pearls / Rubies on Crown Headband
for ($gx = 452; $gx -le 554; $gx += 14) {
    $gt.FillEllipse($jewelRed, $gx, 30, 6, 6)
    $gt.FillEllipse($jewelDiamond, $gx + 1, 31, 2, 2)
}

$jewelRed.Dispose(); $jewelCyan.Dispose(); $jewelDiamond.Dispose(); $jewelGold.Dispose(); $goldCrownBrush.Dispose()

# TECHNITIX Typography
# Title: Big bold majestic serif
$pathTech = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathTech.AddString("TECHNITIX", (New-Object System.Drawing.FontFamily("Georgia")), [int][System.Drawing.FontStyle]::Bold, 76, (New-Object System.Drawing.Point(503, 46)), $sf)

# Gold bevel stroke
$goldBevelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 255, 230, 110), 6)
$goldBevelPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gt.DrawPath($goldBevelPen, $pathTech)

# Deep crimson gradient fill
$crimsonFill = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(503, 46)),
    (New-Object System.Drawing.Point(503, 150)),
    [System.Drawing.Color]::FromArgb(255, 185, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 80, 2, 10)
)
$gt.FillPath($crimsonFill, $pathTech)
$goldBevelPen.Dispose(); $crimsonFill.Dispose(); $pathTech.Dispose()

# NATIONAL LEVEL TECHNICAL SYMPOSIUM Subtitle
$subFont = New-Object System.Drawing.Font("Arial Black", 16, [System.Drawing.FontStyle]::Bold)
$subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 50, 10, 15))
$gt.DrawString("NATIONAL LEVEL TECHNICAL SYMPOSIUM", $subFont, $subBrush, 503, 162, $sf)
$subFont.Dispose(); $subBrush.Dispose()

$gt.Dispose()
$tech.Save($techPath, [System.Drawing.Imaging.ImageFormat]::Png)
$tech.Dispose()
$dept.Dispose()

Write-Host "All 3 HD plaques regenerated with 100% matched frames, typography & crests!"
