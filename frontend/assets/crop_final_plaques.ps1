Add-Type -AssemblyName System.Drawing

$srcLeft = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\ref_left_plaque.png").Path)
$rectL = New-Object System.Drawing.Rectangle(28, 0, ($srcLeft.Width - 32), $srcLeft.Height)
$croppedL = $srcLeft.Clone($rectL, $srcLeft.PixelFormat)
$croppedL.Save("d:\Downloads\project01\frontend\assets\plaque_college.png", [System.Drawing.Imaging.ImageFormat]::Png)
$srcLeft.Dispose()
$croppedL.Dispose()

$srcRight = [System.Drawing.Bitmap]::FromFile((Resolve-Path ".\frontend\assets\ref_right_plaque.png").Path)
$rectR = New-Object System.Drawing.Rectangle(5, 0, ($srcRight.Width - 32), $srcRight.Height)
$croppedR = $srcRight.Clone($rectR, $srcRight.PixelFormat)
$croppedR.Save("d:\Downloads\project01\frontend\assets\plaque_dept.png", [System.Drawing.Imaging.ImageFormat]::Png)
$srcRight.Dispose()
$croppedR.Dispose()

Write-Output "Clean plaques generated: plaque_college.png and plaque_dept.png"
