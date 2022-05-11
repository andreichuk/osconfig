$folder_path_config_powershell = '~/.config/powershell' 

# powershell config
New-Item -Path $folder_path_config_powershell -ItemType Directory
Copy-Item (Join-Path $PSScriptRoot "profile.ps1") $folder_path_config_powershell
