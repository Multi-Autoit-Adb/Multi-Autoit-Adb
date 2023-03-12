
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <GuiListView.au3>
#include <ListviewConstants.au3>
#include "lib/Android.au3"
#include "lib/AndroidConstants.au3"
#include "lib/WM_COPYDATA.au3"
#include <GUIButton.au3>
#include <WinAPISysWin.au3>
#include <WinAPIProc.au3>
#include <StringConstants.au3>
#include <GuiRichEdit.au3>
#include <File.au3>
#include <WinAPIFiles.au3>
#include <GuiComboBox.au3>
#include <GuiIPAddress.au3>
#include <GuiMenu.au3>
#include <Date.au3>
#include <GUIScrollBars.au3>
#include <ScrollBarConstants.au3>
#include "lib/GUIScrollbars_Size.au3"


Opt("WinTitleMatchMode", 4) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
Opt("WinSearchChildren", 1) ;0=no, 1=search children also


Global $oDi = ObjCreate('scripting.dictionary')
Global $oDiDisplay = ObjCreate('scripting.dictionary')

Global $DevicesWidth = 270
Global $DevicesHeight = 600
Global $InforDeviceForm = Null
Global $ListScript = Null
Global $ListApps = Null
Global $aConfigInformation = Null
Global $ScriptManagerForm = Null
Global $DisplayManagerForm = Null
Global $ScriptConfigForm = Null
Global $InstallAppsForm = Null
Global $ComboSelectScript=Null
Global $sRead = Null
Global $aDevicesListView = Null
Global $idButtoncontext = Null
Global $idMenuInformation = Null
Global $idMenuScript = Null
Global $idMenuReboot = Null
Global $idMenuShutDown = Null
Global $idMenuConfig = Null
Global $ScriptPid = Null
Global $OpenModalDeviceName = Null
Global $DeviceProcess = True
Global $sFilePath = _WinAPI_GetTempFileName(@TempDir)
Global $selectWifi = Null
Global $SelectAirplane = Null
Global $SelectData = Null
Global $SelectBluetooth = Null
Global $SelectUSB = Null
Global $serverInputGUI = Null
Global $portGui = Null
Global $RelayServer = Null
Global $UpdateProxy = Null
Global $ClearProxy = Null
Global $SaveDisplaySetting = Null
Global $SelectNoControl = Null
Global $SelectStayAwake = Null
Global $WidthDevices = Null
Global $HeightDevices = Null
Global $idRotation = Null
Global $PhoneNumber = Null
Global $Phonemessage = Null
Global $aDataConfig = Null
Global $CreateKeyData = Null
Global $inputkeyvalueForm = Null
Global $SaveData  = Null
Global $KeyData = Null
Global $ValueData = Null
Global $idMenuRemoveData = Null

#Region ### START Koda GUI section ### Form=
$FormMain = GUICreate("Multi AutoIT ADB", @DesktopWidth, @DesktopHeight, 0, 0,  BitOR($GUI_SS_DEFAULT_GUI,$WS_VSCROLL))

$aRet = _GUIScrollbars_Size(0, $DevicesHeight, 300, 300)

_GUIScrollBars_Init($FormMain)
_GUIScrollBars_ShowScrollBar($FormMain, $SB_VERT, True)
_GUIScrollBars_ShowScrollBar($FormMain, $SB_HORZ, False)
_GUIScrollBars_SetScrollInfoPage($FormMain, $SB_VERT, $aRet[2])
_GUIScrollBars_SetScrollInfoMax($FormMain, $SB_VERT, $aRet[3])

$mEditmenu = GUICtrlCreateMenu("Option")
$mScriptitem = GUICtrlCreateMenuItem("Script File", $mEditmenu )
$mDisplayitem = GUICtrlCreateMenuItem("Display", $mEditmenu )
$mExititem = GUICtrlCreateMenuItem("Exit", $mEditmenu )
		
$aListDevices = GUICtrlCreateListView("", 0, 0, ((@DesktopWidth) *20)/100	, @DesktopHeight-600, -1)
_GUICtrlListView_SetExtendedListViewStyle(-1, BitOR( $LVS_EX_FULLROWSELECT  , $LVS_EX_CHECKBOXES))
_GUICtrlListView_InsertColumn($aListDevices, 0, "ID", 100)
_GUICtrlListView_InsertColumn($aListDevices, 1, "Name", 100)
_GUICtrlListView_InsertColumn($aListDevices, 2, "Temp", 50)
_GUICtrlListView_InsertColumn($aListDevices, 3, "Battery", 50)
$idButtoncontext = GUICtrlCreateContextMenu($aListDevices)
$idMenuScript = GUICtrlCreateMenuItem("Start Script", $idButtoncontext)
$idMenuConfig = GUICtrlCreateMenuItem("Config", $idButtoncontext)
$idinstallapps = GUICtrlCreateMenuItem("Install Apps", $idButtoncontext)
GUICtrlCreateMenuItem("",$idButtoncontext) 

$idSelectScript = GUICtrlCreateMenu("Run Script", $idButtoncontext)
Local $aFileList = _FileListToArray("script", "*",1)
Global $EventMenuScriptItem[$aFileList[0]]
	For $x = 0 to $aFileList[0]-1
		$EventMenuScriptItem[$x] = GUICtrlCreateMenuItem($aFileList[$x+1], $idSelectScript)
	Next
GUICtrlCreateMenuItem("",$idButtoncontext) 
$idMenuReboot = GUICtrlCreateMenuItem("Reboot", $idButtoncontext)
$idMenuShutDown = GUICtrlCreateMenuItem("Shut Down", $idButtoncontext)
GUICtrlCreateMenuItem("",$idButtoncontext) 
$idMenuInformation = GUICtrlCreateMenuItem("About Device", $idButtoncontext)


$aProcessScript = GUICtrlCreateListView("", 0, @DesktopHeight-610, ((@DesktopWidth) *20)/100	, @DesktopHeight-600, -1)
_GUICtrlListView_SetExtendedListViewStyle(-1,$LVS_EX_FULLROWSELECT)
_GUICtrlListView_InsertColumn($aProcessScript, 0, "pId", 50)
_GUICtrlListView_InsertColumn($aProcessScript, 1, "Device", 100)
_GUICtrlListView_InsertColumn($aProcessScript, 2, "Script", 100)
_GUICtrlListView_InsertColumn($aProcessScript, 3, "Usage", 100)
$idButtoncontextProcessScript = GUICtrlCreateContextMenu($aProcessScript)
$idMenuProcessScript = GUICtrlCreateMenuItem("Stop",$idButtoncontextProcessScript)


$aProcessLog = GUICtrlCreateListView("", 0, @DesktopHeight-350, ((@DesktopWidth) *20)/100	, @DesktopHeight-600, -1)
_GUICtrlListView_SetExtendedListViewStyle(-1,$LVS_EX_FULLROWSELECT)
_GUICtrlListView_InsertColumn($aProcessLog , 0, "Device", 100)
_GUICtrlListView_InsertColumn($aProcessLog , 1, "Log", 100)
_GUICtrlListView_InsertColumn($aProcessLog , 2, "Time", 100)
$idButtoncontextProcessLog = GUICtrlCreateContextMenu($aProcessLog)
$idMenuDeviceLog = GUICtrlCreateMenu("Device Filter",$idButtoncontextProcessLog)
$idMenuClearLog = GUICtrlCreateMenuItem("Clear",$idButtoncontextProcessLog)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
GUIRegisterMsg($WM_DEVICECHANGE, "WM_DEVICECHANGE")
GUIRegisterMsg($WM_DESTROY, "WM_DESTROY")
GUIRegisterMsg($WM_COPYDATA, "WM_COPYDATA_ReceiveData") ; register WM_COPYDATA
GUIRegisterMsg($WM_VSCROLL, "_Scrollbars_WM_VSCROLL")

GUISetState(@SW_SHOW)


#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg(1)
	LoadDisplay()
	InitData()
	Switch $nMsg[0]
	Case $GUI_EVENT_CLOSE
		;CloseWindowForm()
		If $nMsg[1] = $FormMain Then
			GUISwitch($FormMain)
			GUIDelete($FormMain)
		EndIf
		If $nMsg[1] = $InforDeviceForm Then
			GUISwitch($InforDeviceForm)
			GUIDelete($InforDeviceForm)
		EndIf
		
		If $nMsg[1] = $ScriptManagerForm Then
			GUISwitch($ScriptManagerForm)
			GUIDelete($ScriptManagerForm)
		EndIf
		If $nMsg[1] = $InstallAppsForm Then
			GUISwitch($InstallAppsForm)
			GUIDelete($InstallAppsForm)
		EndIf		
		
		If $nMsg[1] = $DisplayManagerForm Then
			GUISwitch($DisplayManagerForm)
			GUIDelete($DisplayManagerForm)
		EndIf
		
		If $nMsg[1] = $ScriptConfigForm Then
			GUISwitch($ScriptConfigForm)
			GUIDelete($ScriptConfigForm)
		EndIf			
		
		
		If $nMsg[1] = $inputkeyvalueForm Then
			GUISwitch($inputkeyvalueForm)
			GUIDelete($inputkeyvalueForm)
		EndIf
		CloseAll()
		
	Case $mDisplayitem
		DisplayManagerForm()
	Case $mExititem
		CloseAll()
		Exit
	Case $SaveDisplaySetting
		SaveDisplaySetting()
	Case $EventMenuScriptItem[0] To $EventMenuScriptItem[UBound($EventMenuScriptItem)-1]
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		$x = $nMsg[0]-$EventMenuScriptItem[0]+1
		Local $aFileList = _FileListToArray("script", "*",1)
		$aProcessListView = _GUICtrlListView_GetItemsArray($aProcessScript,2)
		
		$checkDevice = 0
		If UBound($aProcessListView) > 0 Then
			For $aProcessListItem in $aProcessListView
				if StringReplace($aProcessListItem, " ", "") = $aFileList[$x] Then
					$checkDevice = $checkDevice + 1
				EndIf
			Next
		EndIf
		
		$aDeviceScript = _GUICtrlListView_GetItemsArray($aProcessScript,1)
		If UBound($aDeviceScript) > 0 Then
			For $aDeviceScriptItem in $aDeviceScript
				if StringReplace($aDeviceScriptItem, " ", "") = $sAppClicked Then
					ConsoleWrite($aDeviceScriptItem)
					$checkDevice = $checkDevice + 1
				EndIf
			Next
		EndIf
		
		
		UpdateScriptPid()
		$found = _ArraySearch($aProcessListView,$aFileList[$x])
		;Bug here
		If $checkDevice < 2 Then
			CreateProcRunScript($sAppClicked,$aFileList[$x])
		Else
			MsgBox(0,"Oops","Please! Stop script before starting")
		EndIf
	Case $ComboSelectScript
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		iniWrite($sFilePath, "Script", $sAppClicked ,GUICtrlRead($ComboSelectScript))
	Case $idMenuClearLog
		_GUICtrlListView_DeleteAllItems ( $aProcessLog)
	Case $mScriptitem
		$OpenModalDeviceName = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		If $ScriptManagerForm = Null Then 
			$ScriptManagerForm = GUICreate("Script File", 600, 600, 200, 200, -1, -1, $FormMain)
			$ListScript = GUICtrlCreateListView("", 0, 0, 600, 600)
			_GUICtrlListView_InsertColumn($ListSCript ,0, "Name Script", 600)
			GUISetState(@SW_SHOW)
			Local $aFileList = _FileListToArray("script", "*",1)
			For $x = 1 to $aFileList[0]
				_GUICtrlListView_InsertItem($ListSCript, $aFileList[$x] , 0)
			Next
		EndIf

	Case $SelectNoControl
		GUICtrlSetState($SelectStayAwake, $GUI_DISABLE)
	Case $idMenuInformation
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		If $sAppClicked <> "" Then
			$OpenModalDeviceName = $sAppClicked
			AboutDevice($sAppClicked)
		EndIf
	Case $idMenuScript
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		$aProcessListView = _GUICtrlListView_GetItemsArray($aProcessScript,1)
		UpdateScriptPid()
		$found = _ArraySearch($aProcessListView,$sAppClicked)
		If $found = -1 Then
			CreateProcScript($sAppClicked)
		Else
			MsgBox(0,"Oops","Please! Stop script before starting")
		EndIf
	Case $selectWifi
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		If BitAND(GUICtrlRead($selectWifi), $BN_CLICKED) = $BN_CLICKED Then
			If _GUICtrlButton_GetCheck($selectWifi) Then
				__Run('adb -s ' & $sAppClicked &' shell svc wifi enable')
			Else
				__Run('adb -s ' & $sAppClicked &' shell svc wifi disable')
			EndIf
		EndIf
	Case $SelectAirplane
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		If BitAND(GUICtrlRead($SelectAirplane), $BN_CLICKED) = $BN_CLICKED Then
			If _GUICtrlButton_GetCheck($SelectAirplane) Then
				__Run('adb -s ' & $sAppClicked &' shell settings put global airplane_mode_on 1')
				__Run('adb -s ' & $sAppClicked &' shell am broadcast -a android.intent.action.AIRPLANE_MODE')
			Else
				__Run('adb -s ' & $sAppClicked &' shell settings put global airplane_mode_on 0')
				__Run('adb -s ' & $sAppClicked &' shell am broadcast -a android.intent.action.AIRPLANE_MODE')
			EndIf
		EndIf
	Case $SelectData
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		If BitAND(GUICtrlRead($SelectData), $BN_CLICKED) = $BN_CLICKED Then
			If _GUICtrlButton_GetCheck($SelectData) Then
				__Run('adb -s ' & $sAppClicked &' shell svc data enable')
			Else
				__Run('adb -s ' & $sAppClicked &' shell svc data disable')
			EndIf
		EndIf
	Case $SelectBluetooth
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		If BitAND(GUICtrlRead($SelectBluetooth), $BN_CLICKED) = $BN_CLICKED Then
			If _GUICtrlButton_GetCheck($SelectBluetooth) Then
				__Run('adb -s ' & $sAppClicked &' shell  settings put global bluetooth_on 1')
			Else
				__Run('adb -s ' & $sAppClicked &' shell settings put global bluetooth_on 0')
			EndIf
		EndIf
	Case $SelectUSB
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		If BitAND(GUICtrlRead( $SelectUSB), $BN_CLICKED) = $BN_CLICKED Then
			If _GUICtrlButton_GetCheck( $SelectUSB) Then
				StartConnectRelayServer($sAppClicked)
			Else
				StopConnectRelayServer($sAppClicked)
			EndIf
		EndIf
	Case $UpdateProxy
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		$http_proxy = _GUICtrlIpAddress_Get ( $serverInputGUI )& ":" &GUICtrlRead($portGui)
		StartProxy($http_proxy,$sAppClicked)
		MsgBox(0,"Notification","Saved Success")
	Case $ClearProxy
		_GUICtrlIpAddress_Set($serverInputGUI, "0.0.0.0")
		GUICtrlSetData($portGui,"0" )
		StopProxy($sAppClicked)
		MsgBox(0,"Notification","Clean")
	Case $idMenuConfig
		
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		If $sAppClicked <> "" Then
			$OpenModalDeviceName = $sAppClicked
		If $ScriptConfigForm = Null Then
		$ScriptConfigForm = GUICreate("Config", 600, 600, 200, 200, -1, -1, $FormMain)
		Local $aFileList = _FileListToArray("script", "*",1)
		$sRead = IniRead($sFilePath, "Script",$sAppClicked , Null)
		$sDataScript = ""
		$selectedScript = 0
		For $x = 1 to $aFileList[0]
			 $sDataScript &= $aFileList[$x] & "|"
			 If $sRead = $aFileList[$x] Then
				 $selectedScript = $x-1
			EndIf
		Next
		GUICtrlCreateLabel("Default Script:", 12, 15, 85) 
		$ComboSelectScript = GUICtrlCreateCombo(Null, 90, 10,280)
		GUICtrlSetData($ComboSelectScript, $sDataScript) 
		_GUICtrlComboBox_SetCurSel($ComboSelectScript, $selectedScript)

		
		
		GUICtrlCreateLabel("Select Connect:", 12, 43, 85) 
		$SelectWifi = GUICtrlCreateCheckbox("Wifi", 90, 35, 40, 30)
		if _Android_GetGlobal($OpenModalDeviceName,"wifi_on") = 1 Then 
			GUICtrlSetState(-1, $GUI_CHECKED)
		EndIf
		
		$SelectUSB = GUICtrlCreateCheckbox("USB", 130, 35, 40, 30)
		If CheckRelayServerDevice($OpenModalDeviceName)  == True Then
			GUICtrlSetState(-1, $GUI_CHECKED)
		EndIf
		
		$SelectAirplane = GUICtrlCreateCheckbox("AirPlane", 170, 35, 60, 30)
		if _Android_IsAirplaneModeOn($OpenModalDeviceName) Then 
			GUICtrlSetState(-1, $GUI_CHECKED)
		EndIf
		$SelectData = GUICtrlCreateCheckbox("Data", 230, 35, 40, 30)
		if _Android_GetGlobal($OpenModalDeviceName,"mobile_data") = 1 Then 
			GUICtrlSetState(-1, $GUI_CHECKED)
		EndIf
		$SelectBluetooth = GUICtrlCreateCheckbox("Bluetooth", 270, 35, 60, 30)
		if _Android_GetGlobal($OpenModalDeviceName,"bluetooth_on") = 1 Then 
			GUICtrlSetState(-1, $GUI_CHECKED)
		EndIf
		
		
		GUICtrlCreateLabel("Proxy Address:", 12, 76, 85)
		$serverInputGUI =	_GUICtrlIpAddress_Create($ScriptConfigForm, 90, 73)
		_GUICtrlIpAddress_Set($serverInputGUI, "0.0.0.0")
		GUICtrlCreateLabel("Port:", 230, 76, 40)
		$portGui = GUICtrlCreateInput("00", 260, 73, 50, 20)
		
		$UpdateProxy = GUICtrlCreateButton("Save", 330, 70, 85, 25)
		$ClearProxy = GUICtrlCreateButton("Clear", 430, 70, 85, 25)
		if _Android_GetGlobal($OpenModalDeviceName,"http_proxy") <> ":0" And  _Android_GetGlobal($OpenModalDeviceName,"http_proxy") <> "null" Then 
			$addressport  = StringSplit ( _Android_GetGlobal($OpenModalDeviceName,"http_proxy"), ":" )
			If UBound($addressport) > 2 Then
				$address = $addressport[1]
				$port = $addressport[2]
				_GUICtrlIpAddress_Set($serverInputGUI, $address)
				 GUICtrlSetData($portGui,$port )
				GUICtrlSetState(-1, $GUI_CHECKED)
			EndIf
		EndIf
		
		$CreateKeyData = GUICtrlCreateButton("Set Key - Value", 10, 110 , 85, 25)
		$aDataConfig = GUICtrlCreateListView("",0,140 , 600	,300 )
		_GUICtrlListView_SetExtendedListViewStyle(-1,$LVS_EX_FULLROWSELECT)
		_GUICtrlListView_InsertColumn($aDataConfig, 0, "Key", 200)
		_GUICtrlListView_InsertColumn($aDataConfig, 1, "Value", 400)
		$iniData = IniReadSection($sFilePath,$OpenModalDeviceName)
		If @error Then
		Else
			For $i = 1 To $iniData[0][0]
				GUICtrlCreateListViewItem($iniData[$i][0] & "|" &$iniData[$i][1] ,$aDataConfig)
			Next
		EndIf
		$idButtoncontextData = GUICtrlCreateContextMenu($aDataConfig)
		$idMenuRemoveData = GUICtrlCreateMenuItem("Remove",$idButtoncontextData)
		GUISetState(@SW_SHOW)
		EndIf
	EndIf
	Case $idMenuRemoveData
		$sAppClicked = _GUICtrlListView_GetItemText($aDataConfig, Number(_GUICtrlListView_GetSelectedIndices($aDataConfig)))
		IniDelete ( $sFilePath, $OpenModalDeviceName , $sAppClicked )
		_GUICtrlListView_DeleteAllItems($aDataConfig)
		$iniData = IniReadSection($sFilePath,$OpenModalDeviceName)
		If @error Then
		Else
			For $i = 1 To $iniData[0][0]
				GUICtrlCreateListViewItem($iniData[$i][0] & "|" &$iniData[$i][1] ,$aDataConfig)
			Next
		EndIf
		MsgBox(0,"Notification","Remove sucessful")
	Case $CreateKeyData
		If $inputkeyvalueForm = Null Then 
			$inputkeyvalueForm = GUICreate("Input Key & Value", 320, 200, 400, 400,$ScriptConfigForm)
			GUICtrlCreateLabel("Key:", 10, 5, 40)
			$KeyData = GUICtrlCreateInput("", 10, 25, 250, 20)
			GUICtrlCreateLabel("Value:", 10, 55, 40)
			$ValueData = GUICtrlCreateInput("", 10, 70, 250, 20)
			$SaveData = GUICtrlCreateButton("Save", 10, 100, 80, 20)
			GUISetState(@SW_SHOW)
		EndIf
	Case $SaveData 
		;Save to tmpfile And test compile to know save file
		;IniRead($sFilePath, "Script",$aDevice, Null)
		iniWrite($sFilePath, $OpenModalDeviceName,GUICtrlRead($KeyData) ,GUICtrlRead($ValueData))
		
		GUIDelete($inputkeyvalueForm)
		$inputkeyvalueForm = Null
		
		_GUICtrlListView_DeleteAllItems($aDataConfig)
		$iniData = IniReadSection($sFilePath,$OpenModalDeviceName)
		If @error Then
		Else
			For $i = 1 To $iniData[0][0]
				GUICtrlCreateListViewItem($iniData[$i][0] & "|" &$iniData[$i][1] ,$aDataConfig)
			Next
		EndIf
	Case $idinstallapps
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		If $sAppClicked <> "" Then
			AppInstall($sAppClicked)
		EndIf
		
	Case $idMenuProcessScript
		$sAppClicked = _GUICtrlListView_GetItemText($aProcessScript, Number(_GUICtrlListView_GetSelectedIndices($aProcessScript)))
		If ProcessExists($sAppClicked) Then
			ProcessClose($sAppClicked)
		EndIf
		_GUICtrlListView_DeleteItem($aProcessScript, Number(_GUICtrlListView_GetSelectedIndices($aProcessScript)))
		UpdateScriptPid()
	Case $idMenuReboot
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		_Android_Reboot($sAppClicked,"")
		MsgBox(0,"Notification","Reboot Successful")
	Case $idMenuShutDown
		$sAppClicked = _GUICtrlListView_GetItemText($aListDevices, Number(_GUICtrlListView_GetSelectedIndices($aListDevices)))
		_Android_Reboot($sAppClicked,"Shutdown")
		MsgBox(0,"Notification","Shutdown Successful")
	EndSwitch

	ExitAllForm()
WEnd

Func InitData()
	;check device log to show
	If $received Then
		Local $data = StringSplit ( $received, "|" )
		If $data[0] > 3 Then
		If $data[1] = "log" Then
			GUICtrlCreateListViewItem($data[2] & "|" &  $data[3] &"|"  & _NowTime() & "|",$aProcessLog)
			If $data[4] = "info" Then
				GUICtrlSetColor(-1, 0x0000FF)
			EndIf
			If $data[4] = "error" Then
				GUICtrlSetColor(-1, 0x8B0000)
			EndIf
			If $data[4] = "success" Then
				GUICtrlSetColor(-1, 0x008000)
			EndIf	 
		EndIf
		EndIf
		$received = ""
    EndIf
EndFunc

;Star Proxy
Func StartProxy($http_proxy,$iDevice)
	__Run("adb -s " & $iDevice & " shell settings put global http_proxy " & $http_proxy)
EndFunc

Func StopProxy($iDevice)
	__Run("adb -s " & $iDevice & " shell settings put global http_proxy :0")
EndFunc

;End Proxy


Func AppInstall($sAppClicked)
	$OpenModalDeviceName = $sAppClicked
		If $InstallAppsForm = Null Then
			$InstallAppsForm = GUICreate("Install Apps", 600, 600, 200, 200, -1, -1, $FormMain)
			$ListApps = GUICtrlCreateListView("", 0, 0, 600, 600)
			_GUICtrlListView_InsertColumn($ListApps  ,0, "Apps", 600)
			GUISetState(@SW_SHOW)
			Local $aFileList = _FileListToArray("apk", "*",1)
			For $x = 1 to $aFileList[0]
				_GUICtrlListView_InsertItem($ListApps, $aFileList[$x] , 0)
			Next
		EndIf
EndFunc

Func AboutDevice($sAppClicked)
	$aDevices = _Android_GetDevices() 
	$found = _ArraySearch($aDevices , $sAppClicked )
	If $found <> -1 Then
		If $InforDeviceForm = Null Then
			$InforDeviceForm = GUICreate("Device Information", 600, 400, 200, 200, -1, -1, $FormMain)	
			$aConfigInformation = GUICtrlCreateListView("", 0, 0, 700, 400)
			_GUICtrlListView_SetExtendedListViewStyle(-1,$LVS_EX_FULLROWSELECT)
			_GUICtrlListView_InsertColumn($aConfigInformation ,0, "Key", 200)
			_GUICtrlListView_InsertColumn($aConfigInformation ,1, "Value", 400)
			;https://techviral.net/fake-android-device-id-info-identity/
			;https://www.gtricks.com/android/2-ways-to-find-android-device-id-and-change-it/ without root
			_GUICtrlListView_InsertItem($aConfigInformation, "Device ID" , 0)
			_GUICtrlListView_InsertItem($aConfigInformation, "Name" , 1)
			_GUICtrlListView_InsertItem($aConfigInformation, "Model" , 2)
			_GUICtrlListView_InsertItem($aConfigInformation, "Manufacturer" , 4)
			_GUICtrlListView_InsertItem($aConfigInformation, "Brand" , 3)
			_GUICtrlListView_InsertItem($aConfigInformation, "Board" , 5)
			_GUICtrlListView_InsertItem($aConfigInformation, "Device" , 6)
			_GUICtrlListView_InsertItem($aConfigInformation, "Fingerprint" , 7)
			_GUICtrlListView_InsertItem($aConfigInformation, "Total Memory" , 8)
			_GUICtrlListView_InsertItem($aConfigInformation, "Free Memory" , 9)
			_GUICtrlListView_InsertItem($aConfigInformation, "Used Memory" , 10)
			_GUICtrlListView_InsertItem($aConfigInformation, "Temp" , 11)
			_GUICtrlListView_InsertItem($aConfigInformation, "Batery" , 12)
			_GUICtrlListView_InsertItem($aConfigInformation, "Network" , 13)
			_GUICtrlListView_InsertItem($aConfigInformation, "OS" , 14)
			_GUICtrlListView_InsertItem($aConfigInformation, "SDK" , 15)
			_GUICtrlListView_InsertItem($aConfigInformation, "Serial" , 16)
			GUISetState(@SW_SHOW)
			$sDeviceName = _Android_GetDeviceName($sAppClicked)
			; Device ID
			_GUICtrlListView_AddSubItem($aConfigInformation, 0, $sDeviceName[7], 1, 1)
			; Name
			_GUICtrlListView_AddSubItem($aConfigInformation, 1, $sDeviceName[2], 1, 1)
			; Model
			_GUICtrlListView_AddSubItem($aConfigInformation, 2, $sDeviceName[4], 1, 1)
			; Brand
			_GUICtrlListView_AddSubItem($aConfigInformation, 3, $sDeviceName[3], 1, 1)
			; Manufacturer
			_GUICtrlListView_AddSubItem($aConfigInformation, 4, $sDeviceName[1], 1, 1)
			; Board
			_GUICtrlListView_AddSubItem($aConfigInformation, 5, $sDeviceName[6], 1, 1)
			; Device
			_GUICtrlListView_AddSubItem($aConfigInformation, 6, $sDeviceName[0], 1, 1)
			;fingerprint
			_GUICtrlListView_AddSubItem($aConfigInformation, 7, $sDeviceName[5], 1, 1)
			; OS version
			_GUICtrlListView_AddSubItem($aConfigInformation, 14, $sDeviceName[8], 1, 1)
			; Display ID
			; Ramb
			$sDeviceMeminfo = _Android_GetMeminfo($sAppClicked)
			
			If UBound($sDeviceMeminfo) > 2 Then 
				$iTotalMeminfo = $sDeviceMeminfo[0]
				$iFreeMeminfo = $sDeviceMeminfo[1]
				$iUsedMeminfo = $sDeviceMeminfo[2]
				$PercentFreeMeminfo = round(($iFreeMeminfo /$iTotalMeminfo)*100)
				$PercentUsedMeminfo = 100 - $PercentFreeMeminfo
				_GUICtrlListView_AddSubItem($aConfigInformation, 8, $iTotalMeminfo & " GB (100%)", 1, 1)
				_GUICtrlListView_AddSubItem($aConfigInformation, 9, $iFreeMeminfo & "GB ( "  & $PercentFreeMeminfo  & "%)", 1, 1)
				_GUICtrlListView_AddSubItem($aConfigInformation, 10, $iUsedMeminfo & "GB ( "  & $PercentUsedMeminfo   & "%)", 1, 1)
			EndIf
			; Used Ramb
			; Free Ramb
			; Temp
			$sDeviceBatteryTemp = _Android_GetBatteryTemperature($sAppClicked)
			If $sDeviceBatteryTemp <> 0 Then 
				_GUICtrlListView_AddSubItem($aConfigInformation, 11, $sDeviceBatteryTemp/10&" C ", 1, 1)
			EndIf		
	
			; Batery
			$sDeviceBatteryLevel = _Android_GetBatteryLevel($sAppClicked)
			If $sDeviceBatteryLevel <> Null Then
				_GUICtrlListView_AddSubItem($aConfigInformation, 12, $sDeviceBatteryLevel &"%", 1, 1)
			EndIf
	
		; Network using
		$sDeviceNetworkType = _Android_GetNetworkType($sAppClicked)
		_GUICtrlListView_AddSubItem($aConfigInformation, 13, $sDeviceNetworkType, 1, 1)
		; Phone number
			EndIf
	Else
		MsgBox(0,"Oops!","Device is not Found")
	EndIf
EndFunc

;#RELAY ==============================================================
Func CheckRelayServer()
	Return ProcessExists($RelayServer)
EndFunc

Func RelayServer()
	If CheckRelayServer() = False Then
		StartRelayServer()
	EndIf
EndFunc

Func StartRelayServer()
	$sCommand = @ScriptDir&'\package\scrcpy\gnirehtet run '
	$pid = Run($sCommand, @ScriptDir , @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	$RelayServer = $pid
EndFunc

Func StartConnectRelayServer($iDevice)
	RelayServer()
	$sCommand = @ScriptDir&'\package\scrcpy\gnirehtet start ' & $iDevice
	$iPID = Run($sCommand, @ScriptDir&"\package\scrcpy\" , @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
EndFunc


Func StopConnectRelayServer($iDevice)
	__Run("gnirehtet stop " & $iDevice)
EndFunc

Func CheckRelayServerDevice($iDevice)
	$ReadOutSt = __Run("adb -s " & $iDevice & " shell pidof com.genymobile.gnirehtet")
	if $ReadOutSt = 0 Then
		Return False
	Else 
		Return True
	EndIf
EndFunc

;#====================================================================

;#WM ==============================================================

Func WM_DESTROY($hWnd, $iMsg, $wParam, $lParam)
	Return $GUI_RUNDEFMSG
EndFunc
Func _Scrollbars_WM_VSCROLL($hWnd, $Msg, $wParam, $lParam)

	#forceref $Msg, $wParam, $lParam
	Local $nScrollCode = BitAND($wParam, 0x0000FFFF)
	Local $iIndex = -1, $yChar, $yPos
	Local $Min, $Max, $Page, $Pos, $TrackPos

	For $x = 0 To UBound($__g_aSB_WindowInfo) - 1
		If $__g_aSB_WindowInfo[$x][0] = $hWnd Then
			$iIndex = $x
			$yChar = $__g_aSB_WindowInfo[$iIndex][3]
			ExitLoop
		EndIf
	Next
	If $iIndex = -1 Then Return 0

	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)
	$Min = DllStructGetData($tSCROLLINFO, "nMin")
	$Max = DllStructGetData($tSCROLLINFO, "nMax")
	$Page = DllStructGetData($tSCROLLINFO, "nPage")
	$yPos = DllStructGetData($tSCROLLINFO, "nPos")
	$Pos = $yPos
	$TrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")

	Switch $nScrollCode
		Case $SB_TOP
			DllStructSetData($tSCROLLINFO, "nPos", $Min)
		Case $SB_BOTTOM
			DllStructSetData($tSCROLLINFO, "nPos", $Max)
		Case $SB_LINEUP
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - 1)
		Case $SB_LINEDOWN
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + 1)
		Case $SB_PAGEUP
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - $Page)
		Case $SB_PAGEDOWN
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + $Page)
		Case $SB_THUMBTRACK
			DllStructSetData($tSCROLLINFO, "nPos", $TrackPos)
	EndSwitch

	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)

	$Pos = DllStructGetData($tSCROLLINFO, "nPos")
	If ($Pos <> $yPos) Then
		_GUIScrollBars_ScrollWindow($hWnd, 0, $yChar * ($yPos - $Pos))
		$yPos = $Pos
	EndIf

	Return $GUI_RUNDEFMSG

EndFunc   ;==>_Scrollbars_WM_VSCROLL
Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $iwParam
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
    $hWndListView = $aListDevices
    If Not IsHWnd($aListDevices) Then $hWndListView = GUICtrlGetHandle($aListDevices)
		
    $hWndListScript = $ListScript
    If Not IsHWnd($ListScript) Then $hWndListScript = GUICtrlGetHandle($ListScript)

    $hWndListApp = $ListApps
    If Not IsHWnd($ListApps) Then $hWndListApp = GUICtrlGetHandle($ListApps)
	
    $hWndListData = $aDataConfig
    If Not IsHWnd($aDataConfig) Then $hWndListData = GUICtrlGetHandle($aDataConfig)
		
    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hWndListView
            Switch $iCode
                Case $NM_DBLCLK
                    $sAppClicked = _GUICtrlListView_GetItemText($hWndListView, _GUICtrlListView_GetSelectedIndices($hWndListView))
					If $sAppClicked  <> -1 Then
						CreateProcScript($sAppClicked)
                    EndIf
				EndSwitch
		Case $hWndListScript
            Switch $iCode
                Case $NM_DBLCLK
                    $sAppClicked = _GUICtrlListView_GetItemText($hWndListScript, _GUICtrlListView_GetSelectedIndices($hWndListScript))
					If $sAppClicked  <> -1 Then
						Run('"' & @SystemDir & '\Notepad.exe" "' & @ScriptDir &'\script\'& $sAppClicked & '"')
                    EndIf
				EndSwitch
		Case $hWndListApp
			Switch $iCode
                Case $NM_DBLCLK
                    $sAppClicked = _GUICtrlListView_GetItemText($hWndListApp, _GUICtrlListView_GetSelectedIndices($hWndListApp))
					If $sAppClicked  <> -1 Then
						_Android_Install($OpenModalDeviceName,@ScriptDir&"/apk/"&$sAppClicked)
						MsgBox(0,"notification","Install Sucessful")
                    EndIf
				EndSwitch
		Case $hWndListData
			Switch $iCode
                Case $NM_DBLCLK
                    $sAppClicked = _GUICtrlListView_GetItemText($hWndListData, _GUICtrlListView_GetSelectedIndices($hWndListData))
					If $sAppClicked  <> -1 Then
						Local $sValue = InputBox("Change Value",  $sAppClicked, "", "")
						iniWrite($sFilePath, $OpenModalDeviceName,$sAppClicked ,$sValue)
						_GUICtrlListView_DeleteAllItems($aDataConfig)
						$iniData = IniReadSection($sFilePath,$OpenModalDeviceName)
						If @error Then
						Else
							For $i = 1 To $iniData[0][0]
								GUICtrlCreateListViewItem($iniData[$i][0] & "|" &$iniData[$i][1] ,$aDataConfig)
							Next
						EndIf
                    EndIf
				EndSwitch
	EndSwitch
		
	Local $tStruct = DllStructCreate($tagNMHDR, $lParam)
	If GUICtrlGetHandle($aListDevices) = $tStruct.hwndFrom And $tStruct.Code = $LVN_ITEMCHANGED Then
		$tStruct = DllStructCreate($tagNMLISTVIEW, $lParam)
		$RegExNonStandard="(?i)([^a-z0-9-_])"
		$iDevice = StringRegExpReplace(_GUICtrlListView_GetItemText($aListDevices, $tStruct.item),$RegExNonStandard,"")
		If _GUICtrlListView_GetItemChecked($aListDevices, $tStruct.item) Then

			If Not $oDi.Exists($iDevice) Then
				$oDi.Add($iDevice, 0)
			EndIf
			If  $oDi.Exists($iDevice) And $oDi.Item($iDevice) == 0 Then
				StartDevice($iDevice)
			EndIf
		Else
			; BUG when close device multi
			
			If $oDi.Exists($iDevice) And $oDi.Item($iDevice) <> 0 Then
				If ProcessExists ($oDi.Item($iDevice)) Then
				  ProcessClose($oDi.Item($iDevice))
				  $oDi.Remove($iDevice)
				  OrderDisplay()
			  EndIf
			EndIf
		EndIf
  EndIf
  Return $GUI_RUNDEFMSG
EndFunc

Func WM_ACTIVATE($hWnd, $iMsg, $wParam, $lParam)
	If $DeviceProcess Then
		$DeviceProcess = False
		LoadDeviceInformation()
		LoadDeviceMenuLog()
		$DeviceProcess = True
	EndIf
	CheckProcessScript()
  Return $GUI_RUNDEFMSG
EndFunc 

Func WM_DEVICECHANGE($hWnd, $iMsg, $wParam, $lParam)
	If $DeviceProcess Then
		$DeviceProcess = False
		LoadDeviceInformation()
		LoadDeviceMenuLog()
		$DeviceProcess = True
	EndIf
  Return $GUI_RUNDEFMSG
EndFunc 
;=====================================================================

;#CLOSE ===============================================================

Func ExitAllForm()
	If WinExists("Device Information") <> 1 And WinExists("Multi AutoIT ADB") <> 1 Then
		CloseAll()
		Exit
	EndIf
	
	If WinExists("Config") <> 1 And WinExists("Multi AutoIT ADB") <> 1 Then
		CloseAll()
		Exit
	EndIf
	
	If WinExists("Script File") <> 1 And WinExists("Multi AutoIT ADB") <> 1 Then
		CloseAll()
		Exit
	EndIf
	If WinExists("Install Apps") <> 1 And WinExists("Multi AutoIT ADB") <> 1 Then
		CloseAll()
		Exit
	EndIf
	If WinExists("Display") <> 1 And WinExists("Multi AutoIT ADB") <> 1 Then
		CloseAll()
		Exit
	EndIf
	If WinExists("Input Key & Value") <> 1 And WinExists("Multi AutoIT ADB") <> 1 Then
		CloseAll()
		Exit
	EndIf
EndFunc

Func CloseAllScript()
		For $i = 0 to UBound($ScriptPid)-1
			If ProcessExists($ScriptPid[$i])  Then
				ProcessClose($ScriptPid[$i])
			EndIf
		Next
EndFunc

Func CloseAllDevices()
	$aDevices = $oDi.Items
    For $i = 0 To $oDi.Count -1
		If ProcessExists($aDevices[$i]) Then
			ProcessClose($aDevices[$i])
		EndIf
    Next
EndFunc

Func CloseRelayServer()
	If ProcessExists($RelayServer) Then
			ProcessClose($RelayServer)
		EndIf
	EndFunc
	
Func CloseAll()
	CloseAllScript()
	CloseAllDevices()
	CloseRelayServer()
EndFunc


Func CloseWindowForm()
		If WinExists("Device Information") = 1 And BitAND(WinGetState("Device Information"), 8) Then 
			GUIDelete($InforDeviceForm)
			$InforDeviceForm = Null
		ElseIf WinExists("Script File") = 1 And BitAND(WinGetState("Script File"), 8) Then 
			GUIDelete($ScriptManagerForm)
			$ScriptManagerForm = Null
		ElseIf WinExists("Install Apps") = 1 And BitAND(WinGetState("Install Apps"), 8) Then 
			GUIDelete($InstallAppsForm)
			$InstallAppsForm = Null
		ElseIf WinExists("Display") = 1 And BitAND(WinGetState("Display"), 8) Then 
			GUIDelete($DisplayManagerForm)
			$DisplayManagerForm = Null
		ElseIf WinExists("Config") = 1 And BitAND(WinGetState("Config"), 8) Then 
			GUIDelete($ScriptConfigForm)
			$ScriptConfigForm = Null
		ElseIf WinExists("Input Key & Value") = 1 And BitAND(WinGetState("Input Key & Value"), 8) Then 
			GUIDelete($inputkeyvalueForm)
			$inputkeyvalueForm = Null
		ElseIf  WinExists("Multi AutoIT ADB") = 1 And BitAND(WinGetState("Multi AutoIT ADB"), 8) Then 
			;GUIDelete($FormMain)
		EndIf
EndFunc

;=====================================================================


;#DISPLAY ==============================================================
Func OrderDisplay()
	;Bug Maybe in Winmove
	$aKeys = $oDi.Keys
	$count = 0
	For $aKey in $aKeys
		;debug akey

		;ConsoleWrite("0:"&$pos[0]&@CRLF)
		;ConsoleWrite("1:"&$pos[1]&@CRLF)
		ConsoleWrite("$Key:"&$oDi.Item($aKey)&@CRLF)
		If $oDi.Item($aKey) <> "" Then
			$count = $count+1
			$pos = getDevicePositionByPosition($aKey,$DevicesWidth,$DevicesHeight,$count) ; "Notthing bug"
			$hWnd = _GetHwndFromPID($oDi.Item($aKey)) ; Maybe bug here\
			;ConsoleWrite("$hWnd:"&$hWnd&@CRLF)
			WinMove($hWnd,"",$pos[0],$pos[1])
		EndIf
		
		;ConsoleWrite("$Key:"&$aKey&@CRLF)
		
		;WinMove($hWnd,"",$pos[0],$pos[1])
	Next	
EndFunc

Func LoadDeviceMenuLog()
	GUICtrlDelete($idMenuDeviceLog)
	$idMenuDeviceLog = GUICtrlCreateMenu("Device Log",$idButtoncontextProcessLog)
	GUICtrlCreateMenuItem("All",$idMenuDeviceLog)
	$aDevices = _Android_GetDevices()
	
	For $i = 0 To UBound($aDevices) -1
		GUICtrlCreateMenuItem($aDevices[$i],$idMenuDeviceLog)
	Next
	
EndFunc
Func LoadDeviceInformation()
	$aDevices = _Android_GetDevices()
	$aDevicesListView = _GUICtrlListView_GetItemsArray($aListDevices,0)
	If UBound($aDevices) > 0 Then
		For $i = 0 To UBound($aDevices) -1
		$found = _ArraySearch($aDevicesListView, $aDevices[$i])
		If $found <> -1 Then
		Else
			$sDeviceName = _Android_GetDeviceName($aDevices[$i])
			;$sDeviceBatteryTemp = _Android_GetBatteryTemperature($aDevices[$i])
			;$sDeviceBatteryLevel = _Android_GetBatteryLevel($aDevices[$i])
			;$idViewItem = GUICtrlCreateListViewItem($aDevices[$i] & "|" & $sDeviceName[1] & " "&$sDeviceName[0] &"|" &$sDeviceBatteryTemp/10&" C | " & $sDeviceBatteryLevel  &"%|" ,$aListDevices)
			$idViewItem = GUICtrlCreateListViewItem($aDevices[$i] & "|" & $sDeviceName[1] & " "&$sDeviceName[0] &"|"  ,$aListDevices)
			
		EndIf
	Next	
	EndIf
	
	If UBound($aDevicesListView) > 0 Then
		For $i = 0 To UBound($aDevicesListView) -1
			$found = _ArraySearch($aDevices,$aDevicesListView[$i])
			If $found <>  -1 Then
				
			Else
				if $i < _GUICtrlListView_GetItemCount($aListDevices)   Then
					_GUICtrlListView_DeleteItem($aListDevices, $i)
					;If $OpenModalDeviceName = $aDevicesListView[$i] Then
							;If WinExists("Device Information") = 1 And BitAND(WinGetState("Device Information"), 8) Then ; If Device Information exits & is active.
								;GUIDelete($InforDeviceForm)
							;EndIf
							;If WinExists("Config") = 1 And BitAND(WinGetState("Script"), 8) Then ; If Device Information exits & is active.
								;GUIDelete($ScriptConfigForm)
							;EndIf
					;EndIf
				EndIf
				
	
			EndIf
		Next
	EndIf
EndFunc
Func LoadDisplay()
	$aKeys = $oDi.Keys
	For $i = 0 To $oDi.Count -1
			If _elementExists($aKeys, $i)  Then
				$iDevice = $aKeys[$i]
				$apps = GetChildAppInForm()
				If  ProcessExists($oDi.Item($iDevice)) And UBound($apps) < UBound($aKeys) Then
					$hChild = _GetHwndFromPID($oDi.Item($iDevice))
					$CheckinForm = _ArraySearch($apps,$hChild, Default, Default, Default, Default, 4)
					If $CheckinForm == -1 Then
						WinActivate($iDevice)
						$output = _WinAPI_SetParent($hChild,$FormMain)
					EndIf
				EndIf
			EndIf
		Next
EndFunc
	
Func StartDevice($iDevice)
	Local $DevicesWidthSceen = $DevicesWidth
	Local $DevicesHeightSceen = $DevicesHeight
	If IniRead($sFilePath,  "Display", "Width" , Null) <> "" Then 
		$DevicesWidthSceen =  IniRead($sFilePath,  "Display", "Width" , Null)
	EndIf
	If IniRead($sFilePath,  "Display", "Height" , Null) <> "" Then 
		$DevicesHeightSceen =  IniRead($sFilePath,  "Display", "Height" , Null)
	EndIf
	
	$pos = getDevicePosition("",$DevicesWidth,$DevicesHeight) 
	
	$aRet = _GUIScrollbars_Size(0, $pos[2] * $DevicesHeight, 300, 300)
	_GUIScrollBars_SetScrollInfoPage($FormMain, $SB_VERT, $aRet[2])
	_GUIScrollBars_SetScrollInfoMax($FormMain, $SB_VERT, $aRet[3])
	
	
	$pos_x = $pos[0]
	$pos_y = $pos[1]
	; Ratiotion --------------------------------------------------------------
	Local $rotationDevices = ""
	Switch IniRead($sFilePath,  "Display", "Rotation" , Null)
        Case "no rotation"
                $rotationDevices = " --rotation=0"
        Case "90 degrees counterclockwise"
                $rotationDevices = " --rotation=1"
        Case "180 degrees"
                $rotationDevices = " --rotation=2"
        Case "90 degrees clockwise"
                $rotationDevices = " --rotation=3"
			EndSwitch
	Local $NoControlDevice = ""
	If IniRead($sFilePath,  "Display", "NoControl" , Null) = 1 Then
		 $NoControlDevice = " --no-control"
	 EndIf
	 Local $StayAwakeDevice = ""
	If IniRead($sFilePath,  "Display", "StayAwake" , Null) = 1 And IniRead($sFilePath,  "Display", "NoControl" , Null) <> 1 Then
		 $StayAwakeDevice = " --stay-awake"
	 EndIf
	 
	$sCommand = @ScriptDir&'\package\scrcpy\scrcpy -s ' & $iDevice & ' --window-x ' & $pos_x & ' --window-y ' & $pos_y & ' --window-width '& $DevicesWidthSceen & '  --window-height ' & $DevicesHeightSceen & ' --window-borderless --window-title "'&$iDevice&'"'  & $rotationDevices & $NoControlDevice & $StayAwakeDevice
	$pid = Run($sCommand, @ScriptDir , @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	$oDi.Item($iDevice) = $pid
	WinWait($iDevice)
EndFunc

Func getDevicePosition($iDevice,$DevicesWidth,$DevicesHeight)
	Dim $pos[3]
	$ListDevicesTabWidth = Round(((@DesktopWidth) *20)/100)
	$i=0
	$aKeys = $oDi.Keys
	$MaxDevicesInRows = Round((@DesktopWidth - $ListDevicesTabWidth ) / $DevicesWidth )-1
	$displayDevicesNumber =  $oDi.Count
	$RowPosition = Ceiling($displayDevicesNumber/$MaxDevicesInRows)
	$totalRow = $RowPosition-1
	
	if $displayDevicesNumber <= $MaxDevicesInRows Then
		$ColPosition = $displayDevicesNumber
	Else
		$ColPosition =  $displayDevicesNumber - ($totalRow*$MaxDevicesInRows)
	EndIf
	$pos[0] = ($ListDevicesTabWidth + 20) + ($ColPosition-1) *$DevicesWidth
	$pos[1] = $DevicesHeight * $totalRow
	$pos[2] = $totalRow
	Return $pos
EndFunc

Func getDevicePositionByPosition($iDevice,$DevicesWidth,$DevicesHeight,$Count)
	Dim $pos[3]
	$ListDevicesTabWidth = Round(((@DesktopWidth) *20)/100)
	$i=0
	$aKeys = $oDi.Keys
	$MaxDevicesInRows = Round((@DesktopWidth - $ListDevicesTabWidth ) / $DevicesWidth )-1
	$displayDevicesNumber =  $Count
	$RowPosition = Ceiling($displayDevicesNumber/$MaxDevicesInRows)
	$totalRow = $RowPosition-1
	
	if $displayDevicesNumber <= $MaxDevicesInRows Then
		$ColPosition = $displayDevicesNumber
	Else
		$ColPosition =  $displayDevicesNumber - ($totalRow*$MaxDevicesInRows)
	EndIf
	$pos[0] = ($ListDevicesTabWidth + 20) + ($ColPosition-1) *$DevicesWidth
	$pos[1] = $DevicesHeight * $totalRow
	$pos[2] = $totalRow
	Return $pos
EndFunc

Func DisplayManagerForm()
	If $DisplayManagerForm = Null Then 
		$DisplayManagerForm = GUICreate("Display", 300, 300, 200, 200, -1, -1, $FormMain)
		GUICtrlCreateLabel("Width:", 12, 20, 30)
		$WidthDevices = GUICtrlCreateInput( IniRead($sFilePath,  "Display", "Width" , Null) , 50, 18,60, 20)
		GUICtrlCreateLabel("Height:", 12, 50, 35)
		$HeightDevices = GUICtrlCreateInput( IniRead($sFilePath,  "Display", "Height" , Null), 53, 48,60, 20)
		GUICtrlCreateLabel("Rotation:", 12, 80, 45)
		Local $idRotation = GUICtrlCreateCombo("", 60, 77, 185, 20)
		GUICtrlSetData($idRotation, "no rotation|90 degrees counterclockwise|180 degrees| 90 degrees clockwise", IniRead($sFilePath,  "Display", "Rotation" , Null))
		GUICtrlCreateLabel("No Control:", 12, 110, 60)
		$SelectNoControl = GUICtrlCreateCheckbox("", 70, 102, 20, 30)
		GUICtrlSetState($SelectNoControl ,IniRead($sFilePath,  "Display", "NoControl" , Null))
		GUICtrlCreateLabel("Stay Awake:", 12, 140, 60) 
		$SelectStayAwake = GUICtrlCreateCheckbox("", 75, 131, 20, 30)
		GUICtrlSetState($SelectStayAwake ,IniRead($sFilePath,  "Display", "StayAwake" , Null))
		$SaveDisplaySetting = GUICtrlCreateButton("Save", 50, 170, 200, 25)
		GUISetState(@SW_SHOW)
	EndIf
EndFunc
Func SaveDisplaySetting()
	iniWrite($sFilePath, "Display", "Width" ,GUICtrlRead($WidthDevices))
	iniWrite($sFilePath, "Display", "Height" ,GUICtrlRead($HeightDevices))
	iniWrite($sFilePath, "Display", "Rotation" ,GUICtrlRead($idRotation))
	iniWrite($sFilePath, "Display", "NoControl" ,GUICtrlRead($SelectNoControl))
	iniWrite($sFilePath, "Display", "StayAwake" ,GUICtrlRead($SelectStayAwake))
	MsgBox(0,"Notification","Display Config Saved")
EndFunc
Func GetChildAppInForm()
	Local $a_list = _WinAPI_EnumChildWindows($FormMain)
	Local $countArr = 0
	For $i = 1 To $a_list[0][0]
		If $a_list[$i][1] == "SDL_app" Then
			$countArr += 1
		EndIf
	Next
	Dim $ChildAppInForm[$countArr];
	$countArrE = 0
	For $i = 1 To $a_list[0][0]
		If $a_list[$i][1] == "SDL_app" Then
			$ChildAppInForm[$countArrE] =  $a_list[$i][0]
			$countArrE += 1
		EndIf
	Next
Return $ChildAppInForm
EndFunc

;=====================================================================


;#PROCESS ==============================================================
Func _GetWinTitleFromProcName($s_ProcName)
    $pid = ProcessExists($s_ProcName)
    $a_list = WinList()
    For $i = 1 To $a_list[0][0]
        If $a_list[$i][0] <> "" Then
            $pid2 = WinGetProcess($a_list[$i][0])
            If $pid = $pid2 Then Return $a_list[$i][0]
        EndIf
    Next
EndFunc

Func _GetHwndFromPID($PID)
    $hWnd = 0
    $stPID = DllStructCreate("int")
    Do
        $winlist2 = WinList()
        For $i = 1 To $winlist2[0][0]
            If $winlist2[$i][0] <> "" Then
                DllCall("user32.dll", "int", "GetWindowThreadProcessId", "hwnd", $winlist2[$i][1], "ptr", DllStructGetPtr($stPID))
                If DllStructGetData($stPID, 1) = $PID Then
                    $hWnd = $winlist2[$i][1]
                    ExitLoop
                EndIf
            EndIf
        Next
        Sleep(100)
    Until $hWnd <> 0
    Return Ptr($hWnd)
EndFunc ;==>_GetHwndFromPID


Func CheckProcessScript()
	$aProcessListView = _GUICtrlListView_GetItemsArray($aProcessScript,0)
	UpdateScriptPid()
	if UBound($aProcessListView) > 0 Then
		For $i = 0 to UBound($aProcessListView)-1
			If ProcessExists($aProcessListView[$i]) = 0 Then
				_GUICtrlListView_DeleteItem($aProcessScript, $i)
			EndIf
		Next
	EndIf
EndFunc

Func SendDataConfigToChild($hChild)
		$iniData = IniReadSection($sFilePath,$OpenModalDeviceName)
		If @error Then
		Else
			For $i = 1 To $iniData[0][0]
				SendData($hChild,$iniData[$i][0],$iniData[$i][1])
			Next
		EndIf
EndFunc

Func CreateProcRunScript($aDevice,$FileName)
		
		$File = @ScriptDir&"\script\"&$FileName
		$pId = Run('./lib/AutoIt3.exe' & ' /AutoIt3ExecuteScript ' & FileGetShortName($File))
		ConsoleWrite(@AutoItExe)
		$hChild = _GetHwndFromPID($pId); assign child hamdle
		SendData($hChild,PackageData($aDevice))
		;SEND PID to child process
		GUICtrlCreateListViewItem($pId & "|" & $aDevice & "|" & $FileName &"  | " &  "Usaage" &"|" ,$aProcessScript)
		
	EndFunc
	
Func PackageData($aDevice)
		Local $iniDataPackage = ""
		$iniData = IniReadSection($sFilePath,$OpenModalDeviceName)
		If @error Then
		Else
			For $i = 1 To $iniData[0][0]
				$iniDataPackage &= "|"&$iniData[$i][0] &":"&$iniData[$i][1]
			Next
		EndIf
	ConsoleWrite($iniDataPackage)
	Return "device:"&$aDevice&"|parent_pid:"&@AutoItPID &$iniDataPackage
EndFunc

Func CreateProcScript($aDevice)
			$FileName = IniRead($sFilePath, "Script",$aDevice, Null)
			If $FileName <> "" Then
			;$File = FileOpenDialog('Open File', @ScriptDir, 'Text (*.txt)')
				$File = @ScriptDir&"\script\"&$FileName
				$pId = Run(@AutoItExe & ' /AutoIt3ExecuteScript ' & FileGetShortName($File))
				$hChild = _GetHwndFromPID($pId); assign child hamdle=
				
				SendDataConfigToChild($hChild)
				GUICtrlCreateListViewItem($pId & "|" & $aDevice & "|" & $FileName &"  | " &  "Usaage" &"|" ,$aProcessScript)
			Else
				MsgBox(0,"Oops!","Please Select Your Script for this device")
			EndIf

EndFunc

Func UpdateScriptPid()
	$ScriptPid = _GUICtrlListView_GetItemsArray($aProcessScript,0)
EndFunc
;=====================================================================

;#ARRAY ==============================================================
Func _GUICtrlListView_GetItemsArray($hListView,$index)
            Local $a_list, $x
            For $x = 0 To _GUICtrlListView_GetItemCount($hListView) - 1
                If IsArray($a_list) Then
                    ReDim $a_list[UBound($a_list) + 1]
                Else
                    Dim $a_list[1]
                EndIf
                $a_list[UBound($a_list) - 1] = _GUICtrlListView_GetItemText($hListView, $x,$index)
            Next
			Return $a_list
		EndFunc
		
Func _elementExists($array, $element)
    If $element > UBound($array)-1 Then Return False ; element is out of the array bounds
    Return True ; element is in array bounds
EndFunc
;=====================================================================

;Image stop and run on list View device https://www.autoitscript.com/autoit3/docs/functions/GUICtrlCreateContextMenu.htm 
; Click on image and run script
;https://github.com/barry-ran/QtScrcpy#Build
;Feature :https://github.com/rodion-gudz/Android-Tool
;Feature :Data Input Manager
;Feature :Data Output Manager(Save Log)
;Feature :  Wireless debugging option 
;Feature :Menu select all device
;Feature : Plugin , SMS batch , Proxy API wraper for android , https://www.smsdeliverer.com/ , Phone call , Call center , autocall
;Config : Auto charge when low = 
;Config : Auto stop charge when connect
;Feature : change device ID https://techviral.net/fake-android-device-id-info-identity/ https://android.stackexchange.com/questions/175885/factory-reset-android-using-adb Change using app to fake device https://forum.xda-developers.com/t/app-xposed-8-1-12-android-faker-a-module-for-spoof-your-device.4284233/ https://play.google.com/store/apps/details?id=nz.pbomb.xposed.spoofmydevice
;Feature : Manager File
;Feature : Record , Capture Script
;Feature : Service API
;Feature : Forward Call https://github.com/machinaeXphilip/adbController
;Feature : Forward Audio https://github.com/rom1v/sndcpy , VLC too large MB and maybe not forward
;Feature : batch Function For ALL
;Feature : Write document about how script for adb work
;Feature : Call Key value from config farent  
;Feature : Run EXE file - prevent call from child app without parent
;Bug : 1 device only open 1 script -- (DONE)
;Bug : open display model error with file script (Multi) 
;Bug :Select about device , when it hasnt not load finish , click multi 3 click it will close implement (Done)
;Feature: rewrite app to read sms merge with sendsms (Done)