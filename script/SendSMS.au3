#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include "../lib/Android.au3"
#include "../lib/AndroidConstants.au3"
#include "../lib/WM_COPYDATA.au3"


$SendSMSForm = GUICreate("Send SMS", 300, 300, 200, 200, -1, -1)
GUICtrlCreateLabel("Phone Number:", 20, 20, 80)
$PhoneNumber = GUICtrlCreateInput( Null , 100, 18,120, 20)
GUICtrlCreateLabel("Message:", 20, 40, 80)
$Phonemessage = GUICtrlCreateEdit("", 80, 40, 130, 100)
$SendSMS = GUICtrlCreateButton("Send", 50, 170, 200, 25)


GUISetState (@SW_SHOW)

GUIRegisterMsg($WM_COPYDATA, "WM_COPYDATA_ReceiveData") ; register WM_COPYDATA

While  1
$nMsg=GUIGetMsg ()
Init()
Switch  $nMsg
  Case  $GUI_EVENT_CLOSE
   Exit
  Case  $SendSMS
	If GetData("device") <> Null Then
		_Android_SendSMS(GetData("device"),GUICtrlRead($PhoneNumber),GUICtrlRead($Phonemessage))
		SuccessLog(_ConvertPIDToHWnd(GetData("parent_pid")), "log" ,"Send SMS Sucessful")
	EndIf
EndSwitch
WEnd