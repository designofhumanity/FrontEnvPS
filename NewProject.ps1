param([string]$name="", [string]$desc="")
#addToHTML5Boilerplate - add tag style,script to HTML5 boilerplate
function addToHTML5Boilerplate
{
  param( [string]$pattern, [string]$NewString, [boolean]$isreplace, [System.Collections.ArrayList]$content )
  $once = $TRUE
  $i = 0
  $newArray = New-Object System.Collections.ArrayList
  foreach ($line in $content) {
    $i++
    #find first patter line
    if ($line -match $pattern -And $once) {
      $newArray.Add($NewString) > $null
      if(-Not $isreplace -eq $TRUE) {
        $newArray.Add($line) > $null
      }
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
if ($AnswerUpdate -eq "1") {
  Invoke-WebRequest "https://raw.githubusercontent.com/h5bp/html5-boilerplate/master/src/index.html" -outfile $PSScriptRoot\__template\_index.html
  $endData = (get-item .\__template\_index.html).LastWriteTime
  $dateDiff = (new-timespan -start (get-date) -end $endData).days
  Write-Host "HTML5 boilerplate index.html days beetween", $dateDiff
}
}
if (-Not $name) {
  #1)first read project name from user
  $ProjectName=Read-Host -Prompt 'Input project name'
} else {
  Write-Host "ProjectName=$name"
  $ProjectName =$name
}
if (-Not $name) {
  $Description=Read-Host -Prompt 'Input project description'
} else {
  Write-Host "Description=$desc"
  $Description =$desc
}
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
#
$a = git ls-remote --exit-code https://github.com/designofhumanity/$ProjectName 2>&1
if ($a.Exception)
 {
    $AnswerRepo =Read-Host -Prompt "Create repository on github? 1 - yes, 2 - no"
    If ($AnswerRepo -eq "1") {
      $result =Invoke-RestMethod -Headers $Headers -Uri https://api.github.com/user/repos -Body $Body -Method post | Format-Wide -Property clone_url -Column 1 | out-string
      #| Select-String -Pattern "https://github.com/*"
      $result = $result.trim()
      #Read path to your folder with your projects
    }
}
$configurationContent =Get-Content $PSScriptRoot\configuration.conf
$projects_dir = $configurationContent -replace "projects_dir=",""
$full_path = "$projects_dir\$ProjectName"
Set-Location -Path $projects_dir
If (-Not (Test-Path $projects_dir\$ProjectName))
{
  New-Item $projects_dir\$ProjectName -type directory | out-null
}
#basic direcotry structure
If (-Not (Test-Path $full_path\css))
{
  New-Item $full_path\css -type directory | out-null
}
If (-Not (Test-Path $full_path\js))
{
  New-Item $full_path\js -type directory | out-null
}
If (-Not (Test-Path $full_path\node_modules))
{
$AnswerGulp =Read-Host -Prompt "Install gulp? 1 - yes, 2 - no"
if ($AnswerGulp -eq "1") {
Set-Location $full_path;npm i gulp -save-dev -silent
}
}
If (-Not (Test-Path $projects_dir\node_modules\browser-sync))
{
if ($AnswerGulp -eq "1") {
Set-Location $full_path;npm i browser-sync -save-dev -silent
}
}
If (-Not ( Test-Path "$full_path\gulpfile.js" ))
{
  if ($AnswerGulp -eq "1") {
New-Item $full_path\gulpfile.js -ItemType "file" | out-null
$receivedContent = Get-Content -Path $PSScriptRoot\__template\_gulpfile.js
Set-Content $full_path\gulpfile.js -Value $receivedContent
}
}
If (-Not ( Test-Path "$full_path\index.html" ))
{
New-Item $full_path\index.html -ItemType "file" | out-null
}
#work/_template/index.html
#$receivedContent = Get-Content -Path $PSScriptRoot\__template\_index.html
#$receivedContent =iwr -uri https://raw.githubusercontent.com/h5bp/html5-boilerplate/master/src/index.html
$receivedContent =Get-Content -Path $PSScriptRoot\__template\_index.html
if ($AnswerRepo -eq "1") {
  Copy-Item $PSScriptRoot\__template\css\_bootstrap.css $full_path\css\bootstrapGridSystem.css
  $receivedContent = addToHTML5Boilerplate -pattern "<body>" -NewString "`t`t`t`t<p>Created repo on <a href='$result'>github</a></p>" -isreplace $FALSE -content $receivedContent
}
#$AnswerScript =Read-Host -Prompt "Add empty script.js? 1 - yes, 2 - no";
#If ($AnswerScript -eq "1")
#{
  If (-Not ( Test-Path "$full_path\js\main.js" ))
  {
    New-Item $full_path\js\main.js -ItemType "file" | out-null;
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
  #Local jQuery copyCopy-Item $PSScriptRoot\__template\css\bootstrapGridSystem.css $full_path\css\bootstrapGridSystem.css
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
  Copy-Item $PSScriptRoot\__template\css\bootstrapGridSystem.css $full_path\css\bootstrapGridSystem.css
  $receivedContent = addToHTML5Boilerplate -pattern "<link.*" -NewString "`t`t`t`t<link rel=""stylesheet"" href=""css/bootstrapGridSystem.css"">" -isreplace $FALSE -content $receivedContent
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
#  #Local jQuery copyCopy-Item $PSScriptRoot\__template\css\bootstrapGridSystem.css $full_path\css\bootstrapGridSystem.css
#  #break from cycle e.g. first link
#  $once = $FALSE
#  } else {
#  $newArray.Add($line) > $null
#  }
#  }
#  $receivedContent = $newArray
$receivedContent = addToHTML5Boilerplate -Pattern "<title>" -NewString "`t`t`t`t<title>$ProjectName</title>" -isreplace $TRUE -content $receivedContent
Set-Content $full_path\index.html -Value $receivedContent
}
If (-Not ( Test-Path "$full_path\css\main.css" ))
{
  New-Item $full_path\css\main.css -ItemType "file" | out-null;
}
#npm init
#HOW GET Browser-sync version?
#LIcense
If (-Not (Test-Path "$full_path\package.json"))
{
  New-Item $full_path\package.json -ItemType "file" | out-null
  $gulpVersionStr = gulp -version;
  $arr = $gulpVersionStr -split(" ", "")
  $arr.GetType()
$gulpVersion =$arr[3]
  Set-Content $full_path\package.json -Value @"
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
New-Item $full_path\.gitignore -ItemType "file" | out-null
#Get-Content from template
$receivedContent = Get-Content -Path $PSScriptRoot\__template\_.gitignore
Set-Content $full_path\.gitignore -Value $receivedContent
If (-Not ( Test-Path "$full_path\.git" )) {
  set-location $full_path;git init
}
set-location $full_path;git add .
git commit -m "First project commit"
git remote add currentRepo $result
git push currentRepo master
}
#open favorite text editor (I am using ATOM)
atom $full_path
ii $full_path
If ($AnswerGulp -eq "1" -OR (Test-Path "$full_path\gulpfile.js") ) {
start-process powershell.exe -argument '-nologo -noprofile -executionpolicy bypass -command gulp watch'
}
Set-Location $projects_dir
# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUa+EedHg1DQEqnBFgpFJpBcJC
# 0m+gggNCMIIDPjCCAiqgAwIBAgIQz/RnNYpemY5NuvIzjFmVzzAJBgUrDgMCHQUA
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
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFK1KRyaTWr/5yc+ujLCps8oT3RxuMA0GCSqG
# SIb3DQEBAQUABIIBAHRmkv8DU8kN17JgbgwH9d3LHmAhX9pBERCC15L6Bc/SWiXg
# i9JqswMADo9c2WIK5GLXseYgdaAHd8bAeewsbJ2mSPgC3Od7p7WaYQRVJztQ6HlY
# uVhVhnzbHdpRkz5G3k5dPMekdEbEfizwQ10ZnU1pr5C9x/ho9WR/oyRgIb0fLKFN
# hV81s0U3tZ3UJQzLahQTgoV7xbmXk+kuDhaMmzTDQxwbPqC7nlbaXyhkDYqQjSyI
# yfTKyEzjQYYdAbLSZHiKPxlnYS0LnugM56r40VpcPH0kf1BUOc8/07oqUM33xEgT
# YKWgoyA67FSF5oX/w7AsRJ7pAtFCxbyDIvQPNpc=
# SIG # End signature block
