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

$solutionFileName = "$exerciseName.js" # Assuming the solution file is always <exercise-name>.js

# Construct the full path to the solution file in the Exercism directory
$sourcePath = Join-Path $exercismCurrentExerciseDir $solutionFileName
# Construct the destination path for the GitHub repository
$destinationDir = Join-Path $githubRepoDir $exerciseName
$destinationPath = Join-Path $destinationDir $solutionFileName

Write-Host "--- Starting Combined Exercism Submit and GitHub Sync for '$exerciseName' ---" -ForegroundColor Green

# 1. Check if the local solution file exists before proceeding
if (-not (Test-Path $sourcePath)) {
    Write-Host "Error: Solution file not found at '$sourcePath'. Please ensure the file exists in your Exercism directory." -ForegroundColor Red
    exit 1
}

# 2. Submit the solution to Exercism
Write-Host "Submitting '$solutionFileName' to Exercism..." -ForegroundColor Cyan
try {
    # Navigate to the specific exercise directory for submission
    Push-Location $exercismCurrentExerciseDir
    # Execute the exercism submit command without PowerShell's -ErrorAction flag
    exercism submit $solutionFileName

    # Check the exit code of the last external command (exercism)
    if ($LASTEXITCODE -ne 0) {
        throw "Exercism submission failed with exit code $LASTEXITCODE."
    }
    Write-Host "Successfully submitted to Exercism." -ForegroundColor Green
} catch {
    Write-Host "Error submitting to Exercism: $_" -ForegroundColor Red
    # Exit if Exercism submission fails, as GitHub sync won't be meaningful
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

    Write-Host "Committing changes..." -ForegroundColor Cyan
    git commit -m "Solution for $exerciseName"

    Write-Host "Pushing to GitHub (branch: $gitBranch)..." -ForegroundColor Cyan
    git push origin $gitBranch

    Write-Host "--- Combined Exercism Submit and GitHub Sync Completed Successfully! ---" -ForegroundColor Green
} catch {
    Write-Host "Error during Git operations: $_" -ForegroundColor Red
} finally {
    Pop-Location # Go back to the previous directory
}
