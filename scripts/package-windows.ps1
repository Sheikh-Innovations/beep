Write-Output "$WINDOWN_PFX"
Move-Item -Path $WINDOWS_PFX -Destination beep.pem
certutil -decode beep.pem beep.pfx

flutter pub run msix:create -c beep.pfx -p $WINDOWS_PFX_PASS --sign-msix true --install-certificate false
