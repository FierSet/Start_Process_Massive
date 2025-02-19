$selfPath = Split-Path -Parent $PSCommandPath

Write-Output "Installing programs."
Write-Output "`n"#"Script location: $selfPath"

function install_program ($program, $name){

    $job = Start-Process -FilePath $program -ArgumentList "/silent" -PassThru -Verb RunAs #-Wait

    $job.WaitForExit()

    if($job.ExitCode -eq 0){
        Write-Host "Installing: $name Success." -ForegroundColor Green
    }elseif($job.ExitCode -eq 3010){
        Write-Host "Installing: $name Success, Reboot Required." -ForegroundColor Blue
    }else{
        Write-Host "Installing: $name Fatal Error: no installed." -ForegroundColor Red
    }

}

$current_file_nom = 0

$nomfiles = (Get-ChildItem -Path ($selfPath + "\programs") -File).Count

Get-ChildItem -Path ($selfPath + "\programs") | ForEach-Object {
    
    Write-Output "Installing: $($_.Name)."

    $percentComplete = ($current_file_nom / $nomfiles) * 100

    Write-Progress -Activity "Processing..." -Status "$percentComplete% Complete" -PercentComplete $percentComplete

    install_program $_.FullName $_.Name

    $current_file_nom++
}

Write-Output "`n"
Write-Host "Process completed." -ForegroundColor Green