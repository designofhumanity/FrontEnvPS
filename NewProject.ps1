$ProjectName=Read-Host -Prompt 'Input project name'
$Description=Read-Host -Prompt 'Input project description'
$Base64Token = [System.Convert]::ToBase64String([char[]]$AccessToken);
$Headers =@{
Authorization = 'Basic {0}' -f $Base64Token;
};
$Body = @{
  name = $ProjectName;
  description =$Description;
}|ConvertTo-Json;
$result =Invoke-RestMethod -Headers $Headers -Uri https://api.github.com/user/repos -Body $Body -Method post | Format-Wide -Property clone_url -Column 1 | out-string
$result = $result.trim()
If (-Not (Test-Path .\$ProjectName))
{

  New-Item .\$ProjectName -type directory | out-null
}
Set-Location -Path .\$ProjectName
If (-Not (Test-Path .\node_modules))
{

npm i gulp -save-dev -silent
}
If (-Not (Test-Path .\node_modules\browser-sync))
{

npm i browser-sync -save-dev -silent
}
New-Item .\gulpfile.js -ItemType "file" | out-null
$receivedContent = Get-Content -Path "..\__template\gulpfile.js"
Set-Content .\gulpfile.js -Value $receivedContent
If (-Not ( Test-Path ".\index.html" ))
{
New-Item .\index.html -ItemType "file" | out-null
$receivedContent = Get-Content -Path "..\__template\index.html"
Set-Content .\index.html -Value $receivedContent
}
If (-Not (Test-Path .\$ProjectName))
{
  New-Item .\package.json -ItemType "file" | out-null
  Set-Content .\package.json -Value @"
  {
    "name": "$ProjectName",
    "version": "1.0.0",
    "description": "$Description",
    "main": "gulpfile.js",
    "dependencies": {
      "browser-sync": "^2.12.8",
      "gulp": "^3.9.1"
    },
    "devDependencies": {},
    "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1"
    },
    "author": "",
    "license": "ISC"
  }
"@
}
New-Item .\.gitignore -ItemType "file" | out-null
$receivedContent = Get-Content -Path "..\__template\.gitignore"
Set-Content .\.gitignore -Value $receivedContent
git init
git add .
git commit -m "First project commit"
git remote add currentRepo $result
git push currentRepo master
gulp watch

