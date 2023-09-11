# Define a function to calculate the hash of a file
Function Calculate-File-Hash($filepath) {
    try {
        $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
        return $filehash
    }
    catch {
        # Handle any errors that occur when calculating the hash
        Write-Host "Error calculating hash for $filepath $_" -ForegroundColor Red
        return $null
    }
}

# Define a function to erase the baseline file if it already exists
Function Erase-Baseline-If-Already-Exists() {
    if (Test-Path -Path .\baseline.txt) {
        Remove-Item -Path .\baseline.txt
    }
}

# Define a function to read the baseline data from the baseline.txt file into a hashtable
Function Get-Baseline {
    $baseline = @{}
    if (Test-Path -Path .\baseline.txt) {
        $filePathsAndHashes = Get-Content -Path .\baseline.txt
        foreach ($f in $filePathsAndHashes) {
            $split = $f.Split("|")
            $baseline[$split[0]] = $split[1]
        }
    }
    return $baseline
}

# Define a function to update the baseline file with new data
Function Update-Baseline($baseline) {
    $baseline.GetEnumerator() | ForEach-Object {
        "$($_.Key)|$($_.Value)" | Out-File -FilePath .\baseline.txt -Append
    }
}

# Main script execution starts here

Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "    A) Collect new Baseline?"
Write-Host "    B) Begin monitoring files with saved Baseline?"
Write-Host ""
$response = Read-Host -Prompt "Please enter 'A' or 'B'"
Write-Host ""

if ($response -eq "A".ToUpper()) {
    # If the user chooses to collect a new baseline

    Erase-Baseline-If-Already-Exists  # Remove the existing baseline file if it exists
    $baseline = @{}  # Initialize an empty hashtable to store the baseline data

    $files = Get-ChildItem -Path .\Files  # Get a list of files in the "Files" directory
    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName  # Calculate the hash of each file
        if ($hash -ne $null) {
            $baseline[$hash.Path] = $hash.Hash  # Store the file path and hash in the baseline hashtable
        }
    }

    Update-Baseline $baseline  # Update the baseline file with the new baseline data
}

elseif ($response -eq "B".ToUpper()) {
    # If the user chooses to begin monitoring with the saved baseline

    $fileHashDictionary = Get-Baseline  # Load the baseline data into a hashtable

    while ($true) {
        Start-Sleep -Seconds 1

        $files = Get-ChildItem -Path .\Files  # Get a list of files in the "Files" directory
        foreach ($f in $files) {
            $hash = Calculate-File-Hash $f.FullName  # Calculate the hash of each file

            if ($hash -ne $null) {
                if ($fileHashDictionary.ContainsKey($hash.Path)) {
                    if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                        # The file has not changed
                    }
                    else {
                        Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
                    }
                }
                else {
                    Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
                }
            }
        }

        $baselinePaths = $fileHashDictionary.Keys
        $baselinePathsToRemove = @()  # Create a list to store paths to remove

        foreach ($path in $baselinePaths) {
            if (-Not (Test-Path -Path $path)) {
                Write-Host "$($path) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
                $baselinePathsToRemove += $path  # Add paths to remove to the list
              
            }
        }
        # Remove the paths after the loop
        foreach ($pathToRemove in $baselinePathsToRemove) {
            $fileHashDictionary.Remove($pathToRemove)
        }

        Update-Baseline $fileHashDictionary  # Update the baseline file with any changes in the monitored files
    }
}
