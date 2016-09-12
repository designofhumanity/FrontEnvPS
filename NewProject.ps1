function addToHTML
{
  param( [string]$pattern, [string]$NewString, [boolean]$isreplace, [System.Collections.ArrayList]$content )
  Write-Host "Inside addToHTML"
  $once = $TRUE
  $i = 0
  $newArray = New-Object System.Collections.ArrayList
  foreach ($line in $content) {
    $i++
    #находим тег линк
    if ($line -match $pattern -And $once) {
      $newArray.Add($NewString) > $null
      if(-Not $isreplace -eq $TRUE) {
        $newArray.Add($line) > $null
      }
      #вставляем внешние стили
      #but we need to copy this file from template dir to project directory
      #Local jQuery copyCopy-Item $PSScriptRoot\__template\css\bootstrapGridSystem.css $projects_dir\$ProjectName\css\bootstrapGridSystem.css
      #break from cycle e.g. first link
      $once = $FALSE
    } else {
      $newArray.Add($line) > $null
    }
  }
  return $newArray
}
$endData = (get-item $PSScriptRoot\__template\_index.html).LastWriteTime
$dateDiff = (new-timespan -start (get-date) -end $endData)
If ($dateDiff.days -lt -7) {
Write-Host "HTML5 boilerplate index.html outdated file to $dateDiff.days days"
$AnswerUpdate =Read-Host -Prompt 'Update HTML5 boilerplate templates from github? 1 - Yes, else - no'
#$PSScriptRoot\__template\css\bootstrapGridSystem.css
#$PSScriptRoot\__template\_gulpfile.js
if ($AnswerUpdate -eq "1") {
#If ($dateDiff.days -gt 7) {.... update html5-bolerplate
  Invoke-WebRequest "https://raw.githubusercontent.com/h5bp/html5-boilerplate/master/src/index.html" -outfile $PSScriptRoot\__template\_index.html
  $endData = (get-item .\__template\_index.html).LastWriteTime
  $dateDiff = (new-timespan -start (get-date) -end $endData).days
  Write-Host "HTML5 boilerplate index.html days beetween", $dateDiff
}
}
#1) Итак сначала читаем с клавиатуры название проекта
$ProjectName=Read-Host -Prompt 'Input project name'
#... описание проекта
$Description=Read-Host -Prompt 'Input project description'
#Cоздадим репозиторий
#Сервеная сторона
#Когда пользователь хочет отправить the server authentication credentials it may use the Authorization field.
#
#The Authorization field is constructed as follows:
#
#The username and password are combined with a single colon.
#The resulting string is encoded using the RFC2045-MIME variant of Base64, except not limited to 76 char/line.
#The authorization method and a space i.e. "Basic " is then put before the encoded string.
#For example, if the user agent uses Aladdin as the username and OpenSesame as the password then the field is formed as follows:
#
#Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l
#по википедии нам нужно преобразовать наш акстокен в 64 бит строку
$Base64Token = [System.Convert]::ToBase64String([char[]]$AccessToken);
#..дальше нам нужно по википедии cлово Basic и наш акстокен
$Headers =@{
Authorization = 'Basic {0}' -f $Base64Token;
};
$Body = @{
  name = $ProjectName;
  description =$Description;
}|ConvertTo-Json;
$AnswerRepo =Read-Host -Prompt "Create repository on github? 1 - yes, 2 - no"
If ($AnswerRepo -eq "1") {
$result =Invoke-RestMethod -Headers $Headers -Uri https://api.github.com/user/repos -Body $Body -Method post | Format-Wide -Property clone_url -Column 1 | out-string
#| Select-String -Pattern "https://github.com/*"
$result = $result.trim()
#Read path to your folder with your projects
}
$configurationContent =Get-Content $PSScriptRoot\configuration.conf
$projects_dir = $configurationContent -replace "projects_dir=",""
Set-Location -Path $projects_dir
If (-Not (Test-Path .\$ProjectName))
{
  New-Item .\$ProjectName -type directory | out-null
}
#basic direcotry structure
If (-Not (Test-Path .\$ProjectName\css))
{
  New-Item .\$ProjectName\css -type directory | out-null
}
If (-Not (Test-Path .\$ProjectName\js))
{
  New-Item .\$ProjectName\js -type directory | out-null
}
Set-Location -Path .\$ProjectName
If (-Not (Test-Path .\node_modules))
{
$AnswerGulp =Read-Host -Prompt "Install gulp? 1 - yes, 2 - no"
if ($AnswerGulp -eq "1") {
npm i gulp -save-dev -silent
}
}
If (-Not (Test-Path .\node_modules\browser-sync))
{
if ($AnswerGulp -eq "1") {
npm i browser-sync -save-dev -silent
}
}
If (-Not ( Test-Path ".\gulpfile.js" ))
{
  if ($AnswerGulp -eq "1") {
New-Item .\gulpfile.js -ItemType "file" | out-null
$receivedContent = Get-Content -Path $PSScriptRoot\__template\_gulpfile.js
Set-Content .\gulpfile.js -Value $receivedContent
}
}
If (-Not ( Test-Path ".\index.html" ))
{
New-Item .\index.html -ItemType "file" | out-null
}
#work/_template/index.html
#$receivedContent = Get-Content -Path $PSScriptRoot\__template\_index.html
#$receivedContent =iwr -uri https://raw.githubusercontent.com/h5bp/html5-boilerplate/master/src/index.html
$receivedContent =Get-Content -Path $PSScriptRoot\__template\_index.html
if ($AnswerRepo -eq "1") {
  Copy-Item $PSScriptRoot\__template\css\_bootstrap.css $projects_dir\$ProjectName\css\bootstrapGridSystem.css
  $receivedContent = addToHTML -pattern "<body>" -NewString "`t`t`t`t<p>Created repo on <a href='$result'></a>github</p>" -isreplace $FALSE -content $receivedContent
}
#$AnswerScript =Read-Host -Prompt "Add empty script.js? 1 - yes, 2 - no";
#If ($AnswerScript -eq "1")
#{
  If (-Not ( Test-Path "$projects_dir\$ProjectName\js\main.js" ))
  {
    New-Item .\js\main.js -ItemType "file" | out-null;
  }
$AnswerJquery =Read-Host -Prompt "Add jQuery.js? 1 - yes, 2 - no"
if ($AnswerJquery -eq "1") {
  $once = $TRUE
  $i = 0
  $newArray = New-Object System.Collections.ArrayList
  foreach ($line in $receivedContent) {
  $i++
  #находим тег линк
  if ($line -match "</body>" -And $once) {
    $newArray.Add("`t`t`t`t<script src=""js/jQuery.js""></script>") > $null
  $newArray.Add($line) > $null
  #вставляем внешние стили
  #but we need to copy this file from template dir to project directory
  #Local jQuery copyCopy-Item $PSScriptRoot\__template\css\bootstrapGridSystem.css $projects_dir\$ProjectName\css\bootstrapGridSystem.css
  #break from cycle e.g. first link
  $once = $FALSE
  } else {
  $newArray.Add($line) > $null
  }
  }
  $receivedContent = $newArray
}
$AnswerBootstrapGridSystem =Read-Host -Prompt "Add bootstrapGridSystem.css? 1 - yes, 2 - no"
if ($AnswerBootstrapGridSystem -eq "1") {
  if ($line -match "<link.*" -And $once) {
  $newArray.Add("`t`t`t`t<link rel=""stylesheet"" href=""css/bootstrapGridSystem.css"">") > $null
  Copy-Item $PSScriptRoot\__template\css\bootstrapGridSystem.css $projects_dir\$ProjectName\css\bootstrapGridSystem.css
  $receivedContent = addToHTML -pattern "<link.*" -NewString "`t`t`t`t<link rel=""stylesheet"" href=""css/bootstrapGridSystem.css"">" -isreplace $FALSE -content $receivedContent
}
#before write into index.html
#$once = $TRUE
#  $i = 0
#  $newArray = New-Object System.Collections.ArrayList
#  foreach ($line in $receivedContent) {
#  $i++
#  #find last tag </body>
#  if ($line -match "<title>" -And $once) {
#    #first add script tag
#  $newArray.Add("`t`t`t`t<title>$ProjectName</title>") > $null
#  #... and then close </body>
#  #$newArray.Add($line) > $null
#  #вставляем внешние стили
#  #but we need to copy this file from template dir to project directory
#  #Local jQuery copyCopy-Item $PSScriptRoot\__template\css\bootstrapGridSystem.css $projects_dir\$ProjectName\css\bootstrapGridSystem.css
#  #break from cycle e.g. first link
#  $once = $FALSE
#  } else {
#  $newArray.Add($line) > $null
#  }
#  }
#  $receivedContent = $newArray
Write-Host "Before addToHTML call!"
$receivedContent = addToHTML -Pattern "<title>" -NewString "`t`t`t`t<title>$ProjectName</title>" -isreplace $TRUE -content $receivedContent
Set-Content .\index.html -Value $receivedContent
}
If (-Not ( Test-Path "$projects_dir\$ProjectName\css\main.css" ))
{
  New-Item .\css\main.css -ItemType "file" | out-null;
}
#npm init
#HOW GET Browser-sync version?
#LIcense
If (-Not (Test-Path "$projects_dir\$ProjectName\package.json"))
{
  New-Item .\package.json -ItemType "file" | out-null
  $gulpVersionStr = gulp -version;
  $arr = $gulpVersionStr -split(" ", "")
  $arr.GetType()
$gulpVersion =$arr[3]
  Set-Content .\package.json -Value @"
  {
    "name": "$ProjectName",
    "version": "1.0.0",
    "description": "$Description",
    "main": "gulpfile.js",
    "dependencies": {
      "browser-sync": "^2.12.8",
      "gulp": "^$gulpVersion"
    },
    "devDependencies": {},
    "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1"
    },
    "author": "",
    "license": "ISC"
  }
"@
} #else npm init
If ($AnswerRepo -eq "1") {
New-Item .\.gitignore -ItemType "file" | out-null
#Get-Content from template
$receivedContent = Get-Content -Path $PSScriptRoot\__template\_.gitignore
Set-Content .\.gitignore -Value $receivedContent
git init
git add .
git commit -m "First project commit"
git remote add currentRepo $result
git push currentRepo master
}
#open favorite text editor (I am using ATOM)
atom .
ii .
If ($AnswerGulp -eq "1" -OR (Test-Path "$projects_dir\$ProjectName\gulpfile.js") ) {
start-process powershell.exe -argument '-nologo -noprofile -executionpolicy bypass -command gulp watch'
}
Set-Location $projects_dir
# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU3cz/C5RKNTUJLdPjjLrdRXWr
# f9OgggNCMIIDPjCCAiqgAwIBAgIQz/RnNYpemY5NuvIzjFmVzzAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNjAyMTgxNTU3MjBaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANpqT6Qt
# n2ti0mzsf9R6JOzlVDlwagaW4TGMzPQ/+xnikiVA8tXTFgKw5F8lEw/UVTG/BDeS
# yyeknTpoPhg///hisy55+kGabxtXXu5IJdQiqBpDbB5jbLTHb4rDtHtOaK5GYxEM
# HuW9XuZzSE8GcpFwjA7g8aaV7NmjJ5ALww6hCnoua47xFJnSf+FZ1id4TU8OVeo1
# FNq2UzjQwkE8gxBugNgpvNTLxcXa0eqvSADRgvF6sz/jCpG8EWBjuVxBMKq384xc
# fMr6G0RRAyzkD+pdZKejefElPGScOGVCRKkcFa/R/sSjBr8xKN9VNYUNZWOh9MHZ
# lZQDgjYBUnaZjskCAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYBBQUHAwMwXQYDVR0B
# BFYwVIAQr6SFQbkyestk9Xe8A6y8/6EuMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwg
# TG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQi2lIpyC1A6dLoCDA/FTNCzAJBgUrDgMC
# HQUAA4IBAQCQOEmI3EQ7pqRtx7cxqR+SqFAF9EwdVdNvB5xj3DV0v9UjsTbFiHoY
# zXvPlq3rL0YpMc9rCpojJb1r+GEfdrKTseKww2fpdG5ELw2QYqyAil42DlcDY1W5
# olPEu0y9gGDefsqFFok+VSsVsB/CIxq+vfUAnFI48alJa/dxLVybMSt60bTNuOI+
# aU2eA58pTnfCuesVat7NVsXRVy9I9VqLXCeqNCn6IW6X9j1/vpLTEEonA2xFSVpX
# DIgocPdHKi08jOCFnpl1AN9+9Az87A/3eOET53VE8CsrQozqdOyC/KvDUXJ+/ULw
# jSCZFfXOGjt+T1lUKDX7pFOAheI0Ap+aMYIB4TCCAd0CAQEwQDAsMSowKAYDVQQD
# EyFQb3dlclNoZWxsIExvY2FsIENlcnRpZmljYXRlIFJvb3QCEM/0ZzWKXpmOTbry
# M4xZlc8wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJ
# KoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQB
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFDbCp9dINhr2l4dG1ye8PrKv6jZ0MA0GCSqG
# SIb3DQEBAQUABIIBAIx0tewfJX5tgYKAw26FVuxynNz06ENqzvXle+HiftHjoOYh
# bRPBwALk/VeV5DkG5vxFBeRJ65L3zx06LR7HdGdHJmyJZF3IDJ5Zf3ejlgkbjCux
# NvV506mTKncS3v9OHya4uYGPX9bu5JNsQmKq5oQAyCdPnZdwihusvQSwDBia0yxv
# D+h9kOjdBNdb2AIFWFc14kpPeiN4jgWgH4XidAK8pQcd4a21dYUnG2lfDYuyOZVW
# dhb+1w2T51XXOBn2qW26tK/+ZjfNsL8l2i+qzXEusBG4tAmV49qcpLIMAVmSrsRf
# TqMspX6lgYhmRT3m45KFjsOCFxLoefyj9CDDfDQ=
# SIG # End signature block
