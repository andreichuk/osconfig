function Io_DeleteFolderIfExists {
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

function Io_DeleteFileIfExists {
    param (
        $file_path
    )
    
    if ((Test-Path $file_path) -eq $false) {
        return;
    }
 
    "deleting ${file_path}"
    Remove-Item -Path $file_path -Force -ErrorAction SilentlyContinue -ErrorVariable RemoveItemError
    if($RemoveItemError) {
        "can't delete: " + $RemoveItemError
        Exit(1)
    }
}

function Io_CreateFolderIfNotExists {
    param (
        $folder_path
    )

    if ((Test-Path $folder_path)) {
        return;
    }
    
    "creating ${folder_path}"
    New-Item -Path $folder_path -ItemType Directory -Force
}