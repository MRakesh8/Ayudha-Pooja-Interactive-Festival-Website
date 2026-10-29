Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile("C:\Users\rakes\.gemini\antigravity-ide\brain\48bb4a45-86be-4a0d-a0a4-0212f1a3375e\.user_uploaded\media_1792079923641.jpg")

# 1. Left Plaque
$rectL = New-Object System.Drawing.Rectangle(105, 15, 205, 60)
$cropL = $img.Clone($rectL, $img.PixelFormat)
$cropL.Save("d:\Downloads\project01\frontend\assets\crop_left_ref3.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cropL.Dispose()

# 2. Center Plaque
$rectC = New-Object System.Drawing.Rectangle(445, 15, 210, 60)
$cropC = $img.Clone($rectC, $img.PixelFormat)
$cropC.Save("d:\Downloads\project01\frontend\assets\crop_center_ref3.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cropC.Dispose()

# 3. Right Plaque
$rectR = New-Object System.Drawing.Rectangle(790, 15, 210, 60)
$cropR = $img.Clone($rectR, $img.PixelFormat)
$cropR.Save("d:\Downloads\project01\frontend\assets\crop_right_ref3.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cropR.Dispose()

$img.Dispose()
Write-Host "Cropped all 3 plaques from ref3"
