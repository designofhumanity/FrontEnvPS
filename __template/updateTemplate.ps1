$files = @{"_index.html" = "https://raw.githubusercontent.com/h5bp/html5-boilerplate/master/src/index.html";
"_404.html" = "https://raw.githubusercontent.com/h5bp/html5-boilerplate/master/src/404.html";
"_bootstrap.css" = "https://raw.githubusercontent.com/twbs/bootstrap/master/dist/css/bootstrap.css";
"_bootstrap.js" = "https://raw.githubusercontent.com/twbs/bootstrap/master/dist/js/bootstrap.js";}

$rootFolder = ""
Foreach ($key in $files.keys)
{
  #cases for exmaple "jquery.1.3.3.comment.buil.js"
  if ($key.split(".")[-1] -eq "css") {
    $rootFolder = "$PSScriptRoot\css"
    If (-not (Test-Path $rootFolder)) {
      New-Item $rootFolder -type directory | out-null
    }
  }
  if ($key.split(".")[-1] -eq "js") {
    $rootFolder = "$PSScriptRoot\js"
  }
  if ($key.split(".")[-1] -eq "html" -OR ($key.split(".")[-1] -eq "htm")) {
      $rootFolder = $PSScriptRoot
  }
  If (-not (Test-Path $rootFolder\$key))
  {
    New-Item $rootFolder\$key -itemType "file" | out-null
  }
  If (-not (Test-Path $rootFolder)) {
    New-Item $rootFolder -type directory | out-null
  }
  echo $rootFolder\$key
  $endData = (get-item $rootFolder\$key).LastWriteTime
  $dateDiff = (new-timespan -start (get-date) -end $endData)
  #If ($dateDiff.days -gt 7) {
  $url = $files.item($key);
  Invoke-WebRequest -uri $files.item($key) -outfile $rootFolder\$key
  (get-item $rootFolder\$key).LastWriteTime
#}
}


# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUW95+5JK91QHzyWk4AFuHXqSn
# F42gggNCMIIDPjCCAiqgAwIBAgIQz/RnNYpemY5NuvIzjFmVzzAJBgUrDgMCHQUA
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
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFC3Nb4pk3Qlm5IccJGFLqoUoxI6DMA0GCSqG
# SIb3DQEBAQUABIIBAB0ZPR3QWRJpUM1x1Z26rMVz9y7q6tC0eLYmzmt8ImhX5O72
# AS+htGTWJQ9OvWIaHI8iBISNCCYSJA4u3Pxa+wfZVi0m3usZpD2ZTX4U3odB7LTF
# APdrb0H77mVUu0mZesb6KUgniCk4eJkgB9bSYl7QT1WoVnkUz8CzW8IqlZgkE83J
# PEkezqZ1QOtOoC7sS4LK8YWYuY5/Qdgd/EK/M51aXGCF2sK/HCYHbsCakb410fmO
# +g1IXGX471DITVk1YYQPg3IbbTl6c9BOMEkHVyMipBgTcKkfMXItkurBQORXoQS/
# zCl6EZ/zZ4VsWmWUzkh9wmVlQ26urBfCTY1fFZw=
# SIG # End signature block
