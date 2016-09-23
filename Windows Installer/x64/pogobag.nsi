

RequestExecutionLevel admin
;SetCompressor lzma


!define PRODUCT_NAME "PoGoBag Server Installer for Windows(x64)"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "evilhawk00"
!define PRODUCT_WEB_SITE "http://github.com/evilhawk00"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\PoGoBag_Launcher.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "header.bmp"
!define MUI_HEADERIMAGE_RIGHT
BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION}"
; MUI 1.67 compatible ------
!include "MUI.nsh"
!include "x64.nsh"
!include 'LogicLib.nsh'
!include "nsProcess.nsh"
!define LIBRARY_X64






; MUI Settings
!define MUI_ABORTWARNING
;!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_ICON "009BLASTOISE.ico"
;!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_UNICON "131LAPRAS.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "License.rtf"
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
;!define MUI_FINISHPAGE_RUN "$TEMP\rubyinstaller-2.3.1-x64.exe"
;!define MUI_FINISHPAGE_RUN_PARAMETERS "/SILENT /NOCANCEL"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"
;!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "TradChinese"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Setup.exe"
InstallDir "$PROGRAMFILES\PoGoBagServer"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

;retrieved programfiles path from system
var SysEnvProgramFiles64
var SysEnvProgramFiles32



Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function 7zExtractPrograss
 Pop $R8
 Pop $R9
 SetDetailsPrint textonly
 DetailPrint "Extracting ($R8 / $R9) bytes"
 SetDetailsPrint both
FunctionEnd



;check if default programfiles path has been changed
Function CheckProgramFilesPath
 ;ReadRegStr $0 HKLM Software\NSIS ""
 
 Readenvstr $SysEnvProgramFiles64 ProgramW6432
 Readenvstr $SysEnvProgramFiles32 ProgramFiles
 ${If} $SysEnvProgramFiles64 == "C:\Program Files"
 ;passed
 ${Else}
 ;not passed
 Messagebox MB_USERICON `Your system variable %ProgramFiles% for 64bit applications is not "C:\Program Files". This installer does not support customized ProgramFiles locations. Installation aborted.`
 abort
 ${EndIf}
 
 ${If} $SysEnvProgramFiles32 == "C:\Program Files (x86)"
 ;passed
 ${Else}
 ;not passed
 Messagebox MB_USERICON `Your system variable %ProgramFiles% for 32bit applications is not "C:\Program Files (x86)". This installer does not support customized ProgramFiles locations. Installation aborted.`
 abort
 ${EndIf}
FunctionEnd


;check it directory exist
!macro _IsNonEmptyDirectory _a _b _t _f
!insertmacro _LOGICLIB_TEMP
!insertmacro _IncreaseCounter
Push $0
FindFirst $0 $_LOGICLIB_TEMP "${_b}\*"
_IsNonEmptyDirectory_loop${LOGICLIB_COUNTER}:
    StrCmp "" $_LOGICLIB_TEMP _IsNonEmptyDirectory_done${LOGICLIB_COUNTER}
    StrCmp "." $_LOGICLIB_TEMP +2
    StrCmp ".." $_LOGICLIB_TEMP 0 _IsNonEmptyDirectory_done${LOGICLIB_COUNTER}
    FindNext $0 $_LOGICLIB_TEMP
    Goto _IsNonEmptyDirectory_loop${LOGICLIB_COUNTER}
_IsNonEmptyDirectory_done${LOGICLIB_COUNTER}:
FindClose $0
Pop $0
!insertmacro _!= "" $_LOGICLIB_TEMP `${_t}` `${_f}`
!macroend
!define IsNonEmptyDirectory `"" IsNonEmptyDirectory`

Function CheckDevKitDir
${If} ${IsNonEmptyDirectory} "C:\DevKit"
    MessageBox MB_YESNO `The directory for installing Ruby DevKit "C:\DevKit" already exists, delete it's content and continue installing?` IDYES yep IDNO nah
    
yep:
    SetDetailsPrint textonly
    RMDir /r "C:\DevKit"
    goto end
nah:
    Messagebox MB_USERICON "Installation aborted. Continue to rollback the changes."
    SetDetailsPrint both
    DetailPrint "Removing Ruby(64bit)..."
    SetDetailsPrint none
    ExecWait '"C:\Ruby23-x64\unins000.exe" /SILENT /NOCANCEL' $0
    SetDetailsPrint both
    DetailPrint "Changes reverted, installation aborted."
    abort
end:
${EndIf}
FunctionEnd



Section "MainSection" SEC01

  call CheckProgramFilesPath
  SetDetailsPrint none
  SetOutPath "$TEMP"
  SetOverwrite on
  ;install ruby
  SetDetailsPrint textonly
  DetailPrint "Preparing Ruby(64bit)..."
  SetDetailsPrint listonly
  File "rubyinstaller-2.3.1-x64.exe"
  SetDetailsPrint both
  DetailPrint "Installing Ruby(64bit)..."
  SetDetailsPrint none
  ;${DisableX64FSRedirection}
  ;SetRegView 64
  ExecWait '"rubyinstaller-2.3.1-x64.exe" /SILENT /NOCANCEL /tasks="assocfiles,modpath"' $0
  Delete "$OUTDIR\rubyinstaller-2.3.1-x64.exe"
  ;${EnableX64FSRedirection}
  ;extract rubydevkit
  
  ;if C:\DevKit exists but empty,delete it
  Call CheckDevKitDir
  
  
  SetDetailsPrint none
  SetOutPath "C:\."
  SetDetailsPrint textonly
  DetailPrint "Preparing Ruby DevKit(64bit)..."
  SetDetailsPrint listonly
  File "DevKit-mingw64-64-4.7.2-20130224-1432.7z"
  SetDetailsPrint none
  ;RMDir /r "C:\DevKit\"
  SetDetailsPrint listonly
  DetailPrint "Extracting from Archive DevKit-mingw64-64-4.7.2-20130224-1432.7z"
  SetDetailsPrint none
  GetFunctionAddress $R9 7zExtractPrograss
  Nsis7z::ExtractWithCallback "DevKit-mingw64-64-4.7.2-20130224-1432.7z" $R9
  SetDetailsPrint none
  ;DetailPrint "Copying Extracted Files..."
  ;Rename "$OUTDIR\DevKit-mingw64-64-4.7.2-20130224-1432-sfx\" "$OUTDIR\DevKit\"
  Delete "$OUTDIR\DevKit-mingw64-64-4.7.2-20130224-1432.7z"
  ;SetDetailsPrint none
  SetOutPath "$TEMP"
  ;SetOutPath "C:\DevKit"
  SetDetailsPrint both
  DetailPrint "Configuring Ruby DevKit(64bit)..."
  ;SetDetailsPrint textonly
  ;DetailPrint "Configuring Ruby DevKit Step(1/2)..."
  ;SetDetailsPrint none
  ;ExecWait 'ruby dk.rb init' $0
  ;SetDetailsPrint textonly
  ;DetailPrint "Configuring Ruby DevKit Step(2/2)..."
  ;SetDetailsPrint both
  ;ExecDos::exec /DETAILED 'ruby dk.rb install'
  SetDetailsPrint none
  
  File "PGBIns_DKRB.exe"
  ExecWait 'PGBIns_DKRB.exe' $0
  Delete "$OUTDIR\PGBIns_DKRB.exe"
  
  
  ;ExecWait '"C:\Ruby23-x64\bin\ruby.exe" dk.rb install' $0
  ;SetOutPath "$TEMP"
  SetDetailsPrint textonly
  DetailPrint "Preparing Git(64bit)..."
  SetDetailsPrint listonly
  File "Git-2.9.3-64-bit.exe"
  SetDetailsPrint both
  DetailPrint "Installing Git(64bit)..."
  SetDetailsPrint none
  ExecWait '"Git-2.9.3-64-bit.exe" /SILENT /NOCANCEL' $0
  Delete "$OUTDIR\Git-2.9.3-64-bit.exe"
  SetDetailsPrint textonly
  DetailPrint "Preparing Node.js(64bit)..."
  SetDetailsPrint listonly
  File "node-v4.4.7-x64.msi"
  SetDetailsPrint both
  DetailPrint "Installing Node.js(64bit)..."
  SetDetailsPrint none
  ExecWait '"msiexec.exe" /i "node-v4.4.7-x64.msi" /qb-!' $0
  Delete "$OUTDIR\node-v4.4.7-x64.msi"
  

  ;temporary set custom path

  system::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("PATH", "C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program Files\nodejs\;C:\Program Files\Git\cmd;C:\Ruby23-x64\bin").r0'
  
  

  ;SetOutPath "$sysdir"
  SetDetailsPrint textonly
  DetailPrint "Installing Rails...This could take some time."
  SetDetailsPrint listonly
  DetailPrint "Installing Rails..."
  SetDetailsPrint none
  File "PGBIns_rails.exe"
  ExecWait 'PGBIns_rails.exe' $0
  Delete "$OUTDIR\PGBIns_rails.exe"
  ;ExecWait 'gem.bat install rails' $0
  ;ExecWait '"C:\Ruby23-x64\bin\gem.cmd" install rails --no-rdoc --no-ri' $0
  ;ExecDos::exec '"C:\Ruby23-x64\bin\gem.cmd" install rails'
  ;ExecDos::exec 'ruby gem install rails'

  
  SetDetailsPrint textonly
  DetailPrint "Installing bundler...This could take some time."
  SetDetailsPrint listonly
  DetailPrint "Installing bundler..."
  SetDetailsPrint none
  ;ExecWait 'gem install bundler' $0
  ;ExecWait '"$sysdir\cmd.exe" /c "C:\Ruby23-x64\bin\gem.cmd" install bundler' $0
  ;ExecDos::exec /DETAILED '"C:\Ruby23-x64\bin\gem.cmd" install bundler --no-rdoc --no-ri'
  File "PGBIns_Bun.exe"
  ExecWait 'PGBIns_Bun.exe' $0
  Delete "$OUTDIR\PGBIns_Bun.exe"
  
  
  
  ;SetOutPath "$PROGRAMFILES64\Git\cmd"
  ;SetOutPath "C:\."
  ;SetOutPath "$TEMP"
  SetDetailsPrint both
  DetailPrint "Downloading Latest PoGoBag from Git(Repository by dphuang2)"
  SetDetailsPrint none
  File "PGBIns_ClonePGB.exe"
  ExecWait 'PGBIns_ClonePGB.exe' $0
  ;error dummy file "PoGoBagInstaller_GitClone.error"
  Delete "$OUTDIR\PGBIns_ClonePGB.exe"
  ;ExecDos::exec /DETAILED '"$PROGRAMFILES64\Git\cmd\git.exe" clone "https://github.com/dphuang2/PoGoBag.git" "C:\PoGoBag"'
  ;ExecWait '"$PROGRAMFILES64\Git\cmd\git.exe" clone "https://github.com/dphuang2/PoGoBag.git" "C:\PoGoBag"' $0
  ;ExecWait '"$sysdir\cmd.exe" /k "git clone "https://github.com/dphuang2/PoGoBag.git""'
  ;SetDetailsPrint none
  ;SetOutPath "C:\PoGoBag"
  
  
 
  
 
  
  SetDetailsPrint textonly
  DetailPrint "Downloading&Installing All Dependencies...This could take a long time."
  SetDetailsPrint listonly
  DetailPrint "Downloading&Installing All Dependencies..."
  SetDetailsPrint none
  
  File "PGBIns_BID.exe"
  ExecWait 'PGBIns_BID.exe' $0
  Delete "$OUTDIR\PGBIns_BID.exe"
  ;ExecDos::exec 'ruby bundle install --without production'
  ;ExecWait '"$sysdir\cmd.exe" /c "bundle install'
  ;ExecWait '"C:\Ruby23-x64\bin\bundle.bat" install --without production' $0
  ;ExecDos::exec '"C:\Ruby23-x64\bin\bundle.bat" install --without production'
  
  ;ExecDos::exec 'ruby gem uninstall sqlite3'
  
  SetDetailsPrint both
  DetailPrint "Removing Bugged SQLite3..."
  SetDetailsPrint none
  File "PGBIns_RMSQL3.exe"
  ExecWait 'PGBIns_RMSQL3.exe' $0
  Delete "$OUTDIR\PGBIns_RMSQL3.exe"
  ;ExecDos::exec /DETAILED '"C:\Ruby23-x64\bin\gem.cmd" uninstall sqlite3'
  SetDetailsPrint both
  DetailPrint "Applying sqlite3 patch for Windows..."
  ;install sqlite3 manully
  SetDetailsPrint none
  CreateDirectory "C:\Ruby23-x64\temp"
  SetOutPath "C:\Ruby23-x64\temp"
  File "sqlite-amalgamation-3140100.7z"
  GetFunctionAddress $R9 7zExtractPrograss
  Nsis7z::ExtractWithCallback "sqlite-amalgamation-3140100.7z" $R9
  SetDetailsPrint none
  Delete "$OUTDIR\sqlite-amalgamation-3140100.7z"
  SetOutPath "C:\Ruby23-x64\bin"
  File "sqlite-dll-win64-x64-3140100.7z"
  GetFunctionAddress $R9 7zExtractPrograss
  Nsis7z::ExtractWithCallback "sqlite-dll-win64-x64-3140100.7z" $R9
  SetDetailsPrint textonly
  DetailPrint "Applying sqlite3 patch for Windows..."
  SetDetailsPrint none
  Delete "$OUTDIR\sqlite-dll-win64-x64-3140100.7z"
  SetOutPath "$TEMP"
  ;ExecWait '"C:\Ruby23-x64\bin\gem.cmd" install sqlite3 --no-rdoc --no-ri --platform=ruby -- --with-sqlite3-include="C:\Ruby23-x64\temp" --with-sqlite3-lib="C:\Ruby23-x64\bin"' $0
  File "PGBIns_SQL3.exe"
  ExecWait 'PGBIns_SQL3.exe' $0
  Delete "$OUTDIR\PGBIns_SQL3.exe"

  RMDir /r "C:\Ruby23-x64\temp"
  SetDetailsPrint both
  DetailPrint "Configuring PoGoBag database..."
  SetDetailsPrint none
  ;setup database
  ;SetOutPath "C:\PoGoBag"
  File "GBIns_CFDB.exe"
  ExecWait 'GBIns_CFDB.exe' $0
  Delete "$OUTDIR\GBIns_CFDB.exe"
  ;ExecWait '"C:\Ruby23-x64\bin\rake.bat" db:setup' $0
  
  
  SetOutPath "$INSTDIR"
  SetDetailsPrint both
  File "PoGoBag_Launcher.exe"
  CreateDirectory "$SMPROGRAMS\PoGoBag Server Launcher"
  CreateShortCut "$SMPROGRAMS\PoGoBag Server Launcher\Launch PoGoBag Server.lnk" "$INSTDIR\PoGoBag_Launcher.exe"
  CreateShortCut "$DESKTOP\Launch PoGoBag Server.lnk" "$INSTDIR\PoGoBag_Launcher.exe"
  File "PoGoBag_Updater.exe"
  CreateShortCut "$SMPROGRAMS\PoGoBag Server Launcher\Upgrade PoGoBag.lnk" "$INSTDIR\PoGoBag_Updater.exe"
  CreateShortCut "$DESKTOP\Upgrade PoGoBag.lnk" "$INSTDIR\PoGoBag_Updater.exe"
  ;CreateShortCut "$SMPROGRAMS\PoGoBag Server Launcher\Uninstall PoGoBag.lnk" "$INSTDIR\uninst.exe"
  SetDetailsPrint none
  File "desktop.ini"
  SetFileAttributes "desktop.ini" HIDDEN|SYSTEM
  SetFileAttributes "$INSTDIR" SYSTEM
  
SectionEnd

Section -AdditionalIcons
  CreateShortCut "$SMPROGRAMS\PoGoBag Server Launcher\Uninstall PoGoBag.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\Start_PoGoBag.bat"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\PoGoBag_Launcher.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) has been successfully removed from your computer."
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to uninstall $(^Name) and all its components¡H" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  ${nsProcess::KillProcess} "ruby.exe" $R0
  ${nsProcess::KillProcess} "PoGoBag_Launcher.exe" $R0
  ${nsProcess::KillProcess} "PoGoBag_Updater.exe" $R0
  ${nsProcess::KillProcess} "git.exe" $R0
  SetDetailsPrint both
  DetailPrint "Removing Ruby(64bit)..."
  SetDetailsPrint none
  ExecWait '"C:\Ruby23-x64\unins000.exe" /SILENT /NOCANCEL' $0
  SetDetailsPrint both
  DetailPrint "Removing Git(64bit)..."
  SetDetailsPrint none
  ExecWait '"$PROGRAMFILES64\Git\unins000.exe" /SILENT /NOCANCEL' $0
  SetDetailsPrint both
  DetailPrint "Removing Node.js(64bit)..."
  SetDetailsPrint none
  ExecWait '"MsiExec.exe" /x {8434AEA1-1294-47E3-9137-848F546CD824} /qb-!' $0
  Delete "$INSTDIR\uninst.exe"
  SetDetailsPrint textonly
  DetailPrint "Removing Ruby DevKit(64bit)..."
  SetDetailsPrint listonly
  RMDir /r "C:\DevKit\"
  SetDetailsPrint textonly
  DetailPrint "Removing PoGoBag..."
  SetDetailsPrint listonly
  RMDir /r "C:\PoGoBag\"
  SetDetailsPrint textonly
  DetailPrint "Cleaning up ruby installed gems..."
  SetDetailsPrint listonly
  RMDir /r "C:\Ruby23-x64\"
  Delete "$INSTDIR\PoGoBag_Updater.exe"
  Delete "$INSTDIR\PoGoBag_Launcher.exe"
  Delete "$SMPROGRAMS\PoGoBag Server Launcher\Uninstall PoGoBag.lnk"
  Delete "$DESKTOP\Upgrade PoGoBag.lnk"
  Delete "$SMPROGRAMS\PoGoBag Server Launcher\Upgrade PoGoBag.lnk"
  Delete "$DESKTOP\Launch PoGoBag Server.lnk"
  Delete "$SMPROGRAMS\PoGoBag Server Launcher\Launch PoGoBag Server.lnk"

  RMDir "$SMPROGRAMS\PoGoBag Server Launcher"
  Delete "$INSTDIR\desktop.ini"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd