$images_dir = "Archives_and_Media\Images_and_Screenshots"
$output_dir = "ocr_output"

if (!(Test-Path $output_dir)) {
    New-Item -ItemType Directory -Path $output_dir
}

# List files to OCR (GUID-like and most recent)
$files = Get-ChildItem $images_dir | Where-Object { 
    $_.Extension -match "\.tiff|\.TIFF|\.jpg|\.png" -and 
    ($_.Name -match "^[a-f0-9-]{36}" -or $_.Name -match "^babf")
}

foreach ($file in $files) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $outputPath = Join-Path $output_dir ($baseName + "_ocr")
    Write-Host "Processing $($file.Name)..."
    tesseract $file.FullName $outputPath
}
