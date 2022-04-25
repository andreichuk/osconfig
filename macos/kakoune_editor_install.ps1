$editor_src_folder = "~/tmp/kakoune_editor"

function l_DeleteSrcFolder {
    if(Test-Path $editor_src_folder) {
        Remove-Item –path $editor_src_folder -Recurse -Force
    }    
}

l_DeleteSrcFolder
Remove-Item –path $editor_src_folder -Recurse -Force
git clone "https://github.com/mawww/kakoune" $editor_src_folder
Push-Location $editor_src_folder
& make
& make install
l_DeleteSrcFolder
Pop-Location
"done"