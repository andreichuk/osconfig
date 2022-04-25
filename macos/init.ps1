$folder_path_config_powershell = '~/.config/powershell' 
$folder_path_scripts = '~/scripts'

# powershell config
New-Item -Path $folder_path_config_powershell -ItemType Directory
Copy-Item (Join-Path $PSScriptRoot "profile.ps1") $folder_path_config_powershell

# scripts
New-Item -Path $folder_path_scripts -ItemType Directory
Copy-Item -Path (Join-Path $PSScriptRoot "helix_editor_install.ps1") -Destination $folder_path_scripts
Copy-Item -Path (Join-Path $PSScriptRoot "kakoune_editor_install.ps1") -Destination $folder_path_scripts
Copy-Item -Path (Join-Path $PSScriptRoot "zig_compiler_download.ps1") -Destination $folder_path_scripts
