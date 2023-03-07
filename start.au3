#include <GUIConstants.au3>

GUICreate(" My GUI input acceptfile", 320, 120, @DesktopWidth / 2 - 160, @DesktopHeight / 2 - 45)
$file = GUICtrlCreateInput("", 10, 5, 300, 20)
GUICtrlSetState(-1, $GUI_ACCEPTFILES)
$file2 = GUICtrlCreateInput("", 10, 35, 300, 20)
$btn = GUICtrlCreateButton("Ok", 40, 75, 60, 20)

GUISetState()

$msg = 0
While $msg <> $GUI_EVENT_CLOSE
    $msg = GUIGetMsg()
    Select
        Case $msg = $Btn
            MsgBox(262144, '', ' 1 : ' & GUICtrlRead($file) & ' 2: ' & GUICtrlRead($file2))
    EndSelect
WEnd