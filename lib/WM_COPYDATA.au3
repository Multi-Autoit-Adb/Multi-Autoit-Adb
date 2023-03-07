Global $received
Global $sendPakage
Global $oDictionary = ObjCreate('scripting.dictionary')

; Write a func return when pass key
Func Init()
	If $received Then
		Local $dataPackage = StringSplit ( $received, "|" )
		For $i = 1 To $dataPackage[0]
			Local $data = StringSplit ($dataPackage[$i], ":" )
				If $oDictionary.Exists($data[1]) Then
					$oDictionary.Key ($data[1]) = $data[2]
				Else
					$oDictionary.Add ($data[1],   $data[2] )
				EndIf
		Next
		$received = Null
    EndIf
EndFunc

Func GetData($skey)
	Return $oDictionary.Item($skey)
EndFunc

Func SendData($hWnd,$sData)
	WM_COPYDATA_SendData($hWnd, $sData)
EndFunc

Func SendPackageData($hWnd)
	WM_COPYDATA_SendData($hWnd, $sendPackage)
EndFunc


;Func PackageData($skey,$sdata)
	;return $sendPackage &= $skey&":"&$sdata&"|"
;EndFunc
;Update send type log
Func SendLog($hWnd, $sKey ,$sData )
	WM_COPYDATA_SendData($hWnd,$sKey &"|"& GetData("device") &"|"& $sData)
EndFunc
Func InfoLog($hWnd, $sKey ,$sData)
	WM_COPYDATA_SendData($hWnd,$sKey &"|"& GetData("device") &"|"& $sData & "|info")
EndFunc
Func ErrorLog($hWnd, $sKey ,$sData)
	WM_COPYDATA_SendData($hWnd,$sKey &"|"& GetData("device") &"|"& $sData & "|error")
EndFunc
Func SuccessLog($hWnd, $sKey ,$sData)
	WM_COPYDATA_SendData($hWnd,$sKey &"|"& GetData("device") &"|"& $sData & "|success")
EndFunc


Func _ConvertPIDToHWnd($PID)
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

GUIRegisterMsg($WM_COPYDATA, "WM_COPYDATA_ReceiveData") ; register WM_COPYDATA
;===================================================================================================================================
Func WM_COPYDATA_ReceiveData($hWnd, $MsgID, $wParam, $lParam) ;
    Local $tCOPYDATA = DllStructCreate("dword;dword;ptr", $lParam)
    Local $tMsg = DllStructCreate("char[" & DllStructGetData($tCOPYDATA, 2) & "]", DllStructGetData($tCOPYDATA, 3))
    $received = DllStructGetData($tMsg, 1)
EndFunc

Func WM_COPYDATA_SendData($hWnd, $sData)
    Local $tCOPYDATA = DllStructCreate("dword;dword;ptr")
    Local $tMsg = DllStructCreate("char[" & StringLen($sData) + 1 & "]")
    DllStructSetData($tMsg, 1, $sData)
    DllStructSetData($tCOPYDATA, 2, StringLen($sData) + 1)
    DllStructSetData($tCOPYDATA, 3, DllStructGetPtr($tMsg))
    $Ret = DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $hWnd, "int", $WM_COPYDATA, "wparam", 0, "lparam", DllStructGetPtr($tCOPYDATA))
EndFunc