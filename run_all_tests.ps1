# PowerShell script to run tests and analyze across all packages
$packages = @(
    "packages\core",
    "packages\about",
    "packages\movie",
    "packages\tv",
    "packages\search",
    "packages\watchlist",
    "."
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Running Analysis across all packages" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

foreach ($pkg in $packages) {
    Write-Host "`n--> Analyzing $pkg" -ForegroundColor Yellow
    Push-Location $pkg
    flutter analyze
    if ($LASTEXITCODE -ne 0) {
        Write-Host "flutter analyze failed in $pkg" -ForegroundColor Red
        Pop-Location
        exit $LASTEXITCODE
    }
    Pop-Location
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Running Tests across all packages" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$totalTests = 0
foreach ($pkg in $packages) {
    Write-Host "`n--> Testing $pkg" -ForegroundColor Yellow
    Push-Location $pkg
    flutter test --coverage
    if ($LASTEXITCODE -ne 0) {
        Write-Host "flutter test failed in $pkg" -ForegroundColor Red
        Pop-Location
        exit $LASTEXITCODE
    }
    Pop-Location
}

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host "All tests and analyses passed successfully!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
