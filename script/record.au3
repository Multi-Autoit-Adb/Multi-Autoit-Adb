#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include "../lib/Android.au3"
#include "../lib/AndroidConstants.au3"
#include "../lib/WM_COPYDATA.au3"



Global $pid
$Record = GUICreate("Record", 300, 300, 200, 200, -1, -1)
GUISetState (@SW_SHOW)

GUIRegisterMsg($WM_COPYDATA, "WM_COPYDATA_ReceiveData") ; register WM_COPYDATA
Record()
While  1
$nMsg=GUIGetMsg ()
Init()
Switch  $nMsg
	Case  $GUI_EVENT_CLOSE
		If ProcessExists($pid) Then
			ProcessClose($pid)
		EndIf
		Exit
EndSwitch
WEnd

Func Record()
	$sCommand = '..\package\scrcpy\scrcpy -s ' & GetData("device") & ' --record=file.mp4' 
	$pid = Run($sCommand, @ScriptDir , @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	ConsoleWrite($pid)
	SuccessLog(_ConvertPIDToHWnd(GetData("parent_pid")), "log" ,"Start Record")
EndFunc