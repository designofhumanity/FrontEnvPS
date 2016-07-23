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
$result =Invoke-RestMethod -Headers $Headers -Uri https://api.github.com/user/repos -Body $Body -Method post | Format-Wide -Property clone_url -Column 1 | out-string
#| Select-String -Pattern "https://github.com/*"
$result = $result.trim()
#id                : 59658000
#name              : PROJECTNAME
#full_name         : AUTHOR/PROJECTNAME
#owner             : @{login=AUTHOR; id=2714036; avatar_url=https://avatars.githubusercontent.com/u/2714036?v=3; gravatar_id=; url=https://api.github.com/users/AUTHOR;
#                    html_url=https://github.com/AUTHOR; followers_url=https://api.github.com/users/AUTHOR/followers;
#                    following_url=https://api.github.com/users/AUTHOR/following{/other_user}; gists_url=https://api.github.com/users/AUTHOR/gists{/gist_id};
#                    starred_url=https://api.github.com/users/AUTHOR/starred{/owner}{/repo}; subscriptions_url=https://api.github.com/users/AUTHOR/subscriptions;
#                    organizations_url=https://api.github.com/users/AUTHOR/orgs; repos_url=https://api.github.com/users/AUTHOR/repos;
#                    events_url=https://api.github.com/users/AUTHOR/events{/privacy}; received_events_url=https://api.github.com/users/AUTHOR/received_events; type=User; site_admin
#private           : False
#html_url          : https://github.com/AUTHOR/PROJECTNAME
#description       : test 9
#fork              : False
#url               : https://api.github.com/repos/AUTHOR/PROJECTNAME
#forks_url         : https://api.github.com/repos/AUTHOR/PROJECTNAME/forks
#keys_url          : https://api.github.com/repos/AUTHOR/PROJECTNAME/keys{/key_id}
#collaborators_url : https://api.github.com/repos/AUTHOR/PROJECTNAME/collaborators{/collaborator}
#teams_url         : https://api.github.com/repos/AUTHOR/PROJECTNAME/teams
#hooks_url         : https://api.github.com/repos/AUTHOR/PROJECTNAME/hooks
#issue_events_url  : https://api.github.com/repos/AUTHOR/PROJECTNAME/issues/events{/number}
#events_url        : https://api.github.com/repos/AUTHOR/PROJECTNAME/events
#assignees_url     : https://api.github.com/repos/AUTHOR/PROJECTNAME/assignees{/user}
#branches_url      : https://api.github.com/repos/AUTHOR/PROJECTNAME/branches{/branch}
#tags_url          : https://api.github.com/repos/AUTHOR/PROJECTNAME/tags
#blobs_url         : https://api.github.com/repos/AUTHOR/PROJECTNAME/git/blobs{/sha}
#git_tags_url      : https://api.github.com/repos/AUTHOR/PROJECTNAME/git/tags{/sha}
#git_refs_url      : https://api.github.com/repos/AUTHOR/PROJECTNAME/git/refs{/sha}
#trees_url         : https://api.github.com/repos/AUTHOR/PROJECTNAME/git/trees{/sha}
#statuses_url      : https://api.github.com/repos/AUTHOR/PROJECTNAME/statuses/{sha}
#languages_url     : https://api.github.com/repos/AUTHOR/PROJECTNAME/languages
#stargazers_url    : https://api.github.com/repos/AUTHOR/PROJECTNAME/stargazers
#contributors_url  : https://api.github.com/repos/AUTHOR/PROJECTNAME/contributors
#subscribers_url   : https://api.github.com/repos/AUTHOR/PROJECTNAME/subscribers
#subscription_url  : https://api.github.com/repos/AUTHOR/PROJECTNAME/subscription
#commits_url       : https://api.github.com/repos/AUTHOR/PROJECTNAME/commits{/sha}
#git_commits_url   : https://api.github.com/repos/AUTHOR/PROJECTNAME/git/commits{/sha}
#comments_url      : https://api.github.com/repos/AUTHOR/PROJECTNAME/comments{/number}
#issue_comment_url : https://api.github.com/repos/AUTHOR/PROJECTNAME/issues/comments{/number}
#contents_url      : https://api.github.com/repos/AUTHOR/PROJECTNAME/contents/{+path}
#compare_url       : https://api.github.com/repos/AUTHOR/PROJECTNAME/compare/{base}...{head}
#merges_url        : https://api.github.com/repos/AUTHOR/PROJECTNAME/merges
#archive_url       : https://api.github.com/repos/AUTHOR/PROJECTNAME/{archive_format}{/ref}
#downloads_url     : https://api.github.com/repos/AUTHOR/PROJECTNAME/downloads
#issues_url        : https://api.github.com/repos/AUTHOR/PROJECTNAME/issues{/number}
#pulls_url         : https://api.github.com/repos/AUTHOR/PROJECTNAME/pulls{/number}
#milestones_url    : https://api.github.com/repos/AUTHOR/PROJECTNAME/milestones{/number}
#notifications_url : https://api.github.com/repos/AUTHOR/PROJECTNAME/notifications{?since,all,participating}
#labels_url        : https://api.github.com/repos/AUTHOR/PROJECTNAME/labels{/name}
#releases_url      : https://api.github.com/repos/AUTHOR/PROJECTNAME/releases{/id}
#deployments_url   : https://api.github.com/repos/AUTHOR/PROJECTNAME/deployments
#created_at        : 2016-05-25T11:36:32Z
#updated_at        : 2016-05-25T11:36:32Z
#pushed_at         : 2016-05-25T11:36:33Z
#git_url           : git://github.com/AUTHOR/PROJECTNAME.git
#ssh_url           : git@github.com:AUTHOR/PROJECTNAME.git
#clone_url         : https://github.com/AUTHOR/PROJECTNAME.git
#svn_url           : https://github.com/AUTHOR/PROJECTNAME
#homepage          :
#size              : 0
#stargazers_count  : 0
#watchers_count    : 0
#language          :
#has_issues        : True
#has_downloads     : True
#has_wiki          : True
#has_pages         : False
#forks_count       : 0
#mirror_url        :
#open_issues_count : 0
#forks             : 0
#open_issues       : 0
#watchers          : 0
#default_branch    : master
#permissions       : @{admin=True; push=True; pull=True}
#network_count     : 0
#subscribers_count : 1
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
#work/_template/index.html
$receivedContent = Get-Content -Path "..\__template\index.html"
Set-Content .\index.html -Value $receivedContent
}
#npm init
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
#Get-Content from template
$receivedContent = Get-Content -Path "..\__template\.gitignore"
Set-Content .\.gitignore -Value $receivedContent
git init
git add .
git commit -m "First project commit"
git remote add currentRepo $result
git push currentRepo master
gulp watch

# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUDlDZOuPgbU2C8gCu+9eg6Zj+
# qhKgggNCMIIDPjCCAiqgAwIBAgIQz/RnNYpemY5NuvIzjFmVzzAJBgUrDgMCHQUA
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
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFDYgk734n8Jz/ap6ek8jETcm/RLGMA0GCSqG
# SIb3DQEBAQUABIIBAHarhYgBD8CnMOrMY0zPqlHJXCfgYYY0KXeXbM7m+KUY9JkT
# jnSgSuXDGZTpp1pv3oyVRgvBh/KcZ1ytbEpKFVp18fmwMiezKzBQuVjcP+toUpPL
# ETXpNsoCZI50LopBBjHyGC8Xi6maQ3+F9tTFZEvlvmxYzMcBP5BIYrdPvu0WJypJ
# 6ZoCe7XGlGLmIHxenGwhYNW2M+rJEPmxkeXirNO5xFz4PcwyS+sGfCsStWufYpW7
# Bs47Lwo1ZpvKubpylDhmkey6trwddGIo1BGMsGftlMV8JjUZEQv8DSds6kxU3p8K
# 7UpWukW3sL1n4gt7I4bCA0kdCUKhN6BhZaxNM3s=
# SIG # End signature block
