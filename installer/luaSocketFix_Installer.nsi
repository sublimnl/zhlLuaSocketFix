; zhlLuaSocketFix Installer for REPENTOGON
; sublimnl - https://discord.com/invite/5R9CSxzcep

Unicode true
RequestExecutionLevel user

; Metadata to reduce false positives from antivirus
VIProductVersion "1.0.0.1"
VIAddVersionKey "ProductName" "zhlLuaSocketFix"
VIAddVersionKey "CompanyName" "sublimnl"
VIAddVersionKey "FileDescription" "zhlLuaSocketFix Installer for REPENTOGON"
VIAddVersionKey "FileVersion" "1.0.0.1"
VIAddVersionKey "ProductVersion" "1.0.0.1"
VIAddVersionKey "LegalCopyright" "sublimnl © 2025"
VIAddVersionKey "OriginalFilename" "zhlLuaSocketFix_Setup.exe"
VIAddVersionKey "InternalName" "zhlLuaSocketFix"
VIAddVersionKey "Comments" "Open source REPENTOGON mod installer - https://github.com/sublimnl/zhlLuaSocketFix"

; Includes
!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "WinMessages.nsh"
!include "StrFunc.nsh"
${StrRep}
${StrLoc}

; Installer settings
OutFile "zhlLuaSocketFix_Setup.exe"
InstallDir "$LOCALAPPDATA\zhlLuaSocketFix"
ShowInstDetails show
Name "zhlLuaSocketFix for REPENTOGON"
Caption "zhlLuaSocketFix Installer"
BrandingText " "

; MUI Configuration
!define MUI_ICON "zhlLuaSocketFix.ico"
!define MUI_WELCOMEPAGE_TITLE "Welcome to the zhlLuaSocketFix Setup Wizard"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of zhlLuaSocketFix for REPENTOGON.$\r$\n$\r$\nIt is recommended that you close The Binding of Isaac if it is currently running before continuing.$\r$\n$\r$\nClick Next to continue."
!define MUI_INSTFILESPAGE_SHOW_DETAILS
!define MUI_INSTFILESPAGE_PROGRESSBAR "colored"
!define MUI_INSTFILESPAGE_HEADER_TEXT "Installing zhlLuaSocketFix"
!define MUI_INSTFILESPAGE_HEADER_SUBTEXT "Please wait while zhlLuaSocketFix is being installed."
!define MUI_FINISHPAGE_TITLE "Installation Complete"
!define MUI_FINISHPAGE_TEXT "zhlLuaSocketFix has been successfully installed!$\r$\n$\r$\nYou can now start The Binding of Isaac: Rebirth."

; Compression settings to reduce false positives
; Using zlib instead of lzma can reduce false positives
SetCompressor /SOLID zlib
SetDatablockOptimize on
CRCCheck on

; Variables
Var SteamInstallPath
Var IsaacInstallPath
Var IsaacInstalledFlag
Var ErrorMessage
Var ErrorDialog
Var ErrorLabel
Var ErrorDiscordButton
Var ErrorCloseButton

; Macros
!macro AbortWithError message
  StrCpy $ErrorMessage "${message}"
  Call NavigateToErrorPage
!macroend

; Pages
!insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_CUSTOMFUNCTION_SHOW ShowInstallDetails
!insertmacro MUI_PAGE_INSTFILES
Page custom ShowErrorPage LeaveErrorPage
!insertmacro MUI_PAGE_FINISH

; Language
!insertmacro MUI_LANGUAGE "English"

; ============================================================================
; FUNCTIONS
; ============================================================================

Function ShowInstallDetails
  SetDetailsView show
FunctionEnd

Function NavigateToErrorPage
  SendMessage $HWNDPARENT 0x408 1 0
FunctionEnd

Function ShowErrorPage
  ${If} $ErrorMessage == ""
    Abort
  ${EndIf}

  nsDialogs::Create 1018
  Pop $ErrorDialog
  ${If} $ErrorDialog == error
    Abort
  ${EndIf}

  ; Configure error page appearance
  SendMessage $HWNDPARENT ${WM_SETTEXT} 0 "STR:Installation Failed - zhlLuaSocketFix Setup"
  
  GetDlgItem $0 $HWNDPARENT 1037
  SendMessage $0 ${WM_SETTEXT} 0 "STR:Installation Failed"
  SetCtlColors $0 0x000000 0xFFFFFF
  
  GetDlgItem $0 $HWNDPARENT 1038
  SendMessage $0 ${WM_SETTEXT} 0 "STR:Setup could not complete successfully."
  SetCtlColors $0 0x000000 0xFFFFFF

  ; Hide standard buttons and progress elements
  GetDlgItem $0 $HWNDPARENT 1
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 2
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 3
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1035
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1004
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1027
  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $0 $HWNDPARENT 1006
  ShowWindow $0 ${SW_HIDE}

  ; Create error message and buttons
  ${NSD_CreateLabel} 0 20u 100% 60u "Installation failed with the following error:$\r$\n$\r$\n$ErrorMessage$\r$\n$\r$\nFor assistance, please join our Discord community where we can help resolve this issue."
  Pop $ErrorLabel
  
  ${NSD_CreateButton} 5% 80% 40% 18u "Join Discord"
  Pop $ErrorDiscordButton
  ${NSD_OnClick} $ErrorDiscordButton JoinDiscordAndClose
  
  ${NSD_CreateButton} 55% 80% 40% 18u "Close"
  Pop $ErrorCloseButton
  ${NSD_OnClick} $ErrorCloseButton CloseInstaller

  nsDialogs::Show
FunctionEnd

Function LeaveErrorPage
FunctionEnd

Function JoinDiscordAndClose
  ExecShell "open" "https://discord.com/invite/5R9CSxzcep"
  SendMessage $HWNDPARENT ${WM_CLOSE} 0 0
FunctionEnd

Function CloseInstaller
  SendMessage $HWNDPARENT ${WM_CLOSE} 0 0
FunctionEnd

Function SelectIsaacFolder
  Push $0
  
  DetailPrint "Steam detection failed - requesting manual folder selection..."
  Sleep 1000

  nsDialogs::SelectFolderDialog "Please select your Binding of Isaac: Rebirth installation folder" "C:\"
  Pop $0
  
  ${If} $0 == "error"
  ${OrIf} $0 == ""
    DetailPrint "Folder selection cancelled by user"
    StrCpy $IsaacInstallPath ""
    Goto done
  ${EndIf}

  DetailPrint "Selected folder: $0"
  Sleep 500
  
  Push $0
  Call ValidateIsaacFolder
  
  done:
  Pop $0
FunctionEnd

Function ValidateIsaacFolder
  Exch $0  ; Get folder path from stack
  Push $1
  
  DetailPrint "Validating installation folder..."
  Sleep 800
  
  ${If} ${FileExists} "$0\zhlREPENTOGON.dll"
  ${AndIf} ${FileExists} "$0\isaac-ng.exe"
    DetailPrint "✓ Found zhlREPENTOGON.dll"
    Sleep 300
    DetailPrint "✓ Found isaac-ng.exe"
    Sleep 300
    StrCpy $IsaacInstallPath "$0"
    DetailPrint "✓ Folder validation successful"
    Sleep 500
  ${Else}
    DetailPrint "✗ Invalid folder - missing required files"
    Sleep 1000
    StrCpy $IsaacInstallPath ""
  ${EndIf}
  
  Pop $1
  Pop $0
FunctionEnd

Function FindIsaacInSteamLibraries
  Push $0  ; File handle
  Push $1  ; Line buffer
  Push $2  ; Library path
  Push $3  ; Temp variable
  Push $4  ; Line counter
  
  FileOpen $0 "$SteamInstallPath\steamapps\libraryfolders.vdf" r
  ${If} ${Errors}
    StrCpy $IsaacInstallPath ""
    Goto cleanup
  ${EndIf}
  
  StrCpy $IsaacInstallPath ""
  StrCpy $4 0
  
  read_loop:
    IntOp $4 $4 + 1
    ${If} $4 > 2500  ; Safety limit
      Goto cleanup
    ${EndIf}
    
    FileRead $0 $1
    ${If} ${Errors}
      Goto cleanup
    ${EndIf}
    
    ${StrLoc} $3 $1 '"path"' ">"
    ${If} $3 == ""
      Goto read_loop
    ${EndIf}
    
    ; Extract path value between quotes
    ${StrLoc} $3 $1 '"' ">"
    IntOp $3 $3 + 1
    StrCpy $1 $1 "" $3
    ${StrLoc} $3 $1 '"' ">"
    IntOp $3 $3 + 1
    StrCpy $1 $1 "" $3
    ${StrLoc} $3 $1 '"' ">"
    IntOp $3 $3 + 1
    StrCpy $1 $1 "" $3
    ${StrLoc} $3 $1 '"' ">"
    StrCpy $2 $1 $3
    
    ${StrRep} $2 $2 "\\" "\"
    
    ${If} ${FileExists} "$2\steamapps\common\The Binding of Isaac Rebirth\zhlREPENTOGON.dll"
      StrCpy $IsaacInstallPath "$2\steamapps\common\The Binding of Isaac Rebirth"
      Goto cleanup
    ${EndIf}
    
    Goto read_loop
    
  cleanup:
    FileClose $0
    Pop $4
    Pop $3
    Pop $2
    Pop $1
    Pop $0
FunctionEnd

Function TryManualSelection
  Call SelectIsaacFolder
FunctionEnd

; ============================================================================
; INSTALLATION SECTION
; ============================================================================

Section "Install zhlLuaSocketFix"
  SetDetailsPrint both

  DetailPrint "Finding your Binding of Isaac install location..."
  Sleep 1000
  
  ; Try to find Steam installation
  ClearErrors
  ReadRegStr $SteamInstallPath HKCU "Software\Valve\Steam" "SteamPath"
  ${If} ${Errors}
    DetailPrint "Steam not found in registry - trying manual selection..."
    Sleep 1000
    Call TryManualSelection
    ${If} $IsaacInstallPath == ""
      !insertmacro AbortWithError "Could not find Steam installation and no valid Isaac folder was selected."
    ${Else}
      Goto install_file
    ${EndIf}
  ${EndIf}
  
  ${StrRep} $SteamInstallPath $SteamInstallPath "/" "\"

  ; Check if Isaac is installed via Steam
  DetailPrint "Checking if The Binding of Isaac: Rebirth is installed..."
  Sleep 800
  ClearErrors
  ReadRegDWORD $IsaacInstalledFlag HKCU "Software\Valve\Steam\Apps\250900" "Installed"
  ${If} ${Errors}
  ${OrIf} $IsaacInstalledFlag != 1
    DetailPrint "Isaac not found in Steam registry - trying manual selection..."
    Sleep 1000
    Call TryManualSelection
    ${If} $IsaacInstallPath == ""
      !insertmacro AbortWithError "The Binding of Isaac does not appear to be installed with Steam and no valid folder was selected."
    ${Else}
      Goto install_file
    ${EndIf}
  ${EndIf}
  
  DetailPrint "✓ The Binding of Isaac: Rebirth detected"
  Sleep 500

  ; Search Steam libraries for Isaac with REPENTOGON
  DetailPrint "Searching Steam libraries for REPENTOGON installation..."
  Sleep 800
  
  ${If} ${FileExists} "$SteamInstallPath\steamapps\libraryfolders.vdf"
    Call FindIsaacInSteamLibraries
    ${If} $IsaacInstallPath != ""
      DetailPrint "✓ Found Binding of Isaac with REPENTOGON in $IsaacInstallPath"
      Sleep 1000
      Goto install_file
    ${EndIf}
  ${EndIf}
  
  DetailPrint "Isaac with REPENTOGON not found in Steam libraries - trying manual selection..."
  Sleep 1000
  Call TryManualSelection
  ${If} $IsaacInstallPath == ""
    !insertmacro AbortWithError "Unable to find where Binding of Isaac with REPENTOGON is installed."
  ${EndIf}

  install_file:
  DetailPrint "Installing zhlLuaSocketFix.dll..."
  Sleep 800
  SetOutPath "$IsaacInstallPath"
  File "zhlLuaSocketFix.dll"
  DetailPrint "✓ zhlLuaSocketFix.dll installed successfully"
  Sleep 1000
  DetailPrint "Installation completed! You can now start The Binding of Isaac: Rebirth."
  Sleep 500
  DetailPrint ""
  DetailPrint "Click 'Next' to continue..."
  
  SetAutoClose false
SectionEnd