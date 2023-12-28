# Set the current working directory as the base path
$basePath = Get-Location

# Read original and translated names from text files
$originalNames = Get-Content -Path "original_names.txt" -ErrorAction SilentlyContinue
$translatedNames = Get-Content -Path "translated_names.txt" -ErrorAction SilentlyContinue

# Check if the number of original and translated names match
if ($originalNames.Count -ne $translatedNames.Count) {
    Write-Host "Error: The number of original and translated names does not match."
    exit
}

# Create a hashtable for translations
$translations = @{}
for ($i = 0; $i -lt $originalNames.Count; $i++) {
    $originalName = $originalNames[$i].Trim().ToLower()
    $translatedName = $translatedNames[$i].Trim()

    # Check if the key is not null or empty
    if ($originalName -ne $null -and $originalName -ne '') {
        $translations[$originalName] = $translatedName
    }
}

# Get the list of files in the current working directory
$files = Get-ChildItem -Path $basePath -File

# Rename each file using the translation (ignoring case and extension)
foreach ($file in $files) {
    $originalNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($file.Name).ToLower()

    # Check if the translations hashtable contains the key
    if ($translations -ne $null -and $translations.ContainsKey($originalNameWithoutExtension)) {
        $translatedName = $translations[$originalNameWithoutExtension]
        $extension = $file.Extension
        $newPath = Join-Path -Path $basePath -ChildPath "$translatedName$extension"
        Rename-Item -Path $file.FullName -NewName $newPath
    }
}
