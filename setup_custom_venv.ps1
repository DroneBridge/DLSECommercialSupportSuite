# 1. Create the virtual environment
Write-Host "Creating virtual environment..." -ForegroundColor Cyan
python -m venv .venv

# 2. Activate the environment
Write-Host "Activating environment..." -ForegroundColor Cyan
& .\.venv\Scripts\Activate.ps1

# 3. Install the local project
Write-Host "Installing project dependencies ..." -ForegroundColor Cyan
pip install .

Write-Host "Setup complete and environment is active! You can now run the DLSE scripts." -ForegroundColor Green