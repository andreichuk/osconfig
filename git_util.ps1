function Git_CloneOrUpdateRepo {
    param (
        $path_folder,
        $url_repo
    )
    
    if(Test-Path (Join-Path $path_folder ".git")) {
        # git repo already exists
        "repo updating from the origin"
        Push-Location $path_folder
        git reset --hard HEAD 
        git checkout master
        git pull origin master
        Pop-Location
    } else {
        "repo cloning"
        git clone --recurse-submodules $url_repo $path_folder
    }   
}