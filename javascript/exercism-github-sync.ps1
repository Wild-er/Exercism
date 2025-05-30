# exercism-github-sync.ps1

# --- Configuration ---
# IMPORTANT: Adjust these paths to match your setup!
# Base directory where Exercism downloads exercises.
# This is the parent directory of your individual exercise folders (e.g., 'lasagna').
# This path will be used if an exercise name is provided as an argument.
$configuredExercismBaseDir = "C:\Users\Wilde\Exercism\javascript"

# Base directory of your cloned GitHub Exercism repository.
# This is where your 'javascript' folder (for solutions) is located.
$githubRepoDir = "C:\Users\Wilde\Documents\Code Projects\Exercism\javascript"

# The default branch name of your GitHub repository (usually 'main' or 'master').
$gitBranch = "main"
# --- End Configuration ---

# Initialize variables
$exerciseName = $null
$exercismCurrentExerciseDir = $null # This will be the directory where the solution file is located

# Determine exercise name and relevant Exercism directory
if ($args.Count -eq 0) {
    # No exercise name provided, try to infer from current directory
    $currentLocation = Get-Location
    $inferredExerciseName = $currentLocation.BaseName # Get the last part of the path (e.g., 'lasagna')

    # Check if the current directory is likely an Exercism exercise folder
    # by checking if its parent is the configured base directory
    if ($currentLocation.Parent.Path -eq $configuredExercismBaseDir) {
        $exerciseName = $inferredExerciseName
        $exercismCurrentExerciseDir = $currentLocation.Path
        Write-Host "Inferred exercise name from current directory: '$exerciseName'" -ForegroundColor Green
    } else {
        Write-Host "Error: No exercise name provided and not run from an Exercism exercise directory." -ForegroundColor Red
        Write-Host "Please run the script from an exercise directory (e.g., `C:\Users\Wilde\Exercism\javascript\lasagna`)" -ForegroundColor Yellow
        Write-Host "OR provide the exercise name as an argument (e.g., `.\exercism-github-sync.ps1 lasagna`)" -ForegroundColor Yellow
        exit 1
    }
} else {
    # Exercise name provided as an argument
    $exerciseName = $args[0]
    $exercismCurrentExerciseDir = Join-Path $configuredExercismBaseDir $exerciseName
}

# --- IMPROVED LOGIC: Dynamically find and/or select the .js solution file ---
$jsFiles = Get-ChildItem -Path $exercismCurrentExerciseDir -Filter "*.js" -File -Recurse:$false | Select-Object -ExpandProperty Name

$solutionFileName = $null

# 1. Try to find a file matching the exercise name (e.g., 'lasagna.js')
if ($jsFiles -contains "$exerciseName.js") {
    $solutionFileName = "$exerciseName.js"
}
# 2. If not found, try to find 'solution.js'
elseif ($jsFiles -contains "solution.js") {
    $solutionFileName = "solution.js"
}
# 3. If still not found and there's only one .js file, use that
elseif ($jsFiles.Count -eq 1) {
    $solutionFileName = $jsFiles[0]
}
# 4. If multiple .js files and no clear match, prompt the user
elseif ($jsFiles.Count -gt 1) {
    Write-Host "Multiple .js files found in '$exercismCurrentExerciseDir':" -ForegroundColor Yellow
    for ($i = 0; $i -lt $jsFiles.Count; $i++) {
        Write-Host "$($i + 1). $($jsFiles[$i])"
    }

    $selectedIndex = $null
    while ($true) {
        $input = Read-Host "Enter the number of the .js file to submit (1-$($jsFiles.Count))"
        if ([int]::TryParse($input, [ref]$selectedIndex) -and $selectedIndex -ge 1 -and $selectedIndex -le $jsFiles.Count) {
            $solutionFileName = $jsFiles[$selectedIndex - 1]
            break
        } else {
            Write-Host "Invalid selection. Please enter a number between 1 and $($jsFiles.Count)." -ForegroundColor Red
        }
    }
    Write-Host "Selected '$solutionFileName' for submission." -ForegroundColor Green
}
# 5. If no .js files found at all
else {
    Write-Host "Error: No .js solution file found in '$exercismCurrentExerciseDir'. Cannot submit." -ForegroundColor Red
    exit 1
}
# --- END IMPROVED LOGIC ---


# Construct the full path to the solution file in the Exercism directory
$sourcePath = Join-Path $exercismCurrentExerciseDir $solutionFileName
# Construct the destination path for the GitHub repository
$destinationDir = Join-Path $githubRepoDir $exerciseName
$destinationPath = Join-Path $destinationDir $solutionFileName

Write-Host "--- Starting Combined Exercism Submit and GitHub Sync for '$exerciseName' ---" -ForegroundColor Green

# 1. Check if the local solution file exists before proceeding (now mostly a final validation)
if (-not (Test-Path $sourcePath)) {
    Write-Host "Error: Solution file (determined as '$solutionFileName') not found at '$sourcePath'. This is unexpected after search." -ForegroundColor Red
    exit 1
}

# 2. Submit the solution to Exercism
Write-Host "Submitting '$solutionFileName' to Exercism..." -ForegroundColor Cyan
try {
    # Navigate to the specific exercise directory for submission
    Push-Location $exercismCurrentExerciseDir

    # Execute the exercism submit command and capture all its output
    $exercismOutput = exercism submit $solutionFileName *>&1

    # Check the exit code of the last external command (exercism)
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Exercism submission failed with exit code $LASTEXITCODE." -ForegroundColor Red
        Write-Host "--- Exercism CLI Output (Error Details) ---" -ForegroundColor Yellow
        $exercismOutput | ForEach-Object { Write-Host $_ }
        Write-Host "-------------------------------------------" -ForegroundColor Yellow
        throw "Exercism submission failed. Check the 'Exercism CLI Output' above for details."
    }
    Write-Host "Successfully submitted to Exercism." -ForegroundColor Green

} catch {
    Write-Host "An error occurred during Exercism submission: $_" -ForegroundColor Red
    Pop-Location # Ensure we pop back even on error
    exit 1
} finally {
    Pop-Location # Always pop back to the original directory
}

# 3. Create destination directory in GitHub repo if it doesn't exist
if (-not (Test-Path $destinationDir)) {
    Write-Host "Creating directory in GitHub repo: $destinationDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
}

# 4. Copy the solution file from Exercism to GitHub repo
Write-Host "Copying '$solutionFileName' from Exercism to GitHub repo..." -ForegroundColor Cyan
try {
    # Check if the file already exists in the destination to determine if it's an update or new
    if (Test-Path $destinationPath) {
        Write-Host "Updating existing solution file: $solutionFileName" -ForegroundColor Yellow
    } else {
        Write-Host "Adding new solution file: $solutionFileName" -ForegroundColor Green
    }
    Copy-Item -Path $sourcePath -Destination $destinationPath -Force
    Write-Host "Successfully copied: $solutionFileName" -ForegroundColor Green
} catch {
    Write-Host "Error copying file to GitHub repo: $_" -ForegroundColor Red
    exit 1
}

# 5. Navigate to the GitHub repository and perform Git operations
Write-Host "Navigating to GitHub repository: $githubRepoDir" -ForegroundColor Cyan
Push-Location $githubRepoDir

try {
    Write-Host "Adding changes to Git..." -ForegroundColor Cyan
    git add .

    # Prompt for commit message
    $commitMessage = Read-Host "Enter Git commit message (e.g., 'Solve <exercise-name>')"
    if ([string]::IsNullOrWhiteSpace($commitMessage)) {
        $commitMessage = "Solution for $exerciseName" # Default message if user enters nothing
        Write-Host "No commit message provided. Using default: '$commitMessage'" -ForegroundColor Yellow
    }

    Write-Host "Committing changes..." -ForegroundColor Cyan
    git commit -m "$commitMessage"

    Write-Host "Pushing to GitHub (branch: $gitBranch)..." -ForegroundColor Cyan
    git push origin $gitBranch

    Write-Host "--- Combined Exercism Submit and GitHub Sync Completed Successfully! ---" -ForegroundColor Green
} catch {
    Write-Host "Error during Git operations: $_" -ForegroundColor Red
} finally {
    Pop-Location # Go back to the previous directory
}
