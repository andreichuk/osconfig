$url_zig_downloads = "https://ziglang.org/download/"
$url_zig_tools_src = "https://github.com/zigtools/zls"

$folder_source = Join-Path $env:TEMP "zig_stuff"
$path_archive = Join-Path $folder_source "zig_win_64.zip"
$folder_zig = "C:/zig"
$folder_zig_languageServer_source = Join-Path $folder_source "src_language_server"
$zig = Join-Path $folder_zig "zig"
$path_zls = Join-Path $folder_zig_languageServer_source "zig-out/bin/zls.exe"

function l_DeleteFolderIfExists {
    param (
        $folder_path
    )
    
    if ((Test-Path $folder_path) -eq $false) {
        return;
    }
 
    "deleting ${folder_path}"
    Remove-Item -Path $folder_path -Recurse -Force -ErrorAction SilentlyContinue -ErrorVariable RemoveItemError
    if($RemoveItemError) {
        "can't delete: " + $RemoveItemError
        Exit(1)
    }
}

function l_CreateFolder {
    param (
        $folder_path
    )
    
    "creating ${folder_path}"
    New-Item -Path $folder_path -ItemType Directory -Force
}

l_DeleteFolderIfExists $folder_zig
l_DeleteFolderIfExists $folder_source

l_CreateFolder $folder_zig
l_CreateFolder $folder_source

$webResponse = Invoke-WebRequest -Uri $url_zig_downloads
$url_zig_archive =  $webResponse.Links |
    Select-Object href |
    Out-String -Stream |
    Select-String -Pattern ".*\/zig-windows-x86_64-.+-dev\..+\.zip" -Raw |
    Select-Object -First 1

"archive url: ${url_zig_archive}"

Invoke-WebRequest -Uri $url_zig_archive -OutFile $path_archive

"compiler: extracting '${path_archive}' in '${folder_zig}'"
#Expand-Archive $path_archive -DestinationPath $folder_zig
tar -xf $path_archive -C $folder_zig --strip-components 1

"lang server: cloning"
git clone --recurse-submodules $url_zig_tools_src $folder_zig_languageServer_source
Push-Location $folder_zig_languageServer_source
Get-Location 
& $zig build -Drelease-safe
Pop-Location

if ($LASTEXITCODE -ne 0) {
    "zls compilation failed. Exit code ${LASTEXITCODE}"
    Exit(1)
}

"lang server: copy binary"
Copy-Item -Path $path_zls -Destination $folder_zig

"lang server: delete sources"
Remove-Item $folder_zig_languageServer_source -Force -Recurse

l_DeleteFolderIfExists $folder_source

"done"