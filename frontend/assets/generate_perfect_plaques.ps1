Add-Type -AssemblyName System.Drawing

# 1. COLLEGE PLAQUE
$ref = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\ref_left_plaque.png").Path)
$g = [System.Drawing.Graphics]::FromImage($ref)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

# Clean entire background circle with warm gold/ivory brush
$bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 252, 230, 190))
$g.FillEllipse($bgBrush, 68, 2, 118, 114)
$bgBrush.Dispose()

# Draw the official crisp SREC crest
$crest = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\srec_crest.png").Path)
$g.DrawImage($crest, 73, 5, 108, 108)
$crest.Dispose()
$g.Dispose()

# Trim left border to remove stone pillar artifact (first 28px)
$trimRect = New-Object System.Drawing.Rectangle(28, 0, ($ref.Width - 32), $ref.Height)
$finalCollege = $ref.Clone($trimRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Clean all corners and edges outside the gold plaque
for ($y = 0; $y -lt $finalCollege.Height; $y++) {
    for ($x = 0; $x -lt $finalCollege.Width; $x++) {
        # Outside left frame
        if ($x -lt 20) {
            $finalCollege.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
        # Bottom left corner stone pillar: clear anything that is not part of the seal or gold frame
        if ($x -lt 68 -and $y -gt 65) {
            $c = $finalCollege.GetPixel($x, $y)
            $dx = $x - 94
            $dy = $y - 59
            $distSq = $dx * $dx + $dy * $dy
            if ($distSq -gt (54 * 54)) {
                $finalCollege.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            }
        }
    }
}
$ref.Dispose()
$finalCollege.Save("d:\Downloads\project01\frontend\assets\plaque_college_perfect.png", [System.Drawing.Imaging.ImageFormat]::Png)
$finalCollege.Dispose()

# 2. DEPT PLAQUE
$deptRef = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\ref_right_plaque.png").Path)
$deptTrimRect = New-Object System.Drawing.Rectangle(5, 0, ($deptRef.Width - 32), $deptRef.Height)
$finalDept = $deptRef.Clone($deptTrimRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$deptRef.Dispose()

for ($y = 0; $y -lt $finalDept.Height; $y++) {
    for ($x = 0; $x -lt $finalDept.Width; $x++) {
        # Outside right frame
        if ($x -gt ($finalDept.Width - 18)) {
            $finalDept.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
        # Bottom right stone:
        if ($x -gt ($finalDept.Width - 65) -and $y -gt 65) {
            $c = $finalDept.GetPixel($x, $y)
            if ($c.A -gt 0 -and ($c.R -lt 165 -or ($c.R - $c.B) -lt 25)) {
                $finalDept.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            }
        }
    }
}
$finalDept.Save("d:\Downloads\project01\frontend\assets\plaque_dept_perfect.png", [System.Drawing.Imaging.ImageFormat]::Png)
$finalDept.Dispose()

Write-Output "Both plaques successfully saved!"
