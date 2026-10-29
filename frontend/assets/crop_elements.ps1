Add-Type -AssemblyName System.Drawing

$srcPath = (Resolve-Path ".\frontend\assets\technitix_ayudha_puja_gateway_ref.png").Path
$img = [System.Drawing.Bitmap]::FromFile($srcPath)
Write-Output "Image Dimensions: $($img.Width) x $($img.Height)"

# In the image (typically 1920x1080 or 1792x1024):
# Top left plaque: around y: 15 to 135, x: 120 to 760
# Top right plaque: around y: 15 to 135, x: 1160 to 1800
# Bottom Ayudha Pooja banner: around y: 650 to 1050, x: 300 to 1620

$w = $img.Width
$h = $img.Height

Write-Output "Image loaded successfully"
$img.Dispose()
