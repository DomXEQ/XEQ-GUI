# PowerShell script to run the GUI wallet in development mode
# IMPORTANT: This requires Node.js 14.11.0 (as specified in .nvmrc)
# If you're using Node.js 17+, Electron will fail with NODE_OPTIONS error

Write-Host "Starting Equilibria GUI Wallet in development mode..."
Write-Host ""

# Check Node version
$nodeVersion = node --version
Write-Host "Node.js version: $nodeVersion"
Write-Host ""

if ($nodeVersion -match "^v(1[7-9]|[2-9][0-9])") {
    Write-Host "ERROR: You're using Node.js 17+ which is incompatible with Electron." -ForegroundColor Red
    Write-Host ""
    Write-Host "SOLUTION: Install Node.js 14.11.0" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Option 1: Download directly (Recommended)" -ForegroundColor Cyan
    Write-Host "  1. Go to: https://nodejs.org/download/release/v14.11.0/" -ForegroundColor White
    Write-Host "  2. Download: node-v14.11.0-x64.msi" -ForegroundColor White
    Write-Host "  3. Install it" -ForegroundColor White
    Write-Host "  4. Restart PowerShell and run this script again" -ForegroundColor White
    Write-Host ""
    Write-Host "Option 2: Fix NVM (if you prefer NVM)" -ForegroundColor Cyan
    Write-Host "  See: NVM_ALTERNATIVE.md for instructions" -ForegroundColor White
    Write-Host ""
    Write-Host "The GUI wallet requires Node.js 14.11.0 to work properly." -ForegroundColor Yellow
    Write-Host ""
    exit 1
} else {
    Write-Host "Node.js version looks good!" -ForegroundColor Green
    Write-Host ""
}

# Run npm (no NODE_OPTIONS needed for Node.js 14)
npm run dev
