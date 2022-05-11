. "$PSScriptRoot/../io_util.ps1"

$url_zig_downloads = "https://ziglang.org/download/"

$folder_source = Join-Path $env:HOME "Downloads"
$path_archive = Join-Path $folder_source "zig_compiler.tar.xz"
$folder_zig = Join-Path $env:HOME "zig_stuff" "compiler"

Io_DeleteFolderIfExists $folder_zig
Io_DeleteFileIfExists $path_archive

Io_CreateFolderIfNotExists $folder_zig
Io_CreateFolderIfNotExists $folder_source

$webResponse = Invoke-WebRequest -Uri $url_zig_downloads
$url_zig_archive =  $webResponse.Links |
    Select-Object href |
    Out-String -Stream |
    Select-String -Pattern ".*\/zig-linux-x86_64-.+-dev\..+\.tar.xz" -Raw |
    Select-Object -First 1

"archive url: ${url_zig_archive}"

Invoke-WebRequest -Uri $url_zig_archive -OutFile $path_archive

"compiler: extracting '${path_archive}' in '${folder_zig}'"
#Expand-Archive $path_archive -DestinationPath $folder_zig
tar -xf $path_archive -C $folder_zig --strip-components 1

"done"