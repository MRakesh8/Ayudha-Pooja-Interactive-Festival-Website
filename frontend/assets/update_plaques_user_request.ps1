Add-Type -AssemblyName System.Drawing

$deptPath = "d:\Downloads\project01\frontend\assets\plaque_dept_it_aids_perfect.png"
$techPath = "d:\Downloads\project01\frontend\assets\plaque_technitix_perfect.png"

# =========================================================================
# 1. UPDATE RIGHT PLAQUE: DEPARTMENT OF IT & AIDS (ONLY ONE '&')
# =========================================================================
$deptSrc = [System.Drawing.Bitmap]::FromFile($deptPath)
$w = $deptSrc.Width
$h = $deptSrc.Height

$dept = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gd = [System.Drawing.Graphics]::FromImage($dept)
$gd.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gd.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gd.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Draw base frame (including roundel with AI brain chip on left)
$gd.DrawImage($deptSrc, 0, 0, $w, $h)
$deptSrc.Dispose()

# Clear the text area on right: x=290 to 935, y=32 to 215 with matching brushed gold gradient
$rectText = New-Object System.Drawing.Rectangle(292, 32, 642, 182)
$pathD = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathD.AddRectangle($rectText)
$pgradD = New-Object System.Drawing.Drawing2D.PathGradientBrush($pathD)
$pgradD.CenterPoint = New-Object System.Drawing.PointF(615, 123)
$pgradD.CenterColor = [System.Drawing.Color]::FromArgb(255, 255, 245, 218)
$pgradD.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 242, 192, 105))
$gd.FillPath($pgradD, $pathD)
$pgradD.Dispose(); $pathD.Dispose()

# String format centered
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center

# Line 1: DEPARTMENT OF
$pathDep = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathDep.AddString("DEPARTMENT OF", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 44, (New-Object System.Drawing.Point(615, 42)), $sf)

$goldGlowPen1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(195, 255, 230, 120), 4)
$goldGlowPen1.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$gd.DrawPath($goldGlowPen1, $pathDep)

$crimsonBrush1 = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(300, 42)),
    (New-Object System.Drawing.Point(300, 105)),
    [System.Drawing.Color]::FromArgb(255, 185, 10, 25),
    [System.Drawing.Color]::FromArgb(255, 95, 3, 12)
)
$gd.FillPath($crimsonBrush1, $pathDep)
$pathDep.Dispose(); $goldGlowPen1.Dispose(); $crimsonBrush1.Dispose()

# Line 2: IT & AIDS (Large bold crimson serif with 3D gold bevel, ONLY ONE '&')
$pathIT = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathIT.AddString("IT & AIDS", (New-Object System.Drawing.FontFamily("Arial Black")), [int][System.Drawing.FontStyle]::Bold, 82, (New-Object System.Drawing.Point(615, 100)), $sf)

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
$dept.Save($deptPath, [System.Drawing.Imaging.ImageFormat]::Png)
$dept.Dispose()
Write-Host "Updated Department Plaque -> DEPARTMENT OF IT & AIDS"


# =========================================================================
# 2. UPDATE CENTER PLAQUE: TECHNITIX ONLY (REMOVE SUBTITLE, CENTER PROMINENTLY)
# =========================================================================
$techSrc = [System.Drawing.Bitmap]::FromFile($techPath)
$tw = $techSrc.Width
$th = $techSrc.Height

$tech = New-Object System.Drawing.Bitmap($tw, $th, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gt = [System.Drawing.Graphics]::FromImage($tech)
$gt.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gt.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$gt.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Draw base frame
$gt.DrawImage($techSrc, 0, 0, $tw, $th)
$techSrc.Dispose()

# Clear inner face (x=76 to 935, y=36 to 214) with brushed gold gradient to erase old text and subtitle
$rectTechInner = New-Object System.Drawing.Rectangle(76, 36, 860, 178)
$pathTI = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathTI.AddRectangle($rectTechInner)
$pgradTI = New-Object System.Drawing.Drawing2D.PathGradientBrush($pathTI)
$pgradTI.CenterPoint = New-Object System.Drawing.PointF(507, 125)
$pgradTI.CenterColor = [System.Drawing.Color]::FromArgb(255, 255, 245, 218)
$pgradTI.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 242, 192, 105))
$gt.FillPath($pgradTI, $pathTI)
$pgradTI.Dispose(); $pathTI.Dispose()

# TECHNITIX Title (Vertically & horizontally centered, majestic bold serif with 3D gold bevel)
# Center point: X=507, Y=62 for 92pt font so it fills the vertical center perfectly
$sfT = New-Object System.Drawing.StringFormat
$sfT.Alignment = [System.Drawing.StringAlignment]::Center

$pathTech = New-Object System.Drawing.Drawing2D.GraphicsPath
$pathTech.AddString("TECHNITIX", (New-Object System.Drawing.FontFamily("Georgia")), [int][System.Drawing.FontStyle]::Bold, 92, (New-Object System.Drawing.Point(507, 62)), $sfT)

# Gold bevel stroke
$goldBevelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(230, 255, 230, 110), 7)
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
$tech.Save($techPath, [System.Drawing.Imaging.ImageFormat]::Png)
$tech.Dispose()
Write-Host "Updated Center Plaque -> TECHNITIX (Subtitle removed, centered under crown)"
