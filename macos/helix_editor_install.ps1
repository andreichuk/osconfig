$editor_src_folder = "~/tmp/helix_editor"

function l_DeleteSrcFolder {
    if(Test-Path $editor_src_folder) {
        Remove-Item –path $editor_src_folder -Recurse -Force
    }    
}

l_DeleteSrcFolder
git clone "https://github.com/helix-editor/helix" $editor_src_folder
Push-Location $editor_src_folder
& cargo uninstall helix-term
& cargo install --path helix-term
& hx --grammar fetch
& hx --grammar build
l_DeleteSrcFolder
Pop-Location
"done"